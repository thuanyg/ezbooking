import 'package:ezbooking/injection_container.dart';
import 'package:ezbooking/presentation/pages/event/bloc/comment_bloc.dart';
import 'package:ezbooking/presentation/pages/event/bloc/event_detail_bloc.dart';
import 'package:ezbooking/presentation/pages/event/bloc/favorite_bloc.dart';
import 'package:ezbooking/presentation/pages/event/bloc/fetch_comment_bloc.dart';
import 'package:ezbooking/presentation/pages/event/bloc/fetch_favorite_bloc.dart';
import 'package:ezbooking/presentation/pages/login/bloc/login_bloc.dart';
import 'package:ezbooking/presentation/pages/maps/bloc/get_location_bloc.dart';
import 'package:ezbooking/presentation/pages/signup/bloc/signup_bloc.dart';
import 'package:ezbooking/presentation/pages/splash/splash_page.dart';
import 'package:ezbooking/presentation/pages/user_profile/bloc/update_user_bloc.dart';
import 'package:ezbooking/presentation/pages/user_profile/bloc/user_info_bloc.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/filter_bloc.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/latest_event_bloc.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/upcoming_event_bloc.dart';
import 'package:ezbooking/routes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
  initServiceLocator();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<LoginBloc>()),
        BlocProvider(create: (_) => sl<SignupBloc>()),
        BlocProvider(create: (_) => sl<LatestEventBloc>()),
        BlocProvider(create: (_) => sl<UpcomingEventBloc>()),
        BlocProvider(create: (_) => sl<EventDetailBloc>()),
        BlocProvider(create: (_) => sl<UserInfoBloc>()),
        BlocProvider(create: (_) => sl<UpdateUserBloc>()),
        BlocProvider(create: (_) => sl<FavoriteBloc>()),
        BlocProvider(create: (_) => sl<FetchFavoriteBloc>()),
        BlocProvider(create: (_) => FilterBloc()),
        BlocProvider(create: (_) => sl<GetLocationBloc>()),
        BlocProvider(create: (_) => sl<FetchCommentBloc>()),
        BlocProvider(create: (_) => sl<CommentBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EzBooking Application',
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
