import 'dart:async';
import 'dart:io';

import 'package:chatting/models/app_functions.dart';
import 'package:chatting/models/firebase.dart';
import 'package:chatting/mysql/mysql_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';
import 'package:image_picker/image_picker.dart';

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
  final String chatID;
  final String online;
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
    this.chatID,
    this.online,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  double width = 0, height = 60;
  String chattingID;
  var _txtController = TextEditingController();
  ScrollController _controller = ScrollController();

  void isTyping() async {
    // final QuerySnapshot result =
    //     await Firestore.instance.collection('chat').getDocuments();
    // final List<DocumentSnapshot> documents = result.documents;
    // documents.forEach((data) {
    //   if (data['from'] == widget.email && data['to'] == widget.email2 ||
    //       data['to'] == widget.email && data['from'] == widget.email2) {
    //     if (data['from'] == widget.email) {
    //       if (_txtController.text == '' || _txtController.text == null) {
    //         DocumentReference documentReference =
    //             Firestore.instance.collection('chat').document(chattingID);
    //         Firestore.instance.runTransaction((transaction) async {
    //           await transaction.update(documentReference, {
    //             'typingFrom': '0',
    //           });
    //         });
    //       } else {
    //         DocumentReference documentReference =
    //             Firestore.instance.collection('chat').document(chattingID);
    //         Firestore.instance.runTransaction((transaction) async {
    //           await transaction.update(documentReference, {
    //             'typingFrom': '1',
    //           });
    //         });
    //       }
    //     } else {
    //       if (_txtController.text == '' || _txtController.text == null) {
    //         DocumentReference documentReference =
    //             Firestore.instance.collection('chat').document(chattingID);
    //         Firestore.instance.runTransaction((transaction) async {
    //           await transaction.update(documentReference, {
    //             'typingTo': '0',
    //           });
    //         });
    //       } else {
    //         DocumentReference documentReference =
    //             Firestore.instance.collection('chat').document(chattingID);
    //         Firestore.instance.runTransaction((transaction) async {
    //           await transaction.update(documentReference, {
    //             'typingTo': '1',
    //           });
    //         });
    //       }
    //     }
    //   }
    // });
  }

  @override
  void initState() {
    super.initState();
    _txtController.addListener(isTyping);
  }

  bool startTyping = false;
  File _image;
  String genderImage;
  @override
  Widget build(BuildContext context) {
    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
      });

      Navigator.pop(context);
    }

    //
    // print(lastTextId);
    // Fireebase().userReadit(
    //   chattingID,
    //   widget.email,
    // );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            startTyping == '1'
                ? Image.network(
                    'https://media.giphy.com/media/Zx0gTTVNOvRrLxKgc8/giphy.gif',
                    height: 40,
                    width: 40,
                  )
                : Text(''),
            Text(widget.name2),
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 32.0),
            child: widget.online == '1'
                ? Container(
                    width: 15.0,
                    height: 15.0,
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.lightGreenAccent[400],
                    ),
                  )
                : Container(
                    width: 15.0,
                    height: 15.0,
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * .79,
              child: StreamBuilder(
                  stream: Firestore.instance
                      .collection('chat')
                      .document(widget.chatID)
                      .collection('messages')
                      .orderBy('time', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text("");
                    } else {
                      try {
                        return ListView.builder(
                          reverse: true,
                          itemCount: snapshot.data.documents.length,
                          controller: _controller,
                          itemBuilder: (BuildContext context, int index) {
                            String from =
                                snapshot.data.documents[index]['from'];
                            String read =
                                snapshot.data.documents[index]['read'];
                            return Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  from != widget.email
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Stack(
                                            alignment: Alignment.bottomLeft,
                                            children: <Widget>[
                                              Container(
                                                width: 60.0,
                                                height: 60.0,
                                                decoration: new BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: new DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: NetworkImage(
                                                        widget.image2),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(),
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: from == widget.email
                                            ? MainAxisAlignment.end
                                            : MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          from == widget.email
                                              ? read == '0'
                                                  ? Image.network(
                                                      'http://getdrawings.com/free-icon/email-icon-transparent-63.png',
                                                      height: 25,
                                                      width: 25,
                                                    )
                                                  : Image.network(
                                                      'https://images.vexels.com/media/users/3/157932/isolated/preview/951a617272553f49e75548e212ed947f-curved-check-mark-icon-by-vexels.png',
                                                      height: 25,
                                                      width: 25,
                                                    )
                                              : Text(''),
                                          //-------------------- end of user read
                                          Flexible(
                                            child: Bubble(
                                              margin: from == widget.email
                                                  ? BubbleEdges.only(
                                                      top: 10, left: 10)
                                                  : BubbleEdges.only(
                                                      top: 10, right: 10),
                                              padding: BubbleEdges.only(
                                                  right: 16.0, left: 16.0),
                                              stick: true,
                                              nip: from == widget.email
                                                  ? BubbleNip.rightTop
                                                  : BubbleNip.leftTop,
                                              color: from == widget.email
                                                  ? Theme.of(context).cardColor
                                                  : Colors.grey[300],
                                              child: Text(
                                                snapshot.data.documents[index]
                                                    ['content'],
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal),
                                                textAlign: TextAlign.right,
                                                textDirection:
                                                    TextDirection.rtl,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  from == widget.email
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            width: 60.0,
                                            height: 60.0,
                                            decoration: new BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: new DecorationImage(
                                                fit: BoxFit.fill,
                                                image:
                                                    NetworkImage(widget.image),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            );
                          },
                        );
                      } catch (e) {
                        return Text("");
                      }
                    }
                  }),
            ),

            //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: new BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: new BorderRadius.all(
                    const Radius.circular(16.0),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    IconButton(icon: Icon(Icons.image), onPressed: getImage),
                    Flexible(
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: TextField(
                            onChanged: (text) {
                              if (!startTyping) {
                                //  Mysql().updateReadMsg(widget.email, widget.email2);
                                Fireebase().userReadit(
                                  widget.chatID,
                                  widget.email,
                                );
                                startTyping = true;
                              }
                            },
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            controller: _txtController,
                            textAlign: TextAlign.end,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'أكتب هنا',
                            ),
                            onEditingComplete: callback,
                            textInputAction: TextInputAction.send,
                          ),
                        ),
                      ),
                    ),
                    _txtController.text != '' &&
                            _txtController.text != ' ' &&
                            _txtController.text != '  ' &&
                            _txtController.text != '   ' &&
                            _txtController.text != '    ' &&
                            _txtController.text != '     ' &&
                            _txtController.text != '      ' &&
                            _txtController.text != '       ' &&
                            _txtController.text != '        ' &&
                            _txtController.text != '         ' &&
                            _txtController.text != '          ' &&
                            _txtController.text != '           ' &&
                            _txtController.text != '            ' &&
                            _txtController.text != '             ' &&
                            _txtController.text != '              ' &&
                            _txtController.text != '               ' &&
                            _txtController.text != '                '
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                              icon: Icon(Icons.send),
                              onPressed: callback,
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                              icon: Icon(Icons.send),
                              onPressed: callback,
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String lastTextId;
  int now;
  int lastMsg;
  Future<void> callback() async {
    startTyping = false;
    if (now != null) {
      now = now - 1;
    }
    final QuerySnapshot result = await Firestore.instance
        .collection('chat/${widget.chatID}/messages')
        .orderBy('time')
        .where('time', isGreaterThan: now)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    documents.forEach((data) {
      now = data['time'];
    });
    if (now == null) {
      now = 1;
    } else {
      now++;
    }

    //------------------------- this the firestore function
    Fireebase().updateToChatCollections(
      widget.email,
      widget.email2,
      now,
      _txtController.text,
      widget.chatID,
    );

    Mysql().updateLastMsg(
      widget.email,
      widget.email2,
      _txtController.text,
    );
    _txtController.clear();
    AppFunctions().goDownFunction(_controller);
  }
}
