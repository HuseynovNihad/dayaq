import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../bloc/profile_content_bloc.dart';
import '../bloc/profile_content_event.dart';
import '../widgets/profile_content_view.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<ProfileContentBloc>()
            ..add(const ProfileContentRequested(ProfileContentType.about)),
      child: const ProfileContentView(
        title: 'Haqqımızda',
        type: ProfileContentType.about,
        icon: Icons.volunteer_activism_rounded,
        description:
            'Dayaq xeyriyyə cəmiyyəti və fəaliyyətimiz haqqında məlumat.',
      ),
    );
  }
}
