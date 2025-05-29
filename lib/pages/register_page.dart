import 'package:chat_scholar/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../helper/show_snack_bar.dart';
import '../widgets/build_popup_menu.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  static String id = "RegisterPage";

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? email, password;
  GlobalKey<FormState> formKey = GlobalKey();
  bool isLoading = false;

  // Email validation function (only checks format)
  String? validateEmail(String? value) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value!)) {
      return 'Invalid email format';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      progressIndicator: const CircularProgressIndicator(color: kPrimaryColor),
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          elevation: 0,
          actions: [
            buildPopupMenu(context),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                const SizedBox(height: 90),
                Image.asset(kPathLogo, height: 100),
                const Row(
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
                const SizedBox(height: 60),
                const Text(
                  "Register",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  onChanged: (data) {
                    email = data;
                  },
                  hintText: "Email",
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  onChanged: (data) {
                    password = data;
                  },
                  hintText: "Password",
                  obscureText: true,
                ),
                const SizedBox(height: 30),
                CustomButton(
                  text: 'Register',
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                      });
                      try {
                        await RegisterUser();
                        showSnackBar(
                          context,
                          "Account created successfully",
                          color: Colors.green,
                        );
                        Navigator.pop(context);
                      } on FirebaseAuthException catch (e) {
                        String message;
                        if (e.code == 'weak-password') {
                          message = "The password is too weak";
                        } else if (e.code == 'email-already-in-use') {
                          message = "The email is already in use";
                        } else if (e.code == 'invalid-email') {
                          message = "Invalid email format";
                        } else {
                          message = "Error: ${e.message}";
                        }
                        showSnackBar(context, message, color: Colors.red);
                      } catch (e) {
                        showSnackBar(
                          context,
                          "An unexpected error occurred",
                          color: Colors.red,
                        );
                      }
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: Color(0xffc7ede6),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Future<void> RegisterUser() async {
     final credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
          email: email!,
          password: password!,
        );
  }
}
