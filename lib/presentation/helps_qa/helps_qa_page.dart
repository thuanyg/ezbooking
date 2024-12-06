import 'package:ezbooking/core/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpAndQAPage extends StatelessWidget {
  static const String routeName = "HelpAndQAPage";

  const HelpAndQAPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Help & Q&A",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.help_outline,
                    size: 60,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Need Assistance?",
                    style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Find answers to common questions below.",
                    style:
                        GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 46),

            // Q&A Section
            Text(
              "Frequently Asked Questions",
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            _buildQuestionAnswer(
              "How do I book a ticket?",
              "To book a ticket, simply go to the Events page, select an event, choose your ticket type, and proceed to payment.",
            ),
            _buildQuestionAnswer(
              "Can I cancel or refund my ticket?",
              "Yes, cancellations are allowed up to 24 hours before the event. Refund policies depend on the event organizer.",
            ),
            _buildQuestionAnswer(
              "Where can I find my booked tickets?",
              "All your booked tickets are available in the 'My Tickets' section accessible from the main menu.",
            ),
            _buildQuestionAnswer(
              "What payment methods are accepted?",
              "We accept all major credit cards, debit cards, and digital wallets.",
            ),
            const SizedBox(height: 20),

            // Contact Section
            Text(
              "Still need help?",
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Text(
              "If you have additional questions, feel free to contact us:",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.phone, color: AppColors.primaryColor),
              title:
                  Text("84373897359", style: GoogleFonts.poppins(fontSize: 14)),
            ),
            ListTile(
              leading: Icon(Icons.email, color: AppColors.primaryColor),
              title: Text("thuanht.nucc@gmail.com",
                  style: GoogleFonts.poppins(fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget for Q&A
  Widget _buildQuestionAnswer(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style:
                GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 5),
          Text(
            answer,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
