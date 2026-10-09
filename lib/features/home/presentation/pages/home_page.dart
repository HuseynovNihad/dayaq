import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Dayaq')),
    body: SafeArea(
      child: ListView(
        padding: EdgeInsets.all(AppSpacing.page),
        children: [
          Text(
            'Birlikdə dayaq olaq',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            'Kiçik bir dəstək böyük bir dəyişiklik yarada bilər.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: AppSpacing.xl),
          Card(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.volunteer_activism_outlined, size: 40),
                  SizedBox(height: AppSpacing.lg),
                  Text(
                    'Xeyirxahlığa bir addım',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: AppSpacing.sm),
                  const Text('Dəstək olmaq üçün kampaniyaları kəşf edin.'),
                  SizedBox(height: AppSpacing.xl),
                  AppButton(
                    label: 'Kampaniyalara bax',
                    onPressed: () => context.go(AppRoutes.campaigns),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
