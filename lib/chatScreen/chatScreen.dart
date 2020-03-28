import 'dart:async';

import 'package:chatting/models/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String email;
  final String image;
  final String code;
  final String name;
  final String gender;
  final String email2;
  final String image2;
  final String code2;
  final String name2;
  final String gender2;

  const ChatScreen({
    Key key,
    this.email,
    this.image,
    this.code,
    this.name,
    this.gender,
    this.email2,
    this.image2,
    this.code2,
    this.name2,
    this.gender2,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String chattingID;
  var _txtController = TextEditingController();
  ScrollController _controller = ScrollController();
  void getMsgId() async {
    final QuerySnapshot result =
        await Firestore.instance.collection('chat').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    documents.forEach((data) {
      if (data['from'] == widget.email && data['to'] == widget.email2 ||
          data['to'] == widget.email && data['from'] == widget.email2) {
        if (this.mounted) {
          setState(() {
            chattingID = data.documentID;
          });
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getMsgId();
  }

  String genderImage;
  @override
  Widget build(BuildContext context) {
    getMsgId();
    if (widget.image == '1' || widget.image == '2') {
      if (widget.image == '1') {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name2),
        backgroundColor: Colors.purple[900],
        centerTitle: true,
        // actions: <Widget>[
        //   Padding(
        //     padding: const EdgeInsets.only(right: 8.0),
        //     child: Image.network(widget.image == '1' || widget.image == '2'
        //         ? genderImage
        //         : widget.image),
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * .79,
              child: StreamBuilder(
                  stream: Firestore.instance
                      .collection('chat')
                      .document(chattingID)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text("");
                    } else {
                      try {
                        return ListView.builder(
                          itemCount: snapshot.data['messages'].length,
                          controller: _controller,
                          itemBuilder: (BuildContext context, int index) {
                            String from =
                                snapshot.data['messages'][index]['from'];

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                  child: ListTile(
                                title: from == widget.email
                                    ? Text(
                                        snapshot.data['messages'][index]
                                            ['content'],
                                        textDirection: TextDirection.rtl,
                                        style: TextStyle(color: Colors.red),
                                      )
                                    : Text(
                                        snapshot.data['messages'][index]
                                            ['content'],
                                        textDirection: TextDirection.ltr,
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                trailing: from == widget.email
                                    ? Image(
                                        image:
                                            AssetImage('assets/images/ph.png'),
                                        fit: BoxFit.fill,
                                      )
                                    : null,
                                leading: from != widget.email
                                    ? Image(
                                        image:
                                            AssetImage('assets/images/ph.png'),
                                        fit: BoxFit.fill,
                                      )
                                    : null,
                              )),
                            );
                          },
                        );
                      } catch (e) {
                        return Text("لا توجد محادثات");
                      }
                    }
                  }),
            ),

            //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            Container(
              color: Colors.white10,
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _txtController,
                        textAlign: TextAlign.end,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'أكتب هنا',
                        ),
                        onSubmitted: (v) {},
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () async {
                        var now = DateTime.now().millisecondsSinceEpoch;
                        if (chattingID == null) {
                          Fireebase().addToChatCollections(
                            widget.email,
                            widget.email2,
                            now,
                            widget.gender,
                            widget.image,
                            widget.code,
                            widget.name,
                            widget.name2,
                            widget.gender2,
                            widget.image2,
                            widget.code2,
                            _txtController.text,
                          );
                        } else {
                          Fireebase().updateToChatCollections(
                            widget.email,
                            widget.email2,
                            now,
                            widget.gender,
                            widget.image,
                            widget.code,
                            widget.name,
                            widget.name2,
                            widget.gender2,
                            widget.image2,
                            widget.code2,
                            _txtController.text,
                            chattingID,
                          );
                        }

                        setState(() {
                          _txtController.text = '';
                        });
                        Timer(
                            Duration(milliseconds: 300),
                            () => _controller
                                .jumpTo(_controller.position.maxScrollExtent));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
