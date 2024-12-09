import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezbooking/core/config/app_styles.dart';
import 'package:ezbooking/data/models/event.dart';
import 'package:ezbooking/presentation/pages/event/event_detail.dart';
import 'package:ezbooking/presentation/screens/explore/explore_screen.dart';
import 'package:ezbooking/presentation/widgets/cards.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class LatestEvent extends StatefulWidget {
  const LatestEvent({super.key});

  @override
  State<LatestEvent> createState() => _LatestEventState();
}

class _LatestEventState extends State<LatestEvent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Recently",
            style: AppStyles.title1.copyWith(fontWeight: FontWeight.w400),
          ),
        ),
        _buildEventList(),
      ],
    );
  }

  Widget _buildEventList() {
    Query<Event> eventsQuery;

    eventsQuery =
        FirebaseFirestore.instance.collection('events')
        .where("isDelete", isEqualTo: false)
        .withConverter<Event>(
              fromFirestore: (snapshot, _) => Event.fromJson(snapshot.data()!),
              toFirestore: (event, _) => event.toMap(),
            );

    return FirestoreListView<Event>(
      query: eventsQuery,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      loadingBuilder: (context) => Shimmer.fromColors(
        baseColor: Colors.white54,
        highlightColor: Colors.white,
        child: EventStandardCard(
          distance: "",
          title: "",
          date: "",
          imageLink: "",
          location: "",
          onPressed: () {},
        ),
      ),
      errorBuilder: (context, error, stackTrace) => const Center(
        child: Text("Error", style: TextStyle(color: Colors.black)),
      ),
      emptyBuilder: (context) => const Center(
        child:
            Text("No events exist...", style: TextStyle(color: Colors.black)),
      ),
      itemBuilder: (context, snapshot) {
        final event = snapshot.data();

        double distance = 0.0;

        return EventStandardCard(
          title: event.name,
          date: DateFormat('EEE, MMM d - yyyy • h:mm a').format(event.date),
          imageLink: event.poster ?? "",
          location: event.location,
          distance: "",
          // Display distance in km
          onPressed: () {
            Navigator.of(context).pushNamed(
              EventDetail.routeName,
              arguments: event.id,
            );
          },
        );
      },
    );
  }
}
