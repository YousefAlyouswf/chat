import 'package:chatting/chatScreen/chatScreen.dart';
import 'package:chatting/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CurrentUsers extends StatelessWidget {
  final String current;
  final String email;
  final String image;
  final String code;
  const CurrentUsers({
    Key key,
    this.current,
    this.email,
    this.image,
    this.code,
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
                      snapshot.data['usersData'][i]['code'],
                    ));
                  }
                }
                try {
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
                                        'time': now
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
                              ? Colors.grey
                              : _user[index].gender == '2'
                                  ? Colors.pink[100]
                                  : Colors.blue[100],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: Image.asset(
                                'icons/flags/png/${_user[index].code}.png',
                                package: 'country_icons',
                                height: 60,
                                width: 60,
                              ),
                        
                              title: Text(
                                _user[index].name,
                                textAlign: TextAlign.center,
                              ),

                              trailing: Image(
                                image: _user[index].image == null ||
                                        _user[index].image == ''
                                    ? _user[index].gender=='1'?  NetworkImage('https://www.pngitem.com/pimgs/m/184-1842706_transparent-like-a-boss-clipart-man-icon-png.png'): NetworkImage('https://www.nicepng.com/png/detail/207-2074651_png-file-woman-person-icon-png.png')
                                    : NetworkImage(_user[index].image),
                                fit: BoxFit.fitWidth,
                                height: 60,
                                width: 60,
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
