import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.svgIcon,
    this.isLoading = false,
    this.outlined = false,
    this.iconSize = 22,
    this.iconSpacing = 8,
  });

  final String label;
  final VoidCallback? onPressed;

  /// Flutter Icon, Image.asset və digər widget-lər.
  final Widget? icon;

  /// SVG asset faylının yolu.
  final String? svgIcon;

  final bool isLoading;
  final bool outlined;
  final double iconSize;
  final double iconSpacing;

  Widget? _buildIcon() {
    if (svgIcon != null) {
      return SvgPicture.asset(
        svgIcon!,
        width: iconSize.r,
        height: iconSize.r,
        fit: BoxFit.contain,
      );
    }

    return icon;
  }

  @override
  Widget build(BuildContext context) {
    final buttonIcon = _buildIcon();

    final child = isLoading
        ? Semantics(
            label: '$label, yüklənir',
            child: SizedBox.square(
              dimension: 20.r,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: outlined
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (buttonIcon != null) ...[
                buttonIcon,
                SizedBox(width: iconSpacing.w),
              ],
              Flexible(child: Text(label, textAlign: TextAlign.center)),
            ],
          );

    return SizedBox(
      width: double.infinity,
      child: outlined
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              child: child,
            )
          : FilledButton(onPressed: isLoading ? null : onPressed, child: child),
    );
  }
}
