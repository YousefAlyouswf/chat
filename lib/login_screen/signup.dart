import 'package:chatting/mysql/mysql_functions.dart';
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
                Mysql().regUser(
                  _nameController.text,
                  _passwordController.text,
                  _emailController.text,
                  group.toString(),
                );
              },
              child: Container(
                color: Theme.of(context).primaryColor,
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
