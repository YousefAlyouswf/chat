import 'dart:convert';

import 'package:chatting/users_screen/mainUsersScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class Mysql {
  static const ROOT = "http://gewscrap.com/testchat/connect.php";
  static const ADD_USER = "ADD_USER";
  static const LOGIN = "LOGIN";
  static const GET_USERS = "GET_USERS";
  static const UPDATE_STATUS = "UPDATE_STATUS";
  static const DELETE = "DELETE";

  //get all users from mysql to show them in the users screen

  Future<List<Users>> getUsers() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = GET_USERS;
      final response = await http.post(ROOT, body: map);
      print('getEmployees Response: ${response.body}');
      if (200 == response.statusCode) {
        List<Users> list = parseResponse(response.body);
        return list;
      } else {
        return List<Users>();
      }
    } catch (e) {
      return List<Users>();
    }
  }

 static List<Users> parseResponse(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Users>((json) => Users.fromJson(json)).toList();
  }

  // Method to add employee to the database...
  Future<String> addUser(
    String userName,
    String password,
    String email,
    String genderToDB,
    BuildContext context,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String countryCode = prefs.getString('code');
      var map = Map<String, dynamic>();
      map['action'] = ADD_USER;
      map['user'] = userName;
      map['password'] = password;
      map['email'] = email;
      map['gender'] = genderToDB;
      map['code'] = countryCode;
      final response = await http.post(ROOT, body: map);
      print('addUser Response: ${response.body}');
      if (200 == response.statusCode) {
        if (response.body == '1') {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                'البريد الاكتروني مسجل على حساب اخر',
                textAlign: TextAlign.end,
              ),
              duration: Duration(seconds: 3),
            ),
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => UsersScreen(
                name: userName,
                email: email,
                image: '',
                gender: genderToDB,
                password: password,
                code: countryCode,
              ),
            ),
          );
        }
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  Future<String> login(
      String email, String password, BuildContext context) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = LOGIN;
      map['email'] = email;
      map['password'] = password;
      final response = await http.post(ROOT, body: map);
      print('updateEmployee Response: ${response.body}');
      if (200 == response.statusCode) {
        if (response.body == '1') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => UsersScreen(
                name: "userName",
                email: email,
                image: '',
                gender: "1",
                password: password,
                code: 'sa',
              ),
            ),
          );
        } else {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                'خطأ في المعلومات',
                textAlign: TextAlign.end,
              ),
              duration: Duration(seconds: 3),
            ),
          );
        }
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  // Method to update an Employee in Database...
  Future<String> updateUser(
      String empId, String firstName, String lastName) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = UPDATE_STATUS;
      map['emp_id'] = empId;
      map['first_name'] = firstName;
      map['last_name'] = lastName;
      final response = await http.post(ROOT, body: map);
      print('updateEmployee Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  // Method to Delete an Employee from Database...
  static Future<String> deleteUser(String empId) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = DELETE;
      map['emp_id'] = empId;
      final response = await http.post(ROOT, body: map);
      print('deleteEmployee Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error"; // returning just an "error" string to keep this simple...
    }
  }
  // Future regUser(
  //   String userName,
  //   String password,
  //   String email,
  //   String genderToDB,
  //   BuildContext context,
  // ) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String countreyCode = prefs.getString('code');
  //   var url =
  //       'http://gewscrap.com/testchat/get.php?user=$userName&email=$email&gender=$genderToDB&password=$password&code=$countreyCode';
  //   Response response = await get(url);
  //   if (response.body.toString() == '1') {
  //     Scaffold.of(context).showSnackBar(
  //       SnackBar(
  //         backgroundColor: Colors.red,
  //         content: Text(
  //           'البريد الاكتروني مسجل على حساب اخر',
  //           textAlign: TextAlign.end,
  //         ),
  //         duration: Duration(seconds: 3),
  //       ),
  //     );
  //   } else {
  //     Scaffold.of(context).showSnackBar(
  //       SnackBar(
  //         backgroundColor: Colors.green,
  //         content: Text(
  //           'تم التسجيل بنجاح',
  //           textAlign: TextAlign.end,
  //         ),
  //         duration: Duration(seconds: 3),
  //       ),
  //     );
  //     Navigator.of(context).push(
  //       MaterialPageRoute(
  //         builder: (BuildContext context) => UsersScreen(
  //           name: 'Admin',
  //           email: 'Admin@admin.com',
  //           image: '',
  //           gender: '1',
  //           password: '1',
  //           code: 'us',
  //         ),
  //       ),
  //     );
  //   }
  // }

  // Future loginUser(
  //     String userName, String password, BuildContext context) async {
  //   var url =
  //       'http://gewscrap.com/testchat/login.php?user=$userName&password=$password';
  //   Response response = await get(url);
  //   print(response.body.toString());

  //   if (response.body.toString() == '1') {
  //     Navigator.of(context).push(
  //       MaterialPageRoute(
  //         builder: (BuildContext context) => UsersScreen(
  //           name: 'Admin',
  //           email: 'Admin@admin.com',
  //           image: '',
  //           gender: '1',
  //           password: '1',
  //           code: 'us',
  //         ),
  //       ),
  //     );
  //   } else {
  //     Scaffold.of(context).showSnackBar(SnackBar(
  //       backgroundColor: Colors.red,
  //       content: Text(
  //         'أسم المستخدم أو كلمة المرور غير صحيحة',
  //         textAlign: TextAlign.end,
  //       ),
  //       duration: Duration(seconds: 3),
  //     ));
  //   }
  // }
}
