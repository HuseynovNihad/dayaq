import '../registration_responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_dropdown_field.dart';
import '../../../../core/widgets/app_text_field.dart';

class FamilyMemberDraft {
  FamilyMemberDraft({required this.id});

  final int id;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final incomeController = TextEditingController();

  int? relationId;
  DateTime? birthday;

  String get fullName =>
      '${firstNameController.text.trim()} '
              '${lastNameController.text.trim()}'
          .trim();

  String get incomeLabel {
    final value = incomeController.text.trim();
    return value.isEmpty ? '0' : value;
  }

  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    incomeController.dispose();
  }
}

class FamilyMembersForm extends StatefulWidget {
  const FamilyMembersForm({
    super.key,
    required this.formKey,
    required this.members,
  });

  final GlobalKey<FormState> formKey;
  final List<FamilyMemberDraft> members;

  @override
  State<FamilyMembersForm> createState() => FamilyMembersFormState();
}

class FamilyMembersFormState extends State<FamilyMembersForm> {
  static const Map<int, String> _relations = {
    0: 'Ana',
    1: 'Ata',
    2: 'Oğlu',
    3: 'Qızı',
    4: 'Nənə',
    5: 'Baba',
    6: 'Nəvə',
  };

  int? _expandedMemberId;
  int _nextMemberId = 1;

  @override
  void initState() {
    super.initState();

    _nextMemberId = widget.members.isEmpty
        ? 1
        : widget.members
                  .map((member) => member.id)
                  .reduce((a, b) => a > b ? a : b) +
              1;

    _expandedMemberId = widget.members.isEmpty ? null : widget.members.first.id;
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day.$month.${date.year}';
  }

  String _relationLabel(int? id) {
    if (id == null) return 'Status qeyd edilməyib';
    return _relations[id] ?? 'Naməlum';
  }

  // Ailə üzvləri mərhələsi könüllüdür.
  // Heç bir üzv daxil edilmədən və ya sahələr boş olduqda davam edilə bilər.
  bool validateMembers() => true;

  void _addMember() {
    final newMember = FamilyMemberDraft(id: _nextMemberId++);

    setState(() {
      widget.members.add(newMember);
      _expandedMemberId = newMember.id;
    });
  }

