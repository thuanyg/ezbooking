import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezbooking/core/config/app_colors.dart';
import 'package:ezbooking/core/services/notification_service.dart';
import 'package:ezbooking/core/utils/dialogs.dart';
import 'package:ezbooking/presentation/pages/event/bloc/event_detail_bloc.dart';
import 'package:ezbooking/presentation/pages/event/bloc/event_detail_event.dart';
import 'package:ezbooking/presentation/pages/event/bloc/event_detail_state.dart';
import 'package:ezbooking/presentation/policy/policy_privacy_page.dart';
import 'package:ezbooking/presentation/screens/ticket/bloc/get_ticket_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ezbooking/data/models/ticket.dart';
import 'package:ezbooking/data/models/event.dart';
import 'package:ezbooking/core/utils/utils.dart';

class ViewTicketPage extends StatefulWidget {
  static const String routeName = "ViewTicketPage";

  final Ticket ticket;

  const ViewTicketPage({
    super.key,
    required this.ticket,
  });

  @override
  State<ViewTicketPage> createState() => _ViewTicketPageState();
}

class _ViewTicketPageState extends State<ViewTicketPage> {
  final PageController pageController = PageController();
  late EventDetailBloc eventDetailBloc;
  late GetTicketCubit getTicketCubit;

  bool isShowingDialog = false;

  Event? event;

