import 'package:flutter/material.dart';
import 'package:ihapp/widgets/custom_outlinedbuton.dart';
import 'package:ihapp/widgets/custom_textfield.dart';

import '../../location/get_location.dart';

class SeferOlursutr extends StatefulWidget {
  const SeferOlursutr({super.key});

  @override
  State<SeferOlursutr> createState() => _SeferOlursutrState();
}

class _SeferOlursutrState extends State<SeferOlursutr> {
  TextEditingController seferNameController = TextEditingController();
  TextEditingController kimeUidController = TextEditingController();

  bool obsocureText = true;

  IconData suffixIconData = Icons.remove_red_eye_outlined;

  Future<void> sendLocation() async {
    try {
      await GetLocation().sendLocation(
        context: context,
        userUid: 'ghm8Yi9tOnh4NsbDKxz1tVgma8f1',
        seferName: seferNameController.text.trim(),
      );
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          customTextField(
            controller: seferNameController,
            title: 'Name',
            textInputAction: TextInputAction.next,
          ),
          customTextField(
            controller: kimeUidController,
            title: 'E-mail Kime',
            textInputType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
          customOutlinedButton(
            onPressed: () async {
              await sendLocation();
            },
            title: 'Sefer Oluştur',
            context: context,
          ),
        ],
      ),
    );
  }
}
