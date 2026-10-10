import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/app_button.dart';

class HomeAddFamilyButton extends StatelessWidget {
  const HomeAddFamilyButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: 'Yeni ailə əlavə et',
      iconSpacing: 4,
      icon: Icon(Icons.add_rounded, size: 20.r),
      textStyle: context.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w500,
      ),
      onPressed: () {},
    );
  }
}
