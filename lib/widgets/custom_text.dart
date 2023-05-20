import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

Widget customText({
  final String? text,
  final TextStyle? textStyle,
  final TextAlign? textAlign,
  required final BuildContext context,
}) {
  return Text(
    textAlign: textAlign ?? TextAlign.left,
    text ?? '',
    style: textStyle ?? Theme.of(context).textTheme.titleLarge,
  );
}

class CustomTextWidget extends StatelessWidget {
  final String? text;
  final TextStyle? textStyle;
  final TextAlign? textAlign;
  const CustomTextWidget(
      {super.key, this.text, this.textStyle, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      textAlign: textAlign ?? TextAlign.left,
      text ?? '',
      style: textStyle ?? Theme.of(context).textTheme.titleLarge,
    );
  }
}
