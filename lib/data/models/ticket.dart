class Ticket {
  final String id;
  final String orderID;
  final String eventID;
  final String userID;
  final String? seatNumber; // Có thể null nếu vé không có số ghế cố định
  final double ticketPrice;
  final String ticketType;
  final String status; // Trạng thái (Available, Sold, Checked-In, Cancelled)
  final String qrCodeData; // Dữ liệu QR code
  final DateTime createdAt; // Thời gian phát hành
  final DateTime? usedAt; // Thời gian check-in (nếu đã check-in)
  final DateTime? cancellationDate; // Thời gian hủy vé (nếu có)

  Ticket({
    required this.id,
    required this.orderID,
    required this.eventID,
    required this.userID,
    this.seatNumber,
    required this.ticketPrice,
    required this.ticketType,
    required this.status,
    required this.qrCodeData,
    required this.createdAt,
    this.usedAt,
    this.cancellationDate,
  });

  // Chuyển từ Firestore Document Snapshot sang Ticket object
  factory Ticket.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Ticket(
      id: documentId,
      orderID: data['orderID'] ?? '',
      eventID: data['eventID'] ?? '',
      userID: data['userID'] ?? '',
      seatNumber: data['seatNumber'],
      ticketPrice: (data['ticketPrice'] ?? 0).toDouble(),
      ticketType: data['ticketType'] ?? '',
      status: data['status'] ?? '',
      qrCodeData: data['qrCodeData'] ?? '',
      createdAt: DateTime.parse(data['createdAt']), // Firestore lưu dưới dạng ISO8601
      usedAt: data['usedAt'] != null ? DateTime.parse(data['usedAt']) : null,
      cancellationDate: data['cancellationDate'] != null
          ? DateTime.parse(data['cancellationDate'])
          : null,
    );
  }

  // Chuyển từ Ticket object sang Map để lưu vào Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'orderID': orderID,
      'eventID': eventID,
      'userID': userID,
      'seatNumber': seatNumber,
      'ticketPrice': ticketPrice,
      'ticketType': ticketType,
      'status': status,
      'qrCodeData': qrCodeData,
      'createdAt': createdAt.toIso8601String(),
      'usedAt': usedAt?.toIso8601String(),
      'cancellationDate': cancellationDate?.toIso8601String(),
    };
  }
}
