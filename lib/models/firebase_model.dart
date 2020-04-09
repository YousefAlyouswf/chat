import 'package:firebase_database/firebase_database.dart';

class RealTimeFirebase {
  String key;
  String email1;
  String email2;
  String typingTo;
  String text;
  String read;

  RealTimeFirebase(
      this.email1, this.email2, this.text, this.read, this.typingTo);
  RealTimeFirebase.fromSnapshot(DataSnapshot snapshot) {
    key = snapshot.key;
    email1 = snapshot.value['from'];
    email2 = snapshot.value['to'];
    text = snapshot.value['text'];
    read = snapshot.value['read'];
  }
  toJson() {
    return {
      "from": email1,
      "to": email2,
      "text": text,
      "read": read,
    };
  }
}
