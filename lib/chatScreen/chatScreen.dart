import 'dart:async';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:chatting/models/app_functions.dart';
import 'package:chatting/models/firebase.dart';
import 'package:chatting/mysql/mysql_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';
import 'package:image_picker/image_picker.dart';
import '../models/firebase_model.dart';

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
  //Firebase Realtime <-------------------------------------
  List<RealTimeFirebase> _realTime = new List();
  DatabaseReference itemRef;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RealTimeFirebase realTimeFirebase;
  // End <-----------------------------------------------
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
    //------------------------------ TEST
    realTimeFirebase = RealTimeFirebase('', '', '', '', '', '');
    final FirebaseDatabase database = FirebaseDatabase.instance;
    itemRef = database.reference().child(widget.chatID);
    itemRef.onChildAdded.listen(_onEntryAdded);
    itemRef.onChildChanged.listen(_onEntryChanged);
    //------------------------------ TEST
  }

//------------------------------ TEST
  _onEntryAdded(Event event) {
    if (mounted) {
      setState(() {
        _realTime.add(RealTimeFirebase.fromSnapshot(event.snapshot));
      });
    }
  }

  _onEntryChanged(Event event) {
    var old = _realTime.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      _realTime[_realTime.indexOf(old)] =
          RealTimeFirebase.fromSnapshot(event.snapshot);
    });
  }

  void handleSubmit() {
    final FormState form = formKey.currentState;

    if (form.validate()) {
      form.save();
      form.reset();
      realTimeFirebase.email1 = widget.email;
      realTimeFirebase.email2 = widget.email2;
      itemRef.push().set(realTimeFirebase.toJson());
      AppFunctions().goDownFunction(_controller);
    }
  }

  //------------------------------ TEST
  String startTyping = '0';
  @override
  Widget build(BuildContext context) {
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
      //   resizeToAvoidBottomPadding: false,
      body: Column(
        children: <Widget>[
          Flexible(
            child: FirebaseAnimatedList(
                reverse: false,
                controller: _controller,
                query: itemRef,
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  return Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _realTime[index].email1 != widget.email
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
                                          image: NetworkImage(widget.image2),
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
                              mainAxisAlignment:
                                  _realTime[index].email1 == widget.email
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                _realTime[index].email1 == widget.email
                                    ? _realTime[index].read == '0'
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
                                    margin: _realTime[index].email1 ==
                                            widget.email
                                        ? BubbleEdges.only(top: 10, left: 10)
                                        : BubbleEdges.only(top: 10, right: 10),
                                    padding: BubbleEdges.only(
                                        right: 16.0, left: 16.0),
                                    stick: true,
                                    nip: _realTime[index].email1 == widget.email
                                        ? BubbleNip.rightTop
                                        : BubbleNip.leftTop,
                                    color:
                                        _realTime[index].email1 == widget.email
                                            ? Theme.of(context).cardColor
                                            : Colors.grey[300],
                                    child: Text(
                                      _realTime[index].text,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal),
                                      textAlign: TextAlign.right,
                                      textDirection: TextDirection.rtl,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        _realTime[index].email1 == widget.email
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 60.0,
                                  height: 60.0,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(widget.image),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  );
                }),
          ),

          //------------> here you type message
          Flexible(
            flex: 0,
            child: Container(
              decoration: new BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: new BorderRadius.all(
                  const Radius.circular(16.0),
                ),
              ),
              child: Row(
                children: <Widget>[
                  IconButton(icon: Icon(Icons.image), onPressed: null),
                  Flexible(
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Form(
                          key: formKey,
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            textAlign: TextAlign.end,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'أكتب هنا',
                            ),
                            onEditingComplete: handleSubmit,
                            textInputAction: TextInputAction.send,
                            initialValue: '',
                            onSaved: (val) => realTimeFirebase.text = val,
                            validator: (val) => val == "" ? val : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: handleSubmit,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
