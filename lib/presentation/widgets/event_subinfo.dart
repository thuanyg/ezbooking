import 'package:ezbooking/core/config/app_colors.dart';
import 'package:ezbooking/core/config/constants.dart';
import 'package:flutter/material.dart';

class EventSubInformation extends StatelessWidget {
  final String iconName, title, subtitle;

  const EventSubInformation({
    required this.iconName,
    required this.title,
    required this.subtitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFEFF0FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Image.asset(
            assetImageLink + iconName,
            color: AppColors.primaryColor,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w400,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                subtitle,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFF747688),
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
