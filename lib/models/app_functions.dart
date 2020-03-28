import 'package:chatting/users_screen/mainUsersScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase.dart';

class AppFunctions {
  void whatGender(String genderType, String genderImage) {
    if (genderType == '1') {
      genderImage =
          'https://www.pngitem.com/pimgs/m/184-1842706_transparent-like-a-boss-clipart-man-icon-png.png';
    } else {
      genderImage =
          'https://www.nicepng.com/png/detail/207-2074651_png-file-woman-person-icon-png.png';
    }
  }

  String code;
  void getCountry() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    code = prefs.getString('code');
  }

  void goToCountryRoom(BuildContext context) async {
    getCountry();
    bool other = true;
    final QuerySnapshot result =
        await Firestore.instance.collection('countries').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    documents.forEach((data) {
      for (var i = 0; i < data['all'].length; i++) {
        if (prefs.getString('country') == data['all'][i]['code']) {
          other = false;

          Fireebase().goToCountryRoom(
            prefs.getString('email'),
            prefs.getString('gender'),
            prefs.getString('username'),
            prefs.getString('password'),
            prefs.getString('image'),
            data['all'][i]['country'],
            code,
          );

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => UsersScreen(
                name: prefs.getString('username'),
                email: prefs.getString('email'),
                image: prefs.getString('image'),
                gender: prefs.getString('gender'),
                password: prefs.getString('password'),
                current: data['all'][i]['country'],
                code: code,
              ),
            ),
          );
          //prefs.setString('countryName', data['all'][i]['country']);
        }
      }
    });

    if (other) {
      Fireebase().goToCountryRoom(
        prefs.getString('email'),
        prefs.getString('gender'),
        prefs.getString('username'),
        prefs.getString('password'),
        prefs.getString('image'),
        'أخرى',
        code,
      );

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => UsersScreen(
            name: prefs.getString('username'),
            email: prefs.getString('email'),
            image: prefs.getString('image'),
            gender: prefs.getString('gender'),
            password: prefs.getString('password'),
            current: 'أخرى',
          ),
        ),
      );
      prefs.setString('countryName', 'أخرى');
    }
  }
}
