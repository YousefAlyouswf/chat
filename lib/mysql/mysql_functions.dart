import 'dart:convert';

import 'package:chatting/models/chat_model.dart';
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
  static const UPDATE_IMAGE = "UPDATE_IMAGE";
  static const DELETE = "DELETE";
  static const UPDATE_USER_INFO = "UPDATE_USER_INFO";
  static const GET_THIS_USER = "GET_THIS_USER";
  static const OFFLINE = 'OFFLINE';
  static const ADD_TO_CHAT = 'ADD_TO_CHAT';
  static const GET_CHAT = "GET_CHAT";
  static const UPDATE_LAST_MSG = "UPDATE_LAST_MSG";
  static const UPDATE_READ_MSG = "UPDATE_READ_MSG";
  static const GET_CHAT_ID = "GET_CHAT_ID";
  static const COUNT_NEW_MSG = "COUNT_NEW_MSG";

  //get all users from mysql to show them in the users screen

  Future<List<Users>> getUsers() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = GET_USERS;
      final response = await http.post(ROOT, body: map);
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
          updateUserInfo(email);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("email", email);
          prefs.setString("password", password);
          getThisUserInfo(email).then((user) {
            _user = user;
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => UsersScreen(
                  email: email,
                  password: password,
                  name: _user[0].name,
                  image: _user[0].image,
                  code: _user[0].code,
                  gender: _user[0].gender,
                ),
              ),
            );
          });
        }
        return response.body;
      } else {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'حدث خطأ في الاتصال',
              textAlign: TextAlign.end,
            ),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'لا يوجد إتصال بالشبكه',
            textAlign: TextAlign.end,
          ),
          duration: Duration(seconds: 3),
        ),
      );
    }
    return null;
  }

  List<Users> _user;
  Future<String> login(
      String email, String password, BuildContext context) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = LOGIN;
      map['email'] = email;
      map['password'] = password;
      final response = await http.post(ROOT, body: map);
      if (200 == response.statusCode) {
        if (response.body == '1') {
          updateUserInfo(email);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("email", email);
          prefs.setString("password", password);
          getThisUserInfo(email).then((user) {
            _user = user;
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => UsersScreen(
                  email: email,
                  password: password,
                  name: _user[0].name,
                  image: _user[0].image,
                  code: _user[0].code,
                  gender: _user[0].gender,
                ),
              ),
            );
          });
          //------------------------ Send user to main chat

        } else {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                'الإيميل أو الباسورد غير صحيح',
                textAlign: TextAlign.end,
              ),
              duration: Duration(seconds: 3),
            ),
          );
        }
        return response.body;
      } else {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'حدث خطأ في الاتصال',
              textAlign: TextAlign.end,
            ),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'لا يوجد إتصال بالشبكه',
            textAlign: TextAlign.end,
          ),
          duration: Duration(seconds: 3),
        ),
      );
    }
    return null;
  }

  Future<String> updateUserImage(
    String email,
    String image,
  ) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = UPDATE_IMAGE;
      map['email'] = email;
      map['image'] = image;
      final response = await http.post(ROOT, body: map);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  Future<String> updateUserOffline(
    String email,
  ) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = OFFLINE;
      map['email'] = email;
      final response = await http.post(ROOT, body: map);

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
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error"; // returning just an "error" string to keep this simple...
    }
  }

  Future<String> updateUserInfo(String email) async {
    try {
      //First  we gonna update user info
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String country = prefs.getString('country');
      String code = prefs.getString('code');
      String ip = prefs.getString('ip');
      var map = Map<String, dynamic>();
      map['action'] = UPDATE_USER_INFO;
      map['email'] = email;
      map['code'] = code;
      map['ip'] = ip;
      map['country'] = country;
      final response = await http.post(ROOT, body: map);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  Future<List<Users>> getThisUserInfo(String email) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = GET_THIS_USER;
      map['email'] = email;
      final response = await http.post(ROOT, body: map);
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

  //-------------->> Chat options <<-----------------
  Future<String> addToChatTable(
    String yourEmail,
    String hisEmail,
    String yourGender,
    String hisGender,
    String yourImage,
    String hisImage,
    String yourOnline,
    String hisOnline,
    String yourCode,
    String hisCode,
    String yourName,
    String hisName,
  ) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = ADD_TO_CHAT;
      map['yourEmail'] = yourEmail;
      map['hisEmail'] = hisEmail;
      map['yourGender'] = yourGender;
      map['hisGender'] = hisGender;
      map['yourImage'] = yourImage;
      map['hisImage'] = hisImage;
      map['yourOnline'] = yourOnline;
      map['hisOnline'] = hisOnline;
      map['yourCode'] = yourCode;
      map['hisCode'] = hisCode;
      map['yourName'] = yourName;
      map['hisName'] = hisName;

      final response = await http.post(ROOT, body: map);
      if (200 == response.statusCode) {
        if (response.body == '1') {
        } else {}
        return response.body;
      } else {}
    } catch (e) {}
    return null;
  }

  Future<List<Chat>> getChat() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = GET_CHAT;
      final response = await http.post(ROOT, body: map);

      if (200 == response.statusCode) {
        List<Chat> list = parseResponseForChat(response.body);
        return list;
      } else {
        return List<Chat>();
      }
    } catch (e) {
      return List<Chat>();
    }
  }

  static List<Chat> parseResponseForChat(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Chat>((json) => Chat.fromJson(json)).toList();
  }

  Future<String> updateLastMsg(String email, String email2, String text) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = UPDATE_LAST_MSG;
      map['email'] = email;
      map['email2'] = email2;
      map['text'] = text;
      final response = await http.post(ROOT, body: map);
      print(response.body);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  Future<String> updateReadMsg(
    String email,
    String email2,
  ) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = UPDATE_READ_MSG;
      map['email'] = email;
      map['email2'] = email2;
      final response = await http.post(ROOT, body: map);
      print(response.body);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  Future<String> getChatId(String email, String email2) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = GET_CHAT_ID;
      map['email'] = email;
      map['email2'] = email2;
      final response = await http.post(ROOT, body: map);
      print(response.body);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  Future<String> countNewNsg(String email) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = COUNT_NEW_MSG;
      map['email'] = email;
      final response = await http.post(ROOT, body: map);
      print(response.body);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }
}
