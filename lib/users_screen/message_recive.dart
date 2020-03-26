import 'package:chatting/chatScreen/chatScreen.dart';
import 'package:chatting/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageRecive extends StatelessWidget {
  final String current;
  final String email;

  const MessageRecive({
    Key key,
    this.current,
    this.email,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: StreamBuilder(
          stream: Firestore.instance
              .collection('chat')
              .where('to', isEqualTo: email)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text("");
            } else {
              

              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                   
                    child: Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 20,
                            
                            ),
                          ),
                          Text(snapshot.data.documents[index]['from']),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 40,
                             
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
