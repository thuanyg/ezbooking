import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? email;
  String? fullName;
  String? password;
  String? avatarUrl;
  String? phoneNumber;
  String? gender;
  String? birthday;
  Timestamp? createdAt;

  UserModel({
    this.id,
    this.email,
    this.fullName,
    this.password,
    this.avatarUrl,
    this.phoneNumber,
    this.gender,
    this.createdAt,
    this.birthday,
  });

  // Convert UserModel instance to a Map for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'password': password,
      'avatarUrl': avatarUrl,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'createdAt': createdAt,
      "birthday": birthday,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String?,
      email: json['email'] as String?,
      fullName: json['fullName'] as String?,
      password: json['password'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      gender: json['gender'] as String?,
      createdAt: json['createdAt'] as Timestamp?,
      birthday: json['birthday'] as String?,
    );
  }
}
