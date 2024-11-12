import 'package:ezbooking/core/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TicketScreen extends StatelessWidget {
  TicketScreen({super.key});

  static String routeName = "TicketScreen";

  final List<Map<String, dynamic>> tickets = [
    {
      'eventTitle': 'Summer Music Festival',
      'date': DateTime(2024, 7, 15, 19, 30),
      'location': 'Central Park, New York',
      'ticketType': 'VIP Pass',
      'ticketId': 'TIX-2024-001',
      'price': 89.99,
      'status': 'upcoming', // upcoming, completed, cancelled
      'qrCode': 'https://example.com/qr-code.png',
      'seats': ['A1', 'A2'],
      'eventImage': 'https://example.com/music-festival.jpg',
    },
    {
      'eventTitle': 'Tech Conference 2024',
      'date': DateTime(2024, 8, 20, 9, 0),
      'location': 'Convention Center, San Francisco',
      'ticketType': 'Regular Pass',
      'ticketId': 'TIX-2024-002',
      'price': 299.99,
      'status': 'upcoming',
      'qrCode': 'https://example.com/qr-code.png',
      'seats': ['B5'],
      'eventImage': 'https://example.com/tech-conf.jpg',
    },
    {
      'eventTitle': 'Comedy Night Special',
      'date': DateTime(2024, 6, 10, 20, 0),
      'location': 'Laugh Factory, Los Angeles',
      'ticketType': 'Standard Entry',
      'ticketId': 'TIX-2024-003',
      'price': 45.00,
      'status': 'completed',
      'qrCode': 'https://example.com/qr-code.png',
      'seats': ['C12'],
      'eventImage': 'https://example.com/comedy-night.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      centerTitle: true,
      title: const Text(
        'My Tickets',
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 24,
        ),
      ),
      bottom: TabBar(
        labelColor: Colors.blue[700],
        unselectedLabelColor: Colors.grey[600],
        indicatorColor: Colors.blue[700],
        indicatorWeight: 3,
        tabs: const [
          Tab(text: 'Upcoming'),
          Tab(text: 'Completed'),
          Tab(text: 'Cancelled'),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return TabBarView(
      children: [
        _buildTicketList('upcoming'),
        _buildTicketList('completed'),
        _buildTicketList('cancelled'),
      ],
    );
  }

  Widget _buildTicketList(String status) {
    final filteredTickets =
        tickets.where((ticket) => ticket['status'] == status).toList();

    if (filteredTickets.isEmpty) {
      return _buildEmptyState(status);
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      itemCount: filteredTickets.length,
      itemBuilder: (context, index) {
        return _buildTicketCard(filteredTickets[index]);
      },
    );
  }

  Widget _buildEmptyState(String status) {
    IconData icon;
    String message;

    switch (status) {
      case 'upcoming':
        icon = Icons.event_available;
        message = 'No upcoming tickets\nCheck out some events!';
        break;
      case 'completed':
        icon = Icons.event_note;
        message = 'No completed events yet\nYour history will appear here';
        break;
      default:
        icon = Icons.event_busy;
        message = 'No cancelled tickets\nHope it stays this way!';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 64, color: Colors.grey[400]),
          ),
          const SizedBox(height: 24),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketCard(Map<String, dynamic> ticket) {
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
      child: Column(
        children: [
          // Event Image and Basic Info
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              image: DecorationImage(
                image: NetworkImage(ticket['eventImage']),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3),
                  BlendMode.darken,
                ),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 20,
                  bottom: 20,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ticket['eventTitle'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              color: Colors.white70, size: 16),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              ticket['location'],
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
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
          // Dotted Line
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            height: 1,
            child: CustomPaint(
              painter: DottedLinePainter(),
              size: Size.infinite,
            ),
          ),
          // Ticket Details
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                _buildTicketDetail(
                    'Date & Time',
                    DateFormat('MMM dd, yyyy - hh:mm a')
                        .format(ticket['date'])),
                SizedBox(height: 16),
                _buildTicketDetail('Ticket Type',
                    '${ticket['ticketType']} (${ticket['seats'].join(', ')})'),
                SizedBox(height: 16),
                _buildTicketDetail('Ticket ID', ticket['ticketId']),
                SizedBox(height: 20),
                // QR Code
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        color: Colors.white,
                        child: Icon(Icons.qr_code_2_rounded,
                            size: 80, color: Colors.grey[400]),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Show this QR code at the venue',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Scan for quick entry',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.share_outlined),
                        label: Text('Share'),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: Colors.grey[300]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.download_outlined,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Download',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketDetail(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

// Custom Painter for dotted line
class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    const dashWidth = 5;
    const dashSpace = 5;
    double startX = 0;
    final y = size.height / 2;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, y),
        Offset(startX + dashWidth, y),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
