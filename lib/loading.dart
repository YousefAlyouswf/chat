import 'package:chatting/models/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chatting/login_screen/mainStartScreen.dart';
import 'countries/contrties.dart';
import 'users_screen/mainUsersScreen.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void userAlreadyLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userName = prefs.getString('username');
    String password = prefs.getString('password');
    if (userName != null && password != null) {
      goToCountryRoom();
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => StartScreen(),
        ),
      );
    }
  }

  String code;
  void getCountry() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    code = prefs.getString('code');
  }

  void goToCountryRoom() async {
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

          Fireebase().addCountry(
              prefs.getString('email'),
              prefs.getString('gender'),
              prefs.getString('username'),
              prefs.getString('password'),
              prefs.getString('image'),
              data['all'][i]['country'],
              code);

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => UsersScreen(
                name: prefs.getString('username'),
                email: prefs.getString('email'),
                image: prefs.getString('image'),
                gender: prefs.getString('gender'),
                password: prefs.getString('password'),
                current: data['all'][i]['country'],
              ),
            ),
          );
        }
      }
    });

    if (other) {
      Fireebase().addCountry(
          prefs.getString('email'),
          prefs.getString('gender'),
          prefs.getString('username'),
          prefs.getString('password'),
          prefs.getString('image'),
          'أخرى',
          code);

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
    }
  }

  @override
  void initState() {
    userAlreadyLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.network(
          'https://media.giphy.com/media/52qtwCtj9OLTi/giphy.gif',
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}
