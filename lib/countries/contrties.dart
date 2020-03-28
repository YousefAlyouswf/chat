import 'package:chatting/models/chat_model.dart';
import 'package:chatting/models/firebase.dart';
import 'package:chatting/users_screen/mainUsersScreen.dart';
import 'package:chatting/users_screen/message_recive.dart';
import 'package:flutter/material.dart';
import '../drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'country_page.dart';

class Contrties extends StatefulWidget {
  final String email;
  final String name;
  final String gender;
  final String image;
  final String password;
  const Contrties(
      {Key key, this.email, this.name, this.gender, this.image, this.password})
      : super(key: key);
  @override
  _ContrtiesState createState() => _ContrtiesState();
}

class _ContrtiesState extends State<Contrties>
    with SingleTickerProviderStateMixin {
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
            chatModel.add(ChatModel(
              data['from'],
              data['to'],
              date['time'],
              data['gender'],
              data['image'],
              data['code'],
              data['name'],
              date['content'],
            ));
          });
        }
      }
    });
    chatModel.sort((a, b) => a.time.compareTo(b.time));
  }



  String code;
  void getCountry() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    code = prefs.getString('code');
  }

  List<int> countries = new List();
  var map = Map();
  List<String> usersCount = new List();
  void countHomeManyUserInRoom() async {
    final QuerySnapshot result1 =
        await Firestore.instance.collection('users').getDocuments();
    final List<DocumentSnapshot> documents1 = result1.documents;
    usersCount = new List();
    map = Map();
    documents1.forEach((data) {
      for (var i = 0; i < data['usersData'].length; i++) {
        usersCount.add(data['usersData'][i]['current']);
      }
    });

    usersCount.forEach((country) {
      if (!map.containsKey(country)) {
        map[country] = 1;
      } else {
        map[country] += 1;
      }
    });
  }

  TabController _controller;

  @override
  void initState() {
    whoChattingWithMe();
    getCountry();
    countHomeManyUserInRoom();
 
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    whoChattingWithMe();
    countHomeManyUserInRoom();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[900],
        title: Text("سوالف"),
        centerTitle: true,
        bottom: TabBar(
          labelColor: Colors.white,
          labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.white,
          tabs: [
            Tab(
              text: 'جميع الدول',
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
        gender: widget.gender,
      ),
      body: TabBarView(
        children: <Widget>[
          Container(
              color: Colors.white,
              child: CountryPage(widget.email, widget.gender, widget.name,
                  widget.password, widget.image, code, map)),
          Container(
            color: Colors.white,
            child: MessageRecive(
              current: '',
              email: widget.email,
              chatModel: chatModel,
            ),
          ),
        ],
        controller: _controller,
      ),
    );
  }
}
