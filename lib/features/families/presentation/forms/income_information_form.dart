import '../registration_responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    'Müraciət edən şəxs və ailə üzvlərinin əməkhaqqı cəmi',
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

  InputDecoration _inputDecoration({bool isLocked = false}) {
    final radius = BorderRadius.circular(13.regR(context));

    return InputDecoration(
      hintText: '0',
      suffixText: 'AZN',
      suffixStyle: TextStyle(
        fontSize: 13.regSp(context),
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w600,
      ),
      filled: true,
      fillColor: isLocked ? const Color(0xFFF3F1EE) : Colors.white,
      prefixIcon: isLocked
          ? Icon(
              Icons.lock_outline_rounded,
              size: 18.regR(context),
              color: AppColors.textSecondary,
            )
          : null,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 13.regW(context),
        vertical: 14.regH(context),
      ),
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
      padding: EdgeInsets.all(14.regR(context)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17.regR(context)),
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

          SizedBox(height: 4.regH(context)),

          Text(
            _subtitles[index],
            style: context.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),

          SizedBox(height: 12.regH(context)),

          TextField(
            controller: widget.controllers[index],
            readOnly: index == 0,
            showCursor: index != 0,
            enableInteractiveSelection: index != 0,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            inputFormatters: _inputFormatters,
            decoration: _inputDecoration(isLocked: index == 0),
          ),
        ],
      ),
    );
  }

  Widget _compactIncomeField(int index) {
    return Container(
      padding: EdgeInsets.all(12.regR(context)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17.regR(context)),
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

          SizedBox(height: 10.regH(context)),

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
      padding: EdgeInsets.all(20.regR(context)),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFE8BC), Color(0xFFFFF4DE)],
        ),
        borderRadius: BorderRadius.circular(20.regR(context)),
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

                SizedBox(height: 6.regH(context)),

                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: _formatMoney(_total),
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: context.registrationIsTablet
                              ? 36
                              : 29.regSp(context),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      TextSpan(
                        text: ' AZN',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 15.regSp(context),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 12.regW(context)),

          Container(
            width: 54.regR(context),
            height: 54.regR(context),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(15.regR(context)),
            ),
            child: Icon(
              Icons.account_balance_wallet_rounded,
              size: 27.regR(context),
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
          size: 23.regR(context),
        ),

        SizedBox(width: 8.regW(context)),

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

        SizedBox(height: 26.regH(context)),

        _buildSectionHeader(),

        SizedBox(height: 16.regH(context)),

        // On tablets, use two balanced columns; keep phone layout unchanged.
        if (context.registrationIsTablet)
          for (final pair in const <List<int>>[
            [0, 1],
            [2, 3],
            [4, 6],
            [5, 7],
          ]) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _incomeRow(pair[0])),
                const SizedBox(width: 16),
                Expanded(child: _incomeRow(pair[1])),
              ],
            ),
            const SizedBox(height: 14),
          ]
        else ...[
          for (var i = 0; i < 5; i++) ...[
            _incomeRow(i),
            SizedBox(height: 12.regH(context)),
          ],
          _incomeRow(6),
          SizedBox(height: 12.regH(context)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _compactIncomeField(5)),
              SizedBox(width: 12.regW(context)),
              Expanded(child: _compactIncomeField(7)),
            ],
          ),
        ],

        SizedBox(height: 18.regH(context)),
      ],
    );
  }
}
