import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:ezbooking/presentation/screens/event/event_screen.dart';
import 'package:ezbooking/presentation/screens/explore/explore_screen.dart';
import 'package:ezbooking/presentation/pages/profile/profile_screen.dart';
import 'package:ezbooking/presentation/screens/ticket/ticket_screen.dart';
import 'package:ezbooking/core/config/app_colors.dart';
import 'package:ezbooking/core/config/app_styles.dart';
import 'package:ezbooking/core/config/constants.dart';
import 'package:ezbooking/core/utils/image_helper.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: ImageHelper.loadAssetImage("${assetImageLink}ic_avatar.png", width: 40, height: 40, fit: BoxFit.cover),
            ),
            Text("ThuanHT", style: AppStyles.title1,),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: (){},
                      child: ListTile(
                        leading: ImageHelper.loadAssetImage(drawerItems[index].icon),
                        title: Text(drawerItems[index].label),
                      ),
                    );
                  },
                  itemCount: drawerItems.length,
                ),
              ),
            ),
          ],
        )
      ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 28,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: buildBottomNavigationBar(),
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
          _pageViewController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Easing.standard
          );
        });
      },
    );
  }
}
