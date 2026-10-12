import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';

class IncomeInformationForm extends StatefulWidget {
  const IncomeInformationForm({super.key, required this.controllers})
    : assert(
        controllers.length == 8,
        'Gəlir məlumatları üçün 8 controller tələb olunur.',
      );

  final List<TextEditingController> controllers;

  // Backend-in qəbul etdiyi field adları.
  static const List<String> fieldNames = [
    'salary',
    'physical_labor',
    'sosial',
    'scholarship',
    'financial_assistance',
    'charity',
    'individual_assistance',
    'education',
  ];

  static int parseAmount(String value) {
    return int.tryParse(value.trim()) ?? 0;
  }

  // Gələcək POST sorğusunda istifadə ediləcək məlumatlar.
  static Map<String, int> toRequestBody(
    List<TextEditingController> controllers,
  ) {
    assert(controllers.length == 8);

    return {
      for (var i = 0; i < fieldNames.length; i++)
        fieldNames[i]: parseAmount(controllers[i].text),
    };
  }

  @override
  State<IncomeInformationForm> createState() => _IncomeInformationFormState();
}

class _IncomeInformationFormState extends State<IncomeInformationForm> {
  static const List<String> _titles = [
    'Əməkhaqqı (Rəsmi)',
    'Fiziki əmək gəliri',
    'Sosial ödənişlər / Müavinət',
    'Təqaüd',
    'Maddi yardım',
    'Xeyriyyə yardımı',
    'Fərdi yardım',
    'Təhsil üzrə gəlir',
  ];

  static const List<String> _subtitles = [
    'Əsas iş yerindən gəlir',
    'Gündəlik / mövsümi fəhləlik',
    'Dövlət sosial ödənişləri və müavinətlər',
    'Tələbə və ya əlillik təqaüdü',
    'Qohumlardan və yaxınlardan maddi dəstək',
    'Xeyriyyə təşkilatlarından aylıq yardım',
    'Fərdi şəxslərdən alınan yardım',
    'Təhsillə bağlı gəlir',
  ];

  static final List<TextInputFormatter> _inputFormatters = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(9),
  ];

  @override
  void initState() {
    super.initState();

    for (final controller in widget.controllers) {
      controller.addListener(_refreshTotal);
    }
  }

  @override
  void didUpdateWidget(covariant IncomeInformationForm oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!identical(oldWidget.controllers, widget.controllers)) {
      for (final controller in oldWidget.controllers) {
        controller.removeListener(_refreshTotal);
      }

      for (final controller in widget.controllers) {
        controller.addListener(_refreshTotal);
      }
    }
  }

  @override
  void dispose() {
    for (final controller in widget.controllers) {
      controller.removeListener(_refreshTotal);
    }

    super.dispose();
  }

  void _refreshTotal() {
    if (mounted) {
      setState(() {});
    }
  }

  int _amount(int index) {
    return IncomeInformationForm.parseAmount(widget.controllers[index].text);
  }

  int get _total {
    var total = 0;

    for (var i = 0; i < widget.controllers.length; i++) {
      total += _amount(i);
    }

    return total;
  }

  String _formatMoney(int amount) {
    return '${amount.toStringAsFixed(0)}.00';
  }

  InputDecoration _inputDecoration() {
    final radius = BorderRadius.circular(13.r);

    return InputDecoration(
      hintText: '0',
      suffixText: 'AZN',
      suffixStyle: TextStyle(
        fontSize: 13.sp,
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w600,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 14.h),
      enabledBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: const BorderSide(color: Color(0xFFE0DCDA)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      border: OutlineInputBorder(borderRadius: radius),
    );
  }

  Widget _incomeRow(int index) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17.r),
        border: Border.all(color: const Color(0xFFE0DCDA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _titles[index],
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),

          SizedBox(height: 4.h),

          Text(
            _subtitles[index],
            style: context.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),

          SizedBox(height: 12.h),

          TextField(
            controller: widget.controllers[index],
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            inputFormatters: _inputFormatters,
            decoration: _inputDecoration(),
          ),
        ],
      ),
    );
  }

  Widget _compactIncomeField(int index) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17.r),
        border: Border.all(color: const Color(0xFFE0DCDA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _titles[index],
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodySmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: 10.h),

          TextField(
            controller: widget.controllers[index],
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            inputFormatters: _inputFormatters,
            decoration: _inputDecoration(),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFE8BC), Color(0xFFFFF4DE)],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.primary),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ümumi aylıq gəlir',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: 6.h),

                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: _formatMoney(_total),
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 29.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      TextSpan(
                        text: ' AZN',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 12.w),

          Container(
            width: 54.r,
            height: 54.r,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Icon(
              Icons.account_balance_wallet_rounded,
              size: 27.r,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      children: [
        Icon(
          Icons.monetization_on_rounded,
          color: AppColors.primary,
          size: 23.r,
        ),

        SizedBox(width: 8.w),

        Expanded(
          child: Text(
            'Gəlir mənbələri (Aylıq)',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTotalCard(),

        SizedBox(height: 26.h),

        _buildSectionHeader(),

        SizedBox(height: 16.h),

        // İlk 5 gəlir mənbəyi.
        for (var i = 0; i < 5; i++) ...[_incomeRow(i), SizedBox(height: 12.h)],

        // Fərdi yardım (individual_assistance).
        _incomeRow(6),

        SizedBox(height: 12.h),

        // Xeyriyyə yardımı və təhsil üzrə gəlir.
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _compactIncomeField(5)),

            SizedBox(width: 12.w),

            Expanded(child: _compactIncomeField(7)),
          ],
        ),

        SizedBox(height: 18.h),
      ],
    );
  }
}
