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
//------------------------------ make yourseld online

//-------------- textMe collection
    Firestore.instance
        .collection('textMe')
        .document("JzCPQt7TQZTZDMa5jfYq")
        .collection('lastText')
        .where('from', isEqualTo: prefs.getString('email'))
        .getDocuments()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents) {
        ds.reference.updateData({
          'onlineFrom': '0',
        });
      }
    });

    Firestore.instance
        .collection('textMe')
        .document("JzCPQt7TQZTZDMa5jfYq")
        .collection('lastText')
        .where('to', isEqualTo: prefs.getString('email'))
        .getDocuments()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents) {
        ds.reference.updateData({
          'onlineTo': '0',
        });
      }
    });
    //---------------------

    //-------------------- chat collection

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
    //----------------------

//-----------------------------------------
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
    String online,
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
          'onlineFrom': '1',
          'onlineTo': online,
          'typingFrom': '',
          'typingTo': '',
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
        'onlineFrom': '1',
        'onlineTo': online,
        'typing': '0',
        'read': '0',
        'emailID': '',
      });
    }
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

  void readFromRecive(String lastTextId) {
    DocumentReference documentReference = Firestore.instance
        .collection('textMe')
        .document('JzCPQt7TQZTZDMa5jfYq')
        .collection('lastText')
        .document(lastTextId);
    Firestore.instance.runTransaction((transaction) async {
      await transaction.update(documentReference, {
        'read': '1',
      });
    });
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
      'read': '0'
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
        'emailID': email,
        'read': '0',
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
      'image': gender == '1'
          ? 'https://cdn4.iconfinder.com/data/icons/social-messaging-productivity-7/64/x-01-512.png'
          : 'https://cdn1.iconfinder.com/data/icons/business-planning-management-set-2/64/x-90-512.png',
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
