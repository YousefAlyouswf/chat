import 'package:chatting/models/firebase.dart';
import 'package:chatting/users_screen/mainUsersScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CountryPage extends StatelessWidget {
  final String email;

  final String gender;

  final String name;

  final String password;

  final String image;

  final String code;

  final Map map;

  const CountryPage(this.email, this.gender, this.name, this.password,
      this.image, this.code, this.map);

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                          Fireebase().addCountry(
                              email,
                              gender,
                              name,
                              password,
                              image,
                              snapshot.data['all'][index]['country'],
                              code);

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => UsersScreen(
                                name: name,
                                email: email,
                                image: image,
                                gender: gender,
                                password: password,
                                current: snapshot.data['all'][index]['country'],
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
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    width: double.infinity,
                                    color: Colors.black54,
                                    child: Text(
                                      map[snapshot.data['all'][index]
                                                      ['country']]
                                                  .toString() ==
                                              "null"
                                          ? 'الأعضاء  '+'0'
                                          :'الأعضاء  '+ map[snapshot.data['all'][index]
                                                  ['country']]
                                              .toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 13, color: Colors.white),
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
    );
  }
}
