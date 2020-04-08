import 'package:firebase_database/firebase_database.dart';

class RealTimeFirebase {
  String key;
  String email1;
  String email2;
  String image1;
  String image2;
  String text;
  String read;

  RealTimeFirebase(
      this.email1, this.email2, this.image1, this.image2, this.text, this.read);
  RealTimeFirebase.fromSnapshot(DataSnapshot snapshot) {
    key = snapshot.key;
    email1 = snapshot.value['from'];
    email2 = snapshot.value['to'];
    image1 = snapshot.value['image1'];
    image2 = snapshot.value['image2'];
    text = snapshot.value['text'];
    read = snapshot.value['read'];
  }
  toJson() {
    return {
      "from": email1,
      "to": email2,
      "image1": image1,
      "image2": image2,
      "text": text,
      "read": read,
    };
  }
}
