import 'package:firebase_storage/firebase_storage.dart';

class StorageVideo {
  FirebaseStorage reference = FirebaseStorage.instance;
  Future<String> getVideoUrl() async {
    String videoUrl = await reference
        .ref()
        .child("Videolar")
        .child("İhaGörünüt.mp4")
        .getDownloadURL();
    return videoUrl;
  }
}
