import 'package:chat_scholar/cubits/login_cubit/login_states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit {
  LoginCubit() : super(LoginInitial());


  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());
   try{
     await FirebaseAuth.instance.signInWithEmailAndPassword(
       email: email,
       password: password,
     );
     emit(LoginSuccess());
   }catch(e){
     emit(LoginFailure());
   }
  }
}
