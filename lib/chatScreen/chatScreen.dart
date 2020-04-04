import 'package:chatting/models/app_functions.dart';
import 'package:chatting/models/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';

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
  final String online2;

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
    this.online2,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  double width = 0, height = 60;
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
    try {
      getMsgId();
      if (width == 0) {
        width = MediaQuery.of(context).size.width;
      }
      // AppFunctions().goDownFunction(_controller);
    } catch (e) {}

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name2),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
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

                            return Container(
                              child: Row(
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
                                              widget.online2 == '1'
                                                  ? Container(
                                                      width: 15.0,
                                                      height: 15.0,
                                                      decoration:
                                                          new BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors
                                                                .lightGreenAccent[
                                                            400],
                                                      ),
                                                    )
                                                  : Container(
                                                      width: 15.0,
                                                      height: 15.0,
                                                      decoration:
                                                          new BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.grey,
                                                      ),
                                                    )
                                            ],
                                          ),
                                        )
                                      : Container(),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Bubble(
                                        margin: from == widget.email
                                            ? BubbleEdges.only(
                                                top: 20, left: 40)
                                            : BubbleEdges.only(
                                                top: 20, right: 40),
                                        padding: BubbleEdges.all(16.0),
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
                                            style: Theme.of(context)
                                                .textTheme
                                                .body1,
                                            textAlign: from == widget.email
                                                ? TextAlign.right
                                                : TextAlign.left),
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
                                                  image: NetworkImage(
                                                      widget.image)),
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
                color: Colors.white10,
                child: Row(
                  children: <Widget>[
                    IconButton(icon: Icon(Icons.image), onPressed: () {}),
                    Flexible(
                      child: Container(
                        decoration: new BoxDecoration(
                            color: Colors.orange,
                            borderRadius: new BorderRadius.all(
                              const Radius.circular(40.0),
                            )),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: TextField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            controller: _txtController,
                            textAlign: TextAlign.end,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'أكتب هنا',
                            ),
                            onChanged: (v) {},
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
                              onPressed: null,
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

  int now;
  int lastMsg;
  Future<void> callback() async {
    if (now != null) {
      now = now - 1;
    }
    final QuerySnapshot result = await Firestore.instance
        .collection('chat/$chattingID/messages')
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

    //----------------------------------------------- Show last message

    if (lastMsg != null) {
      lastMsg--;
    }
    final QuerySnapshot lastMessages = await Firestore.instance
        .collection('textMe/JzCPQt7TQZTZDMa5jfYq/lastText')
        .orderBy('lastMsg')
        .where('lastMsg', isGreaterThan: lastMsg)
        .getDocuments();
    final List<DocumentSnapshot> documentsOfLastMessage =
        lastMessages.documents;
    documentsOfLastMessage.forEach((data) {
      lastMsg = data['lastMsg'];
    });
    if (lastMsg == 0) {
      lastMsg = 1;
    } else {
      lastMsg++;
    }

    String lastTextId;
    final QuerySnapshot textId = await Firestore.instance
        .collection('textMe')
        .document('JzCPQt7TQZTZDMa5jfYq')
        .collection('lastText')
        .getDocuments();
    final List<DocumentSnapshot> documentstextId = textId.documents;
    documentstextId.forEach((data) {
      if (data['from'] == widget.email && data['to'] == widget.email2 ||
          data['to'] == widget.email && data['from'] == widget.email2) {
        lastTextId = data.documentID;
      }
    });

    //------------------------- this the firestore function
    Fireebase().updateToChatCollections(
      widget.email,
      widget.email2,
      now,
      _txtController.text,
      chattingID,
      lastTextId,
      lastMsg,
    );

    _txtController.clear();
    AppFunctions().goDownFunction(_controller);
  }
}
