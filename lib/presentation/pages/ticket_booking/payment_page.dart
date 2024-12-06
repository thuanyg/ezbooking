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
      vnpAmount: 100000.toString(),
      vnpCreateDate: VnPayPaymentRequest.formatDateTime(DateTime.now()),
      vnpOrderInfo: "Thanh toan don hang ${order.id}",
      vnpReturnUrl: "https://return-url.com",
      vnpExpireDate: VnPayPaymentRequest.formatDateTime(
          DateTime.now().add(const Duration(minutes: 15))),
      vnpTxnRef: DateTime.now().millisecondsSinceEpoch.toString(),
    );

    // final paymentUrl = VNPAYFlutter.instance.generatePaymentUrl(
    //   url: 'https://sandbox.vnpayment.vn/paymentv2/vpcpay.html',
    //   version: '2.0.1',
    //   tmnCode: vnpTmnCode,
    //   txnRef: DateTime.now().millisecondsSinceEpoch.toString(),
    //   orderInfo: 'Pay 30.000 VND',
    //   amount: 30000,
    //   vnpayOrderType: "other",
    //   returnUrl: 'https://htthuan.id.vn/return',
    //   ipAdress: '192.168.10.10',
    //   vnpayHashKey: vnpHashSecret,
    //   vnPayHashType: VNPayHashType.HMACSHA512,
    //   vnpayExpireDate: DateTime.now().add(const Duration(minutes: 15, hours: 7)),
    // );

    String paymentUrl = VnPayPaymentRequest.generatePaymentUrl(paymentRequest);


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
      ..loadRequest(Uri.parse(paymentUrl));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Page'),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
