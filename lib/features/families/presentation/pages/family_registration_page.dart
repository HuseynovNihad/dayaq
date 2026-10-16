import '../registration_responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_alert_dialog.dart';
import '../../data/models/family_registration_request_model.dart';
import '../bloc/families_bloc.dart';
import '../forms/address_information_form.dart';
import '../forms/family_members_form.dart';
import '../forms/income_information_form.dart';
import '../forms/expense_information_form.dart';
import '../forms/personal_information_form.dart';
import '../forms/social_worker_notes_form.dart';
import '../forms/registration_review_form.dart';
import '../../../../core/services/document_pdf_service.dart';
import '../widgets/registration_step_header.dart';
import 'family_registration_success_page.dart';

class FamilyRegistrationPage extends StatefulWidget {
  const FamilyRegistrationPage({super.key});
  @override
  State<FamilyRegistrationPage> createState() => _FamilyRegistrationPageState();
}

class _FamilyRegistrationPageState extends State<FamilyRegistrationPage> {
  int _currentStep = 1;
  bool _isSubmitting = false;
  late final FamiliesBloc _familiesBloc;
  @override
  void initState() {
    super.initState();
    _familiesBloc = sl<FamiliesBloc>();
  }

  // Form key-lər
  final _personalFormKey = GlobalKey<FormState>();
  final _addressFormKey = GlobalKey<FormState>();
  final _membersFormKey = GlobalKey<FormState>();
  final _membersWidgetKey = GlobalKey<FamilyMembersFormState>();
  // ADDIM 1 — Şəxsi məlumatlar
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _finController = TextEditingController();
  final _seriaNumberController = TextEditingController();
  final _phoneController = TextEditingController();
  final _noteController = TextEditingController();
  int? _familyStatus;
  // ADDIM 2 — Ünvan məlumatları
  final _addressController = TextEditingController();
  int? _regionId;
  Position? _currentPosition;
  // ADDIM 3 — Ailə üzvləri
  final List<FamilyMemberDraft> _members = [];
  // ADDIM 4 — Gəlir məlumatları
  //
  // Sıra backend field-ləri ilə eynidir:
  // 0 - salary
  // 1 - physical_labor
  // 2 - sosial
  // 3 - scholarship
  // 4 - financial_assistance
  // 5 - charity
  // 6 - individual_assistance
  // 7 - education
  final List<TextEditingController> _incomeControllers = List.generate(
    8,
    (_) => TextEditingController(),
  );
  // ADDIM 5 — Xərclər (backend sırası ilə)
  final List<TextEditingController> _expenseControllers = List.generate(
    7,
    (_) => TextEditingController(),
  );
  // ADDIM 6 — Sosial işçinin qeydləri və PDF sənədləri
  final _socialWorkerNotesController = TextEditingController();
  final List<FamilyLocalDocument> _documents = [];
  @override
  void dispose() {
    _familiesBloc.close();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _finController.dispose();
    _seriaNumberController.dispose();
    _phoneController.dispose();
    _noteController.dispose();
    _addressController.dispose();
    for (final member in _members) {
      member.dispose();
    }
    for (final controller in _incomeControllers) {
      controller.dispose();
    }
    for (final controller in _expenseControllers) {
      controller.dispose();
    }
    _socialWorkerNotesController.dispose();
    super.dispose();
  }

