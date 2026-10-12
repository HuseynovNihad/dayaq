import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../bloc/profile_content_bloc.dart';
import '../bloc/profile_content_event.dart';
import '../widgets/profile_content_view.dart';

class RulesPage extends StatelessWidget {
  const RulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<ProfileContentBloc>()
            ..add(const ProfileContentRequested(ProfileContentType.rules)),
      child: const ProfileContentView(
        title: 'İstifadə qaydaları',
        type: ProfileContentType.rules,
        icon: Icons.menu_book_rounded,
        description: 'Dayaq tətbiqinin istifadə qaydaları və təlimat videosu.',
      ),
    );
  }
}
