import 'package:frontend/core/network/network_info.dart';
import 'package:frontend/features/attendance/data/data_provider/attendance_data_provider.dart';
import 'package:frontend/features/attendance/data/repository/attendance_repository.dart';
import 'package:frontend/features/attendance/domain/repository/attendance_repository.dart';
import 'package:frontend/features/attendance/domain/use_cases/get_students_absences.dart';
import 'package:frontend/features/attendance/presentation/bloc/attendance_cubit/attendance_cubit.dart';
import 'package:frontend/features/authentication/data/data_providers/authentication_data_provider.dart';
import 'package:frontend/features/authentication/data/data_providers/tokens_data_provider.dart';
import 'package:frontend/features/authentication/data/repository/authentication_repository.dart';
import 'package:frontend/features/authentication/domain/repository/authentication_repository.dart';
import 'package:frontend/features/authentication/domain/use_cases/get_current_student_use_case.dart';
import 'package:frontend/features/authentication/domain/use_cases/load_cached_access_tokens.dart';
import 'package:frontend/features/authentication/domain/use_cases/login_use_case.dart';
import 'package:frontend/features/authentication/domain/use_cases/refresh_access_token.dart';
import 'package:frontend/features/authentication/presentation/bloc/login_cubit/login_cubit.dart';
import 'package:frontend/features/grades/domain/repository/grades_repository.dart';
import 'package:frontend/features/grades/domain/use_cases/get_student_grades.dart';
import 'package:frontend/features/grades/presentation/bloc/data_handler/data_handler_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/certifications/data/data_providers/certifiactions_data_provider.dart';
import 'features/certifications/data/repository/certifications_repository.dart';
import 'features/certifications/domain/repository/certifications_repository.dart';
import 'features/certifications/domain/use_cases/get_student_certifications.dart';
import 'features/certifications/presentation/bloc/certifications_cubit/certifications_cubit.dart';
import 'features/grades/data/data_providers/grades_data_provider.dart';
import 'features/grades/data/repository/grades_repository.py.dart';
import 'features/grades/presentation/bloc/grades/grades_cubit.dart';
import 'features/warnings/data/data_providers/warnings_data_provider.dart';
import 'features/warnings/data/repository/warnings_repository.dart';
import 'features/warnings/domain/reposistory/warnings_repository.dart';
import 'features/warnings/domain/use_cases/get_student_warnings.dart';
import 'features/warnings/presentation/bloc/warnings_cubit/warnings_cubit.dart';

final getIt = GetIt.instance;

Future<void> setUp() async {
  _setupAuthenticationFeature();
  _setupGradesFeature();
  _setupAttendanceFeature();
  _setupWarningsFeature();
  _setupCertificationsFeature();
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

  getIt.registerLazySingleton<RefreshAccessTokenUseCase>(
        () => RefreshAccessTokenUseCase(
      authenticationRepository: getIt(),
    ),
  );

  getIt.registerLazySingleton<LoadCachedAccessTokensUseCase>(
        () => LoadCachedAccessTokensUseCase(
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

void _setupAttendanceFeature() {
  getIt.registerFactory<AttendanceCubit>(
    () => AttendanceCubit(getStudentAbsencesUseCase: getIt()),
  );

  getIt.registerLazySingleton<GetStudentAbsencesUseCase>(
    () => GetStudentAbsencesUseCase(
      attendanceRepository: getIt(),
    ),
  );

  getIt.registerLazySingleton<AttendanceRepository>(
    () => AttendanceRepositoryImpl(
      networkInfo: getIt(),
      attendanceDataProvider: getIt(),
    ),
  );

  getIt.registerLazySingleton<AttendanceDataProvider>(
    () => AttendanceDataProviderImpl(),
  );
}

void _setupWarningsFeature() {
  getIt.registerFactory<WarningsCubit>(
    () => WarningsCubit(getStudentWarningsUseCase: getIt()),
  );

  getIt.registerLazySingleton<GetStudentWarningsUseCase>(
    () => GetStudentWarningsUseCase(
      warningsRepository: getIt(),
    ),
  );

  getIt.registerLazySingleton<WarningsRepository>(
    () => WarningsRepositoryImpl(
      networkInfo: getIt(),
      warningsDataProvider: getIt(),
    ),
  );

  getIt.registerLazySingleton<WarningsDataProvider>(
    () => WarningsDataProviderImpl(),
  );
}

void _setupCertificationsFeature() {
  getIt.registerFactory<CertificationsCubit>(
    () => CertificationsCubit(getStudentCertificationsUseCase: getIt()),
  );

  getIt.registerLazySingleton<GetStudentCertificationsUseCase>(
    () => GetStudentCertificationsUseCase(
      certificationsRepository: getIt(),
    ),
  );

  getIt.registerLazySingleton<CertificationsRepository>(
    () => CertificationsRepositoryImpl(
      networkInfo: getIt(),
      certificationsDataProvider: getIt(),
    ),
  );

  getIt.registerLazySingleton<CertificationsDataProvider>(
    () => CertificationsDataProviderImpl(),
  );
}
