import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezbooking/core/services/firebase_auth_service.dart';
import 'package:ezbooking/core/services/firebase_firestore_service.dart';
import 'package:ezbooking/core/services/google_map_service.dart';
import 'package:ezbooking/data/datasources/auth_datasource.dart';
import 'package:ezbooking/data/datasources/events/event_datasource.dart';
import 'package:ezbooking/data/datasources/events/event_datasource_impl.dart';
import 'package:ezbooking/data/datasources/map_datasource.dart';
import 'package:ezbooking/data/datasources/organizer/organizer_datasource.dart';
import 'package:ezbooking/data/datasources/organizer/organizer_datasource_impl.dart';
import 'package:ezbooking/data/datasources/tickets/ticket_datasource.dart';
import 'package:ezbooking/data/datasources/tickets/ticket_datasource_impl.dart';
import 'package:ezbooking/data/datasources/users/user_datasource.dart';
import 'package:ezbooking/data/datasources/users/user_datasource_impl.dart';
import 'package:ezbooking/data/repositories/auth/auth_repository_impl.dart';
import 'package:ezbooking/data/repositories/event/event_repository_impl.dart';
import 'package:ezbooking/data/repositories/organizer/organizer_repository_impl.dart';
import 'package:ezbooking/data/repositories/tickets/ticket_repository_impl.dart';
import 'package:ezbooking/data/repositories/user/user_repository_impl.dart';
import 'package:ezbooking/domain/repositories/auth_repository.dart';
import 'package:ezbooking/domain/repositories/event_repository.dart';
import 'package:ezbooking/domain/repositories/organizer_repository.dart';
import 'package:ezbooking/domain/repositories/ticket_repository.dart';
import 'package:ezbooking/domain/repositories/user_repository.dart';
import 'package:ezbooking/domain/usecases/auth/auth_usecase.dart';
import 'package:ezbooking/domain/usecases/events/favorite_event.dart';
import 'package:ezbooking/domain/usecases/events/fetch_available_ticket.dart';
import 'package:ezbooking/domain/usecases/events/fetch_comments.dart';
import 'package:ezbooking/domain/usecases/events/fetch_event_detail.dart';
import 'package:ezbooking/domain/usecases/events/fetch_events_latest.dart';
import 'package:ezbooking/domain/usecases/events/fetch_events_organizer.dart';
import 'package:ezbooking/domain/usecases/events/fetch_events_popular.dart';
import 'package:ezbooking/domain/usecases/events/fetch_events_upcoming.dart';
import 'package:ezbooking/domain/usecases/events/fetch_going_event.dart';
import 'package:ezbooking/domain/usecases/maps/map_usecase.dart';
import 'package:ezbooking/domain/usecases/organizers/fetch_organizer.dart';
import 'package:ezbooking/domain/usecases/ticket/create_ticket.dart';
import 'package:ezbooking/domain/usecases/ticket/get_tickets.dart';
import 'package:ezbooking/domain/usecases/user/comment_event.dart';
import 'package:ezbooking/domain/usecases/user/fetch_user_info.dart';
import 'package:ezbooking/domain/usecases/user/update_user_info.dart';
import 'package:ezbooking/presentation/pages/event/bloc/comment_bloc.dart';
import 'package:ezbooking/presentation/pages/event/bloc/event_detail_bloc.dart';
import 'package:ezbooking/presentation/pages/event/bloc/favorite_bloc.dart';
import 'package:ezbooking/presentation/pages/event/bloc/fetch_available_ticket_cubit.dart';
import 'package:ezbooking/presentation/pages/event/bloc/fetch_comment_bloc.dart';
import 'package:ezbooking/presentation/pages/event/bloc/fetch_favorite_bloc.dart';
import 'package:ezbooking/presentation/pages/event/bloc/going_event_cubit.dart';
import 'package:ezbooking/presentation/pages/login/bloc/login_bloc.dart';
import 'package:ezbooking/presentation/pages/maps/bloc/get_location_bloc.dart';
import 'package:ezbooking/presentation/pages/organizer/bloc/events_organizer_bloc.dart';
import 'package:ezbooking/presentation/pages/organizer/bloc/organizer_bloc.dart';
import 'package:ezbooking/presentation/pages/signup/bloc/signup_bloc.dart';
import 'package:ezbooking/presentation/pages/ticket_booking/bloc/tickets/create_ticket_bloc.dart';
import 'package:ezbooking/presentation/pages/user_profile/bloc/update_user_bloc.dart';
import 'package:ezbooking/presentation/pages/user_profile/bloc/user_info_bloc.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/category/fetch_categories_bloc.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/latest/latest_event_bloc.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/organizer/organizer_list_bloc.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/popular/popular_event_bloc.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/upcoming/upcoming_event_bloc.dart';
import 'package:ezbooking/presentation/screens/ticket/bloc/get_ticket_cubit.dart';
import 'package:ezbooking/presentation/screens/ticket/bloc/get_tickets_bloc.dart';
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

  // Google Map Service
  sl.registerLazySingleton<GoogleMapService>(
    () => GoogleMapService(),
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

  sl.registerLazySingleton<FetchEventsPopularUseCase>(
    () => FetchEventsPopularUseCase(sl<EventRepository>()),
  );

  sl.registerLazySingleton<FetchGoingEventUseCase>(
    () => FetchGoingEventUseCase(sl<EventRepository>()),
  );

  sl.registerLazySingleton<FetchAvailableTicketUseCase>(
    () => FetchAvailableTicketUseCase(sl<EventRepository>()),
  );

  sl.registerLazySingleton<PopularEventBloc>(
    () => PopularEventBloc(sl<FetchEventsPopularUseCase>()),
  );

  sl.registerLazySingleton<UpcomingEventBloc>(
    () => UpcomingEventBloc(sl<FetchEventsUpcomingUseCase>()),
  );

  sl.registerLazySingleton<EventDetailBloc>(
    () => EventDetailBloc(sl<FetchEventDetailUseCase>()),
  );

  sl.registerLazySingleton<LatestEventBloc>(
    () => LatestEventBloc(sl<FetchEventsLatestUseCase>()),
  );

  sl.registerLazySingleton<FetchEventsOrganizerUseCase>(
    () => FetchEventsOrganizerUseCase(sl<EventRepository>()),
  );

  sl.registerLazySingleton<GoingEventCubit>(
    () => GoingEventCubit(sl<FetchGoingEventUseCase>()),
  );

  sl.registerLazySingleton<FetchAvailableTicketCubit>(
    () => FetchAvailableTicketCubit(sl<FetchAvailableTicketUseCase>()),
  );

  sl.registerLazySingleton<EventsOrganizerBloc>(
    () => EventsOrganizerBloc(sl<FetchEventsOrganizerUseCase>()),
  );

  /// User
  sl.registerLazySingleton<UserDatasource>(
    () => UserDatasourceImpl(sl<FirebaseFirestoreService>()),
  );

  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(sl<UserDatasource>()),
  );

  sl.registerLazySingleton<FetchUserInfoUseCase>(
    () => FetchUserInfoUseCase(sl<UserRepository>()),
  );

  sl.registerLazySingleton<UserInfoBloc>(
    () => UserInfoBloc(sl<FetchUserInfoUseCase>()),
  );

  sl.registerLazySingleton<UpdateUserInfoUseCase>(
    () => UpdateUserInfoUseCase(sl<UserRepository>()),
  );

  sl.registerLazySingleton<UpdateUserBloc>(
    () => UpdateUserBloc(sl<UpdateUserInfoUseCase>()),
  );

  /// Favorite
  sl.registerLazySingleton<FavoriteEventUseCase>(
    () => FavoriteEventUseCase(sl<EventRepository>()),
  );

  sl.registerLazySingleton<FavoriteBloc>(
    () => FavoriteBloc(sl<FavoriteEventUseCase>()),
  );

  sl.registerLazySingleton<FetchFavoriteBloc>(
    () => FetchFavoriteBloc(sl<FavoriteEventUseCase>()),
  );

  // Map/Location
  sl.registerLazySingleton<MapDatasource>(
    () => MapDatasource(sl<GoogleMapService>()),
  );

  sl.registerLazySingleton<MapUseCase>(
    () => MapUseCase(sl<MapDatasource>()),
  );

  sl.registerLazySingleton<GetLocationBloc>(
    () => GetLocationBloc(sl<MapUseCase>()),
  );

  // Comment
  sl.registerLazySingleton<CommentEventUseCase>(
    () => CommentEventUseCase(sl<UserRepository>()),
  );

  sl.registerLazySingleton<CommentBloc>(
    () => CommentBloc(sl<CommentEventUseCase>()),
  );

  sl.registerLazySingleton<FetchCommentsUseCase>(
    () => FetchCommentsUseCase(sl<EventRepository>()),
  );

  sl.registerLazySingleton<FetchCommentBloc>(
    () => FetchCommentBloc(sl<FetchCommentsUseCase>()),
  );

  // Ticket
  sl.registerLazySingleton<TicketDatasource>(
    () => TicketDatasourceImpl(),
  );

  sl.registerLazySingleton<TicketRepository>(
    () => TicketRepositoryImpl(sl<TicketDatasource>()),
  );

  sl.registerLazySingleton<CreateTicketUseCase>(
    () => CreateTicketUseCase(sl<TicketRepository>()),
  );

  sl.registerLazySingleton<GetTicketsUseCase>(
    () => GetTicketsUseCase(sl<TicketRepository>()),
  );

  sl.registerLazySingleton<GetTicketsBloc>(
    () => GetTicketsBloc(sl<GetTicketsUseCase>()),
  );

  sl.registerLazySingleton<GetTicketCubit>(
    () => GetTicketCubit(sl<GetTicketsUseCase>()),
  );

  sl.registerLazySingleton<CreateTicketBloc>(
    () => CreateTicketBloc(),
  );
  // Organizer
  sl.registerLazySingleton<OrganizerDatasource>(
    () => OrganizerDatasourceImpl(),
  );

  sl.registerLazySingleton<OrganizerRepository>(
    () => OrganizerRepositoryImpl(sl<OrganizerDatasource>()),
  );

  sl.registerLazySingleton<FetchOrganizerUseCase>(
    () => FetchOrganizerUseCase(sl<OrganizerRepository>()),
  );

  sl.registerLazySingleton<OrganizerBloc>(
    () => OrganizerBloc(sl<FetchOrganizerUseCase>()),
  );

  sl.registerLazySingleton<OrganizerListBloc>(
    () => OrganizerListBloc(),
  );

  // Category
  sl.registerLazySingleton<FetchCategoriesBloc>(
    () => FetchCategoriesBloc(),
  );
}
