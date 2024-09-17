import 'package:ezbooking/utils/app_colors.dart';
import 'package:ezbooking/utils/app_styles.dart';
import 'package:ezbooking/utils/constants.dart';
import 'package:ezbooking/utils/image_helper.dart';
import 'package:ezbooking/widgets/favorite.dart';
import 'package:flutter/material.dart';

class UpcomingCard extends StatelessWidget {
  UpcomingCard({
    super.key,
    required this.title,
    required this.date,
    required this.imageLink,
    required this.location,
  });

  String imageLink, date, title, location;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 255,
      width: 237,
      decoration: BoxDecoration(
        color: const Color(0xffefefff),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Stack(children: [
              ImageHelper.loadAssetImage(imageLink, width: 218, height: 130),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                      color: const Color(0xfffff6f2),
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    date,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: AppStyles.title2
                        .copyWith(color: const Color(0xffF0635A), fontSize: 14),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: buildFavoriteButton()
              ),
            ]),
            const SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                title,
                style: AppStyles.title1,
                maxLines: 2,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    ImageHelper.loadAssetImage(
                      "${assetImageLink}ic_location.png",
                      height: 14,
                      tintColor: Colors.grey,
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.title2.copyWith(
                          color: Colors.grey,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.italic),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PopularCard extends StatelessWidget {
  PopularCard({
    super.key,
    required this.title,
    required this.date,
    required this.imageLink,
    required this.location,
  });

  String imageLink, date, title, location;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: 100,
      width: size.width * 0.7,
      decoration: BoxDecoration(
        color: const Color(0xffefefff),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            ImageHelper.loadAssetImage(
              imageLink,
              height: 80,
              width: 80,
              radius: BorderRadius.circular(12),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    title,
                    style: AppStyles.title1,
                    maxLines: 2,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      ImageHelper.loadAssetImage(
                        "${assetImageLink}ic_location.png",
                        height: 14,
                        tintColor: Colors.grey,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyles.title2.copyWith(
                            color: Colors.grey,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class EventStandardCard extends StatelessWidget {
  EventStandardCard({
    super.key,
    required this.title,
    required this.date,
    required this.imageLink,
    required this.location,
  });

  String imageLink, date, title, location;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Card(
      color: Colors.white,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            ImageHelper.loadAssetImage(
              imageLink,
              height: 100,
              width: 85,
              fit: BoxFit.cover,
              radius: BorderRadius.circular(12),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    date,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.title2.copyWith(
                        color: AppColors.primaryColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.italic),
                  ),
                  Text(
                    title,
                    style: AppStyles.title1,
                    maxLines: 2,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      ImageHelper.loadAssetImage(
                        "${assetImageLink}ic_location.png",
                        height: 14,
                        tintColor: Colors.grey,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyles.title2.copyWith(
                            color: Colors.grey,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
