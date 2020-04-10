import 'package:chatting/chatScreen/chatScreen.dart';
import 'package:chatting/mysql/mysql_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../models/user_model.dart';

class CurrentUsers extends StatelessWidget {
  final String email;
  final String image;
  final String code;
  final String name;
  final String gender;
  final List<Users> users;
  final Function getUsers, countNewMsg;
  CurrentUsers({
    Key key,
    this.email,
    this.image,
    this.code,
    this.name,
    this.gender,
    this.users,
    this.getUsers, this.countNewMsg,
  }) : super(key: key);

  //---pull to refresh

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    getUsers();
    countNewMsg();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    getUsers();
    countNewMsg();
    _refreshController.loadComplete();
  }

  //---End pull
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Text("أسحب للأعلى لتحديث الصفحة");
            } else if (mode == LoadStatus.loading) {
              body = CupertinoActivityIndicator();
            } else if (mode == LoadStatus.failed) {
              body = Text("Load Failed!Click retry!");
            } else if (mode == LoadStatus.canLoading) {
              body = Text("release to load more");
            } else {
              body = Text("No more Data");
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: InkWell(
                onTap: users[index].email == email
                    ? null
                    : () async {
                        getUsers();
                        Mysql().addToChatTable(
                          email,
                          users[index].email,
                          gender,
                          users[index].gender,
                          image,
                          users[index].image,
                          '1',
                          users[index].online,
                          code,
                          users[index].code,
                          name,
                          users[index].name,
                        );

                        showSheet(
                          context,
                          users[index].image,
                          users[index].gender,
                          users[index].online,
                          users[index].email,
                          users[index].code,
                          users[index].name,
                        );
                      },
                child: Card(
                  color:
                      users[index].email == email ? Colors.grey : Colors.white,
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
                            users[index].image == null ||
                                    users[index].image == ''
                                ? Container(
                                    width: 75.0,
                                    height: 75.0,
                                    decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: new DecorationImage(
                                        fit: BoxFit.fill,
                                        image: users[index].gender == '1'
                                            ? NetworkImage(
                                                'https://cdn4.iconfinder.com/data/icons/social-messaging-productivity-7/64/x-01-512.png',
                                              )
                                            : NetworkImage(
                                                'https://cdn1.iconfinder.com/data/icons/business-planning-management-set-2/64/x-90-512.png',
                                              ),
                                      ),
                                    ),
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
      ),
    );
  }

  void showSheet(
    BuildContext context,
    String usersImage,
    String usersGender,
    String usersOnline,
    String usersEmail,
    String usersCode,
    String usersName,
  ) {
    showBottomSheet(
      context: context,
      builder: (context) => Container(
        color: Colors.blue[900],
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Stack(
              alignment: Alignment.bottomLeft,
              children: <Widget>[
                usersImage == null || usersImage == ''
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 2,
                        decoration: new BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: usersGender == '1'
                                    ? NetworkImage(
                                        'https://cdn4.iconfinder.com/data/icons/social-messaging-productivity-7/64/x-01-512.png')
                                    : NetworkImage(
                                        'https://cdn1.iconfinder.com/data/icons/business-planning-management-set-2/64/x-90-512.png'))),
                      )
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 2,
                        decoration: new BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: new NetworkImage(
                              usersImage,
                            ),
                          ),
                        ),
                      ),
                usersOnline == '1'
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
            RaisedButton(
              onPressed: () {
                Mysql().getChatId(email, usersEmail).then((id) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => ChatScreen(
                        name: name,
                        email: email,
                        image: image,
                        code: code,
                        gender: gender,
                        email2: usersEmail,
                        gender2: usersGender,
                        name2: usersName,
                        code2: usersCode,
                        image2: usersImage,
                        chatID: id,
                        online: usersOnline,
                      ),
                    ),
                  );
                });
              },
              child: Text("بدأ المحادثة"),
            )
          ],
        ),
      ),
    );
  }
}
