import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Fireebase {
  void exitFfromChat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Firestore.instance
        .collection('chat')
        .where('to', isEqualTo: prefs.getString('email'))
        .getDocuments()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents) {
        ds.reference.updateData({
          'onlineTo': '0',
        });
      }
    });
    Firestore.instance
        .collection('chat')
        .where('from', isEqualTo: prefs.getString('email'))
        .getDocuments()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents) {
        ds.reference.updateData({
          'onlineFrom': '0',
        });
      }
    });

    prefs.setString('username', null);
    prefs.setString('password', null);
    prefs.setString('image', null);
    prefs.setString('userID', null);
  }

  void userReadit(
    String id,
    String email,
  ) {
    Firestore.instance
        .collection('chat')
        .document(id)
        .collection('messages')
        .where('to', isEqualTo: email)
     
        .getDocuments()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents) {
        ds.reference.updateData({
          'read': '1',
        });
      }
    });
  }

  void updateToChatCollections(
    String email,
    String userEmail,
    int now,
    String msg,
    String id,
  ) {
    Firestore.instance
        .collection('chat')
        .document(id)
        .collection('messages')
        .document(now.toString())
        .setData({
      'from': email,
      'to': userEmail,
      'content': msg,
      'time': now,
      'read': '0'
    });
  }

  Future<String> getChatId(String email, String userEmail) async {
    String chatID;
    final QuerySnapshot firstCaseResult = await Firestore.instance
        .collection('chat')
        .where('email', isEqualTo: email)
        .where('email2', isEqualTo: userEmail)
        .getDocuments();
    final List<DocumentSnapshot> documentsOfFirstCase =
        firstCaseResult.documents;
    documentsOfFirstCase.forEach((data) {
      chatID = data.documentID;
    });
    final QuerySnapshot secondCaseResult = await Firestore.instance
        .collection('chat')
        .where('email', isEqualTo: userEmail)
        .where('email2', isEqualTo: email)
        .getDocuments();
    final List<DocumentSnapshot> documentsOfSecondCase =
        secondCaseResult.documents;
    documentsOfSecondCase.forEach((data) {
      chatID = data.documentID;
    });
    return chatID;
  }
}
