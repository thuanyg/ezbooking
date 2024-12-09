import 'package:ezbooking/core/utils/utils.dart';
import 'package:ezbooking/data/models/event.dart';
import 'package:ezbooking/presentation/pages/event/event_detail.dart';
import 'package:ezbooking/presentation/pages/maps/bloc/get_location_bloc.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/upcoming/upcoming_event_bloc.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/upcoming/upcoming_event_state.dart';
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
          return SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (context, index) => const UpcomingCardShimmer(),
            ),
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
      height: 220,
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
                distance: currentPosition == null
                    ? ""
                    : "${AppUtils.convertMetersToKilometers(distance)} km",
              ),
            ),
          );
        },
      ),
    );
  }
}

class UpcomingCardShimmer extends StatelessWidget {
  const UpcomingCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: const Color(0xfff6fbff),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Column(
          children: [
            // Shimmer for the image
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 155,
                width: 230,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            // Shimmer for the title
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 20,
                width: 180,
                color: Colors.grey[300],
              ),
            ),
            const SizedBox(height: 6.0),
            // Shimmer for the location and distance
            Row(
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 14,
                    width: 14,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(width: 4.0),
                Expanded(
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 16,
                      width: double.infinity,
                      color: Colors.grey[300],
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 16,
                    width: 40,
                    color: Colors.grey[300],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
