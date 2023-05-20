import 'package:flutter/material.dart';

Widget customErrorMessage({String? errorMessage}) {
  return Text(errorMessage == '' ? '' : 'Humm ? $errorMessage');
}
