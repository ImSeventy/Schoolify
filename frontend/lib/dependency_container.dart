import 'package:frontend/features/authentication/data/data_providers/authentication_data_provider.dart';
import 'package:frontend/features/authentication/data/data_providers/tokens_data_provider.dart';
import 'package:frontend/features/authentication/data/repository/authentication_repository.dart';
import 'package:frontend/features/authentication/domain/repository/authentication_repository.dart';
import 'package:frontend/features/authentication/domain/use_cases/login_use_case.dart';
import 'package:frontend/features/authentication/presentation/bloc/login_cubit/login_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setUp() async {
  _setupAuthenticationFeature();
  _setupCore();

}

void _setupCore() async {
  final prefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => prefs);

  getIt.registerLazySingleton<InternetConnectionChecker>(() => InternetConnectionChecker());
}

void _setupAuthenticationFeature() {
  getIt.registerFactory<LoginCubit>(
    () => LoginCubit(
      loginUseCase: getIt(),
    ),
  );

  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(
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
