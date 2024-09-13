import 'package:ezbooking/utils/app_colors.dart';
import 'package:ezbooking/utils/app_styles.dart';
import 'package:ezbooking/utils/constants.dart';
import 'package:ezbooking/utils/image_helper.dart';
import 'package:ezbooking/widgets/event_subinfo.dart';
import 'package:ezbooking/widgets/favorite.dart';
import 'package:flutter/material.dart';

class EventDetail extends StatelessWidget {
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
                  onPressed: () {},
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
            bottom: 0,
            left: 36,
            right: 36,
            child: Container(
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
            ),
          )
        ],
      ),
    );
    final body = SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              "International Band Music Concert",
              maxLines: 2,
              style: AppStyles.h2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
            ),
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
          ],
        ),
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          header,
          body,
        ],
      ),
    );
  }
}


