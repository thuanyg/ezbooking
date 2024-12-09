import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ezbooking/core/config/app_colors.dart';
import 'package:ezbooking/core/utils/dialogs.dart';
import 'package:ezbooking/data/models/event.dart';
import 'package:ezbooking/data/models/ticket.dart';
import 'package:ezbooking/domain/entities/ticket_entity.dart';
import 'package:ezbooking/presentation/pages/ticket_booking/view_ticket_page.dart';
import 'package:ezbooking/presentation/screens/ticket/bloc/get_tickets_bloc.dart';
import 'package:ezbooking/presentation/screens/ticket/bloc/get_tickets_event.dart';
import 'package:ezbooking/presentation/screens/ticket/bloc/get_tickets_state.dart';
import 'package:ezbooking/presentation/screens/ticket/eticket_widget.dart';
import 'package:ezbooking/presentation/screens/ticket/ticket_screen_shimmer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({super.key});

  static const String routeName = "TicketScreen";

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  late GetTicketsBloc getTicketsBloc;

  @override
  void initState() {
    super.initState();
    getTicketsBloc = BlocProvider.of<GetTicketsBloc>(context);
    final user = FirebaseAuth.instance.currentUser;
    getTicketsBloc.add(GetTicketEntitiesOfUser(user!.uid));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: _buildAppBar(),
        body: BlocBuilder(
          bloc: getTicketsBloc,
          builder: (context, state) {
            if (state is GetTicketsLoading) {
              return const TicketScreenShimmer();
            }
            if (state is GetTicketEntitiesSuccess) {
              return _buildBody(state.ticketEntities);
            }
            return const SizedBox.shrink();
          },
        ),
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
        labelColor: AppColors.primaryColor,
        unselectedLabelColor: Colors.grey[600],
        indicatorColor: AppColors.primaryColor,
        indicatorWeight: 3,
        tabs: const [
          Tab(text: 'Upcoming'),
          Tab(text: 'Checked'),
          Tab(text: 'Expired'),
          Tab(text: 'Cancelled'),
        ],
      ),
    );
  }

  Widget _buildBody(List<TicketEntity> tickets) {
    final ticketsUpcoming =
        tickets.where((t) => t.ticket.status == "Available").toList();

    final ticketsChecked =
        tickets.where((t) => t.ticket.status == "Used").toList();

    final ticketsExpired =
        tickets.where((t) => t.ticket.status == "Expired").toList();

    final ticketsCancelled =
        tickets.where((t) => t.ticket.status == "Cancelled").toList();

    return TabBarView(
      children: [
        TicketTabViewWidget(type: 'upcoming', filteredTickets: ticketsUpcoming),
        TicketTabViewWidget(type: 'checked', filteredTickets: ticketsChecked),
        TicketTabViewWidget(type: 'expired', filteredTickets: ticketsExpired),
        TicketTabViewWidget(
            type: 'cancelled', filteredTickets: ticketsCancelled),
      ],
    );
  }
}

class TicketTabViewWidget extends StatefulWidget {
  final List<TicketEntity> filteredTickets;
  final String type;

  const TicketTabViewWidget({
    super.key,
    required this.filteredTickets,
    required this.type,
  });

  @override
  State<TicketTabViewWidget> createState() => _TicketTabViewWidgetState();
}

