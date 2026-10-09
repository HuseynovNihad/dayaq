import 'package:flutter/material.dart';

import '../../../../core/widgets/app_empty_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Profil')),
    body: const SafeArea(
      child: AppEmptyState(
        title: 'Profil',
        message: 'Hesab məlumatlarınız burada göstəriləcək.',
        icon: Icons.person_outline,
      ),
    ),
  );
}