  Future<void> _removeMember(FamilyMemberDraft member) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Ailə üzvünü sil?'),
        content: const Text(
          'Bu ailə üzvünün daxil edilmiş məlumatları silinəcək.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Geri qayıt'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Sil', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() {
      widget.members.remove(member);

      if (_expandedMemberId == member.id) {
        _expandedMemberId = widget.members.isEmpty
            ? null
            : widget.members.first.id;
      }
    });

    // Widget ağacından ayrıldıqdan sonra controller-ləri təmizlə.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      member.dispose();
    });
  }

  Future<void> _selectBirthday(FamilyMemberDraft member) async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: member.birthday ?? DateTime(now.year - 20),
      firstDate: DateTime(1900),
      lastDate: now,
      helpText: 'Doğum tarixini seçin',
      cancelText: 'Ləğv et',
      confirmText: 'Seç',
    );

    if (picked == null || !mounted) return;

    setState(() {
      member.birthday = picked;
    });
  }

  Widget _buildSectionHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ailə üzvləri',
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 4.regH(context)),
              Text(
                'Qeydiyyata alınan üzv sayı: '
                '${widget.members.length} nəfər (istəyə bağlı)',
                style: context.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 10.regW(context)),
        FilledButton.icon(
          onPressed: _addMember,
          icon: const Icon(Icons.add_rounded, size: 18),
          label: const Text('Üzv əlavə et'),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFFFDEA2),
            foregroundColor: Colors.black,
            elevation: 0,
            padding: EdgeInsets.symmetric(
              horizontal: 12.regW(context),
              vertical: 11.regH(context),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(FamilyMemberDraft member) {
    return FormField<DateTime>(
      key: ValueKey('birthday_${member.id}_${member.birthday}'),
      initialValue: member.birthday,
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Doğum tarixi',
              style: context.textTheme.titleSmall?.copyWith(
                fontSize: context.registrationIsTablet ? 16 : 14.regSp(context),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10.regH(context)),
            InkWell(
              onTap: () => _selectBirthday(member),
              borderRadius: BorderRadius.circular(15.regR(context)),
              child: InputDecorator(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.regW(context),
                    vertical: 16.regH(context),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.regR(context)),
                    borderSide: const BorderSide(color: Color(0xFFDED8D5)),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.regR(context)),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        member.birthday == null
                            ? 'Tarix seçin'
                            : _formatDate(member.birthday),
                        style: TextStyle(
                          fontSize: 13.regSp(context),
                          color: member.birthday == null
                              ? AppColors.textSecondary
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 17.regR(context),
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildExpandedMember(FamilyMemberDraft member, int index) {
    return Container(
      key: ValueKey('expanded_${member.id}'),
      padding: EdgeInsets.all(
        context.registrationIsTablet ? 22 : 16.regR(context),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.regR(context)),
        border: Border.all(color: AppColors.primary, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18.regR(context),
                backgroundColor: Colors.black,
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: 10.regW(context)),
              Expanded(
                child: Text(
                  'Ailə üzvü ${index + 1}',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () => _removeMember(member),
                icon: const Icon(Icons.delete_outline_rounded, size: 18),
                label: const Text('Sil'),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
              ),
            ],
          ),

          Divider(height: 26.regH(context)),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppTextField(
                  label: 'Ad',
                  hintText: 'Ad',
                  controller: member.firstNameController,
                  textCapitalization: TextCapitalization.words,
                ),
              ),
              SizedBox(width: 10.regW(context)),
              Expanded(
                child: AppTextField(
                  label: 'Soyad',
                  hintText: 'Soyad',
                  controller: member.lastNameController,
                  textCapitalization: TextCapitalization.words,
                ),
              ),
            ],
          ),

          SizedBox(height: 18.regH(context)),

          AppDropdownField<int>(
            key: ValueKey('relation_${member.id}'),
            label: 'Qohumluq əlaqəsi / Status',
            hintText: 'Statusu seçin',
            value: member.relationId,
            items: _relations.entries
                .map(
                  (entry) => DropdownMenuItem<int>(
                    value: entry.key,
                    child: Text(entry.value),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                member.relationId = value;
              });
            },
          ),

          SizedBox(height: 18.regH(context)),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildDateField(member)),
              SizedBox(width: 10.regW(context)),
              Expanded(
                child: AppTextField(
                  label: 'Aylıq fərdi gəlir',
                  hintText: '0 AZN',
                  controller: member.incomeController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCollapsedMember(FamilyMemberDraft member, int index) {
    return Container(
      key: ValueKey('collapsed_${member.id}'),
      padding: EdgeInsets.all(14.regR(context)),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(18.regR(context)),
        border: Border.all(color: const Color(0xFFE1E1E1)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 21.regR(context),
            backgroundColor: const Color(0xFFE4E4E4),
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(width: 12.regW(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.fullName.isEmpty
                      ? 'Ailə üzvü ${index + 1}'
                      : member.fullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4.regH(context)),
                Text(
                  '${_relationLabel(member.relationId)}'
                  ' • ${_formatDate(member.birthday).isEmpty ? "Tarix yoxdur" : _formatDate(member.birthday)}'
                  ' • ${member.incomeLabel} AZN',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Redaktə et',
            onPressed: () {
              setState(() {
                _expandedMemberId = member.id;
              });
            },
            icon: const Icon(Icons.edit_rounded, color: Color(0xFF173CBD)),
          ),
          IconButton(
            tooltip: 'Sil',
            onPressed: () => _removeMember(member),
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(),
          SizedBox(height: 18.regH(context)),
          if (widget.members.isEmpty) ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(18.regR(context)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.regR(context)),
                border: Border.all(color: const Color(0xFFF0ECE7)),
              ),
              child: Text(
                'Ailə üzvlərini əlavə etmək məcburi deyil. '
                'İstəsəniz, bu mərhələni keçə bilərsiniz.',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            SizedBox(height: 14.regH(context)),
          ],

          for (var index = 0; index < widget.members.length; index++) ...[
            if (widget.members[index].id == _expandedMemberId)
              _buildExpandedMember(widget.members[index], index)
            else
              _buildCollapsedMember(widget.members[index], index),

            SizedBox(height: 12.regH(context)),
          ],

          SizedBox(height: 10.regH(context)),

          InkWell(
            onTap: _addMember,
            borderRadius: BorderRadius.circular(18.regR(context)),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20.regH(context)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18.regR(context)),
                border: Border.all(
                  color: const Color(0xFFC7C0BD),
                  width: 1.5,
                  style: BorderStyle.solid,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.add_circle_rounded,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 8.regW(context)),
                  Text(
                    'Növbəti ailə üzvünü əlavə et',
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 16.regH(context)),
        ],
      ),
    );
  }
}
