import 'package:flutter/material.dart';
import 'package:ihapp/functions/custom_functions.dart';
import 'package:ihapp/pages/kullanici/ihalar/iha_cardwidget.dart';

import '../../../consts/paddings.dart';
import '../../../widgets/custom_text.dart';
import 'iha_ekleme_widget.dart';

class IhaEklemeCard extends StatefulWidget {
  final String userUid;
  const IhaEklemeCard({super.key, required this.userUid});

  @override
  State<IhaEklemeCard> createState() => _IhaEklemeCardState();
}

class _IhaEklemeCardState extends State<IhaEklemeCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        GoPagePush(
            widget: IhaEklemeWidget(userIid: widget.userUid), context: context);
      },
      child: Card(
        child: Padding(
          padding: allPadding20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              customText(context: context, text: 'İHA EKLE'),
              Padding(
                padding: horizantalPadding20,
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
