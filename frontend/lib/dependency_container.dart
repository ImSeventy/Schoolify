import 'package:frontend/core/network/network_info.dart';
import 'package:frontend/features/authentication/data/data_providers/authentication_data_provider.dart';
import 'package:frontend/features/authentication/data/data_providers/tokens_data_provider.dart';
import 'package:frontend/features/authentication/data/repository/authentication_repository.dart';
import 'package:frontend/features/authentication/domain/repository/authentication_repository.dart';
import 'package:frontend/features/authentication/domain/use_cases/get_current_student_use_case.dart';
import 'package:frontend/features/authentication/domain/use_cases/login_use_case.dart';
import 'package:frontend/features/authentication/presentation/bloc/login_cubit/login_cubit.dart';
import 'package:frontend/features/grades/domain/repository/grades_repository.dart';
import 'package:frontend/features/grades/domain/use_cases/get_student_grades.dart';
import 'package:frontend/features/grades/presentation/bloc/data_handler/data_handler_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/grades/data/data_providers/grades_data_provider.dart';
import 'features/grades/data/repository/grades_repository.py.dart';
import 'features/grades/presentation/bloc/grades/grades_cubit.dart';

final getIt = GetIt.instance;

Future<void> setUp() async {
  _setupAuthenticationFeature();
  _setupGradesFeature();
  await _setupCore();
}

Future<void> _setupCore() async {
  final prefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => prefs);

  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      internetConnectionChecker: getIt(),
    ),
  );

  getIt.registerLazySingleton<InternetConnectionChecker>(
      () => InternetConnectionChecker());
}

void _setupAuthenticationFeature() {
  getIt.registerFactory<LoginCubit>(
    () => LoginCubit(loginUseCase: getIt(), getCurrentStudentUseCase: getIt()),
  );

  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(
      authenticationRepository: getIt(),
    ),
  );

  getIt.registerLazySingleton<GetCurrentStudentUseCase>(
    () => GetCurrentStudentUseCase(
      authenticationRepository: getIt(),
    ),
  );

  getIt.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepositoryImpl(
      networkInfo: getIt(),
      tokensDataProvider: getIt(),
      authenticationDataProvider: getIt(),
    ),
  );

  getIt.registerLazySingleton<TokensDataProvider>(
    () => TokensDataProviderImpl(
      sharedPreferences: getIt(),
    ),
  );

  getIt.registerLazySingleton<AuthenticationDataProvider>(
    () => AuthenticationDataProviderImpl(),
  );
}

void _setupGradesFeature() {
  getIt.registerFactory<GradesCubit>(
    () => GradesCubit(
      getStudentGradesUseCase: getIt(),
    ),
  );

  getIt.registerFactory<DataHandlerCubit>(
    () => DataHandlerCubit(),
  );

  getIt.registerLazySingleton<GetStudentGradesUseCase>(
    () => GetStudentGradesUseCase(
      gradesRepository: getIt(),
    ),
  );

  getIt.registerLazySingleton<GradesRepository>(
    () => GradesRepositoryImpl(
      networkInfo: getIt(),
      gradesDataProvider: getIt(),
    ),
  );

  getIt.registerLazySingleton<GradesDataProvider>(
    () => GradesDataProviderImpl(),
  );
}
