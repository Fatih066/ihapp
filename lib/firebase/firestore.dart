import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

import '../enums/enums.dart';

class FireStore {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Kullanıcı bilgileri kayıt etme firestore
  Future<void> setUserInfos({
    required String userUid,
    required String name,
    required String phoneNumber,
    required String email,
    required String password,
    required bool isUser,
  }) async {
    final usersRef = await _firestore.collection(
        isUser == true ? Collections.Users.name : Collections.Ihas.name);
    final userInfos = {
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'password': password,
    };
    final ihaInfos = {
      'name': name,
      'model': phoneNumber,
      'email': email,
      'password': password,
    };
    usersRef.doc(userUid).set(isUser == true ? userInfos : ihaInfos);
  }

  //Firestore kullanıcı olup olmadığını sorgulama
  Future<bool?> isUser(String uid) async {
    bool? isUser;

    final usersRef = await _firestore.collection(Collections.Users.name);
    final ihasRef = await _firestore.collection(Collections.Ihas.name);

    //User koleksiyonun verilerinde bu uid var mı
    final userUidDatas = await usersRef.get();
    final userList = userUidDatas.docs;

    //İhas koleksiyonun verilerinde bu uid var mı
    final ihasUidDatas = await ihasRef.get();
    final ihasList = ihasUidDatas.docs;

    if (userList.isNotEmpty) {
      for (var i = 0; i < userList.length; i++) {
        if (userList[i].id == uid) {
          return isUser = true;
        } else {
          isUser = false;
        }
      }
    } else if (ihasList.isNotEmpty) {
      for (var i = 0; i < ihasList.length; i++) {
        if (ihasList[i].id == uid) {
          return isUser = true;
        } else {
          isUser = false;
        }
      }
    }
    return isUser;
  }

  Stream<QuerySnapshot> getSeferlerSnapshot({required String userUid}) {
    final collectionReference = FirebaseFirestore.instance
        .collection(Collections.Users.name)
        .doc(userUid)
        .collection(Collections.Seferler.name);
    final querySnapshot = collectionReference.snapshots();
    return querySnapshot;
  }

  //Firestroye konum bilgileri kaydetme
  Future<void> setUserLocationInfos({
    required String userUid,
    required Position? position,
    required String tarih,
    required String seferName,
  }) async {
    final usersRef = await _firestore
        .collection(Collections.Users.name)
        .doc(userUid)
        .collection(Collections.Seferler.name)
        .doc(seferName);

//veriler okunmadığı için
    await usersRef.set({
      'veri sağla': 'sağlandı',
    });

    final gecmisRef = await usersRef
        .collection(Collections.Konumlar.name)
        .doc(Documents.Gecmis.name);
    final guncelRef = await usersRef
        .collection(Collections.Konumlar.name)
        .doc(Documents.Guncel.name);
    //Konum bilgilerinin map hali
    var userPositionInfos;
    if (position != null) {
      userPositionInfos = {
        'lat': position.latitude,
        'lon': position.longitude,
        'speed': position.speed * 3.6,
        'tarih': 't_$tarih',
      };
    }
    //Güncel konum kaydetme
    await guncelRef.set(userPositionInfos);
    //Geçmiş konum ekleme
    await gecmisRef
        .collection(Collections.Konumlar.name)
        .doc('t_$tarih')
        .set(userPositionInfos);
  }

  //Güncel konum alma
  Future<Stream<DocumentSnapshot<Map<String, dynamic>>>> getLocationGuncel(
      {required String userUid, required String seferName}) async {
    Stream<DocumentSnapshot<Map<String, dynamic>>> location;

    location = await _firestore
        .collection(Collections.Users.name)
        .doc(userUid)
        .collection(Collections.Seferler.name)
        .doc(seferName)
        .collection(Collections.Konumlar.name)
        .doc(Documents.Guncel.name)
        .snapshots();

    return location;
  }

  Future<String?> getGuncelTime(
      {required String userUid, required String seferName}) async {
    String? tarih;
    final usersRef = await _firestore
        .collection(Collections.Users.name)
        .doc(userUid)
        .collection(Collections.Seferler.name)
        .doc(seferName)
        .collection(Collections.Konumlar.name)
        .doc(Documents.Guncel.name)
        .get();
    if (usersRef.exists) {
      tarih = usersRef.get("tarih").toString();
    }
    return tarih;
  }

  //Geçmiş konum verilerini  çekme
  Future<List<Map<String, dynamic>>> getLocationInfoPast(
      {required String userUid, required String seferName}) async {
    List<Map<String, dynamic>> location = [];
    final usersRef = await _firestore
        .collection(Collections.Users.name)
        .doc(userUid)
        .collection(Collections.Seferler.name)
        .doc(seferName)
        .collection(Collections.Konumlar.name)
        .doc(Documents.Gecmis.name)
        .collection(Collections.Konumlar.name)
        .get();

    usersRef.docs.forEach((element) {
      location.add(element.data());
    });

    return location;
  }

  Future<void> addIha({
    required String ihaName,
    required String? ihaUid,
    required String? userUid,
    required String ihaModel,
    required String ihaOwnerUid,
  }) async {
    final ihasRef = _firestore.collection(Collections.Ihas.name);
    final userRef = _firestore.collection(Collections.Users.name);

    //İha koleksiyon oluşturma
    Map<String, Object> ihaInfos = {};
    if (ihaUid != null) {
      ihaInfos = {
        'ihaName': ihaName,
        'ihaModel': ihaModel,
        'ihaOwnerUid': ihaOwnerUid,
      };
      ihasRef.doc(ihaUid).set(ihaInfos);
    }

    //İhayı users koleksiyonun uidsinin altına ekleme
    if (userUid != null && ihaUid != null) {
      userRef.doc(userUid).collection(Collections.Ihalarim.name).doc(ihaUid);
    }
  }
}
