import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ezbooking/core/config/app_colors.dart';

class TicketScreenShimmer extends StatelessWidget {
  const TicketScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildShimmerTicketList();
  }

  Widget _buildShimmerTicketList() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        itemCount: 3, // Simulating 3 ticket placeholders
        itemBuilder: (context, index) {
          return _buildShimmerTicketCard();
        },
      ),
    );
  }

  Widget _buildShimmerTicketCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // Shimmer Event Image
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
          ),

          // Dotted Line Shimmer
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 20,
            color: Colors.grey[300],
          ),

          // Ticket Details Shimmer
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildShimmerDetailRow(),
                const SizedBox(height: 16),
                _buildShimmerDetailRow(),
                const SizedBox(height: 16),
                _buildShimmerDetailRow(),
                const SizedBox(height: 16),
                _buildShimmerDetailRow(),
                const SizedBox(height: 20),

                // QR Code and Buttons Shimmer
                Row(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 20,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: 150,
                            height: 16,
                            color: Colors.grey[300],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Action Buttons Shimmer
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 50,
                        color: Colors.grey[300],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 50,
                        color: Colors.grey[300],
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

  Widget _buildShimmerDetailRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Container(
            height: 16,
            color: Colors.grey[300],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 3,
          child: Container(
            height: 16,
            color: Colors.grey[300],
          ),
        ),
      ],
    );
  }
}
