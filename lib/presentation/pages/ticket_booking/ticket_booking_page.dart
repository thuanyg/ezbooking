import 'package:cloud_firestore/cloud_firestore.dart' as cf;
import 'package:ezbooking/core/config/app_colors.dart';
import 'package:ezbooking/core/config/constants.dart';
import 'package:ezbooking/core/services/mail_service.dart';
import 'package:ezbooking/core/services/notification_service.dart';
import 'package:ezbooking/core/utils/dialogs.dart';
import 'package:ezbooking/core/utils/utils.dart';
import 'package:ezbooking/data/models/event.dart';
import 'package:ezbooking/data/models/notification_model.dart';
import 'package:ezbooking/data/models/order_mail_request.dart';
import 'package:ezbooking/data/models/ticket.dart';
import 'package:ezbooking/data/models/vn_pay_response.dart';
import 'package:ezbooking/presentation/pages/notification/notification_cubit.dart';
import 'package:ezbooking/presentation/pages/ticket_booking/bloc/tickets/create_ticket_bloc.dart';
import 'package:ezbooking/presentation/pages/ticket_booking/payment_page.dart';
import 'package:ezbooking/presentation/pages/ticket_booking/payment_success_page.dart';
import 'package:ezbooking/presentation/pages/user_profile/bloc/user_info_bloc.dart';
import 'package:ezbooking/data/models/order.dart';
import 'package:ezbooking/presentation/pages/user_profile/bloc/user_info_state.dart';
import 'package:ezbooking/presentation/widgets/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

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
  late CreateTicketBloc createTicketBloc;

  bool isOrderCreated = false;
  Order? order;
  Event? event;

  @override
  void initState() {
    super.initState();
    userInfoBloc = BlocProvider.of<UserInfoBloc>(context);
    createTicketBloc = BlocProvider.of<CreateTicketBloc>(context);
  }

  void _incrementTickets() {
    if (numberOfTickets < event!.availableTickets) {
      setState(() {
        numberOfTickets++;
        quantityController.text = numberOfTickets.toString();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text("Not enough tickets available. Please reduce the quantity."),
        ),
      );
    }
  }

  void _decrementTickets() {
    if (numberOfTickets > 1) {
      setState(() {
        numberOfTickets--;
        quantityController.text = numberOfTickets.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    event = ModalRoute.of(context)!.settings.arguments as Event;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
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
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
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
                              onSubmitted: (value) {
                                if (quantityController.text.isEmpty) {
                                  DialogUtils.showWarningDialog(
                                    context: context,
                                    title: "Please choose number of tickets.",
                                    onClickOutSide: () {},
                                  );
                                  return;
                                }
                                final num = int.parse(quantityController.text);
                                if (num > 10) {
                                  DialogUtils.showWarningDialog(
                                    context: context,
                                    title:
                                        "You can only purchase up to 10 tickets at a time.",
                                    onClickOutSide: () {},
                                  );
                                  return;
                                }

                                if (num <= 0) {
                                  DialogUtils.showWarningDialog(
                                    context: context,
                                    title: "Your selection is not valid",
                                    onClickOutSide: () {},
                                  );
                                  return;
                                }

                                setState(() {
                                  numberOfTickets = num;
                                });
                              },
                              onChanged: (value) {
                                final num = int.parse(quantityController.text);
                                if (num > 10) {
                                  DialogUtils.showWarningDialog(
                                    context: context,
                                    title:
                                        "You can only purchase up to 10 tickets at a time.",
                                    onClickOutSide: () {},
                                  );
                                  return;
                                }

                                if (num <= 0) {
                                  DialogUtils.showWarningDialog(
                                    context: context,
                                    title: "Your selection is not valid",
                                    onClickOutSide: () {},
                                  );
                                  return;
                                }
                                setState(() {
                                  numberOfTickets = num;
                                });
                              },
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                              maxLines: 1,
                              maxLength: 2,
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
                              '${event?.ticketPrice.toStringAsFixed(2)} \$',
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
                          '${(numberOfTickets * event!.ticketPrice).toStringAsFixed(2)} \$',
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
                      onTap: () async {
                        if (quantityController.text.isEmpty) {
                          DialogUtils.showWarningDialog(
                            context: context,
                            title: "Please choose number of tickets.",
                            onClickOutSide: () {},
                          );
                          return;
                        }

                        final num = int.parse(quantityController.text);
                        if (num > 10) {
                          DialogUtils.showWarningDialog(
                            context: context,
                            title:
                                "You can only purchase up to 10 tickets at a time.",
                            onClickOutSide: () {},
                          );
                          return;
                        }

                        if (num <= 0) {
                          DialogUtils.showWarningDialog(
                            context: context,
                            title: "Your selection is not valid",
                            onClickOutSide: () {},
                          );
                          return;
                        }

                        createTicketBloc.emitState(TicketCreationStatus.idle);
                        DialogUtils.showLoadingDialog(context);

                        bool isTicketAvailable = event!.availableTickets >=
                            int.parse(quantityController.text);

                        if (!isTicketAvailable) {
                          await Future.delayed(
                              const Duration(milliseconds: 500));
                          DialogUtils.showWarningDialog(
                            context: context,
                            title:
                                "Number of tickets out of ${event!.availableTickets}. Please adjust your selection.",
                            onClickOutSide: () {
                              DialogUtils.hide(context);
                            },
                          );
                          return;
                        }

                        order = Order(
                          id: "EZB-${DateTime.now().millisecondsSinceEpoch}",
                          eventID: event?.id ?? "",
                          status: "pending",
                          paymentMethod: "VNPay",
                          createdAt: cf.Timestamp.now(),
                          ticketPrice: event!.ticketPrice,
                          ticketQuantity: int.parse(quantityController.text),
                          userID: FirebaseAuth.instance.currentUser!.uid,
                          orderType: 'Online',
                        );

                        await cf.FirebaseFirestore.instance
                            .collection('orders')
                            .doc(order?.id)
                            .set(order!.toFirestore());

                        DialogUtils.hide(context);

                        // Handle add free Ticket
                        if (event?.ticketPrice == 0.0) {
                          final tickets = await createTicketFromOrder(order);
                          DialogUtils.hide(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentSuccessPage(
                                order: order!,
                                event: event!,
                                tickets: tickets,
                              ),
                            ),
                          );
                          return;
                        }

                        await Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (context) =>
                                    PaymentPage(order: order!)))
                            .then(
                          (value) async {
                            List<Ticket> tickets = [];

                            final vnpayResponse = value as VnpayResponse;

                            if (vnpayResponse.code == "00") {
                              tickets = await createTicketFromOrder(order);

                              final notiCubit =
                                  BlocProvider.of<NotificationCubit>(context);
                              NotificationModel noti = NotificationModel(
                                id: "",
                                title: "Order Placed Successfully",
                                message:
                                    "Your order (ID: ${order?.id ?? ""}) has been successfully created.",
                                isRead: false,
                                actionUrl: "",
                                createdAt: cf.Timestamp.now(),
                              );

                              await notiCubit.addNotification(
                                  order?.userID ?? "", noti);

                              NotificationService.showInstantNotification(
                                "Order Placed Successfully",
                                "Your order (ID: ${order?.id ?? ""}) has been successfully created.",
                              );
                            } else {
                              createTicketBloc.errorMessage =
                                  vnpayResponse.description;

                              createTicketBloc
                                  .emitState(TicketCreationStatus.error);

                              await cf.FirebaseFirestore.instance
                                  .collection("orders")
                                  .doc(order?.id)
                                  .update({
                                "status": "cancelled",
                                "updatedAt": cf.Timestamp.now(),
                              });
                            }

                            showGeneralDialog(
                              barrierLabel: '',
                              context: context,
                              barrierDismissible: false,
                              pageBuilder: (context, _, __) {
                                return WillPopScope(
                                  onWillPop: () async {
                                    return false;
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 40,
                                    ),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(18),
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.width -
                                                200,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: BlocConsumer(
                                          listener: (context, state) async {
                                            if (state ==
                                                TicketCreationStatus
                                                    .creatingTickets) {
                                              await Future.delayed(
                                                const Duration(
                                                    milliseconds: 2500),
                                                () {
                                                  Navigator.pop(context);
                                                },
                                              );
                                            }
                                            if (state ==
                                                TicketCreationStatus.success) {
                                              final orderMailRequest =
                                                  OrderMailRequest(
                                                      email: userInfoBloc
                                                              .user?.email ??
                                                          "",
                                                      orderDetails:
                                                          OrderDetails(
                                                        orderID:
                                                            order?.id ?? "",
                                                        customerEmail:
                                                            userInfoBloc
                                                                .user?.email,
                                                        customerName:
                                                            userInfoBloc
                                                                .user?.fullName,
                                                        totalAmount:
                                                            _calculateTotalAmount(
                                                          order?.ticketQuantity,
                                                          order?.ticketPrice,
                                                        ),
                                                        tickets: tickets
                                                            .map((ticket) =>
                                                                Tickets(
                                                                  name: ticket
                                                                      .ticketType,
                                                                  quantity:
                                                                      order?.ticketQuantity ??
                                                                          1,
                                                                  price: ticket
                                                                      .ticketPrice
                                                                      .toInt(),
                                                                ))
                                                            .toList(),
                                                      ));
                                              await MailService.sendOrderEmail(
                                                  orderMailRequest);

                                              await Future.delayed(
                                                const Duration(
                                                    milliseconds: 500),
                                                () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          PaymentSuccessPage(
                                                        order: order!,
                                                        event: event!,
                                                        tickets: tickets,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            }
                                            if (state ==
                                                TicketCreationStatus.error) {
                                              await Future.delayed(
                                                const Duration(
                                                    milliseconds: 1500),
                                                () => Navigator.pop(context),
                                              );
                                            }
                                          },
                                          bloc: createTicketBloc,
                                          builder: (context, state) {
                                            if (state ==
                                                TicketCreationStatus.idle) {
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Center(
                                                    child: Lottie.asset(
                                                      '${assetAnimationLink}loading.json',
                                                      width: 80,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  const Text(
                                                    "...",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            } else if (state ==
                                                TicketCreationStatus
                                                    .creatingTickets) {
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Center(
                                                    child: Lottie.asset(
                                                      '${assetAnimationLink}loading.json',
                                                      width: 80,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Creating tickets...",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: AppColors
                                                          .primaryColor,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            } else if (state ==
                                                TicketCreationStatus.success) {
                                              return const Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Center(
                                                      child: Icon(
                                                    Icons.done_all,
                                                    size: 46,
                                                    color: Colors.green,
                                                  )),
                                                  SizedBox(height: 16),
                                                  Text(
                                                    "Order placed successfully!",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            } else if (state ==
                                                TicketCreationStatus.error) {
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Center(
                                                    child: Icon(
                                                      Icons.error,
                                                      size: 46,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  Text(
                                                    createTicketBloc
                                                        .errorMessage,
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            } else {
                                              return const SizedBox.shrink();
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
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

  int _calculateTotalAmount(int? ticketQuantity, double? ticketPrice) {
    // Ensure the ticketQuantity and ticketPrice are not null and valid
    if (ticketQuantity != null && ticketPrice != null) {
      // Calculate the total amount safely
      return (ticketQuantity * ticketPrice)
          .toInt(); // Convert the result to an integer
    }
    return 0; // Return 0 if either value is null or invalid
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

  Future<List<Ticket>> createTicketFromOrder(Order? order) async {
    await cf.FirebaseFirestore.instance
        .collection("orders")
        .doc(order?.id)
        .update({
      "updateAt": cf.Timestamp.now(),
      "status": "success",
    });
    // Create tickets
    List<Ticket> tickets = [];
    for (int i = 0; i < order!.ticketQuantity; i++) {
      final ticketID = AppUtils.generateRandomString(8);
      // Generate and encrypt QR Code data
      final qrCodeData = 'ticketId=$ticketID';

      final encryptedData =
          AppUtils.encryptData(qrCodeData, AppUtils.secretKey);

      final ticket = Ticket(
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
    }
    createTicketBloc.createTickets(tickets, event!);
    return tickets;
  }
}
