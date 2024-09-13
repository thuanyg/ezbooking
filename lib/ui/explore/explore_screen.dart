import 'package:ezbooking/utils/app_colors.dart';
import 'package:ezbooking/utils/app_styles.dart';
import 'package:ezbooking/utils/constants.dart';
import 'package:ezbooking/utils/image_helper.dart';
import 'package:ezbooking/widgets/cards.dart';
import 'package:ezbooking/widgets/category.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

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
                  children: [buildHeaderSticky(), buildHeaderSearch()],
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
          buildShowByCategory(label: 'Upcoming Events', onSeeAll: () {}),
          buildUpcomingEvent(),
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
        SliverToBoxAdapter(
          child: body,
        )
      ],
    );
  }

  Widget buildHeaderSticky() {
    return Container(
      margin: const EdgeInsets.only(top: 44),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: ImageHelper.loadAssetImage("${assetImageLink}ic_menu.png"),
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

  Widget buildHeaderSearch() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: const Row(
          children: [
            Icon(
              Icons.search,
              size: 24,
              color: Colors.white,
            ),
            SizedBox(width: 8),
            Expanded(
              child: TextField(
                style: TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  hintText: "Search...",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ));
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

  Widget buildUpcomingEvent() {
    return SizedBox(
      height: 260,
      child: ListView.builder(
        itemCount: 10,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: UpcomingCard(
              title: "International Band Events",
              date: "10 June",
              imageLink: "${assetImageLink}img_event_example.png",
              location: "36 Guild Street London, UK ",
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
            childAspectRatio: 0.3),
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

class StickyDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.primaryColor,
      margin: const EdgeInsets.only(top: 26),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: ImageHelper.loadAssetImage("${assetImageLink}ic_menu.png"),
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

  @override
  double get maxExtent => 100.0; // Chiều cao tối đa

  @override
  double get minExtent => 100.0; // Chiều cao tối thiểu

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
