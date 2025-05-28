import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
   CustomTextField({
     this.onChanged,
     this.hintText,
     this.obscureText =false,
     this.controller,
    super.key,
  });
  Function(String)? onChanged;
  String ? hintText;
  bool? obscureText;
  TextEditingController? controller ;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText! ,
      validator: (data){
        if(data!.isEmpty){
          return "$hintText is requird";
        }
      },
      style: TextStyle(
        color: Colors.white
      ),
      onChanged: onChanged ,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.white
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
              color: Colors.white
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Colors.white
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Colors.white
          ),
        ),

      ),
    );
  }
}
