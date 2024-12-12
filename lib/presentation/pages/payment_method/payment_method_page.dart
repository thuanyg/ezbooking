import 'package:ezbooking/core/config/constants.dart';
import 'package:ezbooking/core/utils/image_helper.dart';
import 'package:flutter/material.dart';

class PaymentMethodPage extends StatelessWidget {
  static const routeName = "PaymentMethodPage";

  const PaymentMethodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Methods"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ImageHelper.loadAssetImage("${assetImageLink}img_payment.png"),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Choose the different payment methods",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                ImageHelper.loadAssetImage(
                  "${assetImageLink}vnpay.png",
                  height: 28,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("ATM/Internet Banking"),
                  ),
                ),
                Radio(
                  value: "i",
                  groupValue: "i",
                  onChanged: (value) {},
                )
              ],
            )

            // ListTile(
            //   leading: ImageHelper.loadAssetImage(
            //     "${assetImageLink}momo.png",
            //     height: 28,
            //     fit: BoxFit.fill,
            //   ),
            //   title: const Text("Momo"),
            //   trailing: Radio(
            //     value: "a",
            //     groupValue: "i",
            //     onChanged: (value) {},
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
