import '../registration_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';

class FamilyRegistrationSuccessPage extends StatelessWidget {
  const FamilyRegistrationSuccessPage({
    super.key,
    required this.onReturnToFamilies,
  });

  final VoidCallback onReturnToFamilies;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.regW(context)),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      tooltip: 'Bağla',
                      onPressed: onReturnToFamilies,
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ),

                  const Spacer(flex: 2),

                  Container(
                    width: 140.regR(context),
                    height: 140.regR(context),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFF2D1),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Container(
                      width: 82.regR(context),
                      height: 82.regR(context),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.check_rounded,
                        color: Colors.black,
                        size: 46.regR(context),
                      ),
                    ),
                  ),

                  SizedBox(height: 38.regH(context)),

                  Text(
                    'Ailə uğurla qeydiyyata alındı!',
                    textAlign: TextAlign.center,
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  SizedBox(height: 14.regH(context)),

                  Text(
                    'Məlumatlar uğurla göndərildi.',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),

                  const Spacer(flex: 3),

                  SizedBox(
                    width: double.infinity,
                    height: context.registrationIsTablet
                        ? 58
                        : 54.regH(context),
                    child: ElevatedButton(
                      onPressed: onReturnToFamilies,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.regR(context)),
                        ),
                      ),
                      child: Text(
                        'Ailələr siyahısına qayıt',
                        style: textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 24.regH(context)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
