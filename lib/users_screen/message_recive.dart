import 'package:chatting/chatScreen/chatScreen.dart';
import 'package:chatting/models/chat_model.dart';
import 'package:chatting/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageRecive extends StatelessWidget {
  final String current;
  final String email;
  final List<ChatModel> chatModel;
  MessageRecive({
    Key key,
    this.current,
    this.email,
    this.chatModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: ListView.builder(
          itemCount: chatModel.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {},
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
                    Text(chatModel[index].to == email
                        ? chatModel[index].from
                        : chatModel[index].to),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
