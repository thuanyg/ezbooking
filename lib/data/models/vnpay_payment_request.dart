import 'dart:convert';

import 'package:crypto/crypto.dart';

const vnpUrl = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";
const String vnpVersion = "2.1.0";
const String vnpCommand = "pay";
const String vnpTmnCode = "NRGV3922";
const String? vnpBankCode = "VNPAYQR";
const String vnpIpAddr = "127.0.0.1";
const String vnpLocale = "vn";
const String vnpOrderType = "other";
const String vnpHashSecret = "ES0GDAPN8ANDCO99ZDNR76CBXQ3LQJ4E";

class VnPayPaymentRequest {
  final int vnpAmount;
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
    final Map<String, String> vnpParams = {
      'vnp_Amount': (paymentRequest.vnpAmount).toString(),
      'vnp_Command': 'pay',
      'vnp_CreateDate': paymentRequest.vnpCreateDate,
      'vnp_CurrCode': 'VND',
      'vnp_IpAddr': '127.0.0.1',
      'vnp_Locale': 'vn',
      'vnp_OrderInfo': paymentRequest.vnpOrderInfo,
      'vnp_OrderType': 'other',
      'vnp_ReturnUrl': paymentRequest.vnpReturnUrl,
      'vnp_TmnCode': vnpTmnCode,
      'vnp_TxnRef': DateTime.now().millisecondsSinceEpoch.toString(),
      'vnp_Version': '2.1.0',
    };

    final List<String> fieldNames = vnpParams.keys.toList()..sort();

    // Tạo chuỗi hash
    final StringBuffer hashData = StringBuffer();
    for (var field in fieldNames) {
      if (vnpParams[field]!.isNotEmpty) {
        hashData.write('$field=${vnpParams[field]}&');
      }
      print(field);
    }

    String hashDataString = "";

    if (hashData.toString().endsWith('&')) {
      hashDataString = hashData.toString().substring(0, hashData.toString().length - 1);
    }
    // secureHash += vnpHashSecret;

    print("HashData: $hashDataString");

    // Tạo HMAC-SHA512
    final key = utf8.encode(vnpHashSecret);
    final bytes = utf8.encode(hashDataString);
    final hmacSha512 = Hmac(sha512, key);
    final digest = hmacSha512.convert(bytes);
    final vnpSecureHash = digest.toString();

    // Thêm secure hash vào params
    vnpParams['vnp_SecureHash'] = vnpSecureHash;

    // Tạo URL với tất cả các tham số
    final StringBuffer queryUrl = StringBuffer('$vnpUrl?');
    vnpParams.forEach((key, value) {
      queryUrl.write('$key=${Uri.encodeComponent(value)}&');
    });

    // Xóa dấu & cuối cùng
    String finalUrl = queryUrl.toString();
    if (finalUrl.endsWith('&')) {
      finalUrl = finalUrl.substring(0, finalUrl.length - 1);
    }

    print(finalUrl);

    return finalUrl;
  }
}
