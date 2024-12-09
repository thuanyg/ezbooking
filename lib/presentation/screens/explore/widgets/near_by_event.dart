import 'package:ezbooking/core/utils/utils.dart';
import 'package:ezbooking/data/models/event.dart';
import 'package:ezbooking/presentation/pages/event/event_detail.dart';
import 'package:ezbooking/presentation/pages/event/event_nearby.dart';
import 'package:ezbooking/presentation/pages/maps/bloc/get_location_bloc.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/latest/latest_event_bloc.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/latest/latest_event_state.dart';
import 'package:ezbooking/presentation/screens/explore/explore_screen.dart';
import 'package:ezbooking/presentation/screens/explore/widgets/up_coming_event.dart';
import 'package:ezbooking/presentation/widgets/cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class NearByEvent extends StatefulWidget {
  const NearByEvent({super.key});

  @override
  State<NearByEvent> createState() => _NearByEventState();
}

class _NearByEventState extends State<NearByEvent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildShowByCategory(label: 'Events Nearby', onSeeAll: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EventNearbyPage(),
              ));
        }),
        BlocBuilder<LatestEventBloc, LatestEventState>(
          builder: (context, state) {
            if (state is LatestEventLoading) {
              return SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (context, index) => const UpcomingCardShimmer(),
                ),
              );
            }

            if (state is LatestEventLoaded) {
              final getLocationBloc = BlocProvider.of<GetLocationBloc>(context);
              final currentPosition = getLocationBloc.locationResult?.position;

              if (currentPosition == null) {
                return const Center(
                  child: Text('Không thể xác định vị trí hiện tại.'),
                );
              }

              final eventFilterByRadius = state.events.where((e) {
                if (e.geoPoint == null) return false; // Kiểm tra null cho geoPoint
                final distance = Geolocator.distanceBetween(
                  currentPosition.latitude,
                  currentPosition.longitude,
                  e.geoPoint!.latitude,
                  e.geoPoint!.longitude,
                );
                return distance < 30000; // Khoảng cách dưới 20 mét
              }).toList();

              if (eventFilterByRadius.isEmpty) {
                return const Center(
                  child: Text('Không có sự kiện nào gần đây.'),
                );
              }

              return buildNearByEvent(eventFilterByRadius);
            }
            if (state is LatestEventError) {
              return Center(child: Text(state.message));
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget buildNearByEvent(List<Event> events) {
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
