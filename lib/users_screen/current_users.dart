import 'package:flutter/material.dart';
import '../models/user_model.dart';

class CurrentUsers extends StatelessWidget {
  final String email;
  final String image;
  final String code;
  final String name;
  final String gender;
  final int limit;
  final List<Users> users;
  CurrentUsers({
    Key key,
    this.email,
    this.image,
    this.code,
    this.name,
    this.gender,
    this.limit,
    this.users,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: users.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: InkWell(
              onTap: users[index].email == email ? null : () async {},
              child: Card(
                color: users[index].email == email ? Colors.grey : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Image.asset(
                            'icons/flags/png/${users[index].code}.png',
                            package: 'country_icons',
                            height: 40,
                            width: 40,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          users[index].gender == '1'
                              ? Image.asset(
                                  'assets/images/male.png',
                                  height: 20,
                                  width: 20,
                                )
                              : Image.asset(
                                  'assets/images/female.png',
                                  height: 20,
                                  width: 20,
                                ),
                        ],
                      ),
                      Text(
                        users[index].name,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.title,
                      ),
                      Stack(
                        alignment: Alignment.bottomLeft,
                        children: <Widget>[
                          users[index].image == null || users[index].image == ''
                              ? Container(
                                  width: 75.0,
                                  height: 75.0,
                                  decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: new DecorationImage(
                                          fit: BoxFit.fill,
                                          image: users[index].gender == '1'
                                              ? NetworkImage(
                                                  'https://cdn4.iconfinder.com/data/icons/social-messaging-productivity-7/64/x-01-512.png')
                                              : NetworkImage(
                                                  'https://cdn1.iconfinder.com/data/icons/business-planning-management-set-2/64/x-90-512.png'))),
                                )
                              : Container(
                                  width: 75.0,
                                  height: 75.0,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image: new NetworkImage(
                                        users[index].image,
                                      ),
                                    ),
                                  ),
                                ),
                          users[index].online == '1'
                              ? Container(
                                  width: 15.0,
                                  height: 15.0,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.lightGreenAccent[400],
                                  ),
                                )
                              : Container(
                                  width: 15.0,
                                  height: 15.0,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey,
                                  ),
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
