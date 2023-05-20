import 'package:flutter/material.dart';
import 'iha_cardwidget.dart';
import 'iha_ekleme_card.dart';

class Ihalarim extends StatefulWidget {
  final String userUid;
  const Ihalarim({super.key, required this.userUid});

  @override
  State<Ihalarim> createState() => _IhalarimState();
}

class _IhalarimState extends State<Ihalarim> {
  int itemCount = 5;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: itemCount,
              itemBuilder: (context, index) {
                if (index < itemCount - 1) {
                  return const IhaCardWidget();
                } else {
                  return IhaEklemeCard(
                    userUid: widget.userUid,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
