import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezbooking/core/services/firebase_auth_service.dart';
import 'package:ezbooking/core/services/firebase_firestore_service.dart';
import 'package:ezbooking/data/datasources/auth_datasource.dart';
import 'package:ezbooking/data/datasources/events/event_datasource.dart';
import 'package:ezbooking/data/datasources/events/event_datasource_impl.dart';
import 'package:ezbooking/data/repositories/auth/auth_repository_impl.dart';
import 'package:ezbooking/data/repositories/event/event_repository_impl.dart';
import 'package:ezbooking/domain/repositories/auth_repository.dart';
import 'package:ezbooking/domain/repositories/event_repository.dart';
import 'package:ezbooking/domain/usecases/auth/auth_usecase.dart';
import 'package:ezbooking/domain/usecases/events/fetch_event_detail.dart';
import 'package:ezbooking/domain/usecases/events/fetch_events_latest.dart';
import 'package:ezbooking/domain/usecases/events/fetch_events_upcoming.dart';
import 'package:ezbooking/presentation/pages/event/bloc/event_detail_bloc.dart';
import 'package:ezbooking/presentation/pages/login/bloc/login_bloc.dart';
import 'package:ezbooking/presentation/pages/signup/bloc/signup_bloc.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/latest_event_bloc.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/upcoming_event_bloc.dart';
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

  /// Event
  sl.registerLazySingleton<EventDatasource>(
    () => EventDatasourceImpl(sl<FirebaseFirestoreService>()),
  );

  sl.registerLazySingleton<EventRepository>(
    () => EventRepositoryImpl(sl<EventDatasource>()),
  );

  sl.registerLazySingleton<FetchEventsLatestUseCase>(
    () => FetchEventsLatestUseCase(sl<EventRepository>()),
  );

  sl.registerLazySingleton<FetchEventsUpcomingUseCase>(
        () => FetchEventsUpcomingUseCase(sl<EventRepository>()),
  );

  sl.registerLazySingleton<FetchEventDetailUseCase>(
        () => FetchEventDetailUseCase(sl<EventRepository>()),
  );

  sl.registerLazySingleton<LatestEventBloc>(
    () => LatestEventBloc(sl<FetchEventsLatestUseCase>()),
  );

  sl.registerLazySingleton<UpcomingEventBloc>(
        () => UpcomingEventBloc(sl<FetchEventsUpcomingUseCase>()),
  );

  sl.registerLazySingleton<EventDetailBloc>(
        () => EventDetailBloc(sl<FetchEventDetailUseCase>()),
  );
}
