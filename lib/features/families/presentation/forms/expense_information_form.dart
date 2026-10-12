import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';

class ExpenseInformationForm extends StatefulWidget {
  const ExpenseInformationForm({
    super.key,
    required this.controllers,
    required this.incomeControllers,
  }) : assert(controllers.length == 7),
       assert(incomeControllers.length == 8);

  final List<TextEditingController> controllers;
  final List<TextEditingController> incomeControllers;

  static const fieldNames = <String>[
    'education_ex',
    'rent_ex',
    'electric_ex',
    'water_ex',
    'gas_ex',
    'heating_system_ex',
    'communication_ex',
  ];

  static int parseAmount(String input) => int.tryParse(input.trim()) ?? 0;

  static Map<String, int> toRequestBody(
    List<TextEditingController> controllers,
  ) {
    assert(controllers.length == 7);
    return {
      for (var i = 0; i < fieldNames.length; i++)
        fieldNames[i]: parseAmount(controllers[i].text),
    };
  }

  @override
  State<ExpenseInformationForm> createState() => _ExpenseInformationFormState();
}

class _ExpenseInformationFormState extends State<ExpenseInformationForm> {
  static final _formatters = <TextInputFormatter>[
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(9),
  ];

  @override
  void initState() {
    super.initState();
    _listen(widget.controllers);
    _listen(widget.incomeControllers);
  }

  void _listen(List<TextEditingController> items) {
    for (final c in items) {
      c.addListener(_update);
    }
  }

  void _unlisten(List<TextEditingController> items) {
    for (final c in items) {
      c.removeListener(_update);
    }
  }

  @override
  void didUpdateWidget(covariant ExpenseInformationForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.controllers, widget.controllers)) {
      _unlisten(oldWidget.controllers);
      _listen(widget.controllers);
    }
    if (!identical(oldWidget.incomeControllers, widget.incomeControllers)) {
      _unlisten(oldWidget.incomeControllers);
      _listen(widget.incomeControllers);
    }
  }

  void _update() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _unlisten(widget.controllers);
    _unlisten(widget.incomeControllers);
    super.dispose();
  }

  int get _totalIncome => widget.incomeControllers.fold<int>(
    0,
    (sum, c) => sum + ExpenseInformationForm.parseAmount(c.text),
  );

  int get _totalExpense => widget.controllers.fold<int>(
    0,
    (sum, c) => sum + ExpenseInformationForm.parseAmount(c.text),
  );

  String _differenceLabel(int value) => '${value > 0 ? '+' : ''}$value AZN';

  InputDecoration _decoration() => InputDecoration(
    hintText: '0',
    suffixText: 'AZN',
    suffixStyle: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
    filled: true,
    fillColor: Colors.white,
    contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: const BorderSide(color: Color(0xFFDED8D5)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
    ),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
  );

  Widget _summary() {
    final income = _totalIncome;
    final expense = _totalExpense;
    final difference = income - expense;
    final ratio = income == 0
        ? (expense > 0 ? 1.0 : 0.0)
        : (expense / income).clamp(0.0, 1.0).toDouble();

    Widget metric(String label, String value, Color color) => Expanded(
      child: Column(
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
          ),
          SizedBox(height: 6.h),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(19.r),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              metric('Ümumi gəlir', '$income AZN', AppColors.textPrimary),
              Container(width: 1, height: 48.h, color: const Color(0xFFDADADA)),
              metric('Ümumi xərc', '$expense AZN', const Color(0xFFD9232B)),
              Container(width: 1, height: 48.h, color: const Color(0xFFDADADA)),
              metric(
                'Qalıq fərq',
                _differenceLabel(difference),
                difference < 0
                    ? const Color(0xFFD9232B)
                    : const Color(0xFF173CBD),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 10.h,
              backgroundColor: const Color(0xFFE1E1E1),
              valueColor: const AlwaysStoppedAnimation(Color(0xFFD9232B)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _largeExpense(int index, String title, String subtitle) => Container(
    margin: EdgeInsets.only(bottom: 12.h),
    padding: EdgeInsets.all(14.r),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(17.r),
      border: Border.all(color: const Color(0xFFDDD7D4)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 3.h),
        Text(
          subtitle,
          style: context.textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 10.h),
        TextField(
          controller: widget.controllers[index],
          keyboardType: TextInputType.number,
          inputFormatters: _formatters,
          decoration: _decoration(),
        ),
      ],
    ),
  );

  Widget _utility(int index, IconData icon, Color color, String label) =>
      Padding(
        padding: EdgeInsets.symmetric(vertical: 7.h),
        child: Row(
          children: [
            Icon(icon, size: 20.r, color: color),
            SizedBox(width: 10.w),
            Expanded(child: Text(label, style: context.textTheme.bodyMedium)),
            SizedBox(
              width: 118.w,
              child: TextField(
                controller: widget.controllers[index],
                textAlign: TextAlign.end,
                keyboardType: TextInputType.number,
                inputFormatters: _formatters,
                decoration: _decoration(),
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _summary(),
        SizedBox(height: 25.h),
        Row(
          children: [
            const Icon(Icons.receipt_long_rounded, color: Color(0xFFD9232B)),
            SizedBox(width: 9.w),
            Expanded(
              child: Text(
                'Aylıq məişət və sosial xərclər',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        _largeExpense(1, 'Kirayə xərci', 'Aylıq ev kirayəsi'),
        _largeExpense(0, 'Təhsil xərcləri', 'Məktəb ləvazimatı / hazırlıq'),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: const Color(0xFFE2E2E2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'KOMMUNAL XƏRCLƏR',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 8.h),
              _utility(2, Icons.bolt_rounded, Colors.orange, 'Elektrik xərci'),
              const Divider(height: 8),
              _utility(3, Icons.water_drop_rounded, Colors.blue, 'Su xərci'),
              const Divider(height: 8),
              _utility(
                4,
                Icons.local_fire_department_rounded,
                Colors.deepOrange,
                'Qaz xərci',
              ),
              const Divider(height: 8),
              _utility(
                5,
                Icons.thermostat_rounded,
                Colors.red,
                'İstilik sistemi',
              ),
              const Divider(height: 8),
              _utility(
                6,
                Icons.wifi_rounded,
                Colors.indigo,
                'Rabitə və internet',
              ),
            ],
          ),
        ),
        SizedBox(height: 18.h),
      ],
    );
  }
}
