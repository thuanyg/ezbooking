import 'package:ezbooking/core/config/app_colors.dart';
import 'package:ezbooking/core/config/app_styles.dart';
import 'package:ezbooking/core/config/constants.dart';
import 'package:ezbooking/core/utils/image_helper.dart';
import 'package:ezbooking/presentation/widgets/favorite.dart';
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
        padding: const EdgeInsets.all(6),
        child: Column(
          children: [
            Stack(
              children: [
                ImageHelper.loadNetworkImage(
                  imageLink,
                  radius: BorderRadius.circular(6),
                  height: 145,
                  width: 230,
                  fit: BoxFit.fill,
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Opacity(
                    opacity: .88,
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: const Color(0xfffff6f2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          date,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: AppStyles.title2.copyWith(
                              color: const Color(0xffF0635A), fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Opacity(
                    opacity: .95,
                    child: buildFavoriteButton(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    title,
                    style: AppStyles.title1,
                    maxLines: 2,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
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
    required this.onPressed,
  });

  final VoidCallback onPressed;
  String imageLink, date, title, location;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Card(
      color: Colors.white,
      elevation: 1,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              ImageHelper.loadNetworkImage(
                imageLink,
                height: 100,
                width: 85,
                fit: BoxFit.cover,
                radius: BorderRadius.circular(5),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        date,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyles.title2.copyWith(
                          color: AppColors.primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.italic,
                        ),
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
                            height: 10,
                            tintColor: Colors.grey,
                          ),
                          const SizedBox(width: 4.0),
                          Expanded(
                            child: Text(
                              location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppStyles.title2.copyWith(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.italic,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
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
  }
}
