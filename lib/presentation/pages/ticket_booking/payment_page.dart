import 'package:ezbooking/data/models/order.dart';
import 'package:ezbooking/data/models/vnpay_payment_request.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
  }

  Future<void> launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = ModalRoute.of(context)!.settings.arguments as Order;

    VnPayPaymentRequest paymentRequest = VnPayPaymentRequest(
      vnpAmount: 10000 * 100,
      vnpCreateDate: VnPayPaymentRequest.formatDateTime(DateTime.now()),
      vnpOrderInfo: "Thanh toan don hang ${order.id}",
      vnpReturnUrl: "https://return-url.com",
      vnpExpireDate: VnPayPaymentRequest.formatDateTime(
          DateTime.now().add(const Duration(minutes: 15))),
      vnpTxnRef: DateTime.now().millisecondsSinceEpoch.toString(),
    );

    String url =
        "$vnpUrl?vnp_Amount=${paymentRequest.vnpAmount}&vnp_Command=pay&vnp_CreateDate=${paymentRequest.vnpCreateDate}&vnp_CurrCode=VND&vnp_IpAddr=127.0.0.1&vnp_Locale=vn&vnp_OrderInfo=Thanh+toan+don+hang&vnp_OrderType=other&vnp_ReturnUrl=https%3A%2F%2Fdomainmerchant.vn%2FReturnUrl&vnp_TmnCode=$vnpTmnCode&vnp_Version=2.1.0&vnp_SecureHash=12222222222&vnp_TxnRef=5";


    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) async {
            if (request.url.startsWith('tel:') ||
                request.url.startsWith('mailto:')) {
              await launchUrl(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(
          Uri.parse(VnPayPaymentRequest.generatePaymentUrl(paymentRequest)));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Page'),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
