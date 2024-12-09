import 'package:ezbooking/core/utils/utils.dart';
import 'package:ezbooking/data/models/event.dart';
import 'package:ezbooking/data/models/ticket.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';

class ETicket extends StatelessWidget {
  final Ticket ticket;
  final Event event;

  const ETicket({
    Key? key,
    required this.ticket,
    required this.event,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Event Details Section
            _buildEventDetails(),

            const SizedBox(height: 16),

            // Dotted Line
            _buildDottedLine(),

            const SizedBox(height: 16),

            // QR Code
            _buildQRCode(),
          ],
        ),
      ),
    );
  }

  Widget _buildEventDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                event.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'E-ticket',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildInfoRow('ID', ticket.id),
        _buildInfoRow('Date', DateFormat('dd/MM/yyyy').format(event.date)),
        _buildInfoRow('Time', DateFormat('hh:mm a').format(event.date)),
        _buildInfoRow('Location', event.location),
        _buildInfoRow('Type', ticket.ticketType),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              value,
              maxLines: 2,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDottedLine() {
    return Row(
      children: List.generate(
        30,
        (index) => Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            height: 1,
            color: Colors.grey.shade500,
          ),
        ),
      ),
    );
  }

  Widget _buildQRCode() {
    return QrImageView(
      data: ticket.qrCodeData,
      version: QrVersions.auto,
      size: 200,
    );
  }
}
