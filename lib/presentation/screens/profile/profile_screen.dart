import 'package:cached_network_image/cached_network_image.dart';
import 'package:ezbooking/core/config/app_styles.dart';
import 'package:ezbooking/core/utils/image_helper.dart';
import 'package:ezbooking/presentation/pages/event/favorite_event_page.dart';
import 'package:ezbooking/presentation/pages/payment_method/payment_method_page.dart';
import 'package:ezbooking/presentation/pages/user_profile/bloc/user_info_bloc.dart';
import 'package:ezbooking/presentation/pages/user_profile/bloc/user_info_state.dart';
import 'package:ezbooking/presentation/pages/user_profile/my_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shimmer/shimmer.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
                    leading: const CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQdxLYtLxr2EMj73RfHjJAs_yAL-zcFPwYGLQ&s",
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
                onTap: () {},
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
              onTap: () => Navigator.pushNamed(context, FavoritesEventsPage.routeName),
            ),
            const Divider(
              color: Colors.grey,
              height: 1,
              thickness: .1,
            ),
            buildSettingItem(
              title: "Taxes",
              icon: const Icon(Icons.file_copy_outlined),
              onTap: () {},
            ),
            const Divider(
              color: Colors.grey,
              height: 1,
              thickness: .1,
            ),
            buildSettingItem(
              title: "Payments and payouts",
              icon: const Icon(Icons.payments_outlined),
              onTap: () => Navigator.pushNamed(context, PaymentMethodPage.routeName),
            ),
            const Divider(
              color: Colors.grey,
              height: 1,
              thickness: .1,
            ),
            buildSettingItem(
              title: "Login & security",
              icon: const Icon(Icons.security_rounded),
              onTap: () {},
            ),
            const Divider(
              color: Colors.grey,
              height: 1,
              thickness: .1,
            ),
            buildSettingItem(
              title: "Accessibility",
              icon: const Icon(Icons.settings_applications_outlined),
              onTap: () {},
            ),
            const SizedBox(height: 20),
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
                          fontWeight: FontWeight.w300,
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
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 6),
      leading: icon,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: const Icon(
        Icons.keyboard_arrow_right,
        size: 18,
      ),
    );
  }
}
