import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    // Do not log states/events: they can include donor or authentication data.
    if (kDebugMode) {
      debugPrint('BLoC error: ${bloc.runtimeType} (${error.runtimeType})');
    }
    super.onError(bloc, error, stackTrace);
  }
}
