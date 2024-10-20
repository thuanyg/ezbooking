class UserCreation {
  String? fullName;
  String? email;
  String? password;

  UserCreation(
      {required this.fullName, required this.email, required this.password});

  UserCreation fromJson(Map<String, dynamic> json) {
    return UserCreation(
      fullName: json["fullName"],
      email: json["email"],
      password: json["password"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "fullName": fullName,
      "email": email,
      "password": password,
    };
  }
}
