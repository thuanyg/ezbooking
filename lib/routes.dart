import 'package:ezbooking/presentation/contact_us/contact_us_page.dart';
import 'package:ezbooking/presentation/helps_qa/helps_qa_page.dart';
import 'package:ezbooking/presentation/pages/event/event_upcoming.dart';
import 'package:ezbooking/presentation/pages/event/favorite_event_page.dart';
import 'package:ezbooking/presentation/pages/home/home_page.dart';
import 'package:ezbooking/presentation/pages/login/login_page.dart';
import 'package:ezbooking/presentation/pages/onboarding/onboarding_page.dart';
import 'package:ezbooking/presentation/pages/payment_method/payment_method_page.dart';
import 'package:ezbooking/presentation/pages/splash/splash_page.dart';
import 'package:ezbooking/presentation/pages/resetpassword/reset_password.dart';
import 'package:ezbooking/presentation/pages/signup/signup_page.dart';
import 'package:ezbooking/presentation/pages/ticket_booking/choose_seat_page.dart';
import 'package:ezbooking/presentation/pages/ticket_booking/ticket_booking_page.dart';
import 'package:ezbooking/presentation/pages/user_profile/my_profile_page.dart';
import 'package:ezbooking/presentation/search_location/address_finder_page.dart';
import 'package:ezbooking/presentation/taxes/taxes_page.dart';
import 'package:flutter/material.dart';
import 'package:ezbooking/presentation/pages/verification/verification_page.dart';
import 'package:ezbooking/presentation/pages/event/event_detail.dart';

class Routes {
  static Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
    SplashPage.routName: (context) => const SplashPage(),
    HomePage.routeName: (context) => HomePage(),
    OnboardingPage.routeName: (context) => const OnboardingPage(),
    LoginPage.routeName: (context) => LoginPage(),
    SignupPage.routeName: (context) => SignupPage(),
    VerificationPage.routeName: (context) => VerificationPage(),
    ResetPassword.routeName: (context) => const ResetPassword(),
    EventDetail.routeName: (context) => const EventDetail(),
    EventUpComingPage.routeName: (context) => const EventUpComingPage(),
    MyProfilePage.routeName: (context) => MyProfilePage(),
    FavoritesEventsPage.routeName: (context) => const FavoritesEventsPage(),
    TicketBookingPage.routeName: (context) => const TicketBookingPage(),
    SeatSelectionPage.routeName: (context) => const SeatSelectionPage(),
    AddressFinderPage.routeName: (context) => const AddressFinderPage(),
    PaymentMethodPage.routeName: (context) => const PaymentMethodPage(),
    ContactUsPage.routeName: (context) => const ContactUsPage(),
    HelpAndQAPage.routeName: (context) => const HelpAndQAPage(),
    TaxesPage.routeName: (context) => const TaxesPage(),
  };
}
