import 'package:ezbooking/core/utils/utils.dart';
import 'package:ezbooking/core/config/app_colors.dart';
import 'package:ezbooking/core/config/app_styles.dart';
import 'package:ezbooking/core/config/constants.dart';
import 'package:ezbooking/core/utils/image_helper.dart';
import 'package:ezbooking/map_sample.dart';
import 'package:ezbooking/presentation/pages/event/event_upcoming.dart';
import 'package:ezbooking/presentation/pages/maps/bloc/get_location_bloc.dart';
import 'package:ezbooking/presentation/pages/maps/bloc/location_state.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/filter_bloc.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/filter_event.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/latest_event_bloc.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/upcoming_event_bloc.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/upcoming_event_event.dart';
import 'package:ezbooking/presentation/screens/explore/widgets/up_coming_event.dart';
import 'package:ezbooking/presentation/search_location/address_finder_page.dart';
import 'package:ezbooking/presentation/widgets/button.dart';
import 'package:ezbooking/presentation/widgets/cards.dart';
import 'package:ezbooking/presentation/widgets/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with AutomaticKeepAliveClientMixin {
  // Bloc
  late FilterBloc filterBloc;
  late final UpcomingEventBloc upcomingEventBloc;
  late final LatestEventBloc latestEventBloc;
  late final GetLocationBloc locationBloc;

  @override
  void initState() {
    super.initState();
    locationBloc = BlocProvider.of<GetLocationBloc>(context);
    upcomingEventBloc = BlocProvider.of<UpcomingEventBloc>(context);
    latestEventBloc = BlocProvider.of<LatestEventBloc>(context);
    filterBloc = BlocProvider.of<FilterBloc>(context);
    // Fetch Data Initial
    if (locationBloc.locationResult == null) {
      upcomingEventBloc.add(FetchUpcomingEvent(
        limit: 10,
        isFetchApproximately: false,
      ));
    } else {
      upcomingEventBloc.add(FetchUpcomingEvent(
        limit: 10,
        isFetchApproximately: true,
        position: locationBloc.locationResult!.position,
      ));
    }
  }

  Future<DateTime?> showSelectDate(BuildContext context) async {
    DateTime? dateTime = await showDatePicker(
      context: context,
      helpText: "Select Date",
      initialDate: filterBloc.selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );
    return dateTime;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final header = SizedBox(
      height: 200,
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 179,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(33),
                    bottomLeft: Radius.circular(33),
                  ),
                ),
                child: Column(
                  children: [
                    buildHeaderStickyWidget(context),
                    buildHeaderSearch(context)
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 160,
            bottom: 0,
            right: 0,
            left: 24,
            child: buildCategories(),
          ),
        ],
      ),
    );
    final body = Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 18),
      child: Column(
        children: [
          const UpComingEvent(),
          buildShowByCategory(label: 'Popular Now', onSeeAll: () {}),
          buildPopularNowEvent(),
          buildShowByCategory(label: 'Popular Now', onSeeAll: () {}),
          buildPopularNowEvent(),
          buildShowByCategory(label: 'Popular Now', onSeeAll: () {}),
          buildPopularNowEvent(),
        ],
      ),
    );

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: header,
        ),
        SliverPersistentHeader(
          delegate: HeaderStickyDelegate(),
          pinned: true,
        ),
        SliverToBoxAdapter(
          child: body,
        )
      ],
    );
  }

  Widget buildHeaderSearch(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 10),
        child: Row(
          children: [
            const Icon(
              Icons.search,
              size: 24,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: TextField(
                style: TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  hintText: "Search...",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                buildFilterBottomSheet(context);
              },
              child: BlocBuilder(
                bloc: filterBloc,
                builder: (context, state) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: const Color(0xFF5D56F3),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          filterBloc.hasFilter()
                              ? Icons.filter_alt
                              : Icons.filter_alt_off_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          "Filters",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ));
  }

  Future<dynamic> buildFilterBottomSheet(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      context: context,
      builder: (builder) {
        return BlocBuilder(
          bloc: filterBloc,
          // Use StatefulBuilder to handle state changes
          builder: (context, state) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.80,
              width: double.maxFinite,
              color: Colors.transparent,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 130, vertical: 8),
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                        Text("Filters", style: AppStyles.h4),
                        SizedBox(
                          height: 120,
                          child: ListView.builder(
                            itemCount: filterItems.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              bool isSelected = filterBloc.selectedFilterItems
                                  .contains(filterItems[index]);
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                child: InkWell(
                                  onTap: () {
                                    filterBloc.add(
                                        SelectFilterItem(filterItems[index]));
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        width: 60,
                                        height: 60,
                                        padding: const EdgeInsets.all(20),
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: isSelected
                                                ? Colors.white
                                                : AppColors.borderOutlineColor,
                                            width: 1.5,
                                          ),
                                          color: isSelected
                                              ? AppColors.primaryColor
                                              : Colors.white,
                                        ),
                                        child: ImageHelper.loadAssetImage(
                                          filterItems[index].icon,
                                          fit: BoxFit.cover,
                                          tintColor: isSelected
                                              ? Colors.white
                                              : Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Expanded(
                                          child: Text(
                                        filterItems[index].label,
                                        style: const TextStyle(fontSize: 16),
                                      ))
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Text("Time & Date", style: AppStyles.h5),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () async {
                            final selectedDate = await showSelectDate(context);
                            if (selectedDate != null) {
                              filterBloc.add(SetSelectedDate(selectedDate));
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 48,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppColors.borderOutlineColor,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.calendar_month,
                                  color: AppColors.primaryColor,
                                ),
                                Text(
                                  filterBloc.selectedDate != null
                                      ? DateFormat("yyyy-MM-dd")
                                          .format(filterBloc.selectedDate!)
                                      : "Choose from calender",
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text("Location", style: AppStyles.h5),
                        const SizedBox(height: 8),
                        Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(color: AppColors.borderOutlineColor),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 36,
                                  width: 36,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0xffE6E9FF),
                                  ),
                                  child: Icon(
                                    Icons.location_on_outlined,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Expanded(child: Text("Ha Noi, VietNam")),
                                Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: AppColors.primaryColor,
                                  size: 16,
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text("Select price range", style: AppStyles.h5),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Min: ${AppUtils.formatCurrency(filterBloc.currentRangeValues.start)} VND',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Max: ${AppUtils.formatCurrency(filterBloc.currentRangeValues.end)} VND',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // RangeSlider
                        RangeSlider(
                          values: filterBloc.currentRangeValues,
                          activeColor: AppColors.primaryColor,
                          max: 3000000,
                          // 10 million VND
                          divisions: 100,
                          labels: RangeLabels(
                            AppUtils.formatCurrency(
                                filterBloc.currentRangeValues.start),
                            AppUtils.formatCurrency(
                                filterBloc.currentRangeValues.end),
                          ),
                          onChanged: (RangeValues values) {
                            filterBloc.add(SetRangeValues(values));
                          },
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MainOutlineButton(
                                height: 60,
                                width: size.width * 1 / 3 - 20,
                                textButton: "RESET",
                                onTap: () => filterBloc.resetFilter(),
                              ),
                              MainElevatedButton(
                                height: 60,
                                width: size.width * 2 / 3 - 20,
                                textButton: "APPLY",
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildCategories() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        itemCount: categoryItems.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return buildCategory(
            categoryName: categoryItems[index].label,
            icon: categoryItems[index].icon,
            color: categoryItems[index].color,
          );
        },
      ),
    );
  }

  Widget buildPopularNowEvent() {
    return SizedBox(
      height: 200,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 4,
          childAspectRatio: 0.3,
        ),
        itemCount: 10,
        itemBuilder: (context, index) {
          return PopularCard(
            title: "International Band Events",
            date: "10 June",
            imageLink: "${assetImageLink}img_event_example2.png",
            location: "36 Guild Street London, UK ",
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

Widget buildShowByCategory(
    {required String label, required VoidCallback onSeeAll}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppStyles.title1.copyWith(fontWeight: FontWeight.w400),
        ),
        Row(
          children: [
            InkWell(
              onTap: onSeeAll,
              child: Text(
                "See All",
                style: AppStyles.title1.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
            ),
            const Icon(Icons.arrow_right)
          ],
        )
      ],
    ),
  );
}

Widget buildHeaderStickyWidget(BuildContext context) {
  return Container(
    margin: const EdgeInsets.only(top: 36),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            Scaffold.of(context).openDrawer();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: ImageHelper.loadAssetImage("${assetImageLink}ic_menu.png"),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () =>
                Navigator.of(context).pushNamed(AddressFinderPage.routeName),
            child: Column(
              children: [
                const Text(
                  "Current Location",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                BlocBuilder<GetLocationBloc, LocationState>(
                  builder: (context, state) {
                    if (state is LocationSuccess) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          state.address ?? "---",
                          maxLines: 1,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    }

                    return const Text(
                      "",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          child: ImageHelper.loadAssetImage("${assetImageLink}ic_ring.png"),
        ),
      ],
    ),
  );
}

const _maxHeaderExtent = 80.0;

class HeaderStickyDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    var percent = shrinkOffset / _maxHeaderExtent;
    if (percent > 0.1) {
      return Container(
        height: 100,
        color: AppColors.primaryColor,
        child: buildHeaderStickyWidget(context),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        height: 80,
        child: buildShowByCategory(
          label: 'Upcoming Events',
          onSeeAll: () {
            Navigator.of(context).pushNamed(EventUpComingPage.routeName);
          },
        ),
      );
    }
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => _maxHeaderExtent;

  @override
  // TODO: implement minExtent
  double get minExtent => _maxHeaderExtent;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
