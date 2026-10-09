import 'package:flutter/material.dart';

import '../../../../core/widgets/app_empty_state.dart';

class CampaignsPage extends StatelessWidget {
  const CampaignsPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Kampaniyalar')),
    body: const SafeArea(
      child: AppEmptyState(
        title: 'Kampaniyalar',
        message: 'Xeyriyyə kampaniyaları burada göstəriləcək.',
        icon: Icons.volunteer_activism_outlined,
      ),
    ),
  );
}
