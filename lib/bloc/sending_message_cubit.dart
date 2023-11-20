import 'package:contacts_form/dio/dio_send_message.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'sending_message_state.dart';

class SendingMessageCubit extends Cubit<SendingMessageState> {
  SendingMessageCubit(this.dioSendMessage) : super(SendingMessageInitial());

  final DioSendMessage dioSendMessage;

  void sendMessage(String name, String email, String message) async {
    emit(SendingMessageInProgress());
    final response = await dioSendMessage.sendMessage(name, email, message);
    await Future.delayed(const Duration(seconds: 2));
    if (response.containsKey('success')) {
      emit(SendingMessageSuccess(response: response));
    } else {
      emit(SendingMessageFailure(error: response['error']));
    }
  }
}
