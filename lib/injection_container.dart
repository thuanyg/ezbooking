import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezbooking/core/services/firebase_auth_service.dart';
import 'package:ezbooking/core/services/firebase_firestore_service.dart';
import 'package:ezbooking/data/datasources/auth_datasource.dart';
import 'package:ezbooking/data/repositories/auth_repository_impl.dart';
import 'package:ezbooking/domain/repositories/auth_repository.dart';
import 'package:ezbooking/domain/usecases/auth/auth_usecase.dart';
import 'package:ezbooking/presentation/pages/login/bloc/login_bloc.dart';
import 'package:ezbooking/presentation/pages/signup/bloc/signup_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void initServiceLocator() {
  /// Service
  // Firebase Auth Service
  sl.registerLazySingleton<FirebaseAuthService>(
    () => FirebaseAuthService(FirebaseAuth.instance),
  );

  // Firebase Firestore Service
  sl.registerLazySingleton<FirebaseFirestoreService>(
    () => FirebaseFirestoreService(FirebaseFirestore.instance),
  );

  /// Auth
  sl.registerLazySingleton<AuthDatasource>(
    () => AuthDatasource(
      firebaseAuthService: sl<FirebaseAuthService>(),
      firestoreService: sl<FirebaseFirestoreService>(),
    ),
  );

  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(sl<AuthDatasource>()),
  );

  sl.registerLazySingleton<AuthUseCase>(
        () => AuthUseCase(sl<AuthRepository>()),
  );

  sl.registerLazySingleton<SignupBloc>(
        () => SignupBloc(sl<AuthUseCase>()),
  );

  sl.registerLazySingleton<LoginBloc>(
        () => LoginBloc(sl<AuthUseCase>()),
  );
}
