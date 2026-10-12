import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../bloc/profile_content_bloc.dart';
import '../bloc/profile_content_event.dart';
import '../widgets/profile_content_view.dart';

class TermConditionsPage extends StatelessWidget {
  const TermConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfileContentBloc>()
        ..add(const ProfileContentRequested(ProfileContentType.termConditions)),
      child: const ProfileContentView(
        title: 'Şərtlər və Qaydalar',
        type: ProfileContentType.termConditions,
        icon: Icons.description_outlined,
        description: 'Tətbiqdən istifadə ilə bağlı şərtlər və qaydalar.',
      ),
    );
  }
}
