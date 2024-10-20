import 'package:ezbooking/core/config/app_colors.dart';
import 'package:ezbooking/core/config/app_styles.dart';
import 'package:ezbooking/core/config/constants.dart';
import 'package:ezbooking/core/utils/image_helper.dart';
import 'package:ezbooking/presentation/widgets/button.dart';
import 'package:ezbooking/presentation/widgets/event_subinfo.dart';
import 'package:ezbooking/presentation/widgets/favorite.dart';
import 'package:ezbooking/presentation/widgets/organizer.dart';
import 'package:flutter/material.dart';

class EventDetail extends StatelessWidget {
  static const String routeName = "EventDetail";
  const EventDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final header = SizedBox(
      height: 268,
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: 240,
                child: ImageHelper.loadAssetImage(
                  "${assetImageLink}img_event.png",
                  width: double.maxFinite,
                  fit: BoxFit.fill,
                ),
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 28, horizontal: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 7),
                  child: Text(
                    "Event Details",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: buildFavoriteButton(),
                  ),
                ),
                const SizedBox(width: 12)
              ],
            ),
          ),
          Positioned(
            bottom: 2,
            left: 36,
            right: 36,
            child: buildHeaderStickyWidget(),
          )
        ],
      ),
    );
    var body = SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(bottom: 74),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const EventSubInformation(
              title: "14 December, 2021",
              subtitle: "Tuesday, 4:00PM - 9:00PM",
              iconName: "ic_event.png",
            ),
            const SizedBox(height: 20),
            const EventSubInformation(
              title: "Gala Convention Center",
              subtitle: "36 Guild Street London, UK ",
              iconName: "ic_location.png",
            ),
            const SizedBox(height: 20),
            const Organizer(
                avatarImage: "ic_location.png",
                organizerName: "Cartoon Network"),
            const SizedBox(height: 20),
            Text(
              "About Event",
              style: AppStyles.h5.copyWith(
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
              ),
            ),
            Text(
              aboutEvent,
              style: AppStyles.h5.copyWith(
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
            )
          ],
        ),
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              expandedHeight: 268,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                stretchModes: const [StretchMode.blurBackground],
                background: header,
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: buildHeaderSliver(),
            ),
            SliverToBoxAdapter(
              child: body,
            )
          ],
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.3),
            // Shadow color with opacity
            spreadRadius: 1,
            // Spread the shadow
            blurRadius: 16,
            // Blur effect
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.grey.withOpacity(.3),
            // Shadow color with opacity
            spreadRadius: 1,
            // Spread the shadow
            blurRadius: 24,
            // Blur effect
            offset: const Offset(0, -10),
          ),
        ]),
        child: MainElevatedButton(
            textButton: "BUY TICKET", iconName: "ic_button_next.png"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

Widget buildHeaderStickyWidget() {
  return Container(
    height: 60,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: Colors.grey, width: 0.05),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          // Shadow color with opacity
          spreadRadius: 1,
          // Spread the shadow
          blurRadius: 16,
          // Blur effect
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      children: [
        const SizedBox(width: 16),
        Expanded(
          child: Stack(
            children: [
              CircleAvatar(
                child: ImageHelper.loadAssetImage(
                    "${assetImageLink}ic_avatar.png",
                    height: 34,
                    width: 34),
              ),
              Positioned(
                left: 24,
                child: CircleAvatar(
                  child: ImageHelper.loadAssetImage(
                      "${assetImageLink}ic_avatar.png",
                      height: 34,
                      width: 34),
                ),
              ),
              Positioned(
                left: 48,
                child: CircleAvatar(
                  child: ImageHelper.loadAssetImage(
                      "${assetImageLink}ic_avatar.png",
                      height: 34,
                      width: 34),
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: Text(
            "20+ Going",
            style: AppStyles.h5
                .copyWith(color: AppColors.primaryColor, fontSize: 16),
          ),
        ),
        StandardElevatedButton(textButton: "Attend"),
        const SizedBox(width: 16),
      ],
    ),
  );
}

const double _maxHeaderExtent = 120.0;

class buildHeaderSliver extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    var percent = shrinkOffset / _maxHeaderExtent;
    if (percent > 0.1) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        child: Container(
          color: AppColors.primaryColor,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    "Event Details",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: buildFavoriteButton(),
                  ),
                ),
                const SizedBox(width: 12)
              ],
            ),
          ),
        ),
      );
    } else {
      return SizedBox(
        height: 120,
        child: Center(
          child: Text(
            "International Band Music Concert",
            maxLines: 2,
            style: AppStyles.h3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => _maxHeaderExtent;

  @override
  // TODO: implement minExtent
  double get minExtent => 70;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
