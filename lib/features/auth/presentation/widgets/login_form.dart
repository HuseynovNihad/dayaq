import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../bloc/auth_bloc.dart';

class LoginForm extends StatefulWidget with SU {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  static const _iconColor = Color(0xFF857968);
  static const _linkColor = Color(0xFF3954D8);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final bloc = context.read<AuthBloc>();

    if (bloc.state is AuthLoginLoading || bloc.state is AuthLoginSuccess) {
      return;
    }

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    FocusScope.of(context).unfocus();

    bloc.add(
      AuthLoginSubmitted(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _forgotPassword() {
    // TODO: Şifrə bərpası səhifəsinə keçid.
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoginLoading;
        final isBusy = isLoading || state is AuthLoginSuccess;

        return Card(
          elevation: 2,
          shadowColor: Colors.black.withValues(alpha: 0.08),
          color: Colors.white,
          surfaceTintColor: Colors.transparent,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.page),
            child: AutofillGroup(
              child: Form(
                key: _formKey,

                // Form bütün field-ləri avtomatik
                // validasiya etməsin.
                autovalidateMode: AutovalidateMode.disabled,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // E-poçt
                    AppTextField(
                      label: 'E-poçt',
                      hintText: 'ad.soyad@xeyriyye.az',
                      controller: _emailController,
                      enabled: !isBusy,
                      validator: AppValidators.email,

                      // Yalnız bu field dəyişəndə
                      // avtomatik validasiya olunur.
                      autovalidateMode: AutovalidateMode.onUserInteraction,

                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.username],
                      prefixIcon: Icon(
                        Icons.person_outline_rounded,
                        size: 24.r,
                        color: _iconColor,
                      ),
                    ),

                    SizedBox(height: AppSpacing.xl),

                    // Şifrə
                    AppTextField(
                      label: 'Şifrə',
                      hintText: '••••••••',
                      controller: _passwordController,
                      enabled: !isBusy,
                      validator: AppValidators.loginPassword,

                      // Müstəqil validasiya
                      autovalidateMode: AutovalidateMode.onUserInteraction,

                      obscureText: _obscurePassword,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.password],
                      onFieldSubmitted: (_) => _submit(),
                      prefixIcon: Icon(
                        Icons.lock_outline_rounded,
                        size: 24.r,
                        color: _iconColor,
                      ),
                      suffixIcon: IconButton(
                        tooltip: _obscurePassword
                            ? 'Şifrəni göstər'
                            : 'Şifrəni gizlət',
                        onPressed: isBusy ? null : _togglePasswordVisibility,
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 24.r,
                          color: _iconColor,
                        ),
                      ),
                    ),

                    SizedBox(height: 10.h),

                    // Şifrəni unutmusunuz?
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: isBusy ? null : _forgotPassword,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 4.h),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Şifrəni unutmusunuz?',
                          style: context.textTheme.bodySmall?.copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: _linkColor,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // Daxil ol
                    AppButton(
                      label: 'Daxil ol',
                      svgIcon: AppAssets.loginLogo,
                      iconSize: 14,
                      isLoading: isLoading,
                      onPressed: isBusy ? null : _submit,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
