import 'package:chatting/models/chat_model.dart';
import 'package:chatting/models/firebase.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Contrties extends StatefulWidget {
  final String email;
  final String name;
  final String gender;
  final String image;
  final String password;
  final String current;
  final TabController controller;
  const Contrties(
      {Key key,
      this.email,
      this.name,
      this.gender,
      this.image,
      this.password,
      this.controller,
      this.current})
      : super(key: key);
  @override
  _ContrtiesState createState() => _ContrtiesState();
}

class _ContrtiesState extends State<Contrties> {
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
        if (data['usersData'][i]['online'] == '1') {
          usersCount.add(data['usersData'][i]['current']);
        }
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

  @override
  void initState() {
    whoChattingWithMe();
    getCountry();
    countHomeManyUserInRoom();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    whoChattingWithMe();
    countHomeManyUserInRoom();
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: StreamBuilder(
              stream: Firestore.instance
                  .collection('countries')
                  .document('MAqRIisbFZtn4YGoRCqV')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text("");
                } else {
                  return GridView.builder(
                      itemCount: snapshot.data['all'].length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1.2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () async {
                            Fireebase().changeCountry(
                              widget.email,
                              widget.gender,
                              widget.name,
                              widget.password,
                              widget.image,
                              snapshot.data['all'][index]['country'],
                              code,
                            );
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setString('countryName',
                                snapshot.data['all'][index]['country']);

                            widget.controller.index = 1;
                          },
                          child: Card(
                            elevation: 0,
                            color: Colors.white70,
                            child: Container(
                              decoration: new BoxDecoration(
                                  image: new DecorationImage(
                                      image: new NetworkImage(
                                          snapshot.data['all'][index]['image']),
                                      fit: BoxFit.cover)),
                              child: Stack(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      width: double.infinity,
                                      color: Colors.white70,
                                      child: Text(
                                        snapshot.data['all'][index]['country'],
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                      width: double.infinity,
                                      color: Colors.black54,
                                      child: Text(
                                        map[snapshot.data['all'][index]
                                                        ['country']]
                                                    .toString() ==
                                                "null"
                                            ? 'الأعضاء  ' + '0'
                                            : 'الأعضاء  ' +
                                                map[snapshot.data['all'][index]
                                                        ['country']]
                                                    .toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 13, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                }
              }),
        ),
      ),
    );
  }
}
