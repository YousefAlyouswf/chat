import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Fireebase {
  void changeCountry(
    String email,
    String gender,
    String name,
    String password,
    String image,
    String code,
  ) async {
    await Firestore.instance
        .collection('users')
        .document('wauiqt7wiUI283ANx9n1')
        .updateData({
      'usersData': FieldValue.arrayRemove([
        {
          'email': email,
          'gender': gender,
          'name': name,
          'password': password,
          'image': image,
          'code': code,
          'online': '1',
        },
      ]),
    });
    await Firestore.instance
        .collection('users')
        .document('wauiqt7wiUI283ANx9n1')
        .updateData({
      'usersData': FieldValue.arrayUnion([
        {
          'email': email,
          'gender': gender,
          'name': name,
          'password': password,
          'image': image,
          'code': code,
          'online': '1',
        },
      ]),
    });
  }

  void enterToChat(
    String email,
    String gender,
    String name,
    String password,
    String image,
    String code,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('userID');
    DocumentReference documentReference = Firestore.instance
        .collection('users')
        .document('wauiqt7wiUI283ANx9n1')
        .collection('allUsers')
        .document(userID);
    Firestore.instance.runTransaction((transaction) async {
      await transaction.update(documentReference, {
        'online': '1',
      });
    });
  }

  void exitFfromChat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('userID');
    DocumentReference documentReference = Firestore.instance
        .collection('users')
        .document('wauiqt7wiUI283ANx9n1')
        .collection('allUsers')
        .document(userID);
    Firestore.instance.runTransaction((transaction) async {
      await transaction.update(documentReference, {
        'online': '0',
      });
    });

    prefs.setString('username', null);
    prefs.setString('password', null);
    prefs.setString('image', null);
    prefs.setString('userID', null);
  }

  void uploadUserImage(String image, String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('userID');
    DocumentReference documentReference = Firestore.instance
        .collection('users')
        .document('wauiqt7wiUI283ANx9n1')
        .collection('allUsers')
        .document(userID);
    Firestore.instance.runTransaction((transaction) async {
      await transaction.update(documentReference, {
        'image': image,
      });
    });
//----------------------------- recivedMessage screen

    await Firestore.instance
        .collection('textMe')
        .document("JzCPQt7TQZTZDMa5jfYq")
        .collection('lastText')
        .where('from', isEqualTo: email)
        .getDocuments()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents) {
        ds.reference.updateData({
          'image2': image,
        });
      }
    });

    await Firestore.instance
        .collection('textMe')
        .document("JzCPQt7TQZTZDMa5jfYq")
        .collection('lastText')
        .where('to', isEqualTo: email)
        .getDocuments()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents) {
        ds.reference.updateData({
          'image': image,
        });
      }
    });
  }

  void addToChatCollections(
    String email,
    String userEmail,
    String gender,
    String image,
    String code,
    String name,
    String name2,
    String gender2,
    String image2,
    String code2,
  ) async {
    final QuerySnapshot result =
        await Firestore.instance.collection('chat').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    bool thereIsChatting = false;
    documents.forEach(
      (data) {
        if (data['from'] == email && data['to'] == userEmail ||
            data['to'] == email && data['from'] == userEmail) {
          thereIsChatting = true;
        }
      },
    );
    if (thereIsChatting == false) {
      Firestore.instance.collection('chat').document().setData(
        {
          'from': email,
          'to': userEmail,
          'gender': gender2,
          'image': image2,
          'code': code2,
          'name': name2,
          'name2': name,
          'gender2': gender,
          'image2': image,
          'code2': code,
        },
      );

      await Firestore.instance
          .collection('textMe')
          .document('JzCPQt7TQZTZDMa5jfYq')
          .collection('lastText')
          .add({
        'from': email,
        'to': userEmail,
        'gender': gender2,
        'image': image2,
        'code': code2,
        'name': name2,
        'name2': name,
        'gender2': gender,
        'image2': image,
        'code2': code,
        'text': '',
        'lastMsg': 0,
      });
    }
  }

  void updateToChatCollections(
    String email,
    String userEmail,
    int now,
    String msg,
    String id,
    String lastTextId,
    int lastMsg,
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
    });

    DocumentReference documentReference = Firestore.instance
        .collection('textMe')
        .document('JzCPQt7TQZTZDMa5jfYq')
        .collection('lastText')
        .document(lastTextId);
    Firestore.instance.runTransaction((transaction) async {
      await transaction.update(documentReference, {
        'text': msg,
        'lastMsg': lastMsg,
      });
    });
  }

  void signUp(
    String email,
    String gender,
    String name,
    String password,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String code = prefs.getString('code');

    await Firestore.instance
        .collection('users')
        .document('wauiqt7wiUI283ANx9n1')
        .collection('allUsers')
        .add({
      'code': code,
      'email': email,
      'gender': gender,
      'image': '',
      'name': name,
      'online': '0',
      'password': password,
    });
  }

  void resume(
    String email,
    String gender,
    String name,
    String password,
    String image,
    String code,
  ) async {
    await Firestore.instance
        .collection('users')
        .document('wauiqt7wiUI283ANx9n1')
        .updateData({
      'usersData': FieldValue.arrayRemove([
        {
          'email': email,
          'gender': gender,
          'name': name,
          'password': password,
          'image': image,
          'code': code,
          'online': '0',
        },
      ]),
    });
    await Firestore.instance
        .collection('users')
        .document('wauiqt7wiUI283ANx9n1')
        .updateData({
      'usersData': FieldValue.arrayUnion([
        {
          'email': email,
          'gender': gender,
          'name': name,
          'password': password,
          'image': image,
          'code': code,
          'online': '1',
        },
      ]),
    });
  }
}
