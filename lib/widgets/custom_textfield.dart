import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../consts/radius.dart';

Widget customTextField({
  required TextEditingController controller,
  required String title,
  Widget? suffixIcon,
  IconData? prefixIconData,
  bool? obscureText,
  TextInputAction? textInputAction,
  TextInputType? textInputType,
}) {
  return TextField(
    controller: controller,
    obscureText: obscureText ?? false,
    autofocus: false,
    textInputAction: textInputAction,
    keyboardType: textInputType,
    decoration: InputDecoration(
        labelText: title,
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: RadiusUtility().allCircular20,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.amber),
          borderRadius: RadiusUtility().allCircular20,
        ),
        suffixIcon: suffixIcon,
        prefixIcon: Icon(prefixIconData)),
  );
}
