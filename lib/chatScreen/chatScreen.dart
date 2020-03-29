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
        backgroundColor: Colors.purple[900],
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
                                          child: Container(
                                            width: 60.0,
                                            height: 60.0,
                                            decoration: new BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: new DecorationImage(
                                                fit: BoxFit.fill,
                                                image: new AssetImage(
                                                    'assets/images/ph.png'),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Bubble(
                                        margin: BubbleEdges.only(top: 10),
                                        stick: true,
                                        nip: from == widget.email
                                            ? BubbleNip.rightTop
                                            : BubbleNip.leftTop,
                                        color:
                                            Color.fromRGBO(225, 255, 199, 1.0),
                                        child: Text(
                                            snapshot.data.documents[index]
                                                ['content'],
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
                                                    image: new AssetImage(
                                                        'assets/images/ph.png'),
                                                  ))),
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
                        onEditingComplete: callback,
                        textInputAction: TextInputAction.send,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        IconButton(icon: Icon(Icons.send), onPressed: callback),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> callback() async {
    var now = DateTime.now().millisecondsSinceEpoch;

    Fireebase().updateToChatCollections(
      widget.email,
      widget.email2,
      now,
      _txtController.text,
      chattingID,
    );

    _txtController.clear();
    AppFunctions().goDownFunction(_controller);
  }
}