  @override
  void initState() {
    super.initState();
    getTicketCubit = BlocProvider.of<GetTicketCubit>(context);
    eventDetailBloc = BlocProvider.of<EventDetailBloc>(context);

    getTicketCubit.fetchTicket(widget.ticket.id);
    eventDetailBloc.add(FetchEventDetail(widget.ticket.eventID));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetTicketCubit, Ticket?>(
      listener: (context, stateTicket) {
        if (stateTicket != null) {
          // Check ticket status
          if (stateTicket.status == "Used") {
            if (isShowingDialog) return;
            DialogUtils.showWarningDialog(
              context: context,
              title: "This ticket has been checked-in!",
              onClickOutSide: () {
                if (widget.ticket.status != "Used" && isShowingDialog) {
                  getTicketCubit.fetchTicket(widget.ticket.id);
                }
              },
            );
            isShowingDialog = true;
          }

          if (stateTicket.status == "Cancelled") {
            if (isShowingDialog) return;
            DialogUtils.showWarningDialog(
              context: context,
              title: "This ticket has been cancelled!",
              onClickOutSide: () {
                Navigator.pop(context);
              },
            );
            isShowingDialog = true;
          }
        }
      },
      builder: (context, stateTicket) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Ticket Details',
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              if (stateTicket?.status == "Available")
                IconButton(
                  onPressed: () async {
                    await showBottomSheetCancelTicket(
                      context: context,
                      ticket: widget.ticket,
                      onCancelSuccess: () {},
                    );
                  },
                  icon: const Icon(Icons.privacy_tip_outlined),
                )
            ],
          ),
          body: BlocBuilder<EventDetailBloc, EventDetailState>(
            builder: (context, state) {
              if (state is EventDetailLoading) {
                return Center(
                  child: Lottie.asset(
                    "assets/animations/loading.json",
                    height: 80,
                  ),
                );
              }

              if (state is EventDetailError) {
                return Center(
                  child: Text('Error: ${state.message}'),
                );
              }

              if (state is EventDetailLoaded) {
                event = state.event;
                return _buildTicketContent(context, state.event, stateTicket);
              }

              return const Center(
                  child: Text('No ticket information available'));
            },
          ),
        );
      },
    );
  }

  Widget _buildTicketContent(
    BuildContext context,
    Event event,
    Ticket? ticketSnapshot,
  ) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildTicketHeader(ticketSnapshot),
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

  Widget _buildTicketHeader(Ticket? ticketSnapshot) {
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
            ticketSnapshot != null
                ? ticketSnapshot.status
                : widget.ticket.status,
            style: TextStyle(
              color: _getStatusColor(ticketSnapshot),
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  Color _getStatusColor(Ticket? ticket) {
    final ticketComparison = ticket ?? widget.ticket;
    switch (ticketComparison.status) {
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
        data: widget.ticket.qrCodeData,
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
          _buildDetailRow('Location', event.location),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          const SizedBox(width: 10),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> showBottomSheetCancelTicket({
    required BuildContext context,
    required Ticket ticket,
    required Function onCancelSuccess,
  }) async {
    int remainingHours = event?.date
            .toUtc()
            .add(const Duration(hours: 7))
            .difference(DateTime.now().toUtc().add(const Duration(hours: 7)))
            .inHours ??
        0;

    int remainingDays = event?.date
            .toUtc()
            .add(const Duration(hours: 7))
            .difference(DateTime.now().toUtc().add(const Duration(hours: 7)))
            .inDays ??
        0;

    String refundPercent = "";

    if (remainingHours >= 168) {
      // Hủy trước 7 ngày hoặc hơn (168 giờ)
      refundPercent = "100%";
    } else if (remainingHours >= 72) {
      // Hủy trước 3-6 ngày (72 giờ)
      refundPercent = "50%";
    } else if (remainingHours >= 24) {
      // Hủy trước 1-2 ngày (24 giờ)
      refundPercent = "25%";
    } else {
      // Hủy trong vòng 24 giờ
      refundPercent = "0%";
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets.add(
                const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Cancel Ticket',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              SizedBox(height: 10),

              // Cancellation Policy
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PolicyPage(),
                    ),
                  );
                },
                child: Text(
                  'Cancellation Policy',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondaryColor,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text(
                '• Cancellations are subject to the event\'s specific refund policy.',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              Text(
                '• Refund amount depends on the time of cancellation.',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              const SizedBox(height: 20),
              Text(
                'Remaining days: $remainingDays',
                style: TextStyle(fontSize: 15, color: AppColors.primaryColor),
              ),
              const SizedBox(height: 10),
              Text(
                'Refund percent: $refundPercent',
                style: TextStyle(fontSize: 15, color: AppColors.primaryColor),
              ),
              const SizedBox(height: 20),
              // Confirmation Message
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Are you sure you want to cancel this ticket?\nThis action cannot be undone.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.redAccent),
                ),
              ),
              const SizedBox(height: 20),

              // Refund Details
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.primaryColor),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Refund will be processed within 5-7 business days.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Cancel Button
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'No, Keep Ticket',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Confirm Button
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                      ),
                      onPressed: () async {
                        try {
                          DialogUtils.showLoadingDialog(context);
                          await cancelTicket(ticket);
                          onCancelSuccess();
                          NotificationService.showInstantNotification(
                              "Ticket Cancellation",
                              "Your ticket #${ticket.id} has been cancelled!.");
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Ticket cancelled successfully.'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          });
                        } catch (e) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            DialogUtils.showWarningDialog(
                              context: context,
                              title: e.toString(),
                              onClickOutSide: () {
                                Navigator.of(context).pop();
                              },
                            );
                          });
                        } finally {
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text(
                        'Cancel Ticket',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> cancelTicket(Ticket ticket) async {
    final firestore = FirebaseFirestore.instance;

    await firestore.runTransaction((transaction) async {
      final ticketRef = firestore.collection('tickets').doc(ticket.id);
      final eventRef = firestore.collection('events').doc(ticket.eventID);

      // Validate ticket
      final ticketSnapshot = await transaction.get(ticketRef);
      final eventSnapshot = await transaction.get(eventRef);

      if (!ticketSnapshot.exists || ticketSnapshot.get('status') == 'Used') {
        throw Exception('Invalid ticket or already used.');
      }

      if (!eventSnapshot.exists) {
        throw Exception('Event does not exist.');
      }

      final Timestamp eventDateTimestamp = eventSnapshot.get('date');
      final DateTime eventDate =
          eventDateTimestamp.toDate().toUtc().add(const Duration(hours: 7));
      final DateTime now = DateTime.now().add(const Duration(hours: 7));

      // Chỉ cho phép hủy trước 1 ngày
      if (now.isAfter(eventDate.subtract(const Duration(days: 1)))) {
        throw Exception(
            'Cannot cancel ticket less than 1 day before the event.');
      }

      transaction.update(ticketRef, {
        'status': 'Cancelled',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      transaction.update(eventRef, {
        'availableTickets': FieldValue.increment(1),
      });
    });
  }

  double calculateRefundAmount({
    required DateTime eventDate,
    required DateTime cancellationTime,
    required double ticketPrice,
  }) {
    final remainingHours = eventDate.difference(cancellationTime).inHours;

    if (remainingHours >= 168) {
      // Hủy trước 7 ngày hoặc hơn (7 * 24 giờ = 168 giờ): Hoàn 100%
      return ticketPrice;
    } else if (remainingHours >= 72) {
      // Hủy trước 3-6 ngày (3 * 24 giờ = 72 giờ): Hoàn 50%
      return ticketPrice * 0.5;
    } else if (remainingHours >= 24) {
      // Hủy trước 1-2 ngày (1 * 24 giờ = 24 giờ): Hoàn 25%
      return ticketPrice * 0.25;
    } else {
      // Hủy trong vòng 24 giờ: Không hoàn tiền
      return 0.0;
    }
  }
}
