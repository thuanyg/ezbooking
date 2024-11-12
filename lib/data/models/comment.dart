import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezbooking/data/models/user_model.dart';

class Comment {
  String id, userID, eventID;
  double rating;
  String content;
  Timestamp createdAt;

  // Option to show comment
  UserModel? userModel;

  Comment(
    this.id,
    this.userID,
    this.eventID,
    this.createdAt,
    this.rating,
    this.content,
    this.userModel,
  );

  factory Comment.fromJson(
      Map<String, dynamic> json, Map<String, dynamic> userJson) {
    return Comment(
      json["id"],
      json["userID"],
      json["eventID"],
      json["createdAt"] as Timestamp,
      json["rating"] as double,
      json["content"] as String,
      UserModel.fromJson(userJson),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userID': userID,
      "eventID": eventID,
      'createdAt': createdAt,
      "rating": rating,
      "content": content,
    };
  }
}
