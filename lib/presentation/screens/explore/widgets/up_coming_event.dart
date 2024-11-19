import 'package:ezbooking/core/utils/utils.dart';
import 'package:ezbooking/data/models/event.dart';
import 'package:ezbooking/presentation/pages/event/event_detail.dart';
import 'package:ezbooking/presentation/pages/maps/bloc/get_location_bloc.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/upcoming_event_bloc.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/upcoming_event_state.dart';
import 'package:ezbooking/presentation/widgets/cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class UpComingEvent extends StatefulWidget {
  const UpComingEvent({super.key});

  @override
  State<UpComingEvent> createState() => _UpComingEventState();
}

class _UpComingEventState extends State<UpComingEvent> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpcomingEventBloc, UpcomingEventState>(
      builder: (context, state) {
        if (state is UpcomingEventLoading) {
          return Shimmer.fromColors(
            baseColor: Colors.white54,
            highlightColor: Colors.white,
            child: buildUpcomingEventShimmer(),
          );
        }

        if (state is UpcomingEventLoaded) {
          return buildUpcomingEvent(state.events);
        }
        if (state is UpcomingEventError) {
          return Center(child: Text(state.message));
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget buildUpcomingEvent(List<Event> events) {
    return SizedBox(
      height: 260,
      child: ListView.builder(
        itemCount: events.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final getLocationBloc = BlocProvider.of<GetLocationBloc>(context);
          final currentPosition = getLocationBloc.locationResult?.position;

          double distance = 0.0;

          if (currentPosition != null) {
            distance = Geolocator.distanceBetween(
              currentPosition.latitude,
              currentPosition.longitude,
              events[index].geoPoint!.latitude,
              events[index].geoPoint!.longitude,
            );
          }

          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(
                  EventDetail.routeName,
                  arguments: events[index].id,
                );
              },
              child: UpcomingCard(
                id: events[index].id!,
                title: events[index].name,
                date: DateFormat('d \nMMM').format(events[index].date),
                imageLink: events[index].thumbnail ?? "",
                location: events[index].location,
                distance: currentPosition == null ? "" : "${AppUtils.convertMetersToKilometers(distance)} km",
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildUpcomingEventShimmer() {
    return SizedBox(
      height: 260,
      child: ListView.builder(
        itemCount: 5,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: UpcomingCard(
              id: "",
              title: "",
              date: "",
              imageLink: "",
              location: "",
              distance: "",
            ),
          );
        },
      ),
    );
  }
}
