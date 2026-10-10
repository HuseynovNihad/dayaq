import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/app.dart';
import 'core/bloc/app_bloc_observer.dart';
import 'core/di/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('az');
  Bloc.observer = const AppBlocObserver();
  configureDependencies();
  runApp(const DayaqApp());
}
