import 'dart:io';

import 'package:chatting/login_screen/mainStartScreen.dart';
import 'package:chatting/models/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerPage extends StatefulWidget {
  final String name;
  final String email;
  final String image;
  final String gender;
  final String password;
  final String current;
  final String code;

  const DrawerPage(
      {Key key,
      this.name,
      this.email,
      this.image,
      this.gender,
      this.password,
      this.current,
      this.code})
      : super(key: key);

  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  String id;

  bool isLoading;

  File avatarImageFile;

  @override
  Widget build(BuildContext context) {
    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
      });
      uploadImage();
    }

    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            Container(
              height: 200,
              child: UserAccountsDrawerHeader(
                accountEmail: Text(
                  widget.email,
                  style: Theme.of(context).textTheme.headline,
                ),
                accountName: Text(widget.name,
                    style: Theme.of(context).textTheme.headline),
                otherAccountsPictures: <Widget>[
                  Image.asset(widget.gender == "1"
                      ? 'assets/images/male.png'
                      : 'assets/images/female.png')
                ],
                currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: InkWell(
                        onTap: getImage,
                        child: Image.asset('assets/images/female.png'))),
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
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString('username', null);
                  prefs.setString('password', null);

                  Fireebase().logOut(
                      widget.email,
                      widget.gender,
                      widget.name,
                      widget.password,
                      widget.image,
                      widget.current,
                      widget.code);

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => StartScreen(),
                    ),
                  );
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

    List<Map<String, dynamic>> maplistremove = [
      {
        'email': widget.email,
        'gender': widget.gender,
        'name': widget.name,
        'password': widget.password,
        'image': prefs.getString('image'),
        'current': widget.current,
        'code': widget.code,
        'online': '1',
      },
    ];
    await Firestore.instance
        .collection('users')
        .document('wauiqt7wiUI283ANx9n1')
        .updateData({
      'usersData': FieldValue.arrayRemove(maplistremove),
    });
    List<Map<String, dynamic>> maplistadd = [
      {
        'email': widget.email,
        'gender': widget.gender,
        'name': widget.name,
        'password': widget.password,
        'image': image,
        'current': widget.current,
        'code': widget.code,
        'online': '1',
      },
    ];

    await Firestore.instance
        .collection('users')
        .document('wauiqt7wiUI283ANx9n1')
        .updateData({
      'usersData': FieldValue.arrayUnion(maplistadd),
    });
    prefs.setString('image', image);
  }

  Future uploadImage() async {
    String fileName = '${DateTime.now()}.png';
    StorageReference firebaseStorage =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorage.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    url = await firebaseStorage.getDownloadURL() as String;

    if (url.isNotEmpty) {
      updateSection(url);

      // firestoreService.UpdateSection(sectionName, url);
      // Fluttertoast.showToast(
      //     msg: "تمت أظافة القسم",
      //     toastLength: Toast.LENGTH_LONG,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIos: 1,
      //     backgroundColor: Colors.green[200],
      //     textColor: Colors.white,
      //     fontSize: 16.0);

    }
  }
}
