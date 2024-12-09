import 'package:dio/dio.dart';
import 'package:ezbooking/data/models/order_mail_request.dart';

class MailService {
  static Future<void> sendOrderEmail(OrderMailRequest orderMail) async {
    const String apiUrl = 'https://htthuan.id.vn/ezbooking/sendOrderInfo.php';

    Map<String, dynamic> data = {
      'email': orderMail.email,
      'orderDetails': orderMail.orderDetails?.toJson(),
    };

    try {
      // Create Dio instance
      Dio dio = Dio();

      // Send POST request
      Response response = await dio.post(apiUrl, data: data);

      // Check the response status
      if (response.statusCode == 200) {
        final result = response.data;
        if (result['status'] == 'success') {
          print('Order email sent successfully');
        } else {
          print('Failed to send order email: ${result['message']}');
        }
      } else {
        print('Failed to connect to the server');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

}