class UserCreationResponse {
  String? id;
  String? firebaseUid;
  String? fullName;
  String? phoneNumber;
  String? email;
  String? password;
  String? dob;
  String? gender;
  String? avatarUrl;
  String? createdAt;

  UserCreationResponse(
      {this.id,
        this.firebaseUid,
        this.fullName,
        this.phoneNumber,
        this.email,
        this.password,
        this.dob,
        this.gender,
        this.avatarUrl,
        this.createdAt});

  UserCreationResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firebaseUid = json['firebase_uid'];
    fullName = json['fullName'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    password = json['password'];
    dob = json['dob'];
    gender = json['gender'];
    avatarUrl = json['avatarUrl'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firebase_uid'] = this.firebaseUid;
    data['fullName'] = this.fullName;
    data['phoneNumber'] = this.phoneNumber;
    data['email'] = this.email;
    data['password'] = this.password;
    data['dob'] = this.dob;
    data['gender'] = this.gender;
    data['avatarUrl'] = this.avatarUrl;
    data['createdAt'] = this.createdAt;
    return data;
  }
}