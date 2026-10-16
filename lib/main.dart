import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/app.dart';
import 'core/bloc/app_bloc_observer.dart';
import 'core/di/injection.dart';
import 'core/router/app_routes.dart';
import 'core/storage/token_storage.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await initializeDateFormatting('az');

  Bloc.observer = const AppBlocObserver();

  configureDependencies();

  final tokenStorage = sl<TokenStorage>();

  String initialLocation = AppRoutes.login;

  try {
    final hasToken = await tokenStorage.hasToken();

    if (hasToken) {
      initialLocation = AppRoutes.home;
    }
  } catch (error) {
    debugPrint('Session restore failed: $error');
  }

  runApp(DayaqApp(initialLocation: initialLocation));
}
