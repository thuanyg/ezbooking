abstract class PopularEventEvent {}

class FetchPopularEvent extends PopularEventEvent {
  final int? limit;

  FetchPopularEvent({this.limit});
}
