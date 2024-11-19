import 'package:cloud_firestore/cloud_firestore.dart' as cf;
import 'package:ezbooking/core/utils/dialogs.dart';
import 'package:ezbooking/core/utils/utils.dart';
import 'package:ezbooking/data/models/event.dart';
import 'package:ezbooking/data/models/ticket.dart';
import 'package:ezbooking/presentation/pages/ticket_booking/bloc/orders/create_order_bloc.dart';
import 'package:ezbooking/presentation/pages/ticket_booking/bloc/orders/create_order_event.dart';
import 'package:ezbooking/presentation/pages/ticket_booking/bloc/orders/create_order_state.dart';
import 'package:ezbooking/presentation/pages/ticket_booking/bloc/tickets/create_ticket_bloc.dart';
import 'package:ezbooking/presentation/pages/ticket_booking/bloc/tickets/create_ticket_event.dart';
import 'package:ezbooking/presentation/pages/ticket_booking/bloc/tickets/create_ticket_state.dart';
import 'package:ezbooking/presentation/pages/ticket_booking/payment_page.dart';
import 'package:ezbooking/presentation/pages/ticket_booking/payment_success_page.dart';
import 'package:ezbooking/presentation/pages/user_profile/bloc/user_info_bloc.dart';
import 'package:ezbooking/data/models/order.dart';
import 'package:ezbooking/presentation/pages/user_profile/bloc/user_info_state.dart';
import 'package:ezbooking/presentation/widgets/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TicketBookingPage extends StatefulWidget {
  static const String routeName = "TicketBookingPage";

  const TicketBookingPage({super.key});

  @override
  State<TicketBookingPage> createState() => _TicketBookingPageState();
}

class _TicketBookingPageState extends State<TicketBookingPage> {
  int numberOfTickets = 1;
  final quantityController = TextEditingController(text: "1");
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  late UserInfoBloc userInfoBloc;
  late CreateOrderBloc createOrderBloc;
  late CreateTicketBloc createTicketBloc;

  bool isOrderCreated = false;
  Order? order;
  List<Ticket> tickets = [];

  @override
  void initState() {
    super.initState();
    userInfoBloc = BlocProvider.of<UserInfoBloc>(context);
    createOrderBloc = BlocProvider.of<CreateOrderBloc>(context);
    createTicketBloc = BlocProvider.of<CreateTicketBloc>(context);
  }

  void _incrementTickets() {
    setState(() {
      numberOfTickets++;
    });
  }

  void _decrementTickets() {
    if (numberOfTickets > 1) {
      setState(() {
        numberOfTickets--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final event = ModalRoute.of(context)!.settings.arguments as Event;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Ticket Booking',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<UserInfoBloc, UserInfoState>(
            builder: (context, state) {
              if (state is UserInfoLoaded) {
                nameController.text = state.user.fullName ?? "";
                emailController.text = state.user.email ?? "";
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Enter your Info',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: nameController,
                      label: 'Full Name',
                      hint: 'Enter your name',
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: emailController,
                      label: 'Email Address',
                      hint: 'Enter your email',
                      icon: Icons.email_outlined,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Number of Tickets',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: _decrementTickets,
                              color: Colors.grey[600],
                            ),
                          ),
                          Container(
                            width: 100,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            alignment: Alignment.center,
                            child: TextField(
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              controller: quantityController,
                              buildCounter: (context,
                                  {required currentLength,
                                  required isFocused,
                                  required maxLength}) {
                                return const SizedBox.shrink();
                              },
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                              maxLines: 1,
                              maxLength: 4,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: _incrementTickets,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Payment Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...List.generate(
                      numberOfTickets,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Ticket ${index + 1}',
                              style: const TextStyle(color: Colors.black54),
                            ),
                            Text(
                              '${event.ticketPrice.toStringAsFixed(2)} \$',
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${(numberOfTickets * event.ticketPrice).toStringAsFixed(2)} \$',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    MainElevatedButton(
                      height: 50,
                      width: double.infinity,
                      textButton: "Continue",
                      iconName: "ic_button_next.png",
                      onTap: () {
                        DialogUtils.showLoadingDialog(context);
                        // Success payment
                        order = Order(
                          id: AppUtils.generateRandomString(6),
                          eventID: event.id!,
                          status: "success",
                          createdAt: cf.Timestamp.now(),
                          ticketPrice: event.ticketPrice,
                          ticketQuantity: int.parse(quantityController.text),
                          userID: FirebaseAuth.instance.currentUser!.uid,
                          orderType: 'Online',
                        );

                        createOrderBloc.add(CreateOrder(order!));
                        // Create ticket for user
                        _createTicketsForOrder(order!);
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => PaymentPage(),
                        //     settings: RouteSettings(arguments: order),
                        //   ),
                        // );
                      },
                    ),
                    BlocListener(
                      bloc: createOrderBloc,
                      listener: (context, state) {
                        if (state is CreateOrderSuccess) {
                          isOrderCreated = true;
                        }
                      },
                      child: BlocListener(
                        bloc: createTicketBloc,
                        listener: (context, state) {
                          if (state is CreateTicketSuccess) {
                            if (isOrderCreated) {
                              print(isOrderCreated);
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PaymentSuccessPage(
                                    order: order!,
                                    event: event,
                                    tickets: tickets,
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        child: Container(),
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[400]),
              prefixIcon: Icon(icon, color: Colors.grey[400]),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Tạo vé cho đơn hàng
  void _createTicketsForOrder(Order order) {
    try {
      // Gọi add cho mỗi vé để gửi sự kiện vào bloc
      for (int i = 0; i < order.ticketQuantity; i++) {
        final ticketID = AppUtils.generateRandomString(8);
        final qrCodeData =
            'ticketId=$ticketID&orderId=${order.id}&eventId=${order.eventID}';
        final encryptedData =
            AppUtils.encryptData(qrCodeData, AppUtils.secretKey);

        Ticket ticket = Ticket(
          id: ticketID,
          orderID: order.id,
          eventID: order.eventID,
          userID: order.userID,
          ticketPrice: order.ticketPrice,
          ticketType: "Standard",
          status: "Available",
          qrCodeData: encryptedData,
          createdAt: DateTime.now().toUtc().add(const Duration(hours: 7)),
        );
        tickets.add(ticket);
        // Gửi sự kiện tạo vé vào CreateTicketBloc
        createTicketBloc.add(CreateTicket(ticket));
      }
    } catch (e) {
      createTicketBloc.emitError(e.toString());
    }
  }
}
