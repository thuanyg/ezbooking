import 'package:ezbooking/models/onboarding.dart';
import 'package:flutter/material.dart';

List<Onboarding> onboardings = [
  Onboarding(
      "Explore Upcoming and Nearby Events",
      "In publishing and graphic design, Lorem is a placeholder text commonly",
      "${assetImageLink}ic_onboarding1.png"),
  Onboarding(
      "Web Have Modern Events Calendar Feature",
      " In publishing and graphic design, Lorem is a placeholder text commonly",
      "${assetImageLink}ic_onboarding2.png"),
  Onboarding(
      "To Look Up More Events or Activities Nearby By Map",
      "In publishing and graphic design, Lorem is a placeholder text commonly",
      "${assetImageLink}ic_onboarding3.png")
];

List<BottomNavigationItem> bottomNavItems = [
  BottomNavigationItem("${assetImageLink}ic_explore.png", "Explore"),
  BottomNavigationItem("${assetImageLink}ic_event.png", "Event"),
  BottomNavigationItem("${assetImageLink}ic_ticket.png", "Ticket"),
  BottomNavigationItem("${assetImageLink}ic_profile.png", "Profile"),
];

List<CategoryItem> categoryItems = [
  CategoryItem("${assetImageLink}ic_sport_category.png", "Sports", 0xffF0635A),
  CategoryItem("${assetImageLink}ic_music_category.png", "Music", 0xffF59762),
  CategoryItem("${assetImageLink}ic_food_category.png", "Food", 0xff29D697),
  CategoryItem("${assetImageLink}ic_game_category.png", "Game", 0xff46CDFB),
  CategoryItem("${assetImageLink}ic_sport_category.png", "Sports", 0xffECEBFC),
  CategoryItem("${assetImageLink}ic_music_category.png", "Music", 0xffF59762),
  CategoryItem("${assetImageLink}ic_food_category.png", "Food", 0xffF0635A),
  CategoryItem("${assetImageLink}ic_profile.png", "Game", 0xff29D697),
];

class BottomNavigationItem {
  String iconName;
  String label;

  BottomNavigationItem(this.iconName, this.label);
}

class CategoryItem {
  String icon;
  String label;
  int color;

  CategoryItem(this.icon, this.label, this.color);
}

const String assetImageLink = "assets/images/";
const String assetFontLink = "assets/fonts/";
const String assetAnimationLink = "assets/animations/";
