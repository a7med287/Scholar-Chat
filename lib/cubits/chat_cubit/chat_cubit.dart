

import 'package:chat_scholar/cubits/chat_cubit/chat_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatCubit extends Cubit<ChatStates>{
  ChatCubit():super(ChatInitial());
}