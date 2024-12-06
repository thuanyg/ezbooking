import 'package:ezbooking/core/config/app_colors.dart';
import 'package:ezbooking/core/config/constants.dart';
import 'package:ezbooking/core/utils/image_helper.dart';
import 'package:ezbooking/presentation/pages/organizer/page/organizer_page.dart';
import 'package:ezbooking/presentation/widgets/button.dart';
import 'package:flutter/material.dart';

class Organizer extends StatelessWidget {
  final String id, avatarImage, organizerName;

  const Organizer({
    required this.id,
    required this.avatarImage,
    required this.organizerName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => OrganizerProfilePage(organizerID: id),
        ));
      },
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
                color: const Color(0xFFEFF0FF),
                borderRadius: BorderRadius.circular(12)),
            child: ImageHelper.loadNetworkImage(
              avatarImage,
              fit: BoxFit.fill,
              radius: BorderRadius.circular(12),
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
          StandardOutlinedButton(
              textButton: "Organizer",
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => OrganizerProfilePage(organizerID: id),
                ));
              })
        ],
      ),
    );
  }
}
