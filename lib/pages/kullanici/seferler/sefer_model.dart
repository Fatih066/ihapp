import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ihapp/enums/enums.dart';

class SeferModel {
  final String? seferName;

  SeferModel({
    this.seferName,
  });

  factory SeferModel.fromSnapshot(DocumentSnapshot snapshot) {
    return SeferModel(
      seferName: snapshot.id,
    );
  }
}

class SeferModelItems {
  late List<SeferModel> _seferModelList;

  List<SeferModel> get seferModelList => _seferModelList;

  SeferModelItems({required List<SeferModel> list}) {
    _seferModelList = list;
  }
}

Future<SeferModelItems> fetchSeferModels({required String userUid}) async {
  final collectionReference = await FirebaseFirestore.instance
      .collection(Collections.Users.name)
      .doc(userUid)
      .collection(Collections.Seferler.name);
  final querySnapshot = await collectionReference.get();
  print(querySnapshot.size);

  List<SeferModel> seferModels = [];

  querySnapshot.docs.forEach((doc) {
    if (doc.exists) {
      SeferModel seferModel = SeferModel.fromSnapshot(doc);
      seferModels.add(seferModel);
    }
  });

  SeferModelItems seferModelItems = SeferModelItems(list: seferModels);
  return seferModelItems;
}
