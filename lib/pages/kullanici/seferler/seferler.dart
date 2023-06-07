import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ihapp/consts/paddings.dart';
import 'package:ihapp/firebase/auth.dart';
import 'package:ihapp/functions/custom_functions.dart';
import 'package:ihapp/pages/kullanici/seferler/google_maps.dart';
import 'package:ihapp/pages/kullanici/seferler/sefer_model.dart';
import 'package:ihapp/widgets/custom_text.dart';
import 'package:ihapp/firebase/firestore.dart';

import '../../../widgets/custom_circleavatar.dart';

class Seferler extends StatefulWidget {
  const Seferler({super.key});

  @override
  State<Seferler> createState() => _SeferlerState();
}

class _SeferlerState extends State<Seferler> {
  User? user = Auth().currentUser;
  bool isLoading = true;
  late Stream<QuerySnapshot<Object?>> snapshot;
  late FireStore fireStore;

  @override
  void initState() {
    fireStore = FireStore();
    snapshot = fireStore.getSeferlerSnapshot(userUid: user!.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: snapshot,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
          );
        } else if (snapshot.hasError) {
          return ErrorWidget(snapshot.error!);
        } else if (snapshot.hasData) {
          SeferModelItems seferModelItems =
              fetchSeferModels(querySnapshot: snapshot.requireData);
          List<SeferModel> seferModels = seferModelItems.seferModelList;
          return ListView.builder(
            itemCount: seferModels.length,
            itemBuilder: (context, index) {
              SeferModel seferModel = seferModels[index];
              return InkWell(
                onTap: () async {
                  if (seferModel.seferName != null) {
                    GoPagePush(
                        widget: GoogleMaps(seferName: seferModel.seferName!),
                        context: context);
                  }
                },
                child: Card(
                  margin: allPadding20 / 2,
                  child: Padding(
                    padding: allPadding20 / 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CustomCircleAvatar(),
                        customText(
                            context: context, text: seferModel.seferName ?? ''),
                        const Icon(
                          Icons.keyboard_arrow_right_outlined,
                          size: 40,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
        return Container();
      },
    );
  }
}
