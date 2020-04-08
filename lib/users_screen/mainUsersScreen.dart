import 'dart:async';
import 'package:chatting/models/chat_model.dart';
import 'package:chatting/models/firebase.dart';
import 'package:chatting/models/user_model.dart';
import 'package:chatting/mysql/mysql_functions.dart';
import 'package:chatting/users_screen/current_users.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../drawer.dart';
import 'message_recive.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UsersScreen extends StatefulWidget {
  final String name;
  final String email;
  final String image;
  final String gender;
  final String password;
  final String code;
  final String title = 'سوالف';
  const UsersScreen({
    Key key,
    this.name,
    this.email,
    this.image,
    this.gender,
    this.password,
    this.code,
  }) : super(key: key);

  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  TabController _controller;
//-------- this all function to fet data from mysql
  List<Users> _users;
  List<Chat> _chat;
 

  _getUsers() {
   
    Mysql().getUsers().then((users) {
      setState(() {
        _users = users;
      });
  
    });
  }

  _getChatFromMysql() {
   
    Mysql().getChat().then((chat) {
      setState(() {
        _chat = chat;
      });
     
    });
  }



 

  //--------END of sql

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
    _controller.index = 0;
    WidgetsBinding.instance.addObserver(this);
    _users = [];
    _getUsers();
    _getChatFromMysql();


    Timer.periodic(new Duration(seconds: 10), (timer) {
      _getUsers();
      _getChatFromMysql();
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
        print('paused');

        // int _start = 5;
        // const oneSec = const Duration(seconds: 1);
        // new Timer.periodic(
        //   oneSec,
        //   (Timer timer) => setState(
        //     () {
        //       if (_start < 1) {
        //
        //         timer.cancel();
        //       } else {
        //         _start = _start - 1;
        //       }
        //     },
        //   ),
        // );

        //    Navigator.of(context).pop();
        break;
      case AppLifecycleState.resumed:
        print('resumed');

        break;
      case AppLifecycleState.inactive:
        print('inactive');
        break;
      case AppLifecycleState.detached:
        print(
            'detached----------------------------------------------------------');

        break;
    }
  }

  int submitExit = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (submitExit == 0) {
          Fluttertoast.showToast(
              msg: "لتأكيد الخروج أضغط رجوع مرة أخرى",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.yellow,
              textColor: Colors.black,
              fontSize: 16.0);
          submitExit++;
        } else {
          Fireebase().exitFfromChat();
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          submitExit = 0;
        }

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('سوالف'),
          centerTitle: true,
          bottom: TabBar(
            labelColor: Colors.white,
            labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                text: 'الأعضاء',
              ),
              Tab(
                text: 'الرسائل',
              ),
            ],
            controller: _controller,
          ),
        ),
        endDrawer: DrawerPage(
          name: widget.name,
          email: widget.email,
          image: widget.image,
          password: widget.password,
          code: widget.code,
          gender: widget.gender,
        ),
        body: TabBarView(
          children: <Widget>[
            //------------------------------
            Container(
              color: Colors.white,
              child: CurrentUsers(
                email: widget.email,
                image: widget.image,
                code: widget.code,
                name: widget.name,
                gender: widget.gender,
                users: _users,
                getUsers: _getUsers,
              ),
            ),
            Container(
              color: Colors.white,
              child: MessageRecive(
                email: widget.email,
                image: widget.image,
                code: widget.code,
                name: widget.name,
                gender: widget.gender,
                chat: _chat,
                getChat: _getChatFromMysql,
              ),
            ),
          ],
          controller: _controller,
        ),
      ),
    );
  }
}
