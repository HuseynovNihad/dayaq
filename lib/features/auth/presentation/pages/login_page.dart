import 'package:flutter/material.dart';

import '../../../../core/widgets/app_empty_state.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Daxil ol')),
    body: const SafeArea(
      child: AppEmptyState(
        title: 'Daxil ol',
        message: 'Giriş funksiyası növbəti mərhələdə əlavə ediləcək.',
        icon: Icons.lock_outline,
      ),
    ),
  );
}
