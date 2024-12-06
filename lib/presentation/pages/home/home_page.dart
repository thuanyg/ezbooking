import 'dart:io';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ezbooking/core/utils/dialogs.dart';
import 'package:ezbooking/presentation/contact_us/contact_us_page.dart';
import 'package:ezbooking/presentation/helps_qa/helps_qa_page.dart';
import 'package:ezbooking/presentation/pages/event/favorite_event_page.dart';
import 'package:ezbooking/presentation/pages/login/login_page.dart';
import 'package:ezbooking/presentation/pages/maps/bloc/get_location_bloc.dart';
import 'package:ezbooking/presentation/pages/maps/bloc/location_state.dart';
import 'package:ezbooking/presentation/pages/user_profile/bloc/user_info_bloc.dart';
import 'package:ezbooking/presentation/pages/user_profile/bloc/user_info_event.dart';
import 'package:ezbooking/presentation/pages/user_profile/bloc/user_info_state.dart';
import 'package:ezbooking/presentation/screens/event/event_screen.dart';
import 'package:ezbooking/presentation/screens/explore/explore_screen.dart';
import 'package:ezbooking/presentation/screens/profile/profile_screen.dart';
import 'package:ezbooking/presentation/screens/ticket/ticket_screen.dart';
import 'package:ezbooking/core/config/app_colors.dart';
import 'package:ezbooking/core/config/app_styles.dart';
import 'package:ezbooking/core/config/constants.dart';
import 'package:ezbooking/core/utils/image_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  static String routeName = "/HomePage";

  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pageViewController =
      PageController(initialPage: 0, viewportFraction: 1);

  // Bottom nav
  int _tabSelectedIndex = 0;

  late GetLocationBloc locationBloc;
  late UserInfoBloc userInfoBloc;

  @override
  void initState() {
    super.initState();
    userInfoBloc = BlocProvider.of<UserInfoBloc>(context);
    locationBloc = BlocProvider.of<GetLocationBloc>(context);
    locationBloc.getCurrentAddress(context);
    handleFetchUserInfo();
  }

  handleFetchUserInfo() {
    User? user = FirebaseAuth.instance.currentUser;
    if (userInfoBloc.user == null) {
      userInfoBloc.add(FetchUserInfo(user!.uid));
    }
  }

  Future<bool?> _showBackDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          backgroundColor: Colors.white,
          content: const Text(
            'Are you sure you want to leave application?',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Leave'),
              onPressed: () {
                if (Platform.isAndroid) {
                  SystemNavigator.pop();
                } else if (Platform.isIOS) {
                  exit(0);
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocBuilder(
        bloc: locationBloc,
        builder: (context, state) {
          if (state is LocationLoading) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    "assets/animations/loading.json",
                    height: 80,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Initializing...",
                    style: AppStyles.title1.copyWith(
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is LocationSuccess) {
            return PopScope(
              canPop: false,
              onPopInvoked: (bool didPop) async {
                if (didPop) {
                  return;
                }
                final bool shouldPop = await _showBackDialog() ?? false;
                if (context.mounted && shouldPop) {
                  Navigator.pop(context);
                }
              },
              child: Scaffold(
                drawer: Drawer(
                    width: MediaQuery.of(context).size.width * 0.7,
                    elevation: 8,
                    backgroundColor: Colors.white,
                    child: Column(
                      children: [
                        const SizedBox(height: 50),
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: CachedNetworkImageProvider(
                            userInfoBloc.user?.avatarUrl ??
                                'https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg',
                            maxHeight: 50,
                            maxWidth: 50,
                          ),
                        ),
                        const SizedBox(height: 10),
                        BlocBuilder(
                          bloc: userInfoBloc,
                          builder: (context, state) {
                            if (state is UserInfoLoaded) {
                              return Text(
                                state.user.fullName ?? "",
                                style: AppStyles.h5,
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    switch (index) {
                                      case 0:
                                      case 1:
                                      case 2:
                                        Navigator.pushNamed(context,
                                            FavoritesEventsPage.routeName);
                                      case 3:
                                        Navigator.pushNamed(context,
                                            ContactUsPage.routeName);
                                      case 4:
                                        Navigator.pop(context);
                                        setState(() {
                                          _tabSelectedIndex = 3;
                                          _pageViewController.animateToPage(
                                            3,
                                            duration: const Duration(milliseconds: 300),
                                            curve: Easing.standard,
                                          );
                                        });
                                      case 5:
                                        Navigator.pushNamed(context,
                                            HelpAndQAPage.routeName);
                                      case 6:
                                        DialogUtils.showConfirmationDialog(
                                          context: context,
                                          title: "Are you certain you want to sign out?",
                                          textCancelButton: "Cancel",
                                          textAcceptButton: "Logout",
                                          acceptPressed: () async {
                                            DialogUtils.showLoadingDialog(context);
                                            await FirebaseAuth.instance.signOut();
                                            BlocProvider.of<UserInfoBloc>(context).reset();
                                            await Future.delayed(
                                              const Duration(milliseconds: 800),
                                                  () {
                                                Navigator.pushNamedAndRemoveUntil(
                                                  context,
                                                  LoginPage.routeName,
                                                      (route) => false,
                                                );
                                              },
                                            );
                                          },
                                        );
                                    }
                                  },
                                  child: ListTile(
                                    leading: ImageHelper.loadAssetImage(
                                        drawerItems[index].icon),
                                    title: Text(
                                      drawerItems[index].label,
                                    ),
                                  ),
                                );
                              },
                              itemCount: drawerItems.length,
                            ),
                          ),
                        ),
                      ],
                    )),
                body: PageView(
                  controller: _pageViewController,
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    ExploreScreen(),
                    EventScreen(),
                    TicketScreen(),
                    ProfileScreen()
                  ],
                ),
                // floatingActionButton: FloatingActionButton(
                //   onPressed: () {},
                //   backgroundColor: AppColors.primaryColor,
                //   shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(50)),
                //   child: const Icon(
                //     Icons.add,
                //     color: Colors.white,
                //     size: 28,
                //   ),
                // ),
                // floatingActionButtonLocation:
                //     FloatingActionButtonLocation.centerDocked,
                bottomNavigationBar: buildBottomNavigationBar(),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget buildBottomNavigationBar() {
    return AnimatedBottomNavigationBar.builder(
      height: 70,
      elevation: 24,
      itemCount: bottomNavItems.length,
      tabBuilder: (int index, bool isActive) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageHelper.loadAssetImage(
              bottomNavItems[index].iconName,
              height: 24,
              tintColor: isActive ? AppColors.primaryColor : Colors.grey,
            ),
            Text(
              bottomNavItems[index].label,
              style: AppStyles.title1.copyWith(
                color: isActive ? AppColors.primaryColor : Colors.grey,
                fontStyle: FontStyle.italic,
                fontSize: 12,
              ),
            )
          ],
        );
      },
      gapLocation: GapLocation.none,
      notchSmoothness: NotchSmoothness.verySmoothEdge,
      leftCornerRadius: 16,
      rightCornerRadius: 16,
      activeIndex: _tabSelectedIndex,
      onTap: (index) {
        setState(() {
          _tabSelectedIndex = index;
          _pageViewController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Easing.standard,
          );
        });
      },
    );
  }
}
