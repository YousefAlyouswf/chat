import 'package:chatting/models/app_functions.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var _nameController = TextEditingController();

  var _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _nameController,
              textAlign: TextAlign.end,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'أسم المستخدم أو البريد الاكتروني',
              ),
            ),
            TextField(
              controller: _passwordController,
              textAlign: TextAlign.end,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'كلمة المرور',
              ),
            ),
            SizedBox(
              height: 25,
            ),
            InkWell(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();

                bool auth = false;
                final QuerySnapshot result =
                    await Firestore.instance.collection('users').getDocuments();
                final List<DocumentSnapshot> documents = result.documents;
                documents.forEach((data) {
                  for (var i = 0; i < data['usersData'].length; i++) {
                    if (data['usersData'][i]['name'] == _nameController.text &&
                            data['usersData'][i]['password'] ==
                                _passwordController.text ||
                        data['usersData'][i]['email'] == _nameController.text &&
                            data['usersData'][i]['password'] ==
                                _passwordController.text) {
                      auth = true;
                      prefs.setString('username', data['usersData'][i]['name']);
                      prefs.setString('email', data['usersData'][i]['email']);
                      prefs.setString('gender', data['usersData'][i]['gender']);
                      prefs.setString('image', data['usersData'][i]['image']);
                      prefs.setString(
                          'password', data['usersData'][i]['password']);
                      AppFunctions().goToCountryRoom(context);
                      break;
                    }
                  }
                });

                if (!auth) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(
                      'أسم المستخدم أو كلمة المرور غير صحيحة',
                      textAlign: TextAlign.end,
                    ),
                    duration: Duration(seconds: 3),
                  ));
                }
              },
              child: Container(
                color: Colors.purple,
                width: double.infinity,
                height: 50,
                child: Center(
                  child: Text(
                    "دخول",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}