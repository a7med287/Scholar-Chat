import 'package:chat_scholar/constants.dart';
import 'package:chat_scholar/cubits/register_cubit/register_cubit.dart';
import 'package:chat_scholar/cubits/register_cubit/register_states.dart';
import 'package:chat_scholar/helper/show_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../widgets/build_popup_menu.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});
  static String id = "RegisterPage";

  String? email, password;
  GlobalKey<FormState> formKey = GlobalKey();
  bool isLoading = false;

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
    return BlocConsumer<RegisterCubit,RegisterStates>(
      listener: (BuildContext context, Object? state) {
        if (state is RegisterLoading) {
          isLoading = true;
        } else if (state is RegisterSuccess) {
          Navigator.pop(context);
          showSnackBar(context, "Register Success", color: Colors.green);
          isLoading = false;
        } else if (state is RegisterFailure) {
          showSnackBar(context, state.errMessage, color: Colors.red);
          isLoading = false;
        }
      },
      builder: (BuildContext context, state) {
        return ModalProgressHUD(
          progressIndicator: const CircularProgressIndicator(
            color: kPrimaryColor,
          ),
          inAsyncCall: isLoading,
          child: Scaffold(
            backgroundColor: kPrimaryColor,
            appBar: AppBar(
              backgroundColor: kPrimaryColor,
              elevation: 0,
              actions: [buildPopupMenu(context)],
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
                          BlocProvider.of<RegisterCubit>(
                            context,
                          ).RegisterUser(email: email!, password: password!);
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
      },
    );
  }
}
