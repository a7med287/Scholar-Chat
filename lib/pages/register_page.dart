import 'package:chat_scholar/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});
  static String id = "RegisterPage";

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? email, password;

  GlobalKey<FormState> formKey = GlobalKey();

  bool isLoading =false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      progressIndicator: CircularProgressIndicator(color: kPrimaryColor,),

      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: formKey ,
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
                  "Register",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                CustomTextField(
                  onChanged: (data) {
                    email = data;
                  },
                  hintText: "Email",
                ),
                SizedBox(height: 10),
                CustomTextField(
                  onChanged: (data) {
                    password = data;
                  },
                  hintText: "Password",
                  obscureText: true,
                ),
                SizedBox(height: 30),
                CustomButton(
                  text: 'Register',
                  onTap: () async {
                   if(formKey.currentState!.validate()){
                     isLoading=true;
                     setState(() {

                     });
                     try {
                       await RegisterUser();
                       showSnackBar(context, "Created Success",color: Colors.green);
                       Navigator.pop(context);
                     } on FirebaseAuthException catch (e) {
                       //The password provided is too weak. The account already exists for that email
                       if (e.code == 'weak-password') {
                         showSnackBar(context,"The password provided is too weak.",color: Colors.red);
                       } else if (e.code == 'email-already-in-use') {
                         showSnackBar(context, "The email already exists",color: Colors.red);
                       }
                     } catch (e) {
                       showSnackBar(context, "there is an error",color: Colors.red);
                     }
                     isLoading =false;
                     setState(() {

                     });
                   }
                  },
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "already have an account ? ",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        " Login",
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

  void showSnackBar(BuildContext context,String message,{color}) {
     ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor:color,
        content: Text(message),
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
