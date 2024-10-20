import 'package:ezbooking/core/config/app_styles.dart';
import 'package:ezbooking/core/config/constants.dart';
import 'package:ezbooking/presentation/widgets/cards.dart';
import 'package:flutter/material.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  bool isSearchEnable = false;
  final searchEventController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: ListView.builder(
          itemCount: 30,
          itemBuilder: (context, index) {
            return EventStandardCard(
              title: "Jo Malone London’s Mother’s Day Presents",
              date: "Wed, Apr 28 • 5:30 PM",
              imageLink: "${assetImageLink}img_event_example.png",
              location: "Radius Gallery • Santa Cruz, CA",
            );
          },
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "Events",
          style: AppStyles.titleAppBar,
        ),
      ),
      centerTitle: true,
      actions: [
        isSearchEnable
            ? SizedBox(
                width: MediaQuery.of(context).size.width * 0.55,
                height: 44,
                child: TextField(
                  autofocus: true,
                  controller: searchEventController,
                  style: const TextStyle(
                    fontSize: 16.0,
                    height: 0,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "Search event...",
                  ),
                ),
              )
            : const SizedBox.shrink(),
        isSearchEnable
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isSearchEnable = false;
                  });
                },
                icon: const Icon(Icons.cancel),
              )
            : const SizedBox.shrink(),
        IconButton(
          onPressed: () {
            setState(() {
              isSearchEnable = true;
            });
          },
          icon: const Icon(Icons.search),
        ),
      ],
    );
  }
}
