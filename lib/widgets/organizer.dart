import 'package:ezbooking/utils/app_colors.dart';
import 'package:ezbooking/utils/constants.dart';
import 'package:ezbooking/widgets/button.dart';
import 'package:flutter/material.dart';


class Organizer extends StatelessWidget {
  final String avatarImage, organizerName;

  const Organizer({
    required this.avatarImage,
    required this.organizerName,
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
              borderRadius: BorderRadius.circular(12)),
          child: Image.asset(
            assetImageLink + avatarImage,
            color: AppColors.primaryColor,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                organizerName,
                style: const TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Text(
                "Organizer",
                style: TextStyle(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFF747688),
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
        ),
        StandardOutlinedButton(textButton: "Follow", onTap: (){})
      ],
    );
  }
}