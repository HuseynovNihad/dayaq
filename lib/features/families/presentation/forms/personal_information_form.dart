import '../registration_responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_validators.dart';
import '../../../../core/widgets/app_dropdown_field.dart';
import '../../../../core/widgets/app_text_field.dart';

class PersonalInformationForm extends StatelessWidget {
  const PersonalInformationForm({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.finController,
    required this.seriaNumberController,
    required this.phoneController,
    required this.noteController,
    required this.familyStatus,
    required this.onFamilyStatusChanged,
  });

  final GlobalKey<FormState> formKey;

  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController finController;
  final TextEditingController seriaNumberController;
  final TextEditingController phoneController;
  final TextEditingController noteController;

  final int? familyStatus;
  final ValueChanged<int?> onFamilyStatusChanged;

  static const Map<int, String> _familyStatusItems = {
    0: 'Ana',
    1: 'Ata',
    2: 'Oğlu',
    3: 'Qızı',
    4: 'Nənə',
    5: 'Baba',
    6: 'Nəvə',
  };

  String? _validateFin(String? value) {
    final fin = value?.trim() ?? '';

    if (fin.isEmpty) {
      return 'FİN kodu daxil edin.';
    }

    if (fin.length != 7) {
      return 'FİN kodu 7 simvol olmalıdır.';
    }

    if (!RegExp(r'^[A-Z0-9]{7}$').hasMatch(fin.toUpperCase())) {
      return 'Yalnız hərf və rəqəm daxil edin.';
    }

    return null;
  }

  String? _validateSeriaNumber(String? value) {
    final seria = value?.trim() ?? '';

    if (seria.isEmpty) {
      return 'Vəsiqənin seriya və nömrəsini daxil edin.';
    }

    if (!RegExp(r'^[A-Z0-9]+$').hasMatch(seria.toUpperCase())) {
      return 'Yalnız hərf və rəqəm daxil edin.';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(
              context.registrationIsTablet ? 22 : 16.regR(context),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18.regR(context)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48.regR(context),
                  height: 48.regR(context),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFDEA2),
                    borderRadius: BorderRadius.circular(14.regR(context)),
                  ),
                  child: Icon(
                    Icons.person_outline_rounded,
                    color: AppColors.textPrimary,
                    size: 27.regR(context),
                  ),
                ),
                SizedBox(width: 12.regW(context)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Şəxsi məlumatlar',
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 5.regH(context)),
                      Text(
                        'Müraciət edən şəxsin şəxsi və əlaqə '
                        'məlumatlarını daxil edin.',
                        style: context.textTheme.bodySmall?.copyWith(
                          height: 1.45,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20.regH(context)),

          // Ad və Soyad
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppTextField(
                  label: 'Ad',
                  hintText: 'Rəşad',
                  requiredField: true,
                  controller: firstNameController,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  validator: AppValidators.requiredField,
                ),
              ),
              SizedBox(width: 12.regW(context)),
              Expanded(
                child: AppTextField(
                  label: 'Soyad',
                  hintText: 'Əliyev',
                  requiredField: true,
                  controller: lastNameController,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  validator: AppValidators.requiredField,
                ),
              ),
            ],
          ),

          SizedBox(height: 18.regH(context)),

          // FIN və şəxsiyyət vəsiqəsi seriya/nömrəsi
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppTextField(
                  label: 'FİN kod',
                  hintText: '5ABC123',
                  requiredField: true,
                  controller: finController,
                  textCapitalization: TextCapitalization.characters,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                    UpperCaseTextFormatter(),
                    LengthLimitingTextInputFormatter(7),
                  ],
                  validator: _validateFin,
                ),
              ),

              SizedBox(width: 12.regW(context)),

              Expanded(
                child: AppTextField(
                  label: 'Vəsiqə seriyası / №',
                  hintText: 'AA1234567',
                  requiredField: true,
                  controller: seriaNumberController,
                  textCapitalization: TextCapitalization.characters,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                    UpperCaseTextFormatter(),
                    LengthLimitingTextInputFormatter(20),
                  ],
                  validator: _validateSeriaNumber,
                ),
              ),
            ],
          ),

          SizedBox(height: 18.regH(context)),

          // Telefon nömrəsi
          AppTextField(
            label: 'Telefon nömrəsi',
            hintText: '501234567',
            requiredField: true,
            controller: phoneController,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 14.regW(context)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.phone_outlined,
                    size: 18.regR(context),
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(width: 7.regW(context)),
                  Text(
                    '+994',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(width: 7.regW(context)),
                ],
              ),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(9),
            ],
            validator: AppValidators.phone,
          ),

          SizedBox(height: 18.regH(context)),

          // Ailə statusu
          AppDropdownField<int>(
            label: 'Ailə statusu',
            requiredField: true,
            hintText: 'Ailədəki statusunu seçin',
            value: familyStatus,
            prefixIcon: Icon(
              Icons.groups_outlined,
              color: AppColors.textSecondary,
              size: 20.regR(context),
            ),
            items: _familyStatusItems.entries.map((entry) {
              return DropdownMenuItem<int>(
                value: entry.key,
                child: Text(entry.value),
              );
            }).toList(),
            onChanged: onFamilyStatusChanged,
            validator: (value) {
              if (value == null) {
                return 'Ailə statusunu seçin.';
              }
              return null;
            },
          ),

          SizedBox(height: 18.regH(context)),

          // Müraciət qeydi
          AppTextField(
            label: 'Müraciət qeydi',
            hintText:
                'Məsələn: Çoxuşaqlı ailə, tənha ana, '
                'qazi ailəsi...',
            controller: noteController,
            keyboardType: TextInputType.multiline,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.newline,
            maxLines: 4,
            maxLength: 500,
          ),

          SizedBox(height: 12.regH(context)),
        ],
      ),
    );
  }
}

// Kiçik hərfləri avtomatik böyük hərfə çevirir.
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}
