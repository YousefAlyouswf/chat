import 'dart:io';
import 'package:chatting/login_screen/mainStartScreen.dart';
import 'package:chatting/models/firebase.dart';
import 'package:chatting/mysql/mysql_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/firebase.dart';

class DrawerPage extends StatefulWidget {
  final String name;
  final String email;
  final String image;
  final String gender;
  final String password;
  final String code;

  const DrawerPage(
      {Key key,
      this.name,
      this.email,
      this.image,
      this.gender,
      this.password,
      this.code})
      : super(key: key);

  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  String id;

  bool isLoading;

  File avatarImageFile;
  String urlImage;
  void getNewImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    urlImage = prefs.getString('image');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
      });
      uploadImage();
      Navigator.pop(context);
    }

    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            InkWell(
              onTap: getImage,
              child: Container(
                height: 200,
                width: 150,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                    fit: BoxFit.fitHeight,
                    image: new NetworkImage(
                      widget.image == null
                          ? widget.gender == '1'
                              ? 'https://cdn4.iconfinder.com/data/icons/social-messaging-productivity-7/64/x-01-512.png'
                              : 'https://cdn1.iconfinder.com/data/icons/business-planning-management-set-2/64/x-90-512.png'
                          : widget.image,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {},
                child: Card(
                  child: Center(
                    child: Text(
                      "الإعدادات",
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {},
                child: Card(
                  child: Center(
                    child: Text(
                      "الأصدقاء",
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {},
                child: Card(
                  child: Center(
                    child: Text(
                      "شراء",
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () async {
                  try {
                    Mysql().updateUserOffline(widget.email);

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => StartScreen(),
                      ),
                    );
                  } catch (e) {
                    print("error--------------------------------------");
                  }
                },
                child: Card(
                  child: Center(
                    child: Text(
                      "خروج",
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  File _image;
  bool isSuccess = false;
  String url;
  Future updateSection(String image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Mysql().updateUserImage(widget.email, image);
    prefs.setString('image', image);
  }

  Future uploadImage() async {
    String fileName = '${DateTime.now()}.png';
    StorageReference firebaseStorage =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorage.putFile(_image);
    await uploadTask.onComplete;
    url = await firebaseStorage.getDownloadURL() as String;

    if (url.isNotEmpty) {
      updateSection(url);
    }
  }
}
