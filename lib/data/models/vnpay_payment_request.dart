import 'dart:convert';
import 'package:crypto/crypto.dart';

const vnpUrl = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";
const String vnpVersion = "2.1.0";
const String vnpCommand = "pay";
const String vnpTmnCode = "NRGV3922";
const String vnpIpAddr = "127.0.0.1";
const String vnpLocale = "vn";
const String vnpOrderType = "other";
const String vnpHashSecret = "ES0GDAPN8ANDCO99ZDNR76CBXQ3LQJ4E";

class VnPayPaymentRequest {
  final String vnpAmount;
  final String vnpCreateDate;
  final String vnpOrderInfo;
  final String vnpReturnUrl;
  final String vnpExpireDate;
  final String vnpTxnRef;

  VnPayPaymentRequest({
    required this.vnpAmount,
    required this.vnpCreateDate,
    required this.vnpOrderInfo,
    required this.vnpReturnUrl,
    required this.vnpExpireDate,
    required this.vnpTxnRef,
  });

  static String formatDateTime(DateTime dateTime) {
    return '${dateTime.year.toString().padLeft(4, '0')}${dateTime.month.toString().padLeft(2, '0')}${dateTime.day.toString().padLeft(2, '0')}${dateTime.hour.toString().padLeft(2, '0')}${dateTime.minute.toString().padLeft(2, '0')}${dateTime.second.toString().padLeft(2, '0')}';
  }

  static String generatePaymentUrl(VnPayPaymentRequest paymentRequest) {
    try {
      final amount = (double.parse(paymentRequest.vnpAmount) * 100).round().toString();

      final Map<String, String> vnpParams = {
        'vnp_Amount': amount,
        'vnp_Command': vnpCommand,
        'vnp_CreateDate': paymentRequest.vnpCreateDate,
        'vnp_ExpireDate': paymentRequest.vnpExpireDate,
        'vnp_CurrCode': 'VND',
        'vnp_IpAddr': vnpIpAddr,
        'vnp_Locale': vnpLocale,
        'vnp_OrderInfo': paymentRequest.vnpOrderInfo,
        'vnp_OrderType': vnpOrderType,
        'vnp_ReturnUrl': paymentRequest.vnpReturnUrl,
        'vnp_TmnCode': vnpTmnCode,
        'vnp_TxnRef': paymentRequest.vnpTxnRef,
        'vnp_Version': vnpVersion,
      };

      // DEBUG: Print all parameters before sorting
      print('VNPay Parameters Before Sorting:');
      vnpParams.forEach((key, value) {
        print('$key: $value');
      });

      final List<String> fieldNames = vnpParams.keys.toList()..sort();

      final StringBuffer hashData = StringBuffer();
      for (var fieldName in fieldNames) {
        final value = vnpParams[fieldName];
        if (value!.isNotEmpty) {
          if (hashData.isNotEmpty) {
            hashData.write('&');
          }
          hashData.write('$fieldName=${Uri.encodeComponent(value)}');
        }
      }

      final String signData = hashData.toString();
      print('Raw Hash Data: $signData');

      // More robust hash generation
      final vnpSecureHash = Hmac(sha512, utf8.encode(vnpHashSecret))
          .convert(utf8.encode(signData))
          .toString();
          // .toUpperCase(); // VNPay often requires uppercase hashes

      print('Generated Secure Hash (Uppercase): $vnpSecureHash');

      vnpParams['vnp_SecureHash'] = vnpSecureHash;

      final StringBuffer queryUrl = StringBuffer('$vnpUrl?');
      vnpParams.forEach((key, value) {
        if (value.isNotEmpty) {
          if(key == "vnp_Amount") {
            queryUrl.write('$key=${Uri.encodeComponent(value)}');
          } else {
            queryUrl.write('&$key=${Uri.encodeComponent(value)}');
          }
        }
      });

      print('Final Payment URL: $queryUrl');

      return queryUrl.toString();
    } catch (e) {
      print('Error generating payment URL: $e');
      rethrow;
    }
  }
}
