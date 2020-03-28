import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          'current': current,
          'code': code,
          'online': '1',
        },
      ]),
    });
    prefs.setString('countryName', current);
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
    var now,
    String gender,
    String image,
    String code,
    String name,
  ) {
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
    prefs.setString('countryName', current);
  }
}