  // Bütün qeydiyyat məlumatlarını təmizləyir.
  void _clearForm() {
    _personalFormKey.currentState?.reset();
    _addressFormKey.currentState?.reset();
    _finController.clear();
    _seriaNumberController.clear();
    _membersFormKey.currentState?.reset();
    _firstNameController.clear();
    _lastNameController.clear();
    _phoneController.clear();
    _noteController.clear();
    _addressController.clear();
    _socialWorkerNotesController.clear();
    final removedDocuments = List<FamilyLocalDocument>.from(_documents);
    _documents.clear();
    for (final document in removedDocuments) {
      // The cleanup is deliberately non-blocking during navigation.
      DocumentPdfService.deleteStoredFile(
        document.path,
      ).catchError((Object _) {});
    }
    for (final controller in _incomeControllers) {
      controller.clear();
    }
    for (final controller in _expenseControllers) {
      controller.clear();
    }
    // Ailə üzvlərinin controller-ləri səhifədən
    // ayrıldıqdan sonra dispose olunmalıdır.
    final removedMembers = List<FamilyMemberDraft>.from(_members);
    _members.clear();
    setState(() {
      _currentStep = 1;
      _familyStatus = null;
      _regionId = null;
      _currentPosition = null;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final member in removedMembers) {
        member.dispose();
      }
    });
  }

  // Qeydiyyatdan çıxış
  Future<void> _cancelRegistration() async {
    if (_isSubmitting) return;
    final shouldCancel = await AppAlertDialog.showConfirmation(
      context: context,
      title: 'Qeydiyyatı ləğv et?',
      message:
          'Daxil etdiyiniz məlumatlar silinəcək. Davam etmək istəyirsiniz?',
      confirmLabel: 'Bəli, ləğv et',
      cancelLabel: 'Geri qayıt',
      isDestructive: true,
    );
    if (!shouldCancel || !mounted) return;
    _clearForm();
    context.go(AppRoutes.home);
  }

  // Əvvəlki mərhələyə qayıt
  void _previousStep() {
    if (_isSubmitting || _currentStep <= 1) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _currentStep--;
    });
  }

  // Növbəti mərhələyə keçid
  void _nextStep() {
    if (_isSubmitting) return;
    FocusScope.of(context).unfocus();
    switch (_currentStep) {
      case 1:
        _validatePersonalInformation();
        break;
      case 2:
        _validateAddressInformation();
        break;
      case 3:
        _continueFromMembers();
        break;
      case 4:
        _continueFromIncome();
        break;
      case 5:
        _continueFromExpenses();
        break;
      case 6:
        setState(() => _currentStep = 7);
        break;
      case 7:
        _submitRegistration();
        break;
      default:
        break;
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    AppAlertDialog.showError(context: context, message: message);
  }

  String _dateForApi(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  int _moneyValue(TextEditingController controller) {
    return int.tryParse(controller.text.trim()) ?? 0;
  }

  bool _hasAnyMemberInput(FamilyMemberDraft member) {
    return member.firstNameController.text.trim().isNotEmpty ||
        member.lastNameController.text.trim().isNotEmpty ||
        member.relationId != null ||
        member.birthday != null ||
        member.incomeController.text.trim().isNotEmpty;
  }

  void _submitRegistration() {
    if (_isSubmitting) return;
    if (_familyStatus == null ||
        _regionId == null ||
        _currentPosition == null ||
        _firstNameController.text.trim().isEmpty ||
        _lastNameController.text.trim().isEmpty ||
        _finController.text.trim().isEmpty ||
        _seriaNumberController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty ||
        _addressController.text.trim().isEmpty) {
      _showMessage('Məcburi məlumatlar tamamlanmayıb. İlk addımları yoxlayın.');
      return;
    }
    final members = _members.where(_hasAnyMemberInput).toList();
    for (var i = 0; i < members.length; i++) {
      final member = members[i];
      if (member.firstNameController.text.trim().isEmpty ||
          member.lastNameController.text.trim().isEmpty ||
          member.relationId == null ||
          member.birthday == null) {
        _showMessage(
          '${i + 1}-ci ailə üzvünün adı, soyadı, statusu və doğum tarixi tam olmalıdır.',
        );
        return;
      }
    }
    final moneyControllers = [..._incomeControllers, ..._expenseControllers];
    if (moneyControllers.any(
      (c) =>
          c.text.trim().isNotEmpty &&
          (int.tryParse(c.text.trim()) == null || int.parse(c.text.trim()) < 0),
    )) {
      _showMessage(
        'Gəlir və xərc sahələrində sıfır və ya müsbət tam ədəd daxil edin.',
      );
      return;
    }
    if (members.any(
      (m) =>
          m.incomeController.text.trim().isNotEmpty &&
          (num.tryParse(m.incomeController.text.trim()) == null ||
              num.parse(m.incomeController.text.trim()) < 0),
    )) {
      _showMessage('Ailə üzvlərinin gəlirləri düzgün daxil edilməyib.');
      return;
    }
    final personalNote = _noteController.text.trim();
    final workerNote = _socialWorkerNotesController.text.trim();
    final combinedNote = [
      if (personalNote.isNotEmpty) personalNote,
      if (workerNote.isNotEmpty) 'Sosial işçinin qeydi: $workerNote',
    ].join('\n\n');
    final phone = _phoneController.text.replaceAll(RegExp(r'\s+'), '');
    final normalizedPhone = phone.startsWith('+')
        ? phone
        : phone.startsWith('994')
        ? '+$phone'
        : phone.startsWith('0')
        ? '+994${phone.substring(1)}'
        : '+994$phone';
    final request = FamilyRegistrationRequestModel(
      name: _firstNameController.text.trim(),
      surname: _lastNameController.text.trim(),
      fin: _finController.text.trim().toUpperCase(),
      seriaNumber: _seriaNumberController.text.trim().toUpperCase(),
      phone: normalizedPhone,
      regionId: _regionId!,
      address: _addressController.text.trim(),
      familyStatus: _familyStatus!,
      note: combinedNote.isEmpty ? null : combinedNote,
      salary: _moneyValue(_incomeControllers[0]),
      physicalLabor: _moneyValue(_incomeControllers[1]),
      sosial: _moneyValue(_incomeControllers[2]),
      scholarship: _moneyValue(_incomeControllers[3]),
      financialAssistance: _moneyValue(_incomeControllers[4]),
      charity: _moneyValue(_incomeControllers[5]),
      individualAssistance: _moneyValue(_incomeControllers[6]),
      education: _moneyValue(_incomeControllers[7]),
      educationEx: _moneyValue(_expenseControllers[0]),
      rentEx: _moneyValue(_expenseControllers[1]),
      electricEx: _moneyValue(_expenseControllers[2]),
      waterEx: _moneyValue(_expenseControllers[3]),
      gasEx: _moneyValue(_expenseControllers[4]),
      heatingSystemEx: _moneyValue(_expenseControllers[5]),
      communicationEx: _moneyValue(_expenseControllers[6]),
      lat: _currentPosition!.latitude.toString(),
      lng: _currentPosition!.longitude.toString(),
      nameMember: members
          .map((m) => m.firstNameController.text.trim())
          .toList(),
      surnameMember: members
          .map((m) => m.lastNameController.text.trim())
          .toList(),
      statusMember: members.map((m) => m.relationId!).toList(),
      birthMember: members.map((m) => _dateForApi(m.birthday!)).toList(),
      salaryMember: members
          .map((m) => num.tryParse(m.incomeController.text.trim()) ?? 0)
          .toList(),
      documents: _documents.map((document) => document.path).toList(),
      title: _documents.map((document) => document.title.trim()).toList(),
    );
    setState(() => _isSubmitting = true);
    _familiesBloc.add(RegisterFamilyEvent(request: request));
  }

  void _onRegistrationState(BuildContext context, FamiliesState state) {
    if (state is FamilyRegistrationLoading) {
      setState(() => _isSubmitting = true);
    } else if (state is FamilyRegistrationFailure) {
      setState(() => _isSubmitting = false);
      AppAlertDialog.showError(
        context: context,
        message: state.message,
        title: 'Qeydiyyat alınmadı',
        onRetry: _submitRegistration,
      );
    } else if (state is FamilyRegistrationSuccess) {
      setState(() => _isSubmitting = false);
      // Success ekranını BlocConsumer.builder göstərir.
      // Formdan çıxış yalnız istifadəçi düyməni basanda baş verir.
    }
  }

  void _finishRegistration() {
    if (!mounted) return;
    _clearForm();
    context.go(AppRoutes.home);
  }

  void _editStep(int step) {
    if (_isSubmitting) return;
    if (step < 1 || step > 6) return;
    FocusScope.of(context).unfocus();
    setState(() => _currentStep = step);
  }

  static const Map<int, String> _relationNames = {
    0: 'Ana',
    1: 'Ata',
    2: 'Oğlu',
    3: 'Qızı',
    4: 'Nənə',
    5: 'Baba',
    6: 'Nəvə',
  };
  int _sumControllers(List<TextEditingController> controllers) => controllers
      .fold(0, (total, c) => total + (int.tryParse(c.text.trim()) ?? 0));
  String _memberLine(FamilyMemberDraft member) {
    final name = member.fullName.isEmpty
        ? 'Ad qeyd edilməyib'
        : member.fullName;
    final status = _relationNames[member.relationId] ?? 'Status seçilməyib';
    final income = int.tryParse(member.incomeController.text.trim()) ?? 0;
    final birthday = member.birthday;
    final date = birthday == null
        ? ''
        : ' • ${birthday.day.toString().padLeft(2, '0')}.${birthday.month.toString().padLeft(2, '0')}.${birthday.year}';
    return '$name ($status$date) — $income AZN';
  }

  // ADDIM 1 — Validation
  void _validatePersonalInformation() {
    final isValid = _personalFormKey.currentState?.validate() ?? false;
    if (!isValid) return;
    setState(() {
      _currentStep = 2;
    });
  }

  // ADDIM 2 — Validation
  void _validateAddressInformation() {
    final isValid = _addressFormKey.currentState?.validate() ?? false;
    if (!isValid) return;
    if (_regionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rayon / Şəhər seçilməlidir.')),
      );
      return;
    }
    if (_currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Davam etmək üçün cari GPS '
            'koordinatları alınmalıdır.',
          ),
        ),
      );
      return;
    }
    setState(() {
      _currentStep = 3;
    });
  }

  // ADDIM 3 — Ailə üzvləri könüllüdür
  void _continueFromMembers() {
    setState(() {
      _currentStep = 4;
    });
  }

  // ADDIM 4 — Gəlir məlumatları könüllüdür.
  void _continueFromIncome() {
    setState(() {
      _currentStep = 5;
    });
  }

  // ADDIM 5 — Xərc məlumatları könüllüdür.
  void _continueFromExpenses() {
    setState(() {
      _currentStep = 6;
    });
  }

  // Hazırkı addımın forması
  Widget _buildCurrentForm() {
    switch (_currentStep) {
      // ADDIM 1
      case 1:
        return PersonalInformationForm(
          formKey: _personalFormKey,
          firstNameController: _firstNameController,
          lastNameController: _lastNameController,
          finController: _finController,
          seriaNumberController: _seriaNumberController,
          phoneController: _phoneController,
          noteController: _noteController,
          familyStatus: _familyStatus,
          onFamilyStatusChanged: (value) {
            setState(() {
              _familyStatus = value;
            });
          },
        );
      // ADDIM 2
      case 2:
        return AddressInformationForm(
          formKey: _addressFormKey,
          regionId: _regionId,
          onRegionChanged: (value) {
            setState(() {
              _regionId = value;
            });
          },
          addressController: _addressController,
          position: _currentPosition,
          onPositionChanged: (position) {
            setState(() {
              _currentPosition = position;
            });
          },
        );
      // ADDIM 3
      case 3:
        return FamilyMembersForm(
          key: _membersWidgetKey,
          formKey: _membersFormKey,
          members: _members,
        );
      // ADDIM 4
      case 4:
        return IncomeInformationForm(controllers: _incomeControllers);
      // ADDIM 5
      case 5:
        return ExpenseInformationForm(
          controllers: _expenseControllers,
          incomeControllers: _incomeControllers,
        );
      // ADDIM 6
      case 6:
        return SocialWorkerNotesForm(
          notesController: _socialWorkerNotesController,
          documents: _documents,
        );
      // ADDIM 7 — Real məlumatlarla yekun baxış
      case 7:
        return RegistrationReviewForm(
          fullName:
              '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}'
                  .trim(),
          // Yeni sahələr
          fin: _finController.text.trim(),
          seriaNumber: _seriaNumberController.text.trim(),
          phone: _phoneController.text.trim(),
          familyStatus: _relationNames[_familyStatus] ?? 'Seçilməyib',
          personalNote: _noteController.text,
          region: switch (_regionId) {
            1 => 'Bakı',
            2 => 'Sumqayıt',
            _ => 'Seçilməyib',
          },
          address: _addressController.text.trim(),
          coordinates: _currentPosition == null
              ? null
              : '${_currentPosition!.latitude.toStringAsFixed(6)}° N, '
                    '${_currentPosition!.longitude.toStringAsFixed(6)}° E',
          members: _members
              .where(
                (member) =>
                    member.fullName.isNotEmpty ||
                    member.relationId != null ||
                    member.birthday != null ||
                    member.incomeController.text.trim().isNotEmpty,
              )
              .map(_memberLine)
              .toList(),
          totalIncome: _sumControllers(_incomeControllers),
          totalExpense: _sumControllers(_expenseControllers),
          documentTitles: _documents.map((document) => document.title).toList(),
          socialWorkerNote: _socialWorkerNotesController.text,
          onEditStep: _editStep,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop || _isSubmitting) return;

        if (_familiesBloc.state is FamilyRegistrationSuccess) {
          _finishRegistration();
          return;
        }

        if (_currentStep > 1) {
          _previousStep();
        } else {
          _cancelRegistration();
        }
      },
      child: BlocProvider<FamiliesBloc>.value(
        value: _familiesBloc,
        child: BlocConsumer<FamiliesBloc, FamiliesState>(
          listener: _onRegistrationState,
          builder: (context, state) {
            if (state is FamilyRegistrationSuccess) {
              return FamilyRegistrationSuccessPage(
                onReturnToFamilies: _finishRegistration,
              );
            }
            return Scaffold(
              backgroundColor: const Color(0xFFFAF9F6),
              appBar: AppBar(
                backgroundColor: Colors.white,
                centerTitle: true,
                surfaceTintColor: Colors.white,
                elevation: 0,
                titleSpacing: 0,
                leading: IconButton(
                  onPressed: _isSubmitting
                      ? null
                      : (_currentStep > 1
                            ? _previousStep
                            : _cancelRegistration),
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
                title: Text(
                  'Yeni Ailə Qeydiyyatı',
                  style: TextStyle(
                    fontSize: context.registrationIsTablet
                        ? 22
                        : 18.regSp(context),
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF242424),
                  ),
                ),
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    // Form hissəsi
                    Expanded(
                      child: ListView(
                        key: ValueKey(_currentStep),
                        padding: EdgeInsets.symmetric(
                          horizontal: context.registrationIsTablet
                              ? 32
                              : 18.regW(context),
                          vertical: 16.regH(context),
                        ),
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        children: [
                          Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 920),
                              child: RegistrationStepHeader(
                                currentStep: _currentStep,
                                onCancel: _isSubmitting
                                    ? () {}
                                    : _cancelRegistration,
                              ),
                            ),
                          ),
                          SizedBox(height: 20.regH(context)),
                          Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 920),
                              child: _buildCurrentForm(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(
                        16.regW(context),
                        12.regH(context),
                        16.regW(context),
                        12.regH(context),
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(color: Color(0xFFEEEEEE)),
                        ),
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 920),
                          child: Row(
                            children: [
                              // Geri düyməsi
                              SizedBox(
                                height: context.registrationIsTablet
                                    ? 56
                                    : 50.regH(context),
                                child: OutlinedButton.icon(
                                  onPressed: !_isSubmitting && _currentStep > 1
                                      ? _previousStep
                                      : null,
                                  icon: const Icon(Icons.arrow_back_rounded),
                                  label: const Text('Geri'),
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        12.regR(context),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.regW(context)),
                              // Davam et düyməsi
                              Expanded(
                                child: SizedBox(
                                  height: context.registrationIsTablet
                                      ? 56
                                      : 50.regH(context),
                                  child: ElevatedButton(
                                    onPressed: _isSubmitting ? null : _nextStep,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFF4B033),
                                      foregroundColor: const Color(0xFF332414),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          12.regR(context),
                                        ),
                                      ),
                                    ),
                                    child: _isSubmitting
                                        ? SizedBox(
                                            height: 22.regR(context),
                                            width: 22.regR(context),
                                            child:
                                                const CircularProgressIndicator(
                                                  strokeWidth: 2.5,
                                                  color: Color(0xFF332414),
                                                ),
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                _currentStep == 7
                                                    ? 'Ailəni qeydiyyata al'
                                                    : 'Davam et',
                                                style: TextStyle(
                                                  fontSize:
                                                      context
                                                          .registrationIsTablet
                                                      ? 18
                                                      : 15.regSp(context),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(width: 8.regW(context)),
                                              Icon(
                                                _currentStep == 7
                                                    ? Icons.check_rounded
                                                    : Icons
                                                          .arrow_forward_rounded,
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
