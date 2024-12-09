import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezbooking/core/config/app_styles.dart';
import 'package:ezbooking/core/utils/utils.dart';
import 'package:ezbooking/data/models/event.dart';
import 'package:ezbooking/presentation/pages/event/event_detail.dart';
import 'package:ezbooking/presentation/pages/event/widgets/shimmer_event_card.dart';
import 'package:ezbooking/presentation/pages/maps/bloc/get_location_bloc.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/latest/latest_event_bloc.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/latest/latest_event_event.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/latest/latest_event_state.dart';
import 'package:ezbooking/presentation/widgets/cards.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class EventNearbyPage extends StatefulWidget {
  const EventNearbyPage({super.key});

  static String routeName = "EventNearbyPage";

  @override
  State<EventNearbyPage> createState() => _EventNearbyPageState();
}

class _EventNearbyPageState extends State<EventNearbyPage>
    with AutomaticKeepAliveClientMixin {
  bool isSearchEnabled = false;
  final TextEditingController searchEventController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final LatestEventBloc nearEventBloc;
  late final GetLocationBloc locationBloc;

  @override
  void initState() {
    locationBloc = BlocProvider.of<GetLocationBloc>(context);
    nearEventBloc = BlocProvider.of<LatestEventBloc>(context);
    if (locationBloc.locationResult != null) {
      nearEventBloc.add(FetchLatestEvent(
        limit: 100,
        isFetchApproximately: true,
        position: locationBloc.locationResult!.position,
      ));
    }
    super.initState();
  }

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
    return BlocBuilder(
      bloc: nearEventBloc,
      builder: (context, state) {
        if (state is LatestEventLoading) {
          return ListView.builder(
            itemCount: 6,
            itemBuilder: (context, index) => const EventStandardCardShimmer(),
          );
        }

        if (state is LatestEventLoaded) {
          final currentPosition = locationBloc.locationResult?.position;
          return ListView.builder(
            itemCount: state.events.length,
            itemBuilder: (context, index) {
              final event = state.events[index];
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
                date:
                    DateFormat('EEE, MMM d - yyyy • h:mm a').format(event.date),
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

        return const SizedBox.shrink();
      },
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        "Events Nearby",
        style: AppStyles.titleAppBar,
      ),
      centerTitle: true,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
