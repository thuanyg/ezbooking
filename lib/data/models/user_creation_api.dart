class UserCreationApi {
  String? firebaseUid;
  String? fullName;
  String? phoneNumber;
  String? email;
  String? password;
  String? dob;
  String? gender;
  String? avatarUrl;

  UserCreationApi(
      {this.firebaseUid,
        this.fullName,
        this.phoneNumber,
        this.email,
        this.password,
        this.dob,
        this.gender,
        this.avatarUrl});

  UserCreationApi.fromJson(Map<String, dynamic> json) {
    firebaseUid = json['firebase_uid'];
    fullName = json['fullName'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    password = json['password'];
    dob = json['dob'];
    gender = json['gender'];
    avatarUrl = json['avatarUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firebase_uid'] = this.firebaseUid;
    data['fullName'] = this.fullName;
    data['phoneNumber'] = this.phoneNumber;
    data['email'] = this.email;
    data['password'] = this.password;
    data['dob'] = this.dob;
    data['gender'] = this.gender;
    data['avatarUrl'] = this.avatarUrl;
    return data;
  }
}