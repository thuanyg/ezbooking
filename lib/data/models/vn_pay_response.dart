class VnpayResponse {
  final String code;
  final String description;

  VnpayResponse(this.code, this.description);

  static VnpayResponse fromResponseCode(String responseCode) {
    switch (responseCode) {
      case '00':
        return VnpayResponse('00', 'Giao dịch thành công');
      case '07':
        return VnpayResponse('07',
            'Trừ tiền thành công. Giao dịch bị nghi ngờ (liên quan tới lừa đảo, giao dịch bất thường).');
      case '09':
        return VnpayResponse('09',
            'Giao dịch không thành công do: Thẻ/Tài khoản của khách hàng chưa đăng ký dịch vụ InternetBanking tại ngân hàng.');
      case '10':
        return VnpayResponse('10',
            'Giao dịch không thành công do: Khách hàng xác thực thông tin thẻ/tài khoản không đúng quá 3 lần.');
      case '11':
        return VnpayResponse('11',
            'Giao dịch không thành công do: Đã hết hạn chờ thanh toán. Xin quý khách vui lòng thực hiện lại giao dịch.');
      case '12':
        return VnpayResponse('12',
            'Giao dịch không thành công do: Thẻ/Tài khoản của khách hàng bị khóa.');
      case '13':
        return VnpayResponse('13',
            'Giao dịch không thành công do Quý khách nhập sai mật khẩu xác thực giao dịch (OTP). Xin quý khách vui lòng thực hiện lại giao dịch.');
      case '24':
        return VnpayResponse(
            '24', 'Giao dịch không thành công do: Khách hàng hủy giao dịch.');
      case '51':
        return VnpayResponse('51',
            'Giao dịch không thành công do: Tài khoản của quý khách không đủ số dư để thực hiện giao dịch.');
      case '65':
        return VnpayResponse('65',
            'Giao dịch không thành công do: Tài khoản của Quý khách đã vượt quá hạn mức giao dịch trong ngày.');
      case '75':
        return VnpayResponse('75', 'Ngân hàng thanh toán đang bảo trì.');
      case '79':
        return VnpayResponse('79',
            'Giao dịch không thành công do: KH nhập sai mật khẩu thanh toán quá số lần quy định. Xin quý khách vui lòng thực hiện lại giao dịch.');
      case '99':
        return VnpayResponse('99',
            'Các lỗi khác (lỗi còn lại, không có trong danh sách mã lỗi đã liệt kê).');
      default:
        return VnpayResponse('Unknown', 'Mã lỗi không xác định');
    }
  }
}
