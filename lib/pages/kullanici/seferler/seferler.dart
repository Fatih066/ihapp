import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ihapp/consts/paddings.dart';
import 'package:ihapp/firebase/auth.dart';
import 'package:ihapp/firebase/firestore.dart';
import 'package:ihapp/pages/kullanici/seferler/sefer_model.dart';
import 'package:ihapp/widgets/custom_text.dart';

import '../../../enums/enums.dart';
import '../../../widgets/custom_circleavatar.dart';

class Seferler extends StatefulWidget {
  const Seferler({super.key});

  @override
  State<Seferler> createState() => _SeferlerState();
}

class _SeferlerState extends State<Seferler> {
  User? user = Auth().currentUser;
  late Future<SeferModelItems> list;
  bool isLoading = true;
  @override
  void initState() {
    list = fetchSeferModels(userUid: user!.uid).whenComplete(() {
      setState(() {
        isLoading =
            false; // Veri yükleme tamamlandığında ilerleme durumunu güncelle
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
          ))
        : FutureBuilder<SeferModelItems>(
            future: list,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // return CircularProgressIndicator(); // Veri yüklenirken bir yüklenme göstergesi gösterilebilir.
              } else if (snapshot.hasError) {
                return Text(
                    'Hata: ${snapshot.error}'); // Hata durumunda bir hata mesajı gösterilebilir.
              } else if (snapshot.hasData) {
                SeferModelItems seferModelItems = snapshot.data!;
                List<SeferModel> seferModels = seferModelItems.seferModelList;
                return ListView.builder(
                  itemCount: seferModels.length,
                  itemBuilder: (context, index) {
                    SeferModel seferModel = seferModels[index];
                    return InkWell(
                      onTap: () async {
                        if (seferModel.seferName != null) {
                          await FireStore().getLocationInfo(
                              userUid: user!.uid,
                              seferName: seferModel.seferName!);
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
                                  context: context,
                                  text: seferModel.seferName ?? ''),
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
