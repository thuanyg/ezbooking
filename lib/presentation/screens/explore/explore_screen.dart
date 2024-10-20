import 'package:ezbooking/core/utils/utils.dart';
import 'package:ezbooking/presentation/pages/event/event_detail.dart';
import 'package:ezbooking/core/config/app_colors.dart';
import 'package:ezbooking/core/config/app_styles.dart';
import 'package:ezbooking/core/config/constants.dart';
import 'package:ezbooking/core/utils/image_helper.dart';
import 'package:ezbooking/presentation/widgets/button.dart';
import 'package:ezbooking/presentation/widgets/cards.dart';
import 'package:ezbooking/presentation/widgets/category.dart';
import 'package:flutter/material.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  List<FilterItem> selectedFilterItems = [];
  List<String> selectedTime = [];
  DateTime? _selectedDate;
  late RangeValues _currentRangeValues = const RangeValues(0, 0);

  Future showSelectDate(BuildContext context) async {
    showDatePicker(
      context: context,
      helpText: "Select Date",
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    ).then(
      (DateTime? selected) {
        if (selected != null && selected != _selectedDate) {
          setState(() => _selectedDate = selected);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 24),
      child: Column(
        children: [
          buildUpcomingEvent(),
          buildShowByCategory(label: 'Popular Now', onSeeAll: () {}),
          buildPopularNowEvent(),
          buildShowByCategory(label: 'Popular Now', onSeeAll: () {}),
          buildPopularNowEvent(),
          buildShowByCategory(label: 'Popular Now', onSeeAll: () {}),
          buildPopularNowEvent(),
          buildUpcomingEvent(),
          buildUpcomingEvent(),
          buildUpcomingEvent(),
          buildUpcomingEvent(),
          buildUpcomingEvent(),
          buildUpcomingEvent(),
          buildUpcomingEvent(),
          buildUpcomingEvent(),
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
        padding: const EdgeInsets.symmetric(horizontal: 24),
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
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: const Color(0xFF5D56F3),
                  ),
                  child: Row(
                    children: [
                      Image.asset("${assetImageLink}ic_filter.png"),
                      const SizedBox(width: 4),
                      const Text(
                        "Filters",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  )),
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
        return StatefulBuilder(
          // Use StatefulBuilder to handle state changes
          builder: (BuildContext context, StateSetter setState) {
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
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 150, vertical: 8),
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
                            bool isSelected =
                                selectedFilterItems.contains(filterItems[index]);
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      selectedFilterItems.remove(filterItems[index]);
                                    } else {
                                      selectedFilterItems.add(filterItems[index]);
                                    }
                                  });
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (selectedTime.contains("Today")) {
                                  selectedTime.remove("Today");
                                } else {
                                  selectedTime.add("Today");
                                }
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: selectedTime.contains("Today")
                                    ? AppColors.primaryColor
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: selectedTime.contains("Today")
                                      ? Colors.white
                                      : AppColors.borderOutlineColor,
                                ),
                              ),
                              child: Text(
                                "Today",
                                style: TextStyle(
                                  color: selectedTime.contains("Today")
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (selectedTime.contains("Tomorrow")) {
                                  selectedTime.remove("Tomorrow");
                                } else {
                                  selectedTime.add("Tomorrow");
                                }
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: selectedTime.contains("Tomorrow")
                                    ? AppColors.primaryColor
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: selectedTime.contains("Tomorrow")
                                      ? Colors.white
                                      : AppColors.borderOutlineColor,
                                ),
                              ),
                              child: Text(
                                "Tomorrow",
                                style: TextStyle(
                                  color: selectedTime.contains("Tomorrow")
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (selectedTime.contains("This week")) {
                                  selectedTime.remove("This week");
                                } else {
                                  selectedTime.add("This week");
                                }
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: selectedTime.contains("This week")
                                    ? AppColors.primaryColor
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: selectedTime.contains("This week")
                                      ? Colors.white
                                      : AppColors.borderOutlineColor,
                                ),
                              ),
                              child: Text(
                                "This week",
                                style: TextStyle(
                                  color: selectedTime.contains("This week")
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () async {
                          await showSelectDate(context);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 48),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.borderOutlineColor,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_month,
                                color: AppColors.primaryColor,
                              ),
                              Text(
                                _selectedDate != null
                                    ? _selectedDate.toString()
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
                              'Min: ${AppUtils.formatCurrency(_currentRangeValues.start)} VND',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Max: ${AppUtils.formatCurrency(_currentRangeValues.end)} VND',
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
                        values: _currentRangeValues,
                        activeColor: AppColors.primaryColor,
                        max: 3000000,
                        // 10 million VND
                        divisions: 100,
                        labels: RangeLabels(
                          AppUtils.formatCurrency(_currentRangeValues.start),
                          AppUtils.formatCurrency(_currentRangeValues.end),
                        ),
                        onChanged: (RangeValues values) {
                          setState(() {
                            _currentRangeValues = values;
                          });
                        },
                      ),
                      Expanded(
                        child: Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MainOutlineButton(
                                height: 60,
                                width: size.width * 1/3 - 20,
                                textButton: "RESET",
                                onTap: () {
                                  setState(() {
                                    selectedFilterItems.clear();
                                    selectedTime.clear();
                                    _selectedDate = null;
                                    _currentRangeValues = const RangeValues(0, 0);
                                  });
                                },
                              ),
                              MainElevatedButton(
                                height: 60,
                                width: size.width * 2/3 - 20,
                                textButton: "APPLY",
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
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

  Widget buildUpcomingEvent() {
    return SizedBox(
      height: 260,
      child: ListView.builder(
        itemCount: 10,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(EventDetail.routeName);
              },
              child: UpcomingCard(
                title: "International Band Events",
                date: "10 June",
                imageLink: "${assetImageLink}img_event_example.png",
                location: "36 Guild Street London, UK ",
              ),
            ),
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
        const Column(
          children: [
            Text(
              "Current Location",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w300),
            ),
            Text("New Yourk, USA",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400)),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
        padding: const EdgeInsets.symmetric(horizontal: 24),
        height: 80,
        child: buildShowByCategory(label: 'Upcoming Events', onSeeAll: () {}),
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
