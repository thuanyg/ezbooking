import 'package:ezbooking/core/config/app_colors.dart';
import 'package:ezbooking/data/models/category.dart';
import 'package:ezbooking/data/models/event.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventsByCategoryPage extends StatefulWidget {
  final Category category;

  const EventsByCategoryPage({super.key, required this.category});

  @override
  _EventsByCategoryPageState createState() => _EventsByCategoryPageState();
}

class _EventsByCategoryPageState extends State<EventsByCategoryPage> {
  List<Event> events = [];
  bool _isLoading = true;
  String _sortBy = 'Date';

  @override
  void initState() {
    super.initState();
    _fetchEventsByCategory();
  }

  Future<void> _fetchEventsByCategory() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('events')
          .where('category', isEqualTo: widget.category.id)
          .where('isDelete', isEqualTo: false)
          .get();

      setState(() {
        events = querySnapshot.docs
            .map((doc) => Event.fromJson(
                {...doc.data() as Map<String, dynamic>, 'id': doc.id}))
            .toList();
        _sortEvents();
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching events: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _sortEvents() {
    switch (_sortBy) {
      case 'Date':
        events.sort((a, b) => a.date.compareTo(b.date));
        break;
      case 'Price':
        events.sort((a, b) => a.ticketPrice.compareTo(b.ticketPrice));
        break;
      case 'Name':
        events.sort((a, b) => a.name.compareTo(b.name));
        break;
    }
  }

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Sort Events',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryColor,
                ),
              ),
            ),
            ListTile(
              title: Text('Sort by Date'),
              trailing: _sortBy == 'Date'
                  ? Icon(Icons.check, color: AppColors.primaryColor)
                  : null,
              onTap: () {
                setState(() {
                  _sortBy = 'Date';
                  _sortEvents();
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Sort by Price'),
              trailing: _sortBy == 'Price'
                  ? Icon(Icons.check, color: AppColors.primaryColor)
                  : null,
              onTap: () {
                setState(() {
                  _sortBy = 'Price';
                  _sortEvents();
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Sort by Name'),
              trailing: _sortBy == 'Name'
                  ? Icon(Icons.check, color: AppColors.primaryColor)
                  : null,
              onTap: () {
                setState(() {
                  _sortBy = 'Name';
                  _sortEvents();
                });
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 16),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.category.categoryName} Events',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.sort, color: Colors.white),
            onPressed: _showSortBottomSheet,
          ),
        ],
      ),
      body: _isLoading ? _buildLoadingIndicator() : _buildEventsList(),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
      ),
    );
  }

  Widget _buildEventsList() {
    return events.isEmpty
        ? _buildNoEventsWidget()
        : ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            itemCount: events.length,
            itemBuilder: (context, index) {
              return _buildEventCard(events[index]);
            },
          );
  }

  Widget _buildNoEventsWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 100,
            color: AppColors.secondaryColor.withOpacity(0.5),
          ),
          SizedBox(height: 16),
          Text(
            'No events in this category',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.secondaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Check back later for new events',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(Event event) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to event details page
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(
                event.thumbnail ?? event.poster ?? '',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  color: AppColors.backgroundColor,
                  child: Center(
                    child: Icon(
                      Icons.image_not_supported,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 16, color: AppColors.primaryColor),
                      SizedBox(width: 8),
                      Text(
                        _formatDate(event.date),
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              size: 16, color: AppColors.primaryColor),
                          SizedBox(width: 8),
                          Text(
                            event.location,
                            style: TextStyle(color: Colors.grey[700]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Text(
                        '\$${event.ticketPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondaryColor,
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

  String _formatDate(DateTime date) {
    return '${date.day} ${_getMonthName(date.month)} ${date.year}';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }
}
