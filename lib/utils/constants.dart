import 'package:ezbooking/models/onboarding.dart';
import 'package:flutter/material.dart';


const String aboutEvent = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum ley of type and scrambled it to make a type specimen book. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. \nIt was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum ley of type and scrambled it to make a type specimen book.";
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

List<DrawerItem> drawerItems = [
  DrawerItem("${assetImageLink}ic_user_drawer.png", "My Profile"),
  DrawerItem("${assetImageLink}ic_message_drawer.png", "Message"),
  DrawerItem("${assetImageLink}ic_calender_drawer.png", "Calender"),
  DrawerItem("${assetImageLink}ic_bookmark_drawer.png", "Bookmark"),
  DrawerItem("${assetImageLink}ic_mail_drawer.png", "Contact Us"),
  DrawerItem("${assetImageLink}ic_setting_drawer.png", "Settings"),
  DrawerItem("${assetImageLink}ic_help_drawer.png", "Helps & FAQs"),
  DrawerItem("${assetImageLink}ic_logout_drawer.png", "Sign Out"),
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

class DrawerItem {
  String icon;
  String label;

  DrawerItem(this.icon, this.label);
}


const String assetImageLink = "assets/images/";
const String assetFontLink = "assets/fonts/";
const String assetAnimationLink = "assets/animations/";
