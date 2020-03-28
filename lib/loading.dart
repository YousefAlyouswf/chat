import 'package:chatting/models/app_functions.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chatting/login_screen/mainStartScreen.dart';

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
      AppFunctions().goToCountryRoom(context);
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => StartScreen(),
        ),
      );
    }
  }

  String code;

  @override
  void initState() {
    AppFunctions().getCountry();
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
