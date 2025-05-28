import 'package:flutter/material.dart';

import '../constants.dart';

class CustomButton extends StatelessWidget {
   CustomButton({
    this.onTap,
    super.key, required this.text,
  });
 final String text;
 VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10)
        ),
        child:
        Center(
          child: Text(
            text,
            style: TextStyle(
                fontSize: 24,
                color: kPrimaryColor,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }
}
