import 'package:ezbooking/core/config/app_colors.dart';
import 'package:ezbooking/data/models/ticket.dart';
import 'package:ezbooking/presentation/pages/ticket_booking/view_ticket_page.dart';
import 'package:flutter/material.dart';
import 'package:ezbooking/data/models/order.dart';
import 'package:ezbooking/data/models/event.dart';

class PaymentSuccessPage extends StatelessWidget {
  static const String routeName = "PaymentSuccessPage";

  final Order order;
  final Event event;
  final List<Ticket> tickets;

  const PaymentSuccessPage({
    super.key,
    required this.order,
    required this.event,
    required this.tickets,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () =>
              Navigator.of(context).popUntil((route) => route.isFirst),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline,
                color: Colors.green, size: 100),
            const SizedBox(height: 24),
            const Text(
              'Payment Successful',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            const SizedBox(height: 16),
            Text(
              'Order #${order.id}',
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 32),
            _buildOrderSummary(),
            const Spacer(),
            _buildActionButtons(context)
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _buildSummaryRow('Event', event.name ?? 'Unknown Event'),
          const Divider(),
          _buildSummaryRow('Tickets', '${tickets.length} x Standard'),
          const Divider(),
          _buildSummaryRow('Total Price',
              '\$${(order.ticketPrice * tickets.length).toStringAsFixed(2)}'),
          const Divider(),
          _buildSummaryRow('Payment Method', order.orderType ?? 'Online'),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black87))
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            _showTicketSelectionDialog(context);
          },
          child: const Text(
            'View Tickets',
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.blue[700]!),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () => Navigator.of(context).popUntil(
            (route) => route.isFirst,
          ),
          child: const Text('Back to Home'),
        )
      ],
    );
  }

  void _showTicketSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Ticket'),
          content: SingleChildScrollView(
            child: ListBody(
              children: tickets.map((ticket) {
                return ListTile(
                  title: Text('Ticket #${ticket.id}'),
                  subtitle: Text('Type: ${ticket.ticketType ?? 'Standard'}'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewTicketPage(
                          ticket: ticket,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
