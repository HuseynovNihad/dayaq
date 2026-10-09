import 'package:flutter/material.dart';

import '../../../../core/widgets/app_empty_state.dart';

class DonationsPage extends StatelessWidget {
  const DonationsPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('İanələrim')),
    body: const SafeArea(
      child: AppEmptyState(
        title: 'İanələrim',
        message: 'İanə tarixçəniz burada göstəriləcək.',
        icon: Icons.receipt_long_outlined,
      ),
    ),
  );
}
