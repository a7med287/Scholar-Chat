import 'package:chat_scholar/cubits/login_cubit/login_states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitial());

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(LoginFailure(errorMessage: "No user found for that email."));
      } else if (e.code == 'wrong-password') {
        emit(LoginFailure(errorMessage: "Wrong password"));
      } else {
        emit(LoginFailure(errorMessage: "Password or Email is Not correct"));
      }
    } catch (e) {
      emit(LoginFailure(errorMessage: "something went wrong"));
    }
  }
}
