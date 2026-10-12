import 'package:get_it/get_it.dart';

import '../../families/domain/usecases/get_families.dart';
import '../presentation/bloc/home_bloc.dart';

void registerHomeDependencies(GetIt sl) {
  // BLOC
  sl.registerFactory<HomeBloc>(() => HomeBloc(getFamilies: sl<GetFamilies>()));
}
