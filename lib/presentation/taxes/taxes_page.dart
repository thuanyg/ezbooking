import 'package:ezbooking/core/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TaxesPage extends StatelessWidget {
  static const String routeName = "TaxesPage";

  const TaxesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Taxes & Discounts", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Title Section
            Text(
              "Tax Information",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Tax Details Section
            _buildTaxInfo(
              "Value-Added Tax (VAT)",
              "10%",
            ),
            _buildTaxInfo(
              "Service Tax",
              "5%",
            ),
            const SizedBox(height: 20),

            // Discounts Section Title
            Text(
              "Partner Discounts",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Discount Details Section
            _buildDiscountInfo(
              "Event Organizers",
              "15% Discount on Bulk Orders",
            ),
            _buildDiscountInfo(
              "Early Bird Offers",
              "10% Discount on Early Bookings",
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget for Tax Information
  Widget _buildTaxInfo(String taxName, String taxRate) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            taxName,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            taxRate,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widget for Discount Information
  Widget _buildDiscountInfo(String partnerType, String discountDetails) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            partnerType,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            discountDetails,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
