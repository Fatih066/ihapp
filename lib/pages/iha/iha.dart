import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ihapp/pages/iha/sefer_olustur.dart';

import '../../firebase/auth.dart';
import '../../location/get_location.dart';

class IhaPage extends StatefulWidget {
  const IhaPage({super.key});

  @override
  State<IhaPage> createState() => _IhaPageState();
}

class _IhaPageState extends State<IhaPage> {
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
      body: const SeferOlursutr(),
    );
  }
}
