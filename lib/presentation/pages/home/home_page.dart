import 'dart:io';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:ezbooking/core/utils/utils.dart';
import 'package:ezbooking/presentation/pages/maps/bloc/get_location_bloc.dart';
import 'package:ezbooking/presentation/pages/maps/bloc/location_state.dart';
import 'package:ezbooking/presentation/pages/user_profile/bloc/user_info_bloc.dart';
import 'package:ezbooking/presentation/pages/user_profile/bloc/user_info_event.dart';
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

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    BlocProvider.of<UserInfoBloc>(context).add(FetchUserInfo(user!.uid));
    locationBloc = BlocProvider.of<GetLocationBloc>(context);
    locationBloc.getCurrentAddress(context);
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
      body: BlocBuilder(
        bloc: locationBloc,
        builder: (context, state) {
          if (state is LocationLoading) {
            return const Center(child: CircularProgressIndicator());
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
                        const SizedBox(height: 36),
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.black12,
                          child: ImageHelper.loadAssetImage(
                              "${assetImageLink}ic_avatar.png",
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover),
                        ),
                        Text(
                          "ThuanHT",
                          style: AppStyles.title1,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {},
                                  child: ListTile(
                                    leading: ImageHelper.loadAssetImage(
                                        drawerItems[index].icon),
                                    title: Text(drawerItems[index].label),
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
                  children: [
                    ExploreScreen(),
                    EventScreen(),
                    TicketScreen(),
                    ProfileScreen()
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
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
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.verySmoothEdge,
      leftCornerRadius: 16,
      rightCornerRadius: 16,
      activeIndex: _tabSelectedIndex,
      onTap: (index) {
        setState(() {
          _tabSelectedIndex = index;
          _pageViewController.animateToPage(index,
              duration: const Duration(milliseconds: 300),
              curve: Easing.standard);
        });
      },
    );
  }
}
