import 'package:ezbooking/core/config/constants.dart';
import 'package:ezbooking/core/utils/image_helper.dart';
import 'package:flutter/material.dart';

Widget buildCategory({required String categoryName, required String icon, required int color}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    height: 39,
    margin: const EdgeInsets.symmetric(horizontal: 6.0),
    decoration: BoxDecoration(
      color: Color(color),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ImageHelper.loadAssetImage(icon, height: 24, tintColor: Colors.white),
        const SizedBox(width: 4,),
        Text(
          categoryName,
          style: const TextStyle(color: Colors.white),
        )
      ],
    ),
  );
}
