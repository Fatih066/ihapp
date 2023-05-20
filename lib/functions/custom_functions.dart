import 'package:flutter/material.dart';

void GoPagePush({required Widget widget, required BuildContext context}) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) {
        return widget;
      },
    ),
  );
}

void GoPagePushReplacement(
    {required Widget widget, required BuildContext context}) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (context) {
        return widget;
      },
    ),
  );
}
