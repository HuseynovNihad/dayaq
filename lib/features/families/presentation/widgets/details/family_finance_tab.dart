import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/family_details_entity.dart';
import 'detail_common_widgets.dart';

class FamilyFinanceTab extends StatelessWidget {
  const FamilyFinanceTab({super.key, required this.details});
  final FamilyDetailsEntity details;
  String _money(num value) {
    return '${NumberFormat('#,##0.00', 'en_US').format(value)} AZN';
  }

  @override
  Widget build(BuildContext context) {
    final income = details.monthlyIncome;
    final expenses = details.totalExpenses;
    final remaining = details.remainingIncome;
    final percentage = income > 0 ? (expenses / income * 100).round() : 0;
    final progress = income > 0
        ? (expenses / income).clamp(0.0, 1.0).toDouble()
        : 0.0;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _FinanceSummary(
                title: 'Aylıq gəlir',
                amount: _money(income),
                amountColor: AppColors.textPrimary,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: _FinanceSummary(
                title: 'Aylıq xərclər',
                amount: _money(expenses),
                amountColor: const Color(0xFFD8202C),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: _FinanceSummary(
                title: 'Qalan məbləğ',
                amount: _money(remaining),
                amountColor: remaining < 0
                    ? const Color(0xFFD8202C)
                    : const Color(0xFF1642B7),
                highlighted: true,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        DetailCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Gəlir-Xərc nisbəti',
                      style: context.textTheme.titleSmall?.copyWith(
            fontSize: MediaQuery.sizeOf(context).shortestSide >= 600 ? 20 : null,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    income > 0 ? 'Xərc: $percentage%' : 'Gəlir yoxdur',
                    style: context.textTheme.labelMedium?.copyWith(
                      color: const Color(0xFFD8202C),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 12.h,
                  backgroundColor: const Color(0xFF11B887),
                  color: const Color(0xFFD8202C),
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Xərclər: ${_money(expenses)}',
                      style: context.textTheme.bodySmall?.copyWith(
            fontSize: MediaQuery.sizeOf(context).shortestSide >= 600 ? 15 : null,
                        color: const Color(0xFF777777),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Qalıq: ${_money(remaining)}',
                      textAlign: TextAlign.right,
                      style: context.textTheme.bodySmall?.copyWith(
            fontSize: MediaQuery.sizeOf(context).shortestSide >= 600 ? 15 : null,
                        color: const Color(0xFF777777),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        DetailCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DetailSectionTitle('XƏRC TƏFƏRRÜATLARI'),
              SizedBox(height: 8.h),
              _ExpenseRow(
                icon: Icons.home_rounded,
                color: const Color(0xFF697483),
                label: 'Kirayə xərci',
                value: _money(details.rentEx),
              ),
              _ExpenseRow(
                icon: Icons.water_drop_rounded,
                color: const Color(0xFF4585F4),
                label: 'Kommunal xərclər',
                value: _money(details.communalEx),
              ),
              _ExpenseRow(
                icon: Icons.medication_rounded,
                color: const Color(0xFF9A59E8),
                label: 'Xroniki xəstəlik xərcləri',
                value: _money(details.chronicPatientEx),
              ),
              _ExpenseRow(
                icon: Icons.credit_card_rounded,
                color: const Color(0xFFFFA51D),
                label: 'Aylıq borc ödənişləri',
                value: _money(details.monthlyDebtEx),
              ),
              _ExpenseRow(
                icon: Icons.medical_services_outlined,
                color: const Color(0xFFE74652),
                label: 'Tibbi xərclər',
                value: _money(details.monthlyMedicalEx),
                last: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FinanceSummary extends StatelessWidget {
  const _FinanceSummary({
    required this.title,
    required this.amount,
    required this.amountColor,
    this.highlighted = false,
  });
  final String title;
  final String amount;
  final Color amountColor;
  final bool highlighted;
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: MediaQuery.sizeOf(context).shortestSide >= 600 ? 112 : 82.h),
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).shortestSide >= 600 ? 12 : 5.w,
          vertical: MediaQuery.sizeOf(context).shortestSide >= 600 ? 16 : 10.h,
        ),
      decoration: BoxDecoration(
        color: highlighted ? const Color(0xFFFFF3D5) : const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: highlighted
              ? const Color(0xFFFFD57C)
              : const Color(0xFFE5E5E5),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.labelSmall?.copyWith(
              color: const Color(0xFF696969),
            ),
          ),
          SizedBox(height: 7.h),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              amount,
              style: context.textTheme.titleSmall?.copyWith(
            fontSize: MediaQuery.sizeOf(context).shortestSide >= 600 ? 20 : null,
                fontWeight: FontWeight.w800,
                color: amountColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpenseRow extends StatelessWidget {
  const _ExpenseRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
    this.last = false,
  });
  final IconData icon;
  final Color color;
  final String label;
  final String value;
  final bool last;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Row(
            children: [
              Icon(icon, color: color, size: 18.r),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  label,
                  style: context.textTheme.bodySmall?.copyWith(
            fontSize: MediaQuery.sizeOf(context).shortestSide >= 600 ? 15 : null,
                    color: const Color(0xFF747474),
                  ),
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                value,
                style: context.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        if (!last) const Divider(height: 1, color: Color(0xFFEEEEEE)),
      ],
    );
  }
}
