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
    final amount =
        (double.parse(paymentRequest.vnpAmount) * 100).round().toString();

    final Map<String, String> vnpParams = {
      'vnp_Amount': amount,
      'vnp_Command': vnpCommand,
      'vnp_CreateDate': paymentRequest.vnpCreateDate,
      'vnp_CurrCode': 'VND',
      'vnp_IpAddr': vnpIpAddr,
      'vnp_Locale': vnpLocale,
      'vnp_OrderInfo': paymentRequest.vnpOrderInfo,
      'vnp_OrderType': vnpOrderType,
      'vnp_ReturnUrl': paymentRequest.vnpReturnUrl,
      'vnp_TmnCode': vnpTmnCode,
      'vnp_TxnRef': paymentRequest.vnpTxnRef,
      'vnp_Version': vnpVersion,
      'vnp_BankCode': "",
    };

    // Sắp xếp các tham số theo thứ tự a-z
    final List<String> fieldNames = vnpParams.keys.toList()..sort();

    // Tạo chuỗi hash data theo đúng format của VNPay
    final StringBuffer hashData = StringBuffer();
    for (var fieldName in fieldNames) {
      if (vnpParams[fieldName]!.isNotEmpty) {
        if (hashData.isNotEmpty) {
          hashData.write('&');
        }
        hashData
            .write('$fieldName=${Uri.encodeComponent(vnpParams[fieldName]!)}');
      }
    }

    // Tạo chuỗi ký tự cần ký
    final String signData = hashData.toString();
    print(hashData);

    // Tạo chữ ký HMAC-SHA512
    final vnpSecureHash = Hmac(sha512, utf8.encode(vnpHashSecret))
        .convert(utf8.encode(signData))
        .toString();

    // Thêm secure hash vào params
    vnpParams['vnp_SecureHash'] = vnpSecureHash;

    // Tạo URL thanh toán
    final StringBuffer queryUrl = StringBuffer('$vnpUrl?');
    vnpParams.forEach((key, value) {
      if (value.isNotEmpty) {
        if (!queryUrl.toString().endsWith('?')) {
          queryUrl.write('&');
        }
        queryUrl.write('$key=${Uri.encodeComponent(value)}');
      }
    });

    print(queryUrl);

    return queryUrl.toString();
  }
}
