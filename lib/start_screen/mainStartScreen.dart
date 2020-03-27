import 'package:chatting/countries/contrties.dart';
import 'package:chatting/start_screen/signup.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class StartScreen extends StatefulWidget {
  const StartScreen();
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  void userAlreadyLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userName = prefs.getString('username');
    String password = prefs.getString('password');
    if (userName != null && password != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => Contrties(
            name: prefs.getString('username'),
            email: prefs.getString('email'),
            gender: prefs.getString('gender'),
            image: prefs.getString('image'),
            password: prefs.getString('password'),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
   userAlreadyLogin();
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("سوالف"),
        centerTitle: true,
        backgroundColor: Colors.purple[900],
        bottom: TabBar(
          labelColor: Colors.white,
          labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.white,
          tabs: [
            Tab(
              text: 'تسجيل',
            ),
            Tab(
              text: 'دخول',
            ),
          ],
          controller: _controller,
        ),
      ),
      body: TabBarView(
        children: <Widget>[
          Container(
            color: Colors.white,
            child: SignUp(),
          ),
          Container(
            color: Colors.white,
            child: Login(),
          ),
        ],
        controller: _controller,
      ),
    );
  }
}
