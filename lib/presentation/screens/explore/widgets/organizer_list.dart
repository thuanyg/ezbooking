import 'package:cached_network_image/cached_network_image.dart';
import 'package:ezbooking/core/config/app_colors.dart';
import 'package:ezbooking/core/config/app_styles.dart';
import 'package:ezbooking/presentation/pages/organizer/page/organizer_list_page.dart';
import 'package:ezbooking/presentation/pages/organizer/page/organizer_page.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/organizer/organizer_list_bloc.dart';
import 'package:ezbooking/presentation/screens/explore/explore_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class OrganizerList extends StatefulWidget {
  const OrganizerList({super.key});

  @override
  State<OrganizerList> createState() => _OrganizerListState();
}

class _OrganizerListState extends State<OrganizerList> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildShowByCategory(
            label: 'Organizers',
            onSeeAll: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AllOrganizersScreen(),
              ));
            },
          ),
          Expanded(
            child: BlocBuilder<OrganizerListBloc, OrganizerListState>(
              builder: (context, state) {
                if (state is OrganizerListLoading) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade50,
                    child: buildShimmer(),
                  );
                }
                if (state is OrganizerListSuccess) {
                  if (state.organizers.isEmpty) {
                    return const Center(
                      child: Text("No organizers found!."),
                    );
                  }
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.organizers.length > 10 ? 10 : state.organizers.length,
                    itemBuilder: (context, index) {
                      final organizer = state.organizers[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => OrganizerProfilePage(
                                organizerID: organizer.id ?? ""),
                          ));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.55,
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 8,
                          ),
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xfff6fbff),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: AppColors.outlinedButtonColor,
                                backgroundImage: organizer.avatarUrl != null || organizer.avatarUrl != ""
                                    ? CachedNetworkImageProvider(organizer.avatarUrl!)
                                    : null,
                                child: organizer.avatarUrl == null || organizer.avatarUrl == ""
                                    ?  Icon(Icons.person,
                                        size: 24, color: AppColors.primaryColor)
                                    : null,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                organizer.name ?? 'Unnamed Organizer',
                                style: AppStyles.title1.copyWith(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                organizer.address ?? 'No address',
                                style: AppStyles.title1.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildShimmer() {
    return SizedBox(
      height: 200,
      child: GridView.builder(
          scrollDirection: Axis.horizontal,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.25,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 100,
                    height: 12,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 80,
                    height: 10,
                    color: Colors.white,
                  ),
                ],
              ),
            );
          }),
    );
  }
}
