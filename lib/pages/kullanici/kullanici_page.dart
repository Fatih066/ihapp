import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ihapp/firebase/auth.dart';
import 'package:ihapp/pages/kullanici/seferler/seferler.dart';
import 'package:ihapp/pages/kullanici/yayinlar/yayinlar.dart';

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

  int _currentIndex = 0;
  late final pages;

  @override
  void initState() {
    pages = [
      //Ihalarim(userUid: user!.uid),
      const Seferler(),
      const Yayinlar(),
    ];
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: 'Seferler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emergency_recording_outlined),
            label: 'Yayınlar',
          ),
        ],
      ),
      body: pages[_currentIndex],
    );
  }
}
