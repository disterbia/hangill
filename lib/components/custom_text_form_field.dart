import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String hint;
  final funValidator;
  final controller;
  final funSubmit;
  final disable;

  const CustomTextFormField({
    required this.hint,
    this.funValidator,
    this.controller,
    this.funSubmit,
    this.disable
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(width: 150,height: 50,
        child: TextFormField(onFieldSubmitted:(v) {
          funSubmit();
        },
          enabled: disable==true?false:true,
          controller: controller,
          validator: funValidator,
          obscureText: hint == "Password" ? true : false,
          decoration: InputDecoration(
            hintText: hint,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }
}
