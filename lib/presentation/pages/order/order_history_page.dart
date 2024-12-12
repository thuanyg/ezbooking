import 'package:ezbooking/presentation/pages/event/bloc/event_detail_bloc.dart';
import 'package:ezbooking/presentation/pages/event/bloc/event_detail_event.dart';
import 'package:ezbooking/presentation/pages/event/bloc/event_detail_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ezbooking/core/config/app_colors.dart';
import 'package:ezbooking/data/models/order.dart';
import 'package:ezbooking/presentation/screens/profile/fetch_orders_bloc.dart';
import 'package:ezbooking/presentation/pages/user_profile/bloc/user_info_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage>
    with SingleTickerProviderStateMixin {
  late final FetchOrdersCubit fetchOrdersCubit;
  late final UserInfoBloc userInfoBloc;
  late TabController _tabController;

  final List<String> _tabs = ['Success', 'Pending', 'Cancelled'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    fetchOrdersCubit = BlocProvider.of<FetchOrdersCubit>(context);
    userInfoBloc = BlocProvider.of<UserInfoBloc>(context);
    fetchOrdersCubit.fetchOrders(userInfoBloc.user?.id ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order History',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primaryColor,
          labelColor: AppColors.primaryColor,
          unselectedLabelColor: Colors.grey,
          tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocBuilder<FetchOrdersCubit, FetchOrdersState>(
        bloc: fetchOrdersCubit,
        builder: (context, state) {
          if (state is LoadingOrdersState) {
            return ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return _buildOrderCardShimmer();
              },
            );
          }
          if (state is LoadedOrdersState) {
            return TabBarView(
              controller: _tabController,
              children: _tabs.map((tab) {
                final filteredOrders = state.orders.where((order) {
                  switch (tab) {
                    case 'Success':
                      return order.status == 'success';
                    case 'Pending':
                      return order.status == 'pending';
                    case 'Cancelled':
                      return order.status == 'cancelled';
                    default:
                      return false;
                  }
                }).toList();

                return filteredOrders.isEmpty
                    ? _buildEmptyState(tab)
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        itemCount: filteredOrders.length,
                        itemBuilder: (context, index) {
                          final order = filteredOrders[index];
                          return _buildOrderCard(order);
                        },
                      );
              }).toList(),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmptyState(String tab) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'No $tab Orders',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You have no $tab orders at the moment',
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
    return Card(
      elevation: 1,
      color: const Color(0xFFF8F8F8),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppColors.borderOutlineColor,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Order #${order.id}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                _buildStatusChip(order.status),
              ],
            ),
            const SizedBox(height: 12),
            _buildOrderDetailRow(
              'Tickets',
              Text(
                '${order.ticketQuantity} x ${NumberFormat.currency(symbol: '\$').format(order.ticketPrice)}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 8),
            _buildOrderDetailRow(
              'Date',
              Text(
                DateFormat('dd MMM yyyy, HH:mm')
                    .format(order.createdAt.toDate()),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 8),
            _buildActionButtons(order),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    Color textColor;
    switch (status.toLowerCase()) {
      case 'pending':
        chipColor = Colors.orange.shade100;
        textColor = Colors.orange;
        break;
      case 'success':
        chipColor = Colors.green.shade100;
        textColor = Colors.green;
        break;
      case 'cancelled':
        chipColor = Colors.red.shade100;
        textColor = Colors.red;
        break;
      default:
        chipColor = Colors.grey.shade100;
        textColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildOrderDetailRow(String label, Widget value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
        value,
      ],
    );
  }

  Widget _buildActionButtons(Order order) {
    return OutlinedButton(
      onPressed: () => _showOrderDetailsBottomSheet(context, order),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: AppColors.primaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        minimumSize: const Size(double.infinity, 40),
      ),
      child: Text(
        'View Details',
        style: TextStyle(color: AppColors.primaryColor),
      ),
    );
  }

  void _showOrderDetailsBottomSheet(BuildContext context, Order order) {
    final EventDetailBloc eventDetailBloc =
        BlocProvider.of<EventDetailBloc>(context);
    eventDetailBloc.add(FetchEventDetail(order.eventID));
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        shouldCloseOnMinExtent: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: BlocBuilder(
            bloc: eventDetailBloc,
            builder: (context, state) {
              if (state is EventDetailLoading) {
                return Center(
                  child: Lottie.asset(
                    "assets/animations/loading.json",
                    height: 60,
                  ),
                );
              }

              if (state is EventDetailLoaded) {
                final event = state.event;
                return ListView(
                  controller: scrollController,
                  children: [
                    // Header
                    Center(
                      child: Container(
                        width: 50,
                        height: 5,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Text(
                      'Order #${order.id}',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    // Status and Date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildDetailChip(
                          icon: Icons.check_circle_outline,
                          label: 'Status',
                          value: order.status.toUpperCase(),
                          color: _getStatusColor(order.status),
                        ),
                        _buildDetailChip(
                          icon: Icons.calendar_today,
                          label: 'Date',
                          value: DateFormat('dd MMM yyyy\nHH:mm')
                              .format(order.createdAt.toDate()),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Event Information Section
                    _buildSectionTitle('Event Details'),
                    const SizedBox(height: 10),
                    _buildDetailRow('Event Name', event.name),
                    _buildDetailRow('Event Date',
                        DateFormat('dd MMM yyyy, HH:mm').format(event.date)),
                    _buildDetailRow('Location', event.location),
                    _buildDetailRow('Event Type', event.eventType),

                    // Order Details Section
                    const SizedBox(height: 20),
                    _buildSectionTitle('Order Details'),
                    const SizedBox(height: 10),
                    _buildDetailRow(
                      'Tickets Booked',
                      '${order.ticketQuantity} x ${NumberFormat.currency(symbol: '\$').format(order.ticketPrice)}',
                    ),
                    _buildDetailRow(
                      'Total Amount',
                      NumberFormat.currency(symbol: '\$')
                          .format(order.ticketQuantity * order.ticketPrice),
                    ),
                    if (order.discount != null)
                      _buildDetailRow(
                        'Discount',
                        NumberFormat.currency(symbol: '\$')
                            .format(order.discount!),
                      ),

                    // Payment Information
                    const SizedBox(height: 20),
                    _buildSectionTitle('Payment Information'),
                    const SizedBox(height: 10),
                    _buildDetailRow(
                        'Payment Method', order.paymentMethod ?? 'VNPay'),
                    _buildDetailRow('Order Type', order.orderType),
                    _buildDetailRow('Payment ID', order.id ?? 'N/A'),

                    const SizedBox(height: 30),
                    // Close Button
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Close',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
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

// Helper method to get status color
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'success':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

// Helper method to build detail chips
  Widget _buildDetailChip({
    required IconData icon,
    required String label,
    required String value,
    Color color = Colors.grey,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

// Helper method to build section titles
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade800,
      ),
    );
  }

// Helper method to build detail rows
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 15,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              maxLines: 2,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Shimmer
  Widget _buildOrderCardShimmer() {
    return Card(
      elevation: 1,
      color: const Color(0xFFF8F8F8),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildShimmerBox(width: 120, height: 20),
                _buildShimmerBox(width: 60, height: 20),
              ],
            ),
            const SizedBox(height: 12),
            _buildShimmerBox(width: double.infinity, height: 18),
            const SizedBox(height: 8),
            _buildShimmerBox(width: double.infinity, height: 18),
            const SizedBox(height: 8),
            _buildShimmerButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerBox(
      {double width = double.infinity, double height = 16}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        color: Colors.grey.shade300,
      ),
    );
  }

  Widget _buildShimmerButton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 40,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey.shade300,
        ),
      ),
    );
  }
}
