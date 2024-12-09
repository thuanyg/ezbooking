import 'dart:math';

import 'package:ezbooking/core/utils/utils.dart';
import 'package:ezbooking/core/config/app_colors.dart';
import 'package:ezbooking/core/config/app_styles.dart';
import 'package:ezbooking/core/config/constants.dart';
import 'package:ezbooking/core/utils/image_helper.dart';
import 'package:ezbooking/data/models/category.dart';
import 'package:ezbooking/presentation/pages/event/event_upcoming.dart';
import 'package:ezbooking/presentation/pages/event/events_by_category.dart';
import 'package:ezbooking/presentation/pages/maps/bloc/get_location_bloc.dart';
import 'package:ezbooking/presentation/pages/maps/bloc/location_state.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/category/fetch_categories_bloc.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/filter/filter_bloc.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/filter/filter_event.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/latest/latest_event_bloc.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/latest/latest_event_event.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/organizer/organizer_list_bloc.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/popular/popular_event_bloc.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/popular/popular_event_event.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/upcoming/upcoming_event_bloc.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/upcoming/upcoming_event_event.dart';
import 'package:ezbooking/presentation/screens/explore/widgets/latest_event.dart';
import 'package:ezbooking/presentation/screens/explore/widgets/near_by_event.dart';
import 'package:ezbooking/presentation/screens/explore/widgets/organizer_list.dart';
import 'package:ezbooking/presentation/screens/explore/widgets/popular_event.dart';
import 'package:ezbooking/presentation/screens/explore/widgets/up_coming_event.dart';
import 'package:ezbooking/presentation/search/search_result_page.dart';
import 'package:ezbooking/presentation/search_location/address_finder_page.dart';
import 'package:ezbooking/presentation/widgets/button.dart';
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
  late final FetchCategoriesBloc fetchCategoriesBloc;
  late final FilterBloc filterBloc;
  late final UpcomingEventBloc upcomingEventBloc;
  late final LatestEventBloc nearEventBloc;
  late final PopularEventBloc popularEventBloc;
  late final GetLocationBloc locationBloc;
  late final OrganizerListBloc organizerListBloc;

  @override
  void initState() {
    super.initState();
    fetchCategoriesBloc = BlocProvider.of<FetchCategoriesBloc>(context);
    locationBloc = BlocProvider.of<GetLocationBloc>(context);
    upcomingEventBloc = BlocProvider.of<UpcomingEventBloc>(context);
    nearEventBloc = BlocProvider.of<LatestEventBloc>(context);
    filterBloc = BlocProvider.of<FilterBloc>(context);
    popularEventBloc = BlocProvider.of<PopularEventBloc>(context);
    organizerListBloc = BlocProvider.of<OrganizerListBloc>(context);

    // Fetch Data Initial
    fetchCategoriesBloc.fetchCategories();
    if (locationBloc.locationResult?.position == null) {
      upcomingEventBloc.add(FetchUpcomingEvent(
        limit: 10,
        isFetchApproximately: false,
      ));
      nearEventBloc.add(FetchLatestEvent(
        limit: 10,
        isFetchApproximately: false,
      ));
      popularEventBloc.add(FetchPopularEvent());
    } else {
      upcomingEventBloc.add(FetchUpcomingEvent(
        limit: 10,
        isFetchApproximately: true,
        position: locationBloc.locationResult?.position,
      ));
      nearEventBloc.add(FetchLatestEvent(
        limit: 10,
        isFetchApproximately: true,
        position: locationBloc.locationResult?.position,
      ));
      popularEventBloc.add(FetchPopularEvent());
    }
    organizerListBloc.fetchOrganizers();
  }

  Future<DateTimeRange?> showSelectDateRange(BuildContext context) async {
    DateTimeRange? dateRange = await showDateRangePicker(
      context: context,
      helpText: "Select Date Range",
      initialDateRange: filterBloc.selectedDateRange ??
          DateTimeRange(
            start: DateTime.now(),
            end: DateTime.now().add(const Duration(days: 7)),
          ),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );
    return dateRange;
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

    var body = Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 18),
      child: Column(
        children: [
          const UpComingEvent(),
          const SizedBox(height: 16),
          if (locationBloc.locationResult?.position != null) const NearByEvent(),
          const SizedBox(height: 16),
          const OrganizerList(),
          const SizedBox(height: 16),
          const PopularEvent(),
          const SizedBox(height: 16),
          const LatestEvent(),
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
            Expanded(
              child: TextField(
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                onSubmitted: (value) {
                  if (value.trim().isEmpty) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchResultPage(
                        query: value.trim(),
                      ),
                    ),
                  );
                },
                decoration: const InputDecoration(
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
                      color: AppColors.backgroundColor,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          filterBloc.hasFilter()
                              ? Icons.filter_alt
                              : Icons.filter_alt_off_rounded,
                          size: 16,
                          color: Colors.black26,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          "Filters",
                          style: TextStyle(color: Colors.black54),
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
                        BlocBuilder<FetchCategoriesBloc, List<Category>>(
                          builder:
                              (BuildContext context, List<Category> state) {
                            if (state.isNotEmpty) {
                              return SizedBox(
                                height: 120,
                                child: ListView.builder(
                                  itemCount: state.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    bool isSelected = filterBloc
                                        .selectedFilterItems
                                        .contains(state[index]);
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 8),
                                      child: InkWell(
                                        onTap: () {
                                          filterBloc.add(
                                              SelectFilterItem(state[index]));
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
                                                      : AppColors
                                                          .borderOutlineColor,
                                                  width: 1.5,
                                                ),
                                                color: isSelected
                                                    ? AppColors.primaryColor
                                                    : Colors.white,
                                              ),
                                              child: ImageHelper.loadAssetImage(
                                                filterItems[0].icon,
                                                fit: BoxFit.cover,
                                                tintColor: isSelected
                                                    ? Colors.white
                                                    : Colors.grey,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Expanded(
                                                child: Text(
                                              state[index].categoryName,
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ))
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                        Text("Time & Date", style: AppStyles.h5),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () async {
                            final selectedDateRange =
                                await showSelectDateRange(context);
                            if (selectedDateRange != null) {
                              filterBloc
                                  .add(SetSelectedDate(selectedDateRange));
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
                                  filterBloc.selectedDateRange != null
                                      ? "${DateFormat("yyyy-MM-dd").format(filterBloc.selectedDateRange!.start)} - ${DateFormat("yyyy-MM-dd").format(filterBloc.selectedDateRange!.end)}"
                                      : "Choose from calendar",
                                ),
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
                                'Min: \$${AppUtils.formatCurrency(filterBloc.currentRangeValues.start)}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Max: \$${AppUtils.formatCurrency(filterBloc.currentRangeValues.end)}',
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
                          max: 500,
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

  Color getCategoryColor({required int index, required int length}) {
    return categoryColors[index % categoryColors.length];
  }

  Widget buildCategories() {
    return BlocBuilder<FetchCategoriesBloc, List<Category>>(
      builder: (context, state) {
        if (fetchCategoriesBloc.isLoading) {}
        if (!fetchCategoriesBloc.isLoading && state.isNotEmpty) {
          return SizedBox(
            height: 40,
            child: ListView.builder(
              itemCount: state.length,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return buildCategory(
                  categoryName: state[index].categoryName,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          EventsByCategoryPage(category: state[index]),
                    ));
                  },
                  color: getCategoryColor(
                    index: index,
                    length: state.length,
                  ),
                );
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
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
