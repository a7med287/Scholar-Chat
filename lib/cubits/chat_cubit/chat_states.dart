

import 'package:chat_scholar/models/message_model.dart';

abstract class ChatStates{}

class ChatInitial extends ChatStates{}
class ChatSuccess extends ChatStates{
  final List<MessageModel> messagesList ;

  ChatSuccess({required this.messagesList});
}