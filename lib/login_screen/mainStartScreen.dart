import 'package:chatting/login_screen/signup.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class StartScreen extends StatefulWidget {
  const StartScreen();
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("سوالف"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        bottom: TabBar(
          labelColor: Colors.white,
          labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.white,
          tabs: [
            Tab(
              text: 'دخول',
            ),
            Tab(
              text: 'تسجيل',
            ),
          ],
          controller: _controller,
        ),
      ),
      body: TabBarView(
        children: <Widget>[
          Container(
            color: Colors.white,
            child: Login(),
          ),
          Container(
            color: Colors.white,
            child: SignUp(),
          ),
        ],
        controller: _controller,
      ),
    );
  }
}
