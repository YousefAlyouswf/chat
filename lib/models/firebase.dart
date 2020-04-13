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

  void addLastMesageToFiresotre(
      String id, String email, String text, int lastMsg) async {
    Firestore.instance
        .collection('chat')
        .document(id)
        .updateData({'email_last': email, 'text': text, 'num': lastMsg});
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

  Future<String> addToChatFirestore(
    String email,
    String userEmail,
    String myName,
    String userName,
    String myImage,
    String userImage,
    String myGender,
    String userGender,
    String myOnline,
    String userOnline,
    String myCode,
    String userCode,
  ) async {
    String chatID;
    final QuerySnapshot firstCaseResult = await Firestore.instance
        .collection('chat')
        .where('from', isEqualTo: email)
        .where('to', isEqualTo: userEmail)
        .getDocuments();
    final List<DocumentSnapshot> documentsOfFirstCase =
        firstCaseResult.documents;
    documentsOfFirstCase.forEach((data) {
      chatID = data.documentID;
    });
    final QuerySnapshot secondCaseResult = await Firestore.instance
        .collection('chat')
        .where('to', isEqualTo: email)
        .where('from', isEqualTo: userEmail)
        .getDocuments();
    final List<DocumentSnapshot> documentsOfsecondCase =
        secondCaseResult.documents;
    documentsOfsecondCase.forEach((data) {
      chatID = data.documentID;
    });
    if (chatID == null) {
      Firestore.instance.collection('chat').document().setData(
        {
          'from': email,
          'to': userEmail,
          'text': '',
          'num': 0,
          'image1': myImage,
          'image2': userImage,
          'gender1': myGender,
          'gender2': userGender,
          'name1': myName,
          'name2': userName,
          'online1': myOnline,
          'online2': userOnline,
          'code1': myCode,
          'code2': userCode,
          'email_last': '',
          'read': '',
        },
      );
      final QuerySnapshot thirdCaseResult = await Firestore.instance
          .collection('chat')
          .where('from', isEqualTo: email)
          .where('to', isEqualTo: userEmail)
          .getDocuments();
      final List<DocumentSnapshot> documentsOfthirddCase =
          thirdCaseResult.documents;
      documentsOfthirddCase.forEach((data) {
        chatID = data.documentID;
      });
    }
    return chatID;
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
