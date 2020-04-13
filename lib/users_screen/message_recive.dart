import 'package:chatting/chatScreen/chatScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessageRecive extends StatelessWidget {
  final String email, gender, image, code, name;
  final Function getChat, getUsers, countNewMsg;
  MessageRecive({
    Key key,
    this.email,
    this.gender,
    this.image,
    this.code,
    this.name,
    this.getChat,
    this.countNewMsg,
    this.getUsers,
  }) : super(key: key);
  //---pull to refresh

  //---End pull
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder(
          stream:
              Firestore.instance.collection('chat').orderBy('num', descending: true).snapshots(),
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (BuildContext context, int index) {
                DocumentSnapshot chat = snapshot.data.documents[index];
                return chat['from'] == email || chat['to'] == email
                    ? chat['text'] != ''
                        ? InkWell(
                            onTap: () async {
                              if (chat['from'] == email) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ChatScreen(
                                      name: name,
                                      email: email,
                                      image: chat['from'],
                                      code: code,
                                      gender: gender,
                                      email2: chat['to'],
                                      gender2: chat['gender2'],
                                      name2: chat['name2'],
                                      code2: chat['code2'],
                                      image2: chat['image2'],
                                      chatID: chat.documentID,
                                      online: chat['online2'],
                                    ),
                                  ),
                                );
                              } else {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ChatScreen(
                                      name: name,
                                      email: email,
                                      image2: chat['image2'],
                                      code: code,
                                      gender: gender,
                                      email2: chat['from'],
                                      gender2: chat['gender1'],
                                      name2: chat['name1'],
                                      code2: chat['code1'],
                                      image: chat['image1'],
                                      chatID: chat.documentID,
                                      online: chat['online1'],
                                    ),
                                  ),
                                );
                              }
                              getChat();
                              countNewMsg();
                              getUsers();
                            },
                            child: Card(
                              color: chat['read'] == "0" &&
                                      chat['email_last'] != email
                                  ? Colors.yellow
                                  : Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Image.asset(
                                          chat['from'] != email
                                              ? 'icons/flags/png/${chat['code1']}.png'
                                              : 'icons/flags/png/${chat['code2']}.png',
                                          package: 'country_icons',
                                          height: 40,
                                          width: 40,
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        chat['from'] != email
                                            ? chat['gender1'] == "1"
                                                ? Image.asset(
                                                    'assets/images/male.png',
                                                    height: 20,
                                                    width: 20,
                                                  )
                                                : Image.asset(
                                                    'assets/images/female.png',
                                                    height: 20,
                                                    width: 20,
                                                  )
                                            : chat['gender2'] == "1"
                                                ? Image.asset(
                                                    'assets/images/male.png',
                                                    height: 20,
                                                    width: 20,
                                                  )
                                                : Image.asset(
                                                    'assets/images/female.png',
                                                    height: 20,
                                                    width: 20,
                                                  )
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            // snapshot.data.documents[index]
                                            //             ['typing'] ==
                                            //         '1'
                                            //     ? Image.network(
                                            //         'https://media.giphy.com/media/THksdFc9bFRAQcIc13/giphy.gif',
                                            //         height: 40,
                                            //         width: 40,
                                            //       )
                                            //     : Text(''),
                                            Text(
                                              chat['from'] != email
                                                  ? chat['name1']
                                                  : chat['name2'],
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .body1,
                                            ),
                                          ],
                                        ),
                                        Container(
                                          width: 150,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              chat['email_last'] == email
                                                  ? chat['read'] == '0'
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
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Flexible(
                                                child: Text(
                                                  chat['text'],
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Stack(
                                      alignment: Alignment.bottomLeft,
                                      children: <Widget>[
                                        chat['from'] != email
                                            ? Container(
                                                width: 75.0,
                                                height: 75.0,
                                                decoration: new BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: new DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: new NetworkImage(
                                                      chat['image1'],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                width: 75.0,
                                                height: 75.0,
                                                decoration: new BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: new DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: new NetworkImage(
                                                      chat['image2'],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                        chat['from'] != email
                                            ? chat['online1'] == '1'
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
                                            : chat['online2'] == '1'
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
                                                  ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Container()
                    : Container();
              },
            );
          }),
    );
  }
}
