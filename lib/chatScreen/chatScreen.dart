import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String myEmail;
  final String image;
  ChatScreen({Key key, this.userName, this.userEmail, this.myEmail, this.image})
      : super(key: key);

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
      if (data['from'] == widget.myEmail && data['to'] == widget.userEmail ||
          data['to'] == widget.myEmail && data['from'] == widget.userEmail) {
        setState(() {
          chattingID = data.documentID;
        });
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
        title: Text(widget.userName),
        backgroundColor: Colors.purple[900],
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Image.network(widget.image == '1' || widget.image == '2'
                ? genderImage
                : widget.image),
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
                      .document(chattingID)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text("");
                    } else {
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
                              title: from == widget.myEmail
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
                              trailing: from == widget.myEmail
                                  ? Image(
                                      image: AssetImage('assets/images/ph.png'),
                                      fit: BoxFit.fill,
                                    )
                                  : null,
                              leading: from != widget.myEmail
                                  ? Image(
                                      image: AssetImage('assets/images/ph.png'),
                                      fit: BoxFit.fill,
                                    )
                                  : null,
                            )),
                          );
                        },
                      );
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
                        await Firestore.instance
                            .collection('chat')
                            .document(chattingID)
                            .updateData({
                          'messages': FieldValue.arrayUnion([
                            {
                              'content': _txtController.text,
                              'from': widget.myEmail,
                              'to': widget.userEmail
                            },
                          ]),
                        });
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
