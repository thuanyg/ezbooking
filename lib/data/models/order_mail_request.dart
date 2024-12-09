class OrderMailRequest {
  String? email;
  OrderDetails? orderDetails;

  OrderMailRequest({this.email, this.orderDetails});

  OrderMailRequest.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    orderDetails = json['orderDetails'] != null
        ? new OrderDetails.fromJson(json['orderDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    if (this.orderDetails != null) {
      data['orderDetails'] = this.orderDetails!.toJson();
    }
    return data;
  }
}

class OrderDetails {
  String? orderID;
  String? customerName;
  String? customerEmail;
  List<Tickets>? tickets;
  int? totalAmount;

  OrderDetails(
      {this.orderID,
        this.customerName,
        this.customerEmail,
        this.tickets,
        this.totalAmount});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    orderID = json['orderID'];
    customerName = json['customerName'];
    customerEmail = json['customerEmail'];
    if (json['tickets'] != null) {
      tickets = <Tickets>[];
      json['tickets'].forEach((v) {
        tickets!.add(new Tickets.fromJson(v));
      });
    }
    totalAmount = json['totalAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderID'] = this.orderID;
    data['customerName'] = this.customerName;
    data['customerEmail'] = this.customerEmail;
    if (this.tickets != null) {
      data['tickets'] = this.tickets!.map((v) => v.toJson()).toList();
    }
    data['totalAmount'] = this.totalAmount;
    return data;
  }
}

class Tickets {
  String? name;
  int? quantity;
  int? price;

  Tickets({this.name, this.quantity, this.price});

  Tickets.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    quantity = json['quantity'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    return data;
  }
}