import 'package:chatting/chatScreen/chatScreen.dart';
import 'package:chatting/models/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CurrentUsers extends StatelessWidget {
  final String email;
  final String image;
  final String code;
  final String name;
  final String gender;
  CurrentUsers({
    Key key,
    this.email,
    this.image,
    this.code,
    this.name,
    this.gender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: StreamBuilder(
            stream: Firestore.instance
                .collection('users')
                .document('wauiqt7wiUI283ANx9n1')
                .collection('allUsers')
                .orderBy('online', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text("");
              } else {
                try {
                  return ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        child: InkWell(
                          onTap: snapshot.data.documents[index]['email'] ==
                                  email
                              ? null
                              : () async {
                                  Fireebase().addToChatCollections(
                                    email,
                                    snapshot.data.documents[index]['email'],
                                    gender,
                                    image,
                                    code,
                                    name,
                                    snapshot.data.documents[index]['name'],
                                    snapshot.data.documents[index]['gender'],
                                    snapshot.data.documents[index]['image'],
                                    snapshot.data.documents[index]['code'],
                                  );
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ChatScreen(
                                        name: name,
                                        email: email,
                                        image: image,
                                        code: code,
                                        gender: gender,
                                        email2: snapshot.data.documents[index]
                                            ['email'],
                                        gender2: snapshot.data.documents[index]
                                            ['gender'],
                                        name2: snapshot.data.documents[index]
                                            ['name'],
                                        code2: snapshot.data.documents[index]
                                            ['code'],
                                        image2: snapshot.data.documents[index]
                                            ['image'],
                                      ),
                                    ),
                                  );
                                },
                          child: Card(
                            color:
                                snapshot.data.documents[index]['email'] == email
                                    ? Colors.grey
                                    : null,
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
                                        'icons/flags/png/${snapshot.data.documents[index]['code']}.png',
                                        package: 'country_icons',
                                        height: 40,
                                        width: 40,
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      snapshot.data.documents[index]
                                                  ['gender'] ==
                                              '1'
                                          ? Image.asset(
                                              'assets/images/male.png',
                                              height: 20,
                                              width: 20,
                                            )
                                          : Image.asset(
                                              'assets/images/female.png',
                                              height: 20,
                                              width: 20,
                                            ),
                                    ],
                                  ),
                                  Text(
                                    snapshot.data.documents[index]['name'],
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.title,
                                  ),
                                  Stack(
                                    alignment: Alignment.bottomLeft,
                                    children: <Widget>[
                                      snapshot.data.documents[index]['image'] ==
                                                  null ||
                                              snapshot.data.documents[index]
                                                      ['image'] ==
                                                  ''
                                          ? Container(
                                              width: 75.0,
                                              height: 75.0,
                                              decoration: new BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: new DecorationImage(
                                                      fit: BoxFit.fill,
                                                      image: snapshot.data.documents[
                                                                      index]
                                                                  ['gender'] ==
                                                              '1'
                                                          ? NetworkImage(
                                                              'https://cdn4.iconfinder.com/data/icons/social-messaging-productivity-7/64/x-01-512.png')
                                                          : NetworkImage(
                                                              'https://cdn1.iconfinder.com/data/icons/business-planning-management-set-2/64/x-90-512.png'))),
                                            )
                                          : Container(
                                              width: 75.0,
                                              height: 75.0,
                                              decoration: new BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: new DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: new NetworkImage(
                                                    snapshot.data
                                                            .documents[index]
                                                        ['image'],
                                                  ),
                                                ),
                                              ),
                                            ),
                                      snapshot.data.documents[index]
                                                  ['online'] ==
                                              '1'
                                          ? Container(
                                              width: 20.0,
                                              height: 20.0,
                                              decoration: new BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors
                                                    .lightGreenAccent[400],
                                              ),
                                            )
                                          : Container(
                                              width: 20.0,
                                              height: 20.0,
                                              decoration: new BoxDecoration(
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
                        ),
                      );
                    },
                  );
                } catch (e) {
                  return null;
                }
              }
            }),
      ),
    );
  }
}
