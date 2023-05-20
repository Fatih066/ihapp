import 'package:flutter/material.dart';

import '../consts/strings.dart';

class CustomCircleAvatar extends StatelessWidget {
  final String? sourceImage;
  final double? radius;
  final Color? backgroundColor;
  const CustomCircleAvatar({
    super.key,
    this.sourceImage,
    this.radius,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: backgroundColor ?? Colors.amber,
      radius: radius ?? 40,
      backgroundImage: Image.asset(
        sourceImage ?? '${imageSource}iha.png',
        fit: BoxFit.cover,
      ).image,
    );
  }
}
