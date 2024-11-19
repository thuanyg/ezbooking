import 'package:ezbooking/presentation/pages/event/bloc/event_detail_bloc.dart';
import 'package:ezbooking/presentation/pages/event/bloc/event_detail_event.dart';
import 'package:ezbooking/presentation/pages/event/bloc/event_detail_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ezbooking/data/models/ticket.dart';
import 'package:ezbooking/data/models/event.dart';
import 'package:ezbooking/core/utils/utils.dart';

class ViewTicketPage extends StatefulWidget {
  static const String routeName = "ViewTicketPage";

  final Ticket ticket;

  ViewTicketPage({
    super.key,
    required this.ticket,
  });

  @override
  State<ViewTicketPage> createState() => _ViewTicketPageState();
}

class _ViewTicketPageState extends State<ViewTicketPage> {
  final PageController pageController = PageController();
  late EventDetailBloc eventDetailBloc;

  @override
  void initState() {
    super.initState();
    eventDetailBloc = BlocProvider.of<EventDetailBloc>(context);
    eventDetailBloc.add(FetchEventDetail(widget.ticket.eventID));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title:
            const Text('Ticket Details', style: TextStyle(color: Colors.black)),
      ),
      body: BlocBuilder<EventDetailBloc, EventDetailState>(
        builder: (context, state) {
          if (state is EventDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is EventDetailError) {
            return Center(
              child: Text('Error: ${state.message}'),
            );
          }

          if (state is EventDetailLoaded) {
            return _buildTicketContent(context, state.event);
          }

          return const Center(child: Text('No ticket information available'));
        },
      ),
    );
  }

  Widget _buildTicketContent(BuildContext context, Event event) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildTicketHeader(),
            const SizedBox(height: 24),
            _buildQRCode(),
            const SizedBox(height: 24),
            _buildTicketDetails(),
            const SizedBox(height: 16),
            _buildEventDetails(event),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Ticket #${widget.ticket.id}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            widget.ticket.status ?? 'Available',
            style: TextStyle(
              color: _getStatusColor(),
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (widget.ticket.status) {
      case 'Available':
        return Colors.green;
      case 'Used':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildQRCode() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: QrImageView(
        data:
            AppUtils.decryptData(widget.ticket.qrCodeData, AppUtils.secretKey),
        version: QrVersions.auto,
        size: 250,
        gapless: false,
        errorStateBuilder: (cxt, err) {
          return const Center(
            child: Text('Error generating QR code'),
          );
        },
      ),
    );
  }

  Widget _buildTicketDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildDetailRow('Ticket Type', widget.ticket.ticketType),
          const Divider(),
          _buildDetailRow(
              'Price', '\$${widget.ticket.ticketPrice.toStringAsFixed(2)}'),
          const Divider(),
          _buildDetailRow(
              'Purchase Date', AppUtils.formatDate(widget.ticket.createdAt)),
        ],
      ),
    );
  }

  Widget _buildEventDetails(Event event) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Event Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildDetailRow('Event Name', event.name),
          const Divider(),
          _buildDetailRow('Date', AppUtils.formatDate(event.date)),
          const Divider(),
          _buildDetailRow('Location', event.location ?? 'Not Specified'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
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
}
