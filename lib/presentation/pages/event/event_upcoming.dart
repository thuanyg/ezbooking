import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezbooking/core/config/app_styles.dart';
import 'package:ezbooking/core/utils/utils.dart';
import 'package:ezbooking/data/models/event.dart';
import 'package:ezbooking/presentation/pages/event/event_detail.dart';
import 'package:ezbooking/presentation/pages/maps/bloc/get_location_bloc.dart';
import 'package:ezbooking/presentation/widgets/cards.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class EventUpComingPage extends StatefulWidget {
  const EventUpComingPage({super.key});

  static String routeName = "EventUpComingPage";

  @override
  State<EventUpComingPage> createState() => _EventUpComingPageState();
}

class _EventUpComingPageState extends State<EventUpComingPage>
    with AutomaticKeepAliveClientMixin {
  bool isSearchEnabled = false;
  final TextEditingController searchEventController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    searchEventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: _buildEventList(),
      ),
    );
  }

  Widget _buildEventList() {
    Query<Event> eventsQuery;

    final getLocationBloc = BlocProvider.of<GetLocationBloc>(context);
    final currentPosition = getLocationBloc.locationResult?.position;

    if (currentPosition != null) {
      // Kiểm tra và đổi vị trí nếu latitude > 90
      double latitude = currentPosition.latitude;
      double longitude = currentPosition.longitude;
      if (latitude > 90) {
        final temp = latitude;
        latitude = longitude;
        longitude = temp;
      }

      const double earthRadiusKm = 6371.0;
      const double radiusInKm = 1000; // Bán kính 100km

// Tính toán bounding box với hệ số điều chỉnh
      double latKmRatio = 1 / 111.0; // 1 độ latitude ≈ 111km
      double lngKmRatio =
          1 / (111.0 * cos(latitude * pi / 180.0)); // Điều chỉnh theo latitude

// Tính delta cho latitude và longitude
      double latDelta = radiusInKm * latKmRatio * 1.2; // Thêm 20% margin
      double lngDelta = radiusInKm * lngKmRatio * 1.2;

// Tính bounds
      double minLat = latitude - latDelta;
      double maxLat = latitude + latDelta;
      double minLng = longitude - lngDelta;
      double maxLng = longitude + lngDelta;

// Debug logs
      print("Search center: $latitude, $longitude");
      print("Radius: ${radiusInKm}km");
      print(
          "Latitude range: $minLat to $maxLat (delta: ${maxLat - minLat} degrees)");
      print(
          "Longitude range: $minLng to $maxLng (delta: ${maxLng - minLng} degrees)");
      final now = Timestamp.now();
      eventsQuery = FirebaseFirestore.instance
          .collection('events')
          .where("date", isGreaterThan: now)
          .where("geopoint", isGreaterThanOrEqualTo: GeoPoint(minLat, minLng))
          .where("geopoint", isLessThanOrEqualTo: GeoPoint(maxLat, maxLng))
          .orderBy('date', descending: false)
          .withConverter<Event>(
            fromFirestore: (snapshot, _) => Event.fromJson(snapshot.data()!),
            toFirestore: (event, _) => event.toMap(),
          );
    } else {
      eventsQuery = FirebaseFirestore.instance
          .collection('events')
          .where("date", isGreaterThan: Timestamp.now())
          .orderBy('date', descending: false)
          .withConverter<Event>(
            fromFirestore: (snapshot, _) => Event.fromJson(snapshot.data()!),
            toFirestore: (event, _) => event.toMap(),
          );
    }

    return FirestoreListView<Event>(
      query: eventsQuery,
      loadingBuilder: (context) {
        return Center(
          child: Lottie.asset(
            "assets/animations/loading.json",
            height: 80,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) => const Center(
        child: Text(
          "Error",
          style: TextStyle(color: Colors.black),
        ),
      ),
      emptyBuilder: (context) {
        return const Center(
          child: Text(
            "No events exist...",
            style: TextStyle(color: Colors.black),
          ),
        );
      },
      itemBuilder: (context, snapshot) {
        final event = snapshot.data();

        double distance = 0.0;

        if (currentPosition != null) {
          distance = Geolocator.distanceBetween(
            currentPosition.latitude,
            currentPosition.longitude,
            event.geoPoint!.latitude,
            event.geoPoint!.longitude,
          );
        }
        return EventStandardCard(
          distance: currentPosition != null
              ? '${AppUtils.convertMetersToKilometers(distance)} km'
              : "",
          title: event.name,
          date: DateFormat('EEE, MMM d - yyyy • h:mm a').format(event.date),
          imageLink: event.poster ?? "",
          location: event.location,
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

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        "Upcoming events",
        style: AppStyles.titleAppBar,
      ),
      centerTitle: true,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
