import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ihapp/firebase/auth.dart';
import 'package:ihapp/pages/kullanici/seferler/seferler.dart';

class KullaniciHomePage extends StatefulWidget {
  const KullaniciHomePage({super.key});

  @override
  State<KullaniciHomePage> createState() => _KullaniciHomePageState();
}

class _KullaniciHomePageState extends State<KullaniciHomePage> {
  User? user = Auth().currentUser;
  Future<void> signOut() async {
    await Auth().signOut();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: signOut,
            icon: const Icon(
              Icons.logout_outlined,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: const Seferler(),
    );
  }
}
