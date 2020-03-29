import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Fireebase {
  void changeCountry(
    String email,
    String gender,
    String name,
    String password,
    String image,
    String current,
    String code,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
          'current': prefs.getString('countryName'),
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
          'current': prefs.getString('countryName'),
          'code': code,
          'online': '1',
        },
      ]),
    });
  }

  void goToCountryRoom(
    String email,
    String gender,
    String name,
    String password,
    String image,
    String current,
    String code,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
          'current': prefs.getString('countryName'),
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
          'current': prefs.getString('countryName'),
          'code': code,
          'online': '1',
        },
      ]),
    });
    //prefs.setString('countryName', current);
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
  ) {
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
  }

  void updateToChatCollections(
    String email,
    String userEmail,
    var now,
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
    });
  }

  void signUp(
    String email,
    String gender,
    String name,
    String password,
  ) async {
    List<Map<String, dynamic>> maplist = [
      {
        'email': email,
        'gender': gender,
        'name': name,
        'password': password,
        'image': '',
        'current': '',
        'code': '',
        'online': '0',
      },
    ];
    await Firestore.instance
        .collection('users')
        .document('wauiqt7wiUI283ANx9n1')
        .updateData({
      'usersData': FieldValue.arrayUnion(maplist),
    });
  }

  void logOut(
    String email,
    String gender,
    String name,
    String password,
    String image,
    String current,
    String code,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
          'current': prefs.getString('countryName'),
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
          'current': current,
          'code': code,
          'online': '0',
        },
      ]),
    });
  }

  void resume(
    String email,
    String gender,
    String name,
    String password,
    String image,
    String current,
    String code,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
          'current': prefs.getString('countryName'),
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
          'current': prefs.getString('countryName'),
          'code': code,
          'online': '1',
        },
      ]),
    });
  }
}
