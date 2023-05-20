import 'package:flutter/material.dart';

import '../../../consts/paddings.dart';
import '../../../widgets/custom_circleavatar.dart';
import '../../../widgets/custom_text.dart';

class IhaCardWidget extends StatefulWidget {
  const IhaCardWidget({super.key});

  @override
  State<IhaCardWidget> createState() => _IhaCardWidgetState();
}

class _IhaCardWidgetState extends State<IhaCardWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Card(
        margin: allPadding20 / 2,
        child: Padding(
          padding: allPadding20 / 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomCircleAvatar(),
              Column(
                children: [
                  customText(
                    context: context,
                    text: 'Kuzgun',
                  ),
                  customText(
                    context: context,
                    text: '05124',
                  ),
                ],
              ),
              const Icon(
                Icons.keyboard_arrow_right_outlined,
                size: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
