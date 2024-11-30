import 'package:ezbooking/data/models/event.dart';
import 'package:ezbooking/main.dart';
import 'package:ezbooking/presentation/pages/event/bloc/fetch_favorite_bloc.dart';
import 'package:ezbooking/presentation/pages/event/bloc/fetch_favorite_event.dart';
import 'package:ezbooking/presentation/pages/event/bloc/fetch_favorite_state.dart';
import 'package:ezbooking/presentation/pages/event/event_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class FavoritesEventsPage extends StatelessWidget {
  FavoritesEventsPage({super.key});

  static String routeName = "FavoritesEventsPage";
  final List<Map<String, dynamic>> favoriteEvents = [
    {
      'title': 'Summer Music Festival',
      'date': DateTime(2024, 7, 15),
      'location': 'Central Park, New York',
      'imageUrl': 'https://example.com/music-festival.jpg',
      'price': 89.99,
      'category': 'Music',
      'description':
          'Experience the best summer music festival with top artists.',
      'attendees': 2500,
    },
    {
      'title': 'Tech Conference 2024',
      'date': DateTime(2024, 8, 20),
      'location': 'Convention Center, San Francisco',
      'imageUrl': 'https://example.com/tech-conf.jpg',
      'price': 299.99,
      'category': 'Technology',
      'description': 'Join the biggest tech conference of the year.',
      'attendees': 1800,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final FetchFavoriteBloc favoriteBloc =
        BlocProvider.of<FetchFavoriteBloc>(context);
    User? user = FirebaseAuth.instance.currentUser;
    favoriteBloc.add(FetchFavorite(user!.uid));
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: favoriteEvents.isEmpty
          ? _buildEmptyState()
          : BlocBuilder<FetchFavoriteBloc, FetchFavoriteState>(
              builder: (context, state) {
                if (state is FetchFavoriteLoading) {
                  return Center(
                    child: Lottie.asset(
                      "assets/animations/loading.json",
                      height: 80,
                    ),
                  );
                }
                if (state is FetchFavoriteSuccess) {
                  return _buildEventsList(state.events);
                }
                return const SizedBox.shrink();
              },
            ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Favorites',
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 24,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1.0),
        child: Container(
          color: Colors.grey[200],
          height: 1.0,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.black87, size: 28),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.filter_list, color: Colors.black87, size: 28),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.favorite_border,
              size: 80,
              color: Colors.pink[300],
            ),
          ),
          SizedBox(height: 24),
          Text(
            'No Favorites Yet',
            style: TextStyle(
              fontSize: 24,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Start exploring amazing events\nand save your favorites!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
          SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.explore),
            label: Text('Explore Events'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsList(List<Event> events) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Hero(
          tag: 'event-${event.name}',
          child: _buildEventCard(context, event),
        );
      },
    );
  }

  Widget _buildEventCard(BuildContext context, Event event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.pushNamed(
          context,
          EventDetail.routeName,
          arguments: event.id,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Container
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                image: DecorationImage(
                  image: NetworkImage(event.thumbnail.toString()),
                  fit: BoxFit.cover,
                  onError: (_, __) {},
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 16,
                    left: 16,
                    child: _buildCategoryChip(event.eventType),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: _buildAttendeesBadge(100),
                  ),
                ],
              ),
            ),
            // Content Container
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          event.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.favorite, size: 28),
                        color: Colors.red[400],
                        onPressed: () {},
                      ),
                    ],
                  ),
                  Text(
                    event.description,
                    maxLines: 2,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                      height: 1.5,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildInfoRow(event),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Price',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '\$${event.ticketPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Book Now',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        category,
        style: TextStyle(
          color: Colors.blue[700],
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildAttendeesBadge(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.people, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          Text(
            '$count',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(Event event) {
    return Row(
      children: [
        _buildInfoItem(
          Icons.calendar_today,
          DateFormat('MMM dd, yyyy').format(event.date),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _buildInfoItem(
            Icons.location_on,
            event.location,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 18,
          color: Colors.grey[600],
        ),
        SizedBox(width: 8),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
