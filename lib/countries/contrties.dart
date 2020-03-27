import 'package:chatting/users_screen/mainUsersScreen.dart';
import 'package:flutter/material.dart';
import '../drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Contrties extends StatefulWidget {
  final String email;
  final String name;
  final String gender;
  final String image;
  final String password;
  const Contrties(
      {Key key, this.email, this.name, this.gender, this.image, this.password})
      : super(key: key);
  @override
  _ContrtiesState createState() => _ContrtiesState();
}

class _ContrtiesState extends State<Contrties> {
  void goToCountryRoom() async {
    bool other = true;
    final QuerySnapshot result =
        await Firestore.instance.collection('countries').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    documents.forEach((data) {
      for (var i = 0; i < data['all'].length; i++) {
        if (prefs.getString('country') == data['all'][i]['code']) {
          other = false;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => UsersScreen(
                name: widget.name,
                email: widget.email,
                image: widget.image,
                gender: widget.gender,
                password: widget.password,
                current: data['all'][i]['country'],
              ),
            ),
          );
        }
      }
    });

    if (other) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => UsersScreen(
            name: widget.name,
            email: widget.email,
            image: widget.image,
            gender: widget.gender,
            password: widget.password,
            current: 'أخرى',
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    goToCountryRoom();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[900],
        title: Text("سوالف"),
        centerTitle: true,
      ),
      endDrawer: DrawerPage(
        name: widget.name,
        email: widget.email,
        image: widget.image,
        gender: widget.gender,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: StreamBuilder(
              stream: Firestore.instance
                  .collection('countries')
                  .document('MAqRIisbFZtn4YGoRCqV')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text("");
                } else {
                  return GridView.builder(
                      itemCount: snapshot.data['all'].length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1.2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () async {
                            await Firestore.instance
                                .collection('users')
                                .document('wauiqt7wiUI283ANx9n1')
                                .updateData({
                              'usersData': FieldValue.arrayRemove([
                                {
                                  'email': widget.email,
                                  'gender': widget.gender,
                                  'name': widget.name,
                                  'password': widget.password,
                                  'image': widget.image,
                                  'current': '',
                                },
                              ]),
                            });
                            await Firestore.instance
                                .collection('users')
                                .document('wauiqt7wiUI283ANx9n1')
                                .updateData({
                              'usersData': FieldValue.arrayUnion([
                                {
                                  'email': widget.email,
                                  'gender': widget.gender,
                                  'name': widget.name,
                                  'password': widget.password,
                                  'image': widget.image,
                                  'current': snapshot.data['all'][index]
                                      ['country'],
                                },
                              ]),
                            });

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) => UsersScreen(
                                  name: widget.name,
                                  email: widget.email,
                                  image: widget.image,
                                  gender: widget.gender,
                                  password: widget.password,
                                  current: snapshot.data['all'][index]
                                      ['country'],
                                ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 0,
                            color: Colors.white70,
                            child: Container(
                              decoration: new BoxDecoration(
                                  image: new DecorationImage(
                                      image: new NetworkImage(
                                          snapshot.data['all'][index]['image']),
                                      fit: BoxFit.cover)),
                              child: Stack(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      width: double.infinity,
                                      color: Colors.white70,
                                      child: Text(
                                        snapshot.data['all'][index]['country'],
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                        "الأعضاء 10",
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                }
              }),
        ),
      ),
    );
  }
}
