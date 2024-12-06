import 'package:ezbooking/core/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactUsPage extends StatelessWidget {
  static const String routeName = "/ContactUsPage";

  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Us", style: GoogleFonts.poppins()),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
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
                  const Icon(Icons.contact_mail,
                      size: 80, color: Colors.lightBlue),
                  const SizedBox(height: 10),
                  Text(
                    "We'd love to hear from you!",
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Fill out the form below or reach us via email.",
                    style:
                        GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Form Section
            _buildTextField("Your Name", Icons.person),
            const SizedBox(height: 15),
            _buildTextField("Your Email", Icons.email),
            const SizedBox(height: 15),
            _buildTextField("Subject", Icons.subject),
            const SizedBox(height: 15),
            _buildTextField("Message", Icons.message),
            const SizedBox(height: 30),

            // Submit Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle submission logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Message Sent!")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text("Send Message",
                    style:
                        GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 40),

            // Additional Contact Information
            Center(
              child: Column(
                children: [
                  Text("Or Contact Us Directly",
                      style: GoogleFonts.poppins(fontSize: 14)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.phone, color: AppColors.primaryColor),
                      const SizedBox(width: 5),
                      Text("+84373897359",
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: Colors.black)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.email, color: AppColors.primaryColor),
                      const SizedBox(width: 5),
                      Text("thuanht.nuce@gmail.com",
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: Colors.black)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, IconData icon, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: Colors.grey),
        prefixIcon: Icon(icon, color: AppColors.primaryColor),
        filled: true,
        fillColor: Colors.lightBlue.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
