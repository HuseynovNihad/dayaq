import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/app_button.dart';

class HomeAddFamilyButton extends StatelessWidget {
  const HomeAddFamilyButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.sizeOf(context).shortestSide >= 600;

    return AppButton(
      label: 'Yeni ailə əlavə et',
      iconSpacing: isTablet ? 10 : 4,
      icon: Icon(Icons.add_rounded, size: isTablet ? 28 : 20),
      textStyle: context.textTheme.titleMedium?.copyWith(
        fontSize: isTablet ? 20 : null,
        fontWeight: FontWeight.w500,
      ),
      onPressed: onPressed,
    );
  }
}
