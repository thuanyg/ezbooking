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
import 'package:shimmer/shimmer.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen>
    with AutomaticKeepAliveClientMixin {
  bool isSearchEnabled = false;
  final TextEditingController searchEventController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String searchQuery = ""; // Track the search query

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
      const double radiusInKm = 100; // Bán kính 100km

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

      eventsQuery = FirebaseFirestore.instance
          .collection('events')
          .where("geopoint", isGreaterThanOrEqualTo: GeoPoint(minLat, minLng))
          .where("geopoint", isLessThanOrEqualTo: GeoPoint(maxLat, maxLng))
          .where('name', isGreaterThanOrEqualTo: searchQuery)
          .where('name', isLessThan: '$searchQuery\uf8ff') // Filter by prefix
          .withConverter<Event>(
            fromFirestore: (snapshot, _) => Event.fromJson(snapshot.data()!),
            toFirestore: (event, _) => event.toMap(),
          );
    } else {
      eventsQuery = FirebaseFirestore.instance
          .collection('events')
          .where('name', isGreaterThanOrEqualTo: searchQuery)
          .where('name', isLessThan: '$searchQuery\uf8ff') // Filter by prefix
          .withConverter<Event>(
            fromFirestore: (snapshot, _) => Event.fromJson(snapshot.data()!),
            toFirestore: (event, _) => event.toMap(),
          );
    }

    return FirestoreListView<Event>(
      query: eventsQuery,
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

        if (currentPosition != null) {
          distance = Geolocator.distanceBetween(
            currentPosition.latitude,
            currentPosition.longitude,
            event.geoPoint!.latitude,
            event.geoPoint!.longitude,
          );
        }

        return EventStandardCard(
          title: event.name,
          date: DateFormat('EEE, MMM d - yyyy • h:mm a').format(event.date),
          imageLink: event.poster ?? "",
          location: event.location,
          distance: currentPosition != null ? '${AppUtils.convertMetersToKilometers(distance)} km' : "",
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

  AppBar _buildAppBar(BuildContext context) {
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
        _buildSearchField(),
        if (isSearchEnabled)
          IconButton(
            onPressed: () {
              setState(() {
                isSearchEnabled = false;
                searchEventController.clear();
                searchQuery = ""; // Clear search query when disabled
              });
            },
            icon: const Icon(Icons.cancel),
          ),
        if (!isSearchEnabled)
          IconButton(
            onPressed: () {
              setState(() {
                isSearchEnabled = true;
              });
            },
            icon: const Icon(Icons.search),
          ),
      ],
    );
  }

  Widget _buildSearchField() {
    return isSearchEnabled
        ? SizedBox(
            width: MediaQuery.of(context).size.width * 0.55,
            height: 44,
            child: TextField(
              autofocus: true,
              controller: searchEventController,
              style: const TextStyle(fontSize: 16.0, color: Colors.black),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: "Search event...",
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.trim(); // Update search query
                });
              },
            ),
          )
        : const SizedBox.shrink();
  }

  @override
  bool get wantKeepAlive => true;
}
