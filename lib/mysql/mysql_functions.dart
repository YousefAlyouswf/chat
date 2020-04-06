
import 'package:chatting/users_screen/mainUsersScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Mysql {
  Future regUser(
      String userName, String password, String email, String genderToDB) async {
    var url =
        'http://gewscrap.com/testchat/get.php?user=$userName&email=$email&gender=$genderToDB&password=$password';
    Response response = await get(url);
  }

  Future loginUser(
      String userName, String password, BuildContext context) async {
    var url =
        'http://gewscrap.com/testchat/login.php?user=$userName&password=$password';
    Response response = await get(url);
    print(response.body.toString());
    if (response.body.toString() == '1') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => UsersScreen(
            name: 'Admin',
            email: 'Admin@admin.com',
            image: '',
            gender: '1',
            password: '1',
            code: 'us',
          ),
        ),
      );
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'أسم المستخدم أو كلمة المرور غير صحيحة',
          textAlign: TextAlign.end,
        ),
        duration: Duration(seconds: 3),
      ));
    }
  }
}
