import 'package:chatting/countries/contrties.dart';
import 'package:chatting/models/chat_model.dart';
import 'package:chatting/models/firebase.dart';
import 'package:chatting/users_screen/current_users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../drawer.dart';
import 'message_recive.dart';
import 'dart:async';

class UsersScreen extends StatefulWidget {
  final String name;
  final String email;
  final String image;
  final String gender;
  final String password;
  final String current;
  final String code;

  const UsersScreen({
    Key key,
    this.name,
    this.email,
    this.image,
    this.gender,
    this.password,
    this.current,
    this.code,
  }) : super(key: key);

  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  TabController _controller;
  List<ChatModel> chatModel = new List();

  void whoChattingWithMe() async {
    //chatModel = new List();
    final QuerySnapshot result =
        await Firestore.instance.collection('chat').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    chatModel = new List();
    documents.forEach((data) {
      if (data['from'] == widget.email || data['to'] == widget.email) {
        // var date = data['messages'].last;

        // if (this.mounted) {
        //   setState(() {
        //     chatModel.add(
        //       ChatModel(
        //         data['from'],
        //         data['to'],
        //         date['time'],
        //         data['gender'],
        //         data['image'],
        //         data['code'],
        //         data['name'],
        //         date['content'],
        //         data['name2'],
        //         data['gender2'],
        //         data['image2'],
        //         data['code2'],
        //       ),
        //     );
        //   });
        // }
      }
    });
    chatModel.sort((a, b) => a.time.compareTo(b.time));
  }

  String newCurrent;
  void changeCurrentCountry() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      newCurrent = prefs.getString('countryName');
    });
  }

  @override
  void initState() {
    changeCurrentCountry();
    super.initState();
    _controller = TabController(length: 3, vsync: this);
    _controller.index = 1;
    whoChattingWithMe();

    WidgetsBinding.instance.addObserver(this);
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
        //         Fireebase().logOut(
        //           widget.email,
        //           widget.gender,
        //           widget.name,
        //           widget.password,
        //           widget.image,
        //           widget.current,
        //           widget.code,
        //         );
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

        // Fireebase().resume(
        //   widget.email,
        //   widget.gender,
        //   widget.name,
        //   widget.password,
        //   widget.image,
        //   widget.current,
        //   widget.code,
        // );
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

  @override
  Widget build(BuildContext context) {
    whoChattingWithMe();
    changeCurrentCountry();
    return WillPopScope(
      onWillPop: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        Fireebase().logOut(
          widget.email,
          widget.gender,
          widget.name,
          widget.password,
          widget.image,
          widget.current,
          prefs.getString('code'),
        );
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(newCurrent == null ? '1' : newCurrent),
          centerTitle: true,
          bottom: TabBar(
            labelColor: Colors.white,
            labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                text: 'الدول',
              ),
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
          current: newCurrent,
          code: widget.code,
          gender: widget.gender,
        ),
        body: TabBarView(
          children: <Widget>[
            //--------------------------------
            Container(
              color: Colors.white,
              child: Contrties(
                name: widget.name,
                email: widget.email,
                gender: widget.gender,
                image: widget.image,
                password: widget.password,
                controller: _controller,
                current: newCurrent,
              ),
            ),

            //------------------------------
            Container(
              color: Colors.white,
              child: CurrentUsers(
                current: newCurrent,
                email: widget.email,
                image: widget.image,
                code: widget.code,
                name: widget.name,
                gender: widget.gender,
                
              ),
            ),
            Container(
              color: Colors.white,
              child: MessageRecive(
                current: newCurrent,
                email: widget.email,
                chatModel: chatModel,
              ),
            ),
          ],
          controller: _controller,
        ),
      ),
    );
  }
}
