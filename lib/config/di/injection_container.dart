import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_app/core/constants/cache_constants.dart';
import 'package:streaming_app/core/local_storage/cache_manager.dart';
import 'package:streaming_app/core/local_storage/hive_client.dart';
import 'package:streaming_app/core/network/dio_client.dart';
import 'package:streaming_app/core/network/interceptors/auth_interceptor.dart';
import 'package:streaming_app/core/network/interceptors/error_interceptor.dart';
import 'package:streaming_app/core/network/network_info.dart';

// Authentication feature
import 'package:streaming_app/features/authentication/data/datasources/auth_local_data_source.dart';
import 'package:streaming_app/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:streaming_app/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:streaming_app/features/authentication/domain/repositories/auth_repository.dart';
import 'package:streaming_app/features/authentication/domain/usecases/get_current_user.dart';
import 'package:streaming_app/features/authentication/domain/usecases/login_with_google.dart';
import 'package:streaming_app/features/authentication/domain/usecases/logout.dart';
import 'package:streaming_app/features/authentication/presentation/bloc/auth_bloc.dart';

// Streaming feature (will be added later)
// import 'package:streaming_app/features/streaming/...';

final getIt = GetIt.instance;

/// Setup dependency injection
/// This must be called before runApp() in main.dart
Future<void> setupDependencyInjection() async {
  // ========================================
  // TIER 1: External Services (Singletons)
  // ========================================

  // Hive (must initialize first)
  await HiveClient.init();

  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // Network
  getIt.registerSingleton<NetworkInfo>(NetworkInfoImpl());

  // Dio interceptors
  getIt.registerSingleton<AuthInterceptor>(
    AuthInterceptor(sharedPreferences: getIt()),
  );
  getIt.registerSingleton<ErrorInterceptor>(ErrorInterceptor());

  // Dio client
  getIt.registerSingleton<DioClient>(
    DioClient(
      authInterceptor: getIt(),
      errorInterceptor: getIt(),
    ),
  );

  // Firebase services
  getIt.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  getIt.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);

  // Google Sign In with Web Client ID
  getIt.registerSingleton<GoogleSignIn>(
    GoogleSignIn(
    serverClientId: '487978615621-d6f51hd7tjsuh4943us59pfd4t5tsqos.apps.googleusercontent.com',
      scopes: ['email', 'profile'],
    ),
  );

  // Hive boxes
  getIt.registerSingleton<Box>(
    HiveClient.getTypedBox(CacheConstants.settingsBox),
    instanceName: 'settingsBox',
  );
  getIt.registerSingleton<Box>(
    HiveClient.getTypedBox(CacheConstants.usersBox),
    instanceName: 'usersBox',
  );

  // Cache manager
  getIt.registerSingleton<CacheManager>(
    CacheManager(settingsBox: getIt(instanceName: 'settingsBox')),
  );

  // ========================================
  // TIER 2: Data Sources (Lazy Singletons)
  // ========================================

  // Authentication data sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      dioClient: getIt(),
      firebaseAuth: getIt(),
      googleSignIn: getIt(),
    ),
  );

  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      sharedPreferences: getIt(),
      usersBox: getIt(instanceName: 'usersBox'),
    ),
  );

  // ========================================
  // TIER 3: Repositories (Lazy Singletons)
  // ========================================

  // Authentication repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  // ========================================
  // TIER 4: Use Cases (Lazy Singletons)
  // ========================================

  // Authentication use cases
  getIt.registerLazySingleton(() => LoginWithGoogle(getIt()));
  getIt.registerLazySingleton(() => Logout(getIt()));
  getIt.registerLazySingleton(() => GetCurrentUser(getIt()));

  // ========================================
  // TIER 5: BLoCs (Factories)
  // ========================================

  // Authentication BLoC
  getIt.registerFactory(
    () => AuthBloc(
      loginWithGoogle: getIt(),
      logout: getIt(),
      getCurrentUser: getIt(),
    ),
  );
}
