import 'package:chatting/models/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageRecive extends StatelessWidget {
  final String email;
  MessageRecive({
    Key key,
    this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: StreamBuilder(
            stream: Firestore.instance
                .collection('textMe')
                .document('JzCPQt7TQZTZDMa5jfYq')
                .collection('lastText').orderBy('lastMsg', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text("");
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    return snapshot.data.documents[index]['from'] == email ||
                            snapshot.data.documents[index]['to'] == email
                        ? snapshot.data.documents[index]['text'] != ''
                            ? InkWell(
                                onTap: () {},
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                              snapshot.data.documents[index]
                                                          ['from'] ==
                                                      email
                                                  ? 'icons/flags/png/${snapshot.data.documents[index]['code']}.png'
                                                  : 'icons/flags/png/${snapshot.data.documents[index]['code2']}.png',
                                              package: 'country_icons',
                                              height: 40,
                                              width: 40,
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            snapshot.data.documents[index]
                                                        ['from'] ==
                                                    email
                                                ? snapshot.data.documents[index]
                                                            ['gender'] ==
                                                        "1"
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
                                                : snapshot.data.documents[index]
                                                            ['gender2'] ==
                                                        "1"
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
                                          children: <Widget>[
                                            Text(
                                              snapshot.data.documents[index]
                                                          ['from'] ==
                                                      email
                                                  ? snapshot.data
                                                      .documents[index]['name']
                                                  : snapshot
                                                          .data.documents[index]
                                                      ['name2'],
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .body1,
                                            ),
                                            Container(
                                              width: 150,
                                              child: Text(
                                                snapshot.data.documents[index]
                                                    ['text'],
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            )
                                          ],
                                        ),
                                        Stack(
                                          alignment: Alignment.bottomLeft,
                                          children: <Widget>[
                                            snapshot.data.documents[index]
                                                        ['from'] ==
                                                    email
                                                ? snapshot.data.documents[index]
                                                                ['image'] ==
                                                            null ||
                                                        snapshot.data.documents[
                                                                    index]
                                                                ['image'] ==
                                                            ''
                                                    ? Container(
                                                        width: 75.0,
                                                        height: 75.0,
                                                        decoration: new BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            image: new DecorationImage(
                                                                fit:
                                                                    BoxFit.fill,
                                                                image: snapshot.data.documents[index]
                                                                            [
                                                                            'gender'] ==
                                                                        '1'
                                                                    ? NetworkImage(
                                                                        'https://cdn4.iconfinder.com/data/icons/social-messaging-productivity-7/64/x-01-512.png')
                                                                    : NetworkImage(
                                                                        'https://cdn1.iconfinder.com/data/icons/business-planning-management-set-2/64/x-90-512.png'))),
                                                      )
                                                    : Container(
                                                        width: 75.0,
                                                        height: 75.0,
                                                        decoration:
                                                            new BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          image:
                                                              new DecorationImage(
                                                            fit: BoxFit.fill,
                                                            image:
                                                                new NetworkImage(
                                                              snapshot.data
                                                                      .documents[
                                                                  index]['image2'],
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                : snapshot.data.documents[index]
                                                                ['image2'] ==
                                                            null ||
                                                        snapshot.data
                                                                    .documents[index]
                                                                ['image2'] ==
                                                            ''
                                                    ? Container(
                                                        width: 75.0,
                                                        height: 75.0,
                                                        decoration:
                                                            new BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          image:
                                                              new DecorationImage(
                                                            fit: BoxFit.fill,
                                                            image: snapshot.data
                                                                            .documents[index]
                                                                        [
                                                                        'gender2'] ==
                                                                    '1'
                                                                ? NetworkImage(
                                                                    'https://cdn4.iconfinder.com/data/icons/social-messaging-productivity-7/64/x-01-512.png')
                                                                : NetworkImage(
                                                                    'https://cdn1.iconfinder.com/data/icons/business-planning-management-set-2/64/x-90-512.png'),
                                                          ),
                                                        ),
                                                      )
                                                    : Container(
                                                        width: 75.0,
                                                        height: 75.0,
                                                        decoration:
                                                            new BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          image:
                                                              new DecorationImage(
                                                            fit: BoxFit.fill,
                                                            image:
                                                                new NetworkImage(
                                                              snapshot.data
                                                                      .documents[
                                                                  index]['image2'],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                            // snapshot.data.documents[index]['online'] ==
                                            //         '1'
                                            //     ? Container(
                                            //         width: 20.0,
                                            //         height: 20.0,
                                            //         decoration: new BoxDecoration(
                                            //           shape: BoxShape.circle,
                                            //           color: Colors.lightGreenAccent[400],
                                            //         ),
                                            //       )
                                            //     : Container(
                                            //         width: 20.0,
                                            //         height: 20.0,
                                            //         decoration: new BoxDecoration(
                                            //           shape: BoxShape.circle,
                                            //           color: Colors.grey,
                                            //         ),
                                            //       ),
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
              }
            }),
      ),
    );
  }
}
