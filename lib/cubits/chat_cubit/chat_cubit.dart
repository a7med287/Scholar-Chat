import 'package:chat_scholar/cubits/chat_cubit/chat_states.dart';
import 'package:chat_scholar/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants.dart';

class ChatCubit extends Cubit<ChatStates> {
  ChatCubit() : super(ChatInitial());

  CollectionReference messages = FirebaseFirestore.instance.collection(
    kMessagesCollection,
  );
  List<MessageModel> messagesList =[] ;
  void sendMessage({required String sendMessage, required String email}) {
    messages.add({
      kMessage: sendMessage,
      kCreatedAt: DateTime.now(),
      "id": email,
    });
  }

  void getMeassage(){
    messages.orderBy(kCreatedAt, descending: true).snapshots().listen((event) {
     messagesList.clear();
      for(var doc in event.docs){
        messagesList.add(MessageModel.fromJson(doc));
      }
      emit(ChatSuccess(messagesList: messagesList));
    },);
  }
}
