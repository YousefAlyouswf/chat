import 'package:chatting/chatScreen/chatScreen.dart';
import 'package:chatting/models/user.dart';
import 'package:chatting/users_screen/current_users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../drawer.dart';
import 'message_recive.dart';

class UsersScreen extends StatefulWidget {
  final String name;
  final String email;
  final String image;
  final String gender;
  final String password;
  final String current;

  const UsersScreen(
      {Key key,
      this.name,
      this.email,
      this.image,
      this.gender,
      this.password,
      this.current})
      : super(key: key);

  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  void whatGender(String genderType, String genderImage) {
    if (genderType == '1') {
      setState(() {
        genderImage =
            'https://www.pngitem.com/pimgs/m/184-1842706_transparent-like-a-boss-clipart-man-icon-png.png';
      });
    } else {
      setState(() {
        genderImage =
            'https://www.nicepng.com/png/detail/207-2074651_png-file-woman-person-icon-png.png';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await Firestore.instance
            .collection('users')
            .document('wauiqt7wiUI283ANx9n1')
            .updateData({
          'usersData': FieldValue.arrayRemove([
            {
              'email': widget.email,
              'gender': widget.gender,
              'name': widget.name,
              'password': widget.password,
              'image': widget.image,
              'current': widget.current,
            },
          ]),
        });
        await Firestore.instance
            .collection('users')
            .document('wauiqt7wiUI283ANx9n1')
            .updateData({
          'usersData': FieldValue.arrayUnion([
            {
              'email': widget.email,
              'gender': widget.gender,
              'name': widget.name,
              'password': widget.password,
              'image': widget.image,
              'current': '',
            },
          ]),
        });
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple[900],
          title: Text(widget.current),
          centerTitle: true,
          bottom: TabBar(
            labelColor: Colors.white,
            labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                text: 'الأعضاء',
              ),
              Tab(
                text: 'الرسائل',
              ),
            ],
            controller: _controller,
          ),
        ),
        endDrawer: DrawerPage(
          name: widget.name,
          email: widget.email,
          image: widget.image,
        ),
        body: TabBarView(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: CurrentUsers(
                current: widget.current,
                email: widget.email,
                image: widget.image,
              ),
            ),
            Container(
              color: Colors.white,
              child: MessageRecive(
                current: widget.current,
                email: widget.email,
              ),
            ),
          ],
          controller: _controller,
        ),
      ),
    );
  }
}
