import 'package:chat_scholar/constants.dart';
import 'package:chat_scholar/cubits/chat_cubit/chat_cubit.dart';
import 'package:chat_scholar/cubits/login_cubit/login_cubit.dart';
import 'package:chat_scholar/cubits/login_cubit/login_states.dart';
import 'package:chat_scholar/pages/chat_page.dart';
import 'package:chat_scholar/pages/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../helper/show_snack_bar.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  static String id = "LoginPage";
  String? email, password;
  GlobalKey<FormState> formKey = GlobalKey();

  bool isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginStates>(
      listener: (BuildContext context, state) {
        if (state is LoginLoading) {
          isLoading = true;
        } else if (state is LoginSuccess) {
          BlocProvider.of<ChatCubit>(context).getMeassage();
          Navigator.pushNamed(context, ChatPage.id,arguments: email);
          isLoading = false;
        } else if (state is LoginFailure) {
          showSnackBar(context, state.errorMessage, color: Colors.red);
        }
      },
      child: ModalProgressHUD(
        progressIndicator: CircularProgressIndicator(color: kPrimaryColor),
        inAsyncCall: isLoading,
        child: Scaffold(
          backgroundColor: kPrimaryColor,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: formKey,
              child: ListView(
                children: [
                  SizedBox(height: 90),
                  Image.asset(kPathLogo, height: 100),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Scholar Chat",
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontFamily: "Pacifico",
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 60),
                  Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    controller: _emailController,
                    onChanged: (data) {
                      email = data;
                    },
                    hintText: "Email",
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    controller: _passController,
                    onChanged: (data) {
                      password = data;
                    },
                    hintText: "Password",
                    obscureText: true,
                  ),
                  SizedBox(height: 30),
                  CustomButton(
                    text: 'Login',
                    onTap: () async {
                      if (formKey.currentState?.validate() ?? false) {
                        BlocProvider.of<LoginCubit>(
                          context,
                        ).loginUser(email: email!, password: password!);
                      }
                    },
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "don't have an account ? ",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, RegisterPage.id);
                        },
                        child: Text(
                          " Register",
                          style: TextStyle(
                            color: Color(0xffc7ede6),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20), // Added some bottom padding
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loginUser() async {
    if (email != null && password != null) {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email!,
        password: password!,
      );
    } else {
      throw Exception("Email or password is null");
    }
  }
}
