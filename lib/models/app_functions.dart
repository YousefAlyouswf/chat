import 'dart:async';

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
    code = 'us';
  }

  void goToChat(BuildContext context) async {
    getCountry();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //-------------------- chat collection

    Firestore.instance
        .collection('chat')
        .where('to', isEqualTo: prefs.getString('email'))
        .getDocuments()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents) {
        ds.reference.updateData({
          'onlineTo': '1',
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
          'onlineFrom': '1',
        });
      }
    });
    //----------------------

//-----------------------------------------
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => UsersScreen(
          name: prefs.getString('username'),
          email: prefs.getString('email'),
          image: prefs.getString('image'),
          gender: prefs.getString('gender'),
          password: prefs.getString('password'),
          code: code,
        ),
      ),
    );
  }

// Start chatScreen

  void goDownFunction(ScrollController _controller) {
    Timer(Duration(milliseconds: 300),
        () => _controller.jumpTo(_controller.position.maxScrollExtent + 1));
  }

  //End chatScreen
}
