import 'package:flutter/material.dart';
import 'package:ihapp/widgets/custom_text.dart';

import '../consts/paddings.dart';

Widget customOutlinedButton({
  required final VoidCallback onPressed,
  required final String title,
  required final BuildContext context,
  final Color? backgroundColor,
  final Color? textColor,
  final Color? borderColor,
}) {
  return OutlinedButton(
    onPressed: onPressed,
    style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith(
            (states) => backgroundColor ?? Colors.transparent),
        side: MaterialStateProperty.resolveWith((states) =>
            BorderSide(width: 2, color: borderColor ?? Colors.black))),
    child: Padding(
      padding: verticalPadding20 / 1.5,
      child: CustomTextWidget(
        text: title,
        textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: textColor,
            ),
      ),
    ),
  );
}

class CustomOutlinedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String title;
  final Color? backgroundColor;
  final Color? textColor;
  const CustomOutlinedButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.backgroundColor,
    this.textColor,
  });

  @override
  State<CustomOutlinedButton> createState() => _CustomOutlinedButtonState();
}

class _CustomOutlinedButtonState extends State<CustomOutlinedButton> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: widget.onPressed,
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith(
              (states) => widget.backgroundColor ?? Colors.transparent),
          side: MaterialStateProperty.resolveWith(
              (states) => const BorderSide(width: 2))),
      child: Padding(
        padding: verticalPadding20 / 1.5,
        child: CustomTextWidget(
          text: widget.title,
          textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: widget.textColor,
              ),
        ),
      ),
    );
  }
}
