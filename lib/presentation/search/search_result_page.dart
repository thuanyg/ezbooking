import 'package:ezbooking/core/config/app_colors.dart';
import 'package:ezbooking/core/config/app_styles.dart';
import 'package:ezbooking/core/config/constants.dart';
import 'package:ezbooking/core/utils/image_helper.dart';
import 'package:ezbooking/core/utils/utils.dart';
import 'package:ezbooking/data/models/category.dart';
import 'package:ezbooking/data/models/event.dart';
import 'package:ezbooking/presentation/pages/event/event_detail.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/category/fetch_categories_bloc.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/filter/filter_bloc.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/filter/filter_event.dart';
import 'package:ezbooking/presentation/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class SearchResultPage extends StatefulWidget {
  final String query;

  const SearchResultPage({super.key, required this.query});

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  late FilterBloc filterBloc;
  late List<Event> allEvents = [];
  late List<Event> filteredEvents = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    filterBloc = BlocProvider.of<FilterBloc>(context);
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    setState(() {
      isLoading = true;
    });
    try {
      // Fetch events from Firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('events')
          .where('isDelete', isEqualTo: false)
          .get();

      // Convert Firestore documents to Event objects
      allEvents = querySnapshot.docs
          .map((doc) => Event.fromJson(
              {...doc.data() as Map<String, dynamic>, 'id': doc.id}))
          .toList();

      // Apply search and filter
      _applyFilters();
    } catch (e) {
      setState(() {
        filteredEvents = [];
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _applyFilters() {
    setState(() {
      filteredEvents = allEvents.where((event) {
        // Text search
        bool matchesQuery = widget.query.isEmpty ||
            event.name.toLowerCase().contains(widget.query.toLowerCase());

        // Filter by selected filter items
        bool matchesFilterItems = filterBloc.selectedFilterItems.isEmpty ||
            filterBloc.selectedFilterItems.any((filterItem) =>
                event.category == filterItem.id ||
                event.eventType == filterItem.categoryName);

        // Filter by date range
        bool matchesDateRange = filterBloc.selectedDateRange == null ||
            (event.date.isAfter(filterBloc.selectedDateRange!.start) &&
                event.date.isBefore(filterBloc.selectedDateRange!.end)) ||
            event.date.isAtSameMomentAs(filterBloc.selectedDateRange!.start) ||
            event.date.isAtSameMomentAs(filterBloc.selectedDateRange!.end);

        // Filter by price range
        bool matchesPriceRange = filterBloc.currentRangeValues.start == 0 &&
                filterBloc.currentRangeValues.end == 0 ||
            (event.ticketPrice >= filterBloc.currentRangeValues.start &&
                event.ticketPrice <= filterBloc.currentRangeValues.end);

        return matchesQuery &&
            matchesFilterItems &&
            matchesDateRange &&
            matchesPriceRange;
      }).toList();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search Results',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: isLoading
          ? Center(
              child: Lottie.asset(
              "assets/animations/loading.json",
              height: 80,
            ))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Found ${filteredEvents.length} events: ${widget.query}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondaryColor,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.filter_list,
                            color: AppColors.primaryColor),
                        onPressed: () async {
                          buildFilterBottomSheet(context);
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: filteredEvents.isEmpty
                      ? _buildNoResultsWidget()
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: filteredEvents.length,
                          itemBuilder: (context, index) {
                            final event = filteredEvents[index];
                            return _buildEventCard(event);
                          },
                        ),
                ),
              ],
            ),
    );
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
                          builder: (BuildContext context, List<Category> state) {
                            if(state.isNotEmpty){
                              return SizedBox(
                                height: 120,
                                child: ListView.builder(
                                  itemCount: state.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    bool isSelected = filterBloc.selectedFilterItems
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
                                                      : AppColors.borderOutlineColor,
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
                                                  style: const TextStyle(fontSize: 16),
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
                                  _applyFilters();
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

  Widget _buildNoResultsWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 100,
            color: AppColors.secondaryColor.withOpacity(0.5),
          ),
          SizedBox(height: 16),
          Text(
            'No events found',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.secondaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(Event event) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          EventDetail.routeName,
          arguments: event.id,
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(
                event.thumbnail ?? event.poster ?? '',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  color: AppColors.backgroundColor,
                  child: Center(
                    child: Icon(
                      Icons.image_not_supported,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 16, color: AppColors.primaryColor),
                      SizedBox(width: 8),
                      Text(
                        _formatDate(event.date),
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(Icons.location_on,
                                size: 16, color: AppColors.primaryColor),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                event.location,
                                style: TextStyle(color: Colors.grey[700]),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '\$${event.ticketPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_getMonthName(date.month)} ${date.year}';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }
}
