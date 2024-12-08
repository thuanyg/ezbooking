import 'package:ezbooking/core/utils/dialogs.dart';
import 'package:ezbooking/data/models/order.dart';
import 'package:ezbooking/data/models/vn_pay_response.dart';
import 'package:ezbooking/data/models/vnpay_payment_request.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPage extends StatefulWidget {
  final Order order;

  const PaymentPage({super.key, required this.order});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  WebViewController controller = WebViewController();

  @override
  void initState() {
    super.initState();
    preparePaymentRequest();
  }

  @override
  void dispose() {
    super.dispose();
    print("-----Update status order cancelled here-----");
  }

  preparePaymentRequest() {
    VnPayPaymentRequest paymentRequest = VnPayPaymentRequest(
      vnpAmount:
          (widget.order.ticketPrice * widget.order.ticketQuantity * 24000)
              .toString(),
      vnpCreateDate: VnPayPaymentRequest.formatDateTime(
          DateTime.now().toUtc().add(const Duration(hours: 7))),
      vnpOrderInfo: Uri.encodeComponent(
          "Thanh toan don hang EzBooking ${widget.order.id}"),
      vnpReturnUrl: "https://vnpay-ipn.vercel.app/vnpay_return",
      vnpExpireDate: VnPayPaymentRequest.formatDateTime(
          DateTime.now().toUtc().add(const Duration(minutes: 15, hours: 7))),
      vnpTxnRef: widget.order.id,
    );

    String paymentUrl = VnPayPaymentRequest.generatePaymentUrl(paymentRequest);

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) async {
            if (request.url.startsWith('tel:') ||
                request.url.startsWith('mailto:')) {
              launchUrl(request.url);
              return NavigationDecision.prevent;
            }

            // Kiểm tra URL trả về từ VNPAY
            if (request.url
                .startsWith("https://vnpay-ipn.vercel.app/vnpay_return")) {
              // Tự động xử lý kết quả trả về từ VNPAY
              Uri returnUrl = Uri.parse(request.url);
              String rspCode =
                  returnUrl.queryParameters['vnp_ResponseCode'] ?? '99';

              final response = VnpayResponse.fromResponseCode(rspCode);

              Navigator.pop<VnpayResponse>(context, response);

              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(paymentUrl));
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
    return WillPopScope(
      onWillPop: () async {
        DialogUtils.showConfirmationDialog(
          context: context,
          title: "Are you sure you want to exit?",
          textCancelButton: "Cancel",
          textAcceptButton: "OK",
          acceptPressed: () {
            print("================================");
            Navigator.pop<VnpayResponse>(
                context, VnpayResponse.fromResponseCode("24"));
          },
        );
        return true;
      },
      child: Scaffold(
        body: Padding(
            padding: EdgeInsets.only(top: kToolbarHeight - 20),
            child: WebViewWidget(controller: controller)),
      ),
    );
  }
}
