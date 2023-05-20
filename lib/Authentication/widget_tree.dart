import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:ihapp/Authentication/login.dart';
import 'package:ihapp/firebase/auth.dart';
import 'package:ihapp/firebase/firestore.dart';
import 'package:ihapp/pages/iha/iha.dart';
import 'package:ihapp/pages/kullanici/kullanici_page.dart';

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return FutureBuilder(
            future: FireStore().isUser(snapshot.data!.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return snapshot.data == false ? IhaPage() : KullaniciHomePage();
              } else {
                return LoginPage();
              }
            },
          );
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
