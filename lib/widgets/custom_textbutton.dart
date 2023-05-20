import 'package:flutter/material.dart';
import 'package:ihapp/widgets/custom_text.dart';

Widget customTextButton(
    {required VoidCallback onpressed, required String text}) {
  return TextButton(
      onPressed: onpressed,
      child: Text(
        text,
      ));
}
