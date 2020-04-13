import 'dart:async';
import 'dart:io';
import 'package:chatting/models/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:chatting/models/app_functions.dart';
import 'package:chatting/mysql/mysql_functions.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';
import 'package:image_picker/image_picker.dart';
import '../models/firebase_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:vector_math/vector_math_64.dart' as vc;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String url;
  ScrollController _controller = ScrollController();

  FirebaseDatabase database;
  final databaseForTyping = FirebaseDatabase.instance.reference();
  @override
  void initState() {
    super.initState();
    //------------------------------ TEST
    realTimeFirebase = RealTimeFirebase('', '', '', '', '', '');
    database = FirebaseDatabase.instance;
    itemRef = database.reference().child(widget.chatID).child('chat');
    itemRef.onChildAdded.listen(_onEntryAdded);
    itemRef.onChildChanged.listen(_onEntryChanged);
    itemRef.onChildRemoved.listen(_onEntryRemoved);
    AppFunctions().goDownFunction(_controller);
    //------------------------------ TEST
    databaseForTyping.onChildChanged.listen(type);
    itemRef.onChildAdded.listen(chatScreenDown);
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
    try {
      var old = _realTime.singleWhere((entry) {
        return entry.key == event.snapshot.key;
      });
      setState(() {
        _realTime[_realTime.indexOf(old)] =
            RealTimeFirebase.fromSnapshot(event.snapshot);
      });
    } catch (e) {
      print('error');
    }
  }

  _onEntryRemoved(Event event) {
    if (mounted) {
      setState(() {
        _realTime.remove(RealTimeFirebase.fromSnapshot(event.snapshot));
      });
    }
  }

  chatScreenDown(Event event) {
    AppFunctions().goDownFunction(_controller);
  }

  int lastMsg;
  void handleSubmit(String urlImage) async {
    await databaseForTyping
        .reference()
        .child(widget.chatID)
        .child('typing' + widget.email)
        .update({'typingTo': ''});
    final FormState form = formKey.currentState;

    if (form.validate()) {
      form.save();
      form.reset();
      realTimeFirebase.email1 = widget.email;
      realTimeFirebase.email2 = widget.email2;
      realTimeFirebase.image = '';
      realTimeFirebase.read = '0';
      await itemRef.push().set(realTimeFirebase.toJson());

      AppFunctions().goDownFunction(_controller);
      if (lastMsg != null) {
        lastMsg--;
      }
      final QuerySnapshot lastMessages = await Firestore.instance
          .collection('chat')
          .orderBy('num')
          .where('num', isGreaterThan: lastMsg)
          .getDocuments();
      final List<DocumentSnapshot> documentsOfLastMessage =
          lastMessages.documents;
      documentsOfLastMessage.forEach((data) {
        lastMsg =  data['num'];
      });
      if (lastMsg == 0) {
        lastMsg = 1;
      } else {
        lastMsg++;
      }
      Fireebase().addLastMesageToFiresotre(
          widget.chatID, widget.email, realTimeFirebase.text, lastMsg);
    } else if (urlImage != null) {
      form.save();
      form.reset();
      realTimeFirebase.email1 = widget.email;
      realTimeFirebase.email2 = widget.email2;
      realTimeFirebase.image = urlImage;
      await itemRef.push().set(realTimeFirebase.toJson());

      AppFunctions().goDownFunction(_controller);
      if (lastMsg != null) {
        lastMsg--;
      }
      final QuerySnapshot lastMessages = await Firestore.instance
          .collection('chat')
          .orderBy('num')
          .where('num', isGreaterThan: lastMsg)
          .getDocuments();
      final List<DocumentSnapshot> documentsOfLastMessage =
          lastMessages.documents;
      documentsOfLastMessage.forEach((data) {
        lastMsg = data['num'];
      });
      if (lastMsg == 0) {
        lastMsg = 1;
      } else {
        lastMsg++;
      }
      Fireebase()
          .addLastMesageToFiresotre(widget.chatID, widget.email, 'أرسل صورة 1989 تممم', lastMsg);
    }
    setState(() {
      urlImage = null;
      url = null;
    });
  }

  type(Event event) async {
    try {
      await databaseForTyping
          .reference()
          .child(widget.chatID)
          .child('typing' + widget.email2)
          .once()
          .then((DataSnapshot snap) {
        if (mounted) {
          setState(() {
            startTyping = snap.value['typingTo'];
          });
        }
      });
    } catch (e) {}
  }

  void saveLastMsg(String msg) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(widget.chatID, msg);
  }

  File _image;
  String startTyping;
  //------------------------------ TEST
  @override
  Widget build(BuildContext context) {
    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
      });
      uploadImage();
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            startTyping == widget.email
                ? Image.network(
                    'https://media.giphy.com/media/FsWCqX6FR0ASKUOArv/giphy.gif',
                    height: 60,
                    width: 60,
                  )
                : Text(""),
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
          buildChatFlexible(),
          buildInputFlexible(context, getImage),
        ],
      ),
    );
  }

  Flexible buildInputFlexible(BuildContext context, Future getImage()) {
    return Flexible(
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
            IconButton(icon: Icon(Icons.image), onPressed: getImage),
            Flexible(
              child: Container(
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Form(
                    key: formKey,
                    child: TextFormField(
                      onChanged: (t) {
                        if (t.length == 1) {
                          databaseForTyping
                              .reference()
                              .child(widget.chatID)
                              .child('typing' + widget.email)
                              .set({
                            'typingTo': widget.email2,
                          });
                        } else if (t.length == 0) {
                          databaseForTyping
                              .reference()
                              .child(widget.chatID)
                              .child('typing' + widget.email)
                              .update({'typingTo': ''});
                        }
                      },
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      textAlign: TextAlign.end,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'أكتب هنا',
                      ),
                      onEditingComplete: () {
                        handleSubmit(url);
                      },
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
                onPressed: () {
                  handleSubmit(url);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Flexible buildChatFlexible() {
    return Flexible(
      child: FirebaseAnimatedList(
          reverse: false,
          controller: _controller,
          query: itemRef,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            if (_realTime[index].email1 != widget.email &&
                _realTime[index].key != 'typing') {
              itemRef
                  .child(_realTime[index].key)
                  .update({'read': '1'}).whenComplete(() {
                Mysql().updateReadMsg(widget.email, widget.email2);
              });
            }
            saveLastMsg(_realTime.last.text);
            return InkWell(
              onLongPress: () {
                print(_realTime[index].key.toString());
                //  itemRef.child(_realTime[index].key).remove();
              },
              child: Container(
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

                            //------ Here send Image to chat
                            _realTime[index].image != ''
                                ? InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            CustomDialog(
                                          description: _realTime[index].image,
                                        ),
                                      );
                                    },
                                    child: Bubble(
                                      margin: _realTime[index].email1 ==
                                              widget.email
                                          ? BubbleEdges.only(
                                              top: 10,
                                              left: 10,
                                            )
                                          : BubbleEdges.only(
                                              top: 10,
                                              right: 10,
                                            ),
                                      padding: BubbleEdges.only(
                                        right: 16.0,
                                        left: 16.0,
                                      ),
                                      stick: true,
                                      nip: _realTime[index].email1 ==
                                              widget.email
                                          ? BubbleNip.rightTop
                                          : BubbleNip.leftTop,
                                      color: _realTime[index].email1 ==
                                              widget.email
                                          ? Theme.of(context).cardColor
                                          : Colors.grey[300],
                                      child: Container(
                                        width: 100,
                                        height: 100,
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          image: new DecorationImage(
                                            fit: BoxFit.fill,
                                            image: new NetworkImage(
                                              _realTime[index].image,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                :
                                //-------- End Image to Chat
                                Flexible(
                                    child: Bubble(
                                      margin: _realTime[index].email1 ==
                                              widget.email
                                          ? BubbleEdges.only(
                                              top: 10,
                                              left: 10,
                                            )
                                          : BubbleEdges.only(
                                              top: 10,
                                              right: 10,
                                            ),
                                      padding: BubbleEdges.only(
                                        right: 16.0,
                                        left: 16.0,
                                      ),
                                      stick: true,
                                      nip: _realTime[index].email1 ==
                                              widget.email
                                          ? BubbleNip.rightTop
                                          : BubbleNip.leftTop,
                                      color: _realTime[index].email1 ==
                                              widget.email
                                          ? Theme.of(context).cardColor
                                          : Colors.grey[300],
                                      child: Text(
                                        _realTime[index].text,
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
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
              ),
            );
          }),
    );
  }

  Future uploadImage() async {
    String fileName = '${DateTime.now()}.png';
    StorageReference firebaseStorage =
        FirebaseStorage.instance.ref().child(fileName);

    if (_image.lengthSync() > 1000000) {
      Fluttertoast.showToast(
          msg: "حجم الصورة كبير!! أختر صورة أخرى",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      StorageUploadTask uploadTask = firebaseStorage.putFile(_image);
      await uploadTask.onComplete;
      url = await firebaseStorage.getDownloadURL() as String;

      if (url.isNotEmpty) {
        handleSubmit(url);
      }
    }
  }
}

class CustomDialog extends StatefulWidget {
  final String description;

  CustomDialog({
    @required this.description,
  });

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  double _scale = 1.0;

  double _previuseScale = 1.0;

  dialogContent(BuildContext context) {
    return GestureDetector(
      onScaleStart: (ScaleStartDetails _detials) {
        print(_detials);
        _previuseScale = _scale;
        setState(() {});
      },
      onScaleUpdate: (ScaleUpdateDetails _detials) {
        _scale = _previuseScale * _detials.scale;
        setState(() {});
      },
      onScaleEnd: (ScaleEndDetails _detials) {
        _previuseScale = 1.0;
        setState(() {});
      },
      child: Transform(
        transform: Matrix4.diagonal3(vc.Vector3(_scale, _scale, _scale)),
        alignment: FractionalOffset.center,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.5,
          width: double.infinity,
          decoration: new BoxDecoration(
            shape: BoxShape.rectangle,
            image: new DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(widget.description),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}
