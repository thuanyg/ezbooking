import 'package:ezbooking/presentation/pages/event/event_detail.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/popular/popular_event_bloc.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/popular/popular_event_state.dart';
import 'package:ezbooking/presentation/screens/explore/explore_screen.dart';
import 'package:ezbooking/presentation/widgets/cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class PopularEvent extends StatefulWidget {
  const PopularEvent({super.key});

  @override
  State<PopularEvent> createState() => _PopularEventState();
}

class _PopularEventState extends State<PopularEvent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildShowByCategory(label: 'Popular Now', onSeeAll: () {}),
        SizedBox(
          height: 200,
          child: BlocBuilder<PopularEventBloc, PopularEventState>(
            builder: (context, state) {
              if (state is PopularEventLoading) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade50,
                  child: buildShimmer(),
                );
              }
              if (state is PopularEventLoaded) {
                if (state.events.isEmpty) {
                  return const Center(
                    child: Text("No popular events found!."),
                  );
                }
                return GridView.builder(
                  scrollDirection: Axis.horizontal,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.25,
                  ),
                  itemCount: state.events.length,
                  itemBuilder: (context, index) {
                    return PopularCard(
                      title: state.events[index].name,
                      date: DateFormat('EEE, MMM d - yyyy • h:mm a')
                          .format(state.events[index].date),
                      imageLink: state.events[index].poster ?? "",
                      location: state.events[index].location,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          EventDetail.routeName,
                          arguments: state.events[index].id,
                        );
                      },
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  Widget buildShimmer() {
    return SizedBox(
      height: 200,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.25,
        ),
        itemCount: 4,
        itemBuilder: (context, index) {
          return PopularCard(
            title: "Event",
            date: "dd/MM/yyyy",
            imageLink: "",
            location: "...",
            onTap: () {},
          );
        },
      ),
    );
  }
}
