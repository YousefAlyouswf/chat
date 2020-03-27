import 'package:chatting/chatScreen/chatScreen.dart';
import 'package:chatting/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CurrentUsers extends StatelessWidget {
  final String current;
  final String email;
  final String image;
  const CurrentUsers({
    Key key,
    this.current,
    this.email,
    this.image,
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
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text("");
              } else {
                List<User> _user = new List();
                for (var i = 0; i < snapshot.data['usersData'].length; i++) {
                  if (snapshot.data['usersData'][i]['current'] == current) {
                    _user.add(User(
                      snapshot.data['usersData'][i]['name'],
                      snapshot.data['usersData'][i]['email'],
                      snapshot.data['usersData'][i]['image'],
                      snapshot.data['usersData'][i]['gender'],
                      snapshot.data['usersData'][i]['password'],
                      snapshot.data['usersData'][i]['current'],
                    ));
                  }
                }

                return ListView.builder(
                  itemCount: _user.length,
                  itemBuilder: (BuildContext context, int index) {
                 
                    return InkWell(
                      onTap: _user[index].email == email
                          ? null
                          : () async {
                            var now = DateTime.now().millisecondsSinceEpoch;

                              final QuerySnapshot result = await Firestore
                                  .instance
                                  .collection('chat')
                                  .getDocuments();
                              final List<DocumentSnapshot> documents =
                                  result.documents;
                              bool found = false;
                              documents.forEach((data) {
                                if (data['from'] == email &&
                                        data['to'] == _user[index].email ||
                                    data['to'] == email &&
                                        data['from'] == _user[index].email) {
                                  found = true;
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ChatScreen(
                                        userName: _user[index].name,
                                        userEmail: _user[index].email,
                                        myEmail: email,
                                        image: _user[index].image == ''
                                            ? _user[index].gender
                                            : _user[index].image,
                                      ),
                                    ),
                                  );
                                }
                              });
                              if (!found) {
                                Firestore.instance
                                    .collection('chat')
                                    .document()
                                    .setData({
                                  'from': email,
                                  'to': _user[index].email,
                                  'messages': FieldValue.arrayUnion([
                                    {
                                      'from': email,
                                      'to': _user[index].email,
                                      'content': '',
                                      'time':now
                                    },
                                  ]),
                                });
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ChatScreen(
                                      userName: _user[index].name,
                                      userEmail: _user[index].email,
                                      myEmail: email,
                                      image: _user[index].image,
                                    ),
                                  ),
                                );
                              }
                            },
                      child: Card(
                        color: _user[index].email == email
                            ? Colors.red[100]
                            : Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 20,
                                child: Image(
                                  image: AssetImage(_user[index].gender == '2'
                                      ? 'assets/images/female.png'
                                      : 'assets/images/male.png'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Text(_user[index].name),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 40,
                                child: Image(
                                  image: _user[index].image == null ||
                                          _user[index].image == ''
                                      ? AssetImage('assets/images/ph.png')
                                      : NetworkImage(_user[index].image),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            }),
      ),
    );
  }
}
