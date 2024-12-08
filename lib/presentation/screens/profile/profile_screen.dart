import 'package:cached_network_image/cached_network_image.dart';
import 'package:ezbooking/core/config/app_styles.dart';
import 'package:ezbooking/core/utils/dialogs.dart';
import 'package:ezbooking/core/utils/image_helper.dart';
import 'package:ezbooking/presentation/pages/event/favorite_event_page.dart';
import 'package:ezbooking/presentation/pages/login/bloc/login_bloc.dart';
import 'package:ezbooking/presentation/pages/login/bloc/login_event.dart';
import 'package:ezbooking/presentation/pages/login/login_page.dart';
import 'package:ezbooking/presentation/pages/payment_method/payment_method_page.dart';
import 'package:ezbooking/presentation/pages/user_profile/bloc/user_info_bloc.dart';
import 'package:ezbooking/presentation/pages/user_profile/bloc/user_info_state.dart';
import 'package:ezbooking/presentation/pages/user_profile/my_profile_page.dart';
import 'package:ezbooking/presentation/policy/policy_privacy_page.dart';
import 'package:ezbooking/presentation/taxes/taxes_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 18,
          right: 18,
          top: 60,
          bottom: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Profile",
                style: AppStyles.h4.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 26,
                ),
              ),
            ),
            const SizedBox(height: 16),
            BlocBuilder(
              bloc: context.read<UserInfoBloc>(),
              builder: (context, state) {
                if (state is UserInfoLoading) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey,
                    highlightColor: Colors.white54,
                    child: ListTile(
                      onTap: () {},
                      contentPadding: const EdgeInsets.all(0),
                      leading: const CircleAvatar(),
                      title: const Text("EzBooking user"),
                      subtitle: const Text("Show profile"),
                      trailing: const Icon(
                        Icons.keyboard_arrow_right,
                        size: 26,
                      ),
                    ),
                  );
                }
                if (state is UserInfoLoaded) {
                  return ListTile(
                    onTap: () =>
                        Navigator.pushNamed(context, MyProfilePage.routeName),
                    contentPadding: const EdgeInsets.all(0),
                    leading: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                        state.user.avatarUrl ??
                            "https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg",
                      ),
                    ),
                    title: Text(state.user.fullName ?? "Guess"),
                    subtitle: const Text("Show profile"),
                    trailing: const Icon(
                      Icons.keyboard_arrow_right,
                      size: 26,
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            const Divider(
              color: Colors.grey,
              height: 1,
              thickness: .3,
            ),
            const SizedBox(height: 12),
            Card(
              color: Colors.white,
              elevation: 8,
              child: InkWell(
                onTap: () async {
                  String url = "https://htthuan.id.vn";
                  _launchURL(url);
                },
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Discover more event",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              "It's simple to get set up\nand start exploring fantastic events.",
                              style: TextStyle(
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ImageHelper.loadNetworkImage(
                        height: 70,
                        width: 90,
                        fit: BoxFit.cover,
                        "https://cdni.iconscout.com/illustration/premium/thumb/event-management-illustration-download-in-svg-png-gif-file-formats--service-entertainment-catering-pack-people-illustrations-4620530.png?f=webp",
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Settings",
                style: AppStyles.h5.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 12),
            buildSettingItem(
              title: "Personal information",
              icon: const Icon(Icons.account_circle_outlined),
              onTap: () =>
                  Navigator.pushNamed(context, MyProfilePage.routeName),
            ),
            const Divider(
              color: Colors.grey,
              height: 1,
              thickness: .1,
            ),
            buildSettingItem(
              title: "Favorite events",
              icon: const Icon(Icons.bookmark_added),
              onTap: () =>
                  Navigator.pushNamed(context, FavoritesEventsPage.routeName),
            ),
            const Divider(
              color: Colors.grey,
              height: 1,
              thickness: .1,
            ),
            buildSettingItem(
              title: "Taxes",
              icon: const Icon(Icons.file_copy_outlined),
              onTap: () {
                Navigator.pushNamed(context, TaxesPage.routeName);
              },
            ),
            const Divider(
              color: Colors.grey,
              height: 1,
              thickness: .1,
            ),
            buildSettingItem(
              title: "Payments and payouts",
              icon: const Icon(Icons.payments_outlined),
              onTap: () =>
                  Navigator.pushNamed(context, PaymentMethodPage.routeName),
            ),
            const Divider(
              color: Colors.grey,
              height: 1,
              thickness: .1,
            ),
            buildSettingItem(
              title: "Policy & Privacy",
              icon: const Icon(Icons.policy),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PolicyPage(),
                  )),
            ),
            const Divider(
              color: Colors.grey,
              height: 1,
              thickness: .1,
            ),
            buildSettingItem(
              title: "Accessibility",
              icon: const Icon(Icons.settings_applications_outlined),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("This feature are being developed!")));
              },
            ),
            const Divider(
              color: Colors.grey,
              height: 1,
              thickness: .1,
            ),
            buildSettingItem(
              title: "Sign Out",
              color: Colors.red,
              icon: const Icon(
                Icons.login_outlined,
                color: Colors.red,
              ),
              onTap: () {
                DialogUtils.showConfirmationDialog(
                  context: context,
                  title: "Are you certain you want to sign out?",
                  textCancelButton: "Cancel",
                  textAcceptButton: "Logout",
                  acceptPressed: () async {
                    DialogUtils.showLoadingDialog(context);
                    await FirebaseAuth.instance.signOut();
                    await GoogleSignIn().signOut();
                    await FirebaseMessaging.instance.deleteToken();
                    await Future.delayed(
                      const Duration(milliseconds: 800),
                      () {
                        BlocProvider.of<UserInfoBloc>(context).reset();
                        BlocProvider.of<LoginBloc>(context).add(Reset());
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          LoginPage.routeName,
                          (route) => false,
                        );
                      },
                    );
                  },
                );
              },
            ),
            const Divider(
              color: Colors.grey,
              height: 1,
              thickness: .1,
            ),
            const SizedBox(height: 50),
            FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        'Version: ${snapshot.data?.version ?? "..."}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    );
                  default:
                    return const SizedBox();
                }
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget buildSettingItem({
    required String title,
    required Icon icon,
    required onTap,
    Color color = Colors.black,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 6),
      leading: icon,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: color,
        ),
      ),
      trailing: Icon(
        Icons.keyboard_arrow_right,
        size: 18,
        color: color,
      ),
    );
  }
}
