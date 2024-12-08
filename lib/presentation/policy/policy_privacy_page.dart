import 'package:ezbooking/core/config/app_colors.dart';
import 'package:flutter/material.dart';


class PolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy & Terms', style:  TextStyle(fontWeight: FontWeight.w600),),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'We respect your privacy and are committed to protecting your personal data. '
                  'This privacy policy explains how we collect, use, and protect your information.',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 24),
            Text(
              'Cancellation Policy',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            SizedBox(height: 12),
            const Text(
              'If you wish to cancel your ticket, please note the following:\n\n'
                  '1. You can cancel your ticket up to 7 days before the event for a full refund.\n'
                  '2. Cancellations made between 3-6 days before the event will receive a 50% refund.\n'
                  '3. Cancellations made between 1-2 days before the event will receive a 25% refund.\n'
                  '4. No refunds will be issued for cancellations within 24 hours of the event.',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            SizedBox(height: 24),
            Text(
              'Terms & Conditions',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            SizedBox(height: 12),
            const Text(
              'By using our service, you agree to the following terms:\n\n'
                  '1. All ticket sales are final and are subject to our cancellation policy.\n'
                  '2. Users must provide accurate information when booking tickets.\n'
                  '3. Any misuse or fraudulent activity may result in account suspension.',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
