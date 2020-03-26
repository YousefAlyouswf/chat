import 'package:chatting/start_screen/signup.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class StartScreen extends StatefulWidget {
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
