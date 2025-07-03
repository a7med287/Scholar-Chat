import 'package:chat_scholar/cubits/register_cubit/register_states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit(): super(RegisterInitial());

  Future<void> RegisterUser({
    required String email,
    required String password,
  }) async {
    emit(RegisterLoading());
    try {
     UserCredential user =  await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      emit(RegisterSuccess());
    }on FirebaseAuthException catch (e) {
      String errMessage;
      if (e.code == 'weak-password') {
        errMessage = "The password is too weak";
        emit(RegisterFailure(errMessage: errMessage));
      } else if (e.code == 'email-already-in-use') {
        errMessage = "The email is already in use";
        emit(RegisterFailure(errMessage: errMessage));
      } else if (e.code == 'invalid-email') {
        errMessage = "Invalid email format";
        emit(RegisterFailure(errMessage: errMessage));
      } else {
        errMessage = "Error: ${e.message}";
        emit(RegisterFailure(errMessage: errMessage));
      }
    } catch (e) {
      emit(RegisterFailure(errMessage: "Something wnt wrong"));
    }
  }
}
