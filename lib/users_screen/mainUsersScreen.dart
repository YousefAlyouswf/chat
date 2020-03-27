import 'package:chatting/models/chat_model.dart';
import 'package:chatting/models/firebase.dart';
import 'package:chatting/users_screen/current_users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../drawer.dart';
import 'message_recive.dart';

class UsersScreen extends StatefulWidget {
  final String name;
  final String email;
  final String image;
  final String gender;
  final String password;
  final String current;
  final String code;

  const UsersScreen(
      {Key key,
      this.name,
      this.email,
      this.image,
      this.gender,
      this.password,
      this.current,
      this.code})
      : super(key: key);

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
        var date = data['messages'].last;
        if (this.mounted) {
          setState(() {
            chatModel.add(ChatModel(data['from'], data['to'], date['time']));
          });
        }
      }
    });
    chatModel.sort((a, b) => a.time.compareTo(b.time));
  }

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
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
        Fireebase().removeCountry(
          widget.email,
          widget.gender,
          widget.name,
          widget.password,
          widget.image,
          widget.current,
          widget.code,
        );

        Navigator.of(context).pop();
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

  void whatGender(String genderType, String genderImage) {
    if (genderType == '1') {
      setState(() {
        genderImage =
            'https://www.pngitem.com/pimgs/m/184-1842706_transparent-like-a-boss-clipart-man-icon-png.png';
      });
    } else {
      setState(() {
        genderImage =
            'https://www.nicepng.com/png/detail/207-2074651_png-file-woman-person-icon-png.png';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    whoChattingWithMe();
    return WillPopScope(
      onWillPop: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        Fireebase().removeCountry(
          widget.email,
          widget.gender,
          widget.name,
          widget.password,
          widget.image,
          widget.current,
          prefs.getString('code'),
        );

        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple[900],
          title: Text(widget.current),
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
        ),
        body: TabBarView(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: CurrentUsers(
                current: widget.current,
                email: widget.email,
                image: widget.image,
                code: widget.code,
              ),
            ),
            Container(
              color: Colors.white,
              child: MessageRecive(
                current: widget.current,
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
