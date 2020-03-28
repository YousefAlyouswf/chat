import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  int group = 1;
  var _nameController = TextEditingController();
  var _emailController = TextEditingController();
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
                hintText: 'أسم المستخدم',
              ),
            ),
            TextField(
              controller: _emailController,
              textAlign: TextAlign.end,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'البريد الاكتروني',
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Radio(
                    value: 2,
                    groupValue: group,
                    onChanged: (t) {
                      setState(() {
                        group = t;
                      });
                    }),
                Text("أنثى"),
                Radio(
                    value: 1,
                    groupValue: group,
                    onChanged: (t) {
                      setState(() {
                        group = t;
                      });
                    }),
                Text("ذكر"),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            InkWell(
              onTap: () async {
                List<Map<String, dynamic>> maplist = [
                  {
                    'email': _emailController.text,
                    'gender': group.toString(),
                    'name': _nameController.text,
                    'password': _passwordController.text,
                    'image': '',
                    'current': '',
                  },
                ];
                await Firestore.instance
                    .collection('users')
                    .document('wauiqt7wiUI283ANx9n1')
                    .updateData({
                  'usersData': FieldValue.arrayUnion(maplist),
                });
              },
              child: Container(
                color: Colors.purple,
                width: double.infinity,
                height: 50,
                child: Center(
                  child: Text(
                    "تسجيل",
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
