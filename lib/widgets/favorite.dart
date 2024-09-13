import 'package:flutter/material.dart';

Widget buildFavoriteButton() {
  return Container(
    height: 36,
    width: 36,
    decoration: BoxDecoration(
      color: const Color(0xfffff6f2),
      borderRadius: BorderRadius.circular(10),
    ),
    child: IconButton(
      icon: const Icon(
        Icons.bookmark,
        size: 18,
        color: Colors.red,
      ),
      onPressed: () {},
    ),
  );
}