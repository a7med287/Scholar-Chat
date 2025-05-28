import 'package:chat_scholar/constants.dart';
import 'package:chat_scholar/pages/chat_page.dart';
import 'package:chat_scholar/pages/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});
  static String id = "LoginPage";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? email, password;

  GlobalKey<FormState> formKey = GlobalKey();

  bool isLoading = false;
 TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
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
                      setState(() {
                        isLoading = true;
                      });
                      try {
                        await loginUser();
                        Navigator.pushNamed(context, ChatPage.id,arguments: email);
                        _emailController.clear();
                        _passController.clear();
                      } on FirebaseAuthException catch (e) {
                        String errorMessage;
                        if (e.code == 'user-not-found') {
                          errorMessage = "No user found for that email.";
                          print(errorMessage);
                        } else if (e.code == 'wrong-password') {
                          errorMessage = "Wrong password provided for that user.";
                          print(errorMessage);
                        } else {
                          errorMessage = "Password or Email is Not correct";
                          print('FirebaseAuthException: ${e.code} - ${e.message}'); // Log the full error for debugging
                        }
                        showSnackBar(
                          context,
                          errorMessage,
                          color: Colors.red,
                        );
                      } catch (e) {
                        String errorMessage;
                        if (e.toString().contains('RecaptchaAction')) {
                          errorMessage = "Security verification failed. Please try again.";
                          print('Recaptcha verification failed: ${e.toString()}');
                          showSnackBar(
                            context,
                            errorMessage,
                            color: Colors.orange,
                          );
                        } else {
                          // Handle other generic errors
                          errorMessage = "An unexpected error occurred. Please try again.";
                          print('An unexpected error occurred: ${e.toString()}');
                          showSnackBar(
                            context,
                            errorMessage,
                            color: Colors.red,
                          );
                        }
                      } finally {
                        setState(() {
                          isLoading = false;
                        });
                      }
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
    );
  }

  void showSnackBar(BuildContext context, String message, {Color color = Colors.grey}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(child: Text(message)),
        backgroundColor: color,
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