class _TicketTabViewWidgetState extends State<TicketTabViewWidget>
    with AutomaticKeepAliveClientMixin {
  //Create an instance of ScreenshotController
  List<ScreenshotController> screenshotControllers = [];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _buildTicketList(widget.type, widget.filteredTickets);
  }

  Widget _buildTicketList(String status, List<TicketEntity> filteredTickets) {
    if (filteredTickets.isEmpty) {
      return _buildEmptyState(status);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      itemCount: filteredTickets.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final screenshotController = ScreenshotController();
        screenshotControllers.add(screenshotController);
        return _buildTicketCard(
          filteredTickets[index],
          screenshotController,
        );
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
      case 'checked':
        icon = Icons.event_note;
        message =
            'No checking completed events yet\nYour history will appear here';
        break;
      case 'expired':
        icon = Icons.event_note;
        message =
            'No checking expired events yet\nYour tickets will appear here';
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
            padding: const EdgeInsets.all(20),
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

  Widget _buildTicketCard(
    TicketEntity ticketEntity,
    ScreenshotController screenshotController,
  ) {
    final event = ticketEntity.event;
    final ticket = ticketEntity.ticket;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewTicketPage(
              ticket: ticketEntity.ticket,
            ),
          ),
        );
      },
      child: Screenshot(
        controller: screenshotController,
        child: Container(
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
                    image: CachedNetworkImageProvider(event.thumbnail ?? ""),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.55),
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
                            event.name,
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
                                  event.location,
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
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 20,
                child: CustomPaint(
                  painter: DottedLinePainter(),
                  size: Size.infinite,
                ),
              ),
              // Ticket Details
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildTicketDetail(
                      'Check-in time',
                      DateFormat('MMM dd, yyyy - hh:mm a').format(
                        event.date,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (ticket.usedAt != null && ticket.status == "Used")
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildTicketDetail(
                          'Used At',
                          DateFormat('MMM dd, yyyy - hh:mm a')
                              .format(ticket.usedAt!),
                        ),
                      ),
                    _buildTicketDetail('Ticket Type', ticket.ticketType),
                    const SizedBox(height: 16),
                    _buildTicketDetail('Ticket ID', ticket.id),
                    const SizedBox(height: 20),
                    // QR Code
                    if (ticket.usedAt == null && ticket.status == "Available")
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            _buildQRCode(ticket),
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
                    // Action Buttons
                    if (ticket.usedAt == null && ticket.status == "Available")
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                await captureAndShareTicket(
                                    ticket, event, screenshotController);
                              },
                              icon: Icon(
                                Icons.share_outlined,
                                color: AppColors.primaryColor,
                              ),
                              label: Text(
                                'Share',
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                side: BorderSide(color: Colors.grey[300]!),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                await handleCaptureAndDownloadTicket(
                                  ticket,
                                  event,
                                  screenshotController,
                                );
                              },
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
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
        ),
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

  Widget _buildQRCode(Ticket ticket) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: QrImageView(
        data: ticket.qrCodeData,
        version: QrVersions.auto,
        size: 100,
        gapless: false,
        errorStateBuilder: (cxt, err) {
          return const Center(
            child: Text('Error generating QR code'),
          );
        },
      ),
    );
  }

  Future<void> handleCaptureAndDownloadTicket(
    Ticket ticket,
    Event event,
    ScreenshotController screenshotController,
  ) async {
    DialogUtils.showLoadingDialog(context);
    screenshotController
        .captureFromWidget(
      delay: const Duration(seconds: 1),
      ETicket(ticket: ticket, event: event),
    )
        .then((capturedImage) async {
      await saveImageToGallery(capturedImage);
      DialogUtils.hide(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.primaryColor,
          content: const Text(
            "Ticket was saved successfully in Gallery.",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    });
  }

  Future<void> captureAndShareTicket(
    Ticket ticket,
    Event event,
    ScreenshotController screenshotController,
  ) async {
    DialogUtils.showLoadingDialog(context);
    screenshotController
        .captureFromWidget(
      delay: const Duration(milliseconds: 500),
      ETicket(ticket: ticket, event: event),
    )
        .then((capturedImage) async {
      // Share the image
      await shareTicket(capturedImage);
      DialogUtils.hide(context);
    });
  }

  Future<void> shareTicket(Uint8List imageBytes) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/ticket.png';

      // Save the image to a temporary file
      final file = await File(filePath).create();
      await file.writeAsBytes(imageBytes);

      // Share the file
      await Share.shareXFiles(
        [XFile(filePath)],
        text: 'Check out this ticket!',
      );
    } catch (e) {
      print('Error sharing file: $e');
    }
  }

  Future<void> saveImageToGallery(Uint8List imageBytes) async {
    try {
      // Save the image
      final path =
          '/storage/emulated/0/Pictures/ezbooking_ticket_image_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(path);
      await file.writeAsBytes(imageBytes);

      // Invoke the native method
      const platform = MethodChannel('media_scanner');
      await platform.invokeMethod('scanFile', {"path": path});

      print('Image saved to gallery: $path');
    } catch (e) {
      print('Error saving image to gallery: $e');
    }
  }

  @override
  bool get wantKeepAlive => true;
}

// Custom Painter for dotted line
class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 2
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
