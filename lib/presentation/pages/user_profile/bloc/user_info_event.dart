abstract class UserInfoEvent {}

class FetchUserInfo extends UserInfoEvent {
  final String uid;

  FetchUserInfo(this.uid);
}
