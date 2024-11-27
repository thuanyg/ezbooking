import 'package:cloud_firestore/cloud_firestore.dart';

class Organizer {
  String? id;
  String? name;
  String? email;
  String? address;
  String? phoneNumber;
  String? facebook;
  String? website;
  String? avatarUrl;
  Timestamp? createdAt;

  Organizer({
    this.id,
    this.name,
    this.email,
    this.address,
    this.phoneNumber,
    this.facebook,
    this.website,
    this.avatarUrl,
    this.createdAt,
  });

  factory Organizer.fromJson(Map<String, dynamic> json) {
    return Organizer(
      id: json['id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      facebook: json['facebook'] as String?,
      website: json['website'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      createdAt: json['createdAt'] as Timestamp?,
    );
  }

}
