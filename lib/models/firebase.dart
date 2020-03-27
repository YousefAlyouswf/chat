import 'package:cloud_firestore/cloud_firestore.dart';

class Fireebase {
  void removeCountry(
    String email,
    String gender,
    String name,
    String password,
    String image,
    String current,
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
          'current': current,
          'code': code,
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
          'current': '',
          'code': '',
        },
      ]),
    });
  }

  void addCountry(
    String email,
    String gender,
    String name,
    String password,
    String image,
    String current,
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
          'current': '',
          'code': '',
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
          'current': current,
          'code': code,
        },
      ]),
    });
  }

  void addToChatCollections(String email, String userEmail, var now,
      String gender, String image, String code, String name) {
    Firestore.instance.collection('chat').document().setData({
      'from': email,
      'to': userEmail,
      'gender': gender,
      'image': image,
      'code': code,
      'name': name,
      'messages': FieldValue.arrayUnion([
        {
          'from': email,
          'to': userEmail,
          'content': '',
          'time': now,
        },
      ]),
    });
  }
}
