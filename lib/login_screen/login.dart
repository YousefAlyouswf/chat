import 'package:chatting/mysql/mysql_functions.dart';
import 'package:flutter/material.dart';

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
            SizedBox(
              height: 25,
            ),
            InkWell(
              onTap: () async {
               
                Mysql().login(
                  _nameController.text,
                  _passwordController.text,
                  context,
                );
              },
              child: Container(
                color: Theme.of(context).primaryColor,
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
