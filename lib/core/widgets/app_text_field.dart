import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../extensions/context_extensions.dart';
import '../theme/app_colors.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.focusNode,
    this.validator,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.autocorrect = false,
    this.enableSuggestions = false,
    this.onChanged,
    this.onFieldSubmitted,
    this.autofillHints,
    this.prefixIcon,
    this.suffixIcon,
    this.labelTrailing,
  });

  final String label;
  final String? hintText;

  final TextEditingController? controller;
  final FocusNode? focusNode;

  final FormFieldValidator<String>? validator;
  final AutovalidateMode autovalidateMode;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  final bool obscureText;
  final bool enabled;
  final bool autocorrect;
  final bool enableSuggestions;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;

  final Iterable<String>? autofillHints;

  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget? labelTrailing;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(18.r);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: context.textTheme.titleSmall?.copyWith(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (labelTrailing != null) labelTrailing!,
          ],
        ),

        SizedBox(height: 12.h),

        TextFormField(
          controller: controller,
          focusNode: focusNode,
          enabled: enabled,

          // Hər field-in müstəqil validasiyası
          validator: validator,
          autovalidateMode: autovalidateMode,

          keyboardType: keyboardType,
          textInputAction: textInputAction,
          obscureText: obscureText,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          autofillHints: autofillHints,
          autocorrect: autocorrect && !obscureText,
          enableSuggestions: enableSuggestions && !obscureText,

          style: context.textTheme.bodyLarge?.copyWith(
            fontSize: 14.sp,
            color: AppColors.textPrimary,
          ),

          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFFD7C6B0),
              fontWeight: FontWeight.w400,
            ),

            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,

            filled: true,
            fillColor: Colors.white,

            contentPadding: EdgeInsets.symmetric(
              horizontal: 18.w,
              vertical: 18.h,
            ),

            prefixIconConstraints: BoxConstraints(
              minWidth: 52.w,
              minHeight: 24.h,
            ),

            suffixIconConstraints: BoxConstraints(
              minWidth: 48.w,
              minHeight: 24.h,
            ),

            border: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: const BorderSide(color: Color(0xFFF4F1ED)),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: const BorderSide(color: Color(0xFFF4F1ED), width: 1),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),

            errorBorder: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),

            focusedErrorBorder: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),

            disabledBorder: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: const BorderSide(color: Color(0xFFF4F1ED)),
            ),
          ),
        ),
      ],
    );
  }
}
