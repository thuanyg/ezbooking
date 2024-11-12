import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ezbooking/core/config/app_colors.dart';
import 'package:ezbooking/core/config/app_styles.dart';
import 'package:ezbooking/core/utils/dialogs.dart';
import 'package:ezbooking/data/models/user_model.dart';
import 'package:ezbooking/presentation/pages/user_profile/bloc/update_user_bloc.dart';
import 'package:ezbooking/presentation/pages/user_profile/bloc/update_user_event.dart';
import 'package:ezbooking/presentation/pages/user_profile/bloc/update_user_state.dart';
import 'package:ezbooking/presentation/pages/user_profile/bloc/user_info_bloc.dart';
import 'package:ezbooking/presentation/pages/user_profile/bloc/user_info_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class MyProfilePage extends StatelessWidget {
  MyProfilePage({super.key});

  static const routeName = 'MyProfilePage';

  final genders = ["Male", "Female", "Non Binary", "Other"];

  @override
  Widget build(BuildContext context) {
    final userInfoBloc = BlocProvider.of<UserInfoBloc>(context);
    final updateUserBloc = BlocProvider.of<UpdateUserBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: AppStyles.titleAppBar,
        ),
      ),
      body: BlocBuilder(
        bloc: userInfoBloc,
        builder: (context, state) {
          if (state is UserInfoLoading) {
            return buildShimmer();
          }

          if (state is UserInfoLoaded) {
            return BlocListener(
              bloc: updateUserBloc,
              listener: (context, updateState) {
                if (updateState is UpdateUserLoading) {
                  DialogUtils.showLoadingDialog(context);
                }
                if (updateState is UpdateUserSuccess) {
                  userInfoBloc.emitUser(updateState.userModel);
                  DialogUtils.hide(context);
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 54,
                  left: 12,
                  right: 12,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 35,
                        backgroundImage: CachedNetworkImageProvider(
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQdxLYtLxr2EMj73RfHjJAs_yAL-zcFPwYGLQ&s",
                          maxWidth: 100,
                          maxHeight: 100,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        state.user.fullName ?? "Undefined",
                        style:
                            AppStyles.h5.copyWith(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 10),
                      buildListTileInfoItem(
                        label: "Email",
                        text: state.user.email ?? "Undefined",
                        iconData: Icons.email,
                        isEmpty: false,
                        onTap: () {},
                      ),
                      const SizedBox(height: 6),
                      buildListTileInfoItem(
                        label: "Gender",
                        text: state.user.gender ?? "",
                        isEmpty: state.user.gender == null ? true : false,
                        iconData: Icons.person,
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.white,
                            barrierLabel: '',
                            isScrollControlled: true,
                            isDismissible: true,
                            builder: (context) {
                              return Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 10),
                                      const Text(
                                        "Select your gender",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Expanded(
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: List.generate(
                                              genders.length,
                                              (index) => buildGenderOption(
                                                onTap: () {
                                                  // Close bottom sheet
                                                  Navigator.pop(context);
                                                  // Update user information
                                                  User? currentUser =
                                                      FirebaseAuth
                                                          .instance.currentUser;
                                                  final user =
                                                      UserModel.fromJson(
                                                          state.user.toJson());
                                                  user.gender = genders[index];
                                                  updateUserBloc.add(
                                                      UpdateUserInformation(
                                                          currentUser!.uid,
                                                          user));
                                                },
                                                gender: genders[index],
                                              ),
                                            ).toList(),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 6),
                      buildListTileInfoItem(
                        label: "Birthday",
                        text: state.user.birthday == null
                            ? ""
                            : DateFormat("dd-MM-yyyy")
                                .format(DateTime.parse(state.user.birthday!)),
                        iconData: Icons.cake,
                        isEmpty: state.user.birthday == null ? true : false,
                        onTap: () async {
                          DateTime? datePicked = state.user.birthday != null
                              ? await _selectDate(
                                  context, DateTime.parse(state.user.birthday!))
                              : await _selectDate(context, null);
                          if (datePicked == null) return;
                          User? currentUser = FirebaseAuth.instance.currentUser;
                          UserModel user =
                              UserModel.fromJson(state.user.toJson());
                          user.birthday = datePicked.toIso8601String();
                          updateUserBloc.add(
                              UpdateUserInformation(currentUser!.uid, user));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          if (state is UserInfoError) {
            return Center(
              child: Text(state.error),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget buildGenderOption(
      {required VoidCallback onTap, required String gender}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Text(
          gender,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.white,
      highlightColor: Colors.white54,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 54,
          left: 12,
          right: 12,
        ),
        child: Align(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 35,
              ),
              const SizedBox(height: 10),
              Text(
                "",
                style: AppStyles.h5.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              buildListTileInfoItem(
                label: "",
                text: "",
                iconData: Icons.email,
                isEmpty: false,
                onTap: () {},
              ),
              const SizedBox(height: 6),
              buildListTileInfoItem(
                label: "",
                text: "",
                isEmpty: false,
                iconData: Icons.person,
                onTap: () {},
              ),
              const SizedBox(height: 6),
              buildListTileInfoItem(
                label: "",
                text: "",
                iconData: Icons.cake,
                isEmpty: false,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  ListTile buildListTileInfoItem({
    required String label,
    required String text,
    required IconData iconData,
    required VoidCallback onTap,
    required bool isEmpty,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      tileColor: Colors.grey.shade200,
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: isEmpty
          ? Text(
              "Select your ${label.toLowerCase()}",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.redAccent,
                fontWeight: FontWeight.w400,
              ),
            )
          : Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
      leading: Icon(
        iconData,
        size: 24,
        color: Colors.black54,
      ),
    );
  }

  Future<DateTime?> _selectDate(
      BuildContext context, DateTime? initialDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      // builder: (context, child) {
      //   return Theme(
      //     data: ThemeData.dark().copyWith(
      //       colorScheme: ColorScheme.dark(
      //         primary: Colors.black,
      //         onPrimary: Colors.white,
      //         surface: AppColors.primaryColor,
      //         onSurface: Colors.white,
      //       ),
      //     ),
      //     child: child!,
      //   );
      // },
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(1900, 8),
      lastDate: DateTime(2101),
    );
    return picked;
  }
}