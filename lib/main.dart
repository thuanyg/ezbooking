import 'package:app_links/app_links.dart';
import 'package:ezbooking/core/services/firebase_cloud_message.dart';
import 'package:ezbooking/core/services/notification_service.dart';
import 'package:ezbooking/injection_container.dart';
import 'package:ezbooking/presentation/pages/event/bloc/comment_bloc.dart';
import 'package:ezbooking/presentation/pages/event/bloc/event_detail_bloc.dart';
import 'package:ezbooking/presentation/pages/event/bloc/favorite_bloc.dart';
import 'package:ezbooking/presentation/pages/event/bloc/fetch_available_ticket_cubit.dart';
import 'package:ezbooking/presentation/pages/event/bloc/fetch_comment_bloc.dart';
import 'package:ezbooking/presentation/pages/event/bloc/fetch_favorite_bloc.dart';
import 'package:ezbooking/presentation/pages/event/bloc/going_event_cubit.dart';
import 'package:ezbooking/presentation/pages/login/bloc/login_bloc.dart';
import 'package:ezbooking/presentation/pages/maps/bloc/get_location_bloc.dart';
import 'package:ezbooking/presentation/pages/notification/notification_cubit.dart';
import 'package:ezbooking/presentation/pages/organizer/bloc/events_organizer_bloc.dart';
import 'package:ezbooking/presentation/pages/organizer/bloc/organizer_bloc.dart';
import 'package:ezbooking/presentation/pages/signup/bloc/signup_bloc.dart';
import 'package:ezbooking/presentation/pages/splash/splash_page.dart';
import 'package:ezbooking/presentation/pages/ticket_booking/bloc/tickets/create_ticket_bloc.dart';
import 'package:ezbooking/presentation/pages/user_profile/bloc/update_user_bloc.dart';
import 'package:ezbooking/presentation/pages/user_profile/bloc/user_info_bloc.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/category/fetch_categories_bloc.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/filter/filter_bloc.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/latest/latest_event_bloc.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/organizer/organizer_list_bloc.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/popular/popular_event_bloc.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/upcoming/upcoming_event_bloc.dart';
import 'package:ezbooking/presentation/screens/profile/fetch_orders_bloc.dart';
import 'package:ezbooking/presentation/screens/ticket/bloc/get_ticket_cubit.dart';
import 'package:ezbooking/presentation/screens/ticket/bloc/get_tickets_bloc.dart';
import 'package:ezbooking/routes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appLinks = AppLinks();

  final sub = appLinks.uriLinkStream.listen((uri) {
    print("URI: ${uri.toString()}");
  });
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
  initServiceLocator();
  await NotificationService.init();
  final fcm = FirebaseCloudMessage();
  await fcm.initialize();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => FilterBloc()),
        BlocProvider(create: (_) => sl<LoginBloc>()),
        BlocProvider(create: (_) => sl<SignupBloc>()),
        BlocProvider(create: (_) => sl<LatestEventBloc>()),
        BlocProvider(create: (_) => sl<UpcomingEventBloc>()),
        BlocProvider(create: (_) => sl<PopularEventBloc>()),
        BlocProvider(create: (_) => sl<EventDetailBloc>()),
        BlocProvider(create: (_) => sl<UserInfoBloc>()),
        BlocProvider(create: (_) => sl<UpdateUserBloc>()),
        BlocProvider(create: (_) => sl<FavoriteBloc>()),
        BlocProvider(create: (_) => sl<FetchFavoriteBloc>()),
        BlocProvider(create: (_) => sl<GetLocationBloc>()),
        BlocProvider(create: (_) => sl<FetchCommentBloc>()),
        BlocProvider(create: (_) => sl<CommentBloc>()),
        BlocProvider(create: (_) => sl<GetTicketsBloc>()),
        BlocProvider(create: (_) => sl<GetTicketCubit>()),
        BlocProvider(create: (_) => sl<CreateTicketBloc>()),
        BlocProvider(create: (_) => sl<GoingEventCubit>()),
        BlocProvider(create: (_) => sl<FetchAvailableTicketCubit>()),
        BlocProvider(create: (_) => sl<OrganizerBloc>()),
        BlocProvider(create: (_) => sl<EventsOrganizerBloc>()),
        BlocProvider(create: (_) => sl<OrganizerListBloc>()),
        BlocProvider(create: (_) => sl<FetchCategoriesBloc>()),
        BlocProvider(create: (_) => FetchOrdersCubit()),
        BlocProvider(create: (_) => NotificationCubit()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EzBooking',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          elevation: 1,
          backgroundColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      routes: Routes.routes,
      initialRoute: SplashPage.routName,
    );
  }
}
