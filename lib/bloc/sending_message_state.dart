part of 'sending_message_cubit.dart';

@immutable
abstract class SendingMessageState {}

class SendingMessageInitial extends SendingMessageState {}

class SendingMessageInProgress extends SendingMessageState {}

class SendingMessageSuccess extends SendingMessageState {
  SendingMessageSuccess({required this.response});

  final Map<String, dynamic> response;
}

class SendingMessageFailure extends SendingMessageState {
  SendingMessageFailure({required this.error});

  final String error;
}
