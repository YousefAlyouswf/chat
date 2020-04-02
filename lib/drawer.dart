import 'package:chatting/login_screen/mainStartScreen.dart';
import 'package:chatting/models/firebase.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            Container(
              height: 200,
              child: UserAccountsDrawerHeader(
                accountEmail: Text(
                  email,
                  style: Theme.of(context).textTheme.headline,
                ),
                accountName:
                    Text(name, style: Theme.of(context).textTheme.headline),
                otherAccountsPictures: <Widget>[
                  Image.asset(gender == "1"
                      ? 'assets/images/male.png'
                      : 'assets/images/female.png')
                ],
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: image == null || image == ''
                      ? Image(
                          image: AssetImage('assets/images/ph.png'),
                          fit: BoxFit.fill,
                        )
                      : Container(
                          width: 250.0,
                          height: 250.0,
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: new NetworkImage(image),
                            ),
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
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString('username', null);
                  prefs.setString('password', null);

                  Fireebase().logOut(
                      email, gender, name, password, image, current, code);

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
}
