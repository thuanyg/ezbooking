import 'package:ezbooking/core/config/app_colors.dart';
import 'package:ezbooking/core/config/app_styles.dart';
import 'package:ezbooking/core/config/constants.dart';
import 'package:ezbooking/core/utils/image_helper.dart';
import 'package:ezbooking/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shimmer/shimmer.dart';

class UpcomingCard extends StatelessWidget {
  const UpcomingCard({
    super.key,
    required this.id,
    required this.title,
    required this.date,
    required this.imageLink,
    required this.location,
    required this.distance,
  });

  final String id, imageLink, date, title, location, distance;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        color: const Color(0xfff6fbff),
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
                  height: 120,
                  width: 200,
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
              ],
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    title,
                    style: AppStyles.title1.copyWith(
                      color: const Color(0xff333333),
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    ),
                    maxLines: 2,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Row(
                  children: [
                    ImageHelper.loadAssetImage(
                      "${assetImageLink}ic_location.png",
                      height: 14,
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
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.italic,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Text(
                      distance,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.title2.copyWith(
                        color: Colors.grey,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.italic,
                      ),
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
  const PopularCard({
    super.key,
    required this.title,
    required this.date,
    required this.imageLink,
    required this.location,
    required this.onTap,
  });

  final String imageLink, date, title, location;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        width: size.width * 0.7,
        decoration: BoxDecoration(
          color: const Color(0xfff6fbff),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              ImageHelper.loadNetworkImage(
                imageLink,
                height: 90,
                width: 75,
                fit: BoxFit.cover,
                radius: BorderRadius.circular(5),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: AppStyles.title1.copyWith(
                        color: const Color(0xff333333),
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
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
                        Expanded(
                          child: Text(
                            location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppStyles.title2.copyWith(
                              color: Colors.grey,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              overflow: TextOverflow.ellipsis,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.date_range,
                          color: Colors.grey,
                          size: 15,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          date,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.title2.copyWith(
                            color: Colors.grey,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class EventStandardCard extends StatelessWidget {
  const EventStandardCard({
    super.key,
    required this.title,
    required this.date,
    required this.imageLink,
    required this.location,
    required this.onPressed,
    required this.distance,
    this.color,
  });

  final VoidCallback onPressed;
  final String imageLink, date, title, location, distance;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color ?? Colors.white,
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
                        style: AppStyles.title1.copyWith(
                          color: const Color(0xff333333),
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                        ),
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
                          const SizedBox(width: 16),
                          Text(
                            distance,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppStyles.title2.copyWith(
                              color: Colors.grey[400],
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.italic,
                              overflow: TextOverflow.ellipsis,
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
