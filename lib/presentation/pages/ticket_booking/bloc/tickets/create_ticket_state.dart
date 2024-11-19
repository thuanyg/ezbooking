abstract class CreateTicketState {}

class CreateTicketInitial extends CreateTicketState {}

class CreateTicketLoading extends CreateTicketState {}

class CreateTicketSuccess extends CreateTicketState {}

class CreateTicketFailure extends CreateTicketState {
  final String errorMessage;

  CreateTicketFailure(this.errorMessage);
}
