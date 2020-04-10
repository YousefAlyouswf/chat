import 'package:chatting/mysql/mysql_functions.dart';
import 'package:flutter/material.dart';
import 'package:chatting/login_screen/mainStartScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void userAlreadyLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email');
    String password = prefs.getString('password');
    if (email != null && password != null) {
      Mysql().login(email, password, context);
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => StartScreen(),
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
      backgroundColor: Color(0xff262626),
      body: Center(
        child: Image.network(
          'https://media.giphy.com/media/GR81UZYyhN3Ww/giphy.gif',
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}
