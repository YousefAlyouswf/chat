import 'package:chatting/chatScreen/chatScreen.dart';
import 'package:chatting/models/chat_model.dart';
import 'package:chatting/mysql/mysql_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MessageRecive extends StatelessWidget {
  final String email, gender, image, code, name;
  final List<Chat> chat;
  final Function getChat, countNewMsg;
  MessageRecive({
    Key key,
    this.email,
    this.gender,
    this.image,
    this.code,
    this.name,
    this.chat,
    this.getChat,
    this.countNewMsg,
  }) : super(key: key);
  //---pull to refresh

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    getChat();
    countNewMsg();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    getChat();
    countNewMsg();
    _refreshController.loadComplete();
  }

  //---End pull
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
              body = Text("لتحميل بيانات أكثر");
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
          itemCount: chat.length,
          itemBuilder: (BuildContext context, int index) {
            return chat[index].yourEmail == email ||
                    chat[index].hisEmail == email
                ? chat[index].text != ''
                    ? InkWell(
                        onTap: () async {
                          if (chat[index].yourEmail == email) {
                            Mysql().updateReadMsg(email, chat[index].hisEmail);

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) => ChatScreen(
                                  name: name,
                                  email: email,
                                  image: chat[index].yourImage,
                                  code: code,
                                  gender: gender,
                                  email2: chat[index].hisEmail,
                                  gender2: chat[index].hisGender,
                                  name2: chat[index].hisName,
                                  code2: chat[index].hisCode,
                                  image2: chat[index].hisImage,
                                  chatID: chat[index].id,
                                  online: chat[index].hisOnline,
                                ),
                              ),
                            );
                          } else {
                            Mysql().updateReadMsg(email, chat[index].yourEmail);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) => ChatScreen(
                                  name: name,
                                  email: email,
                                  image: chat[index].hisImage,
                                  code: code,
                                  gender: gender,
                                  email2: chat[index].yourEmail,
                                  gender2: chat[index].yourGender,
                                  name2: chat[index].yourName,
                                  code2: chat[index].yourCode,
                                  image2: chat[index].yourImage,
                                  chatID: chat[index].id,
                                  online: chat[index].yourOnline,
                                ),
                              ),
                            );
                          }
                        },
                        child: Card(
                          color: chat[index].readMsg == "0" &&
                                  chat[index].lastSent != email
                              ? Colors.yellow
                              : Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Image.asset(
                                      chat[index].yourEmail != email
                                          ? 'icons/flags/png/${chat[index].yourCode}.png'
                                          : 'icons/flags/png/${chat[index].hisCode}.png',
                                      package: 'country_icons',
                                      height: 40,
                                      width: 40,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    chat[index].yourEmail != email
                                        ? chat[index].yourGender == "1"
                                            ? Image.asset(
                                                'assets/images/male.png',
                                                height: 20,
                                                width: 20,
                                              )
                                            : Image.asset(
                                                'assets/images/female.png',
                                                height: 20,
                                                width: 20,
                                              )
                                        : chat[index].hisGender == "1"
                                            ? Image.asset(
                                                'assets/images/male.png',
                                                height: 20,
                                                width: 20,
                                              )
                                            : Image.asset(
                                                'assets/images/female.png',
                                                height: 20,
                                                width: 20,
                                              )
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        // snapshot.data.documents[index]
                                        //             ['typing'] ==
                                        //         '1'
                                        //     ? Image.network(
                                        //         'https://media.giphy.com/media/THksdFc9bFRAQcIc13/giphy.gif',
                                        //         height: 40,
                                        //         width: 40,
                                        //       )
                                        //     : Text(''),
                                        Text(
                                          chat[index].yourEmail != email
                                              ? chat[index].yourName
                                              : chat[index].hisName,
                                          textAlign: TextAlign.center,
                                          style:
                                              Theme.of(context).textTheme.body1,
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: 150,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          chat[index].lastSent == email
                                              ? chat[index].readMsg == '0'
                                                  ? Image.network(
                                                      'http://getdrawings.com/free-icon/email-icon-transparent-63.png',
                                                      height: 25,
                                                      width: 25,
                                                    )
                                                  : Image.network(
                                                      'https://images.vexels.com/media/users/3/157932/isolated/preview/951a617272553f49e75548e212ed947f-curved-check-mark-icon-by-vexels.png',
                                                      height: 25,
                                                      width: 25,
                                                    )
                                              : Text(''),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Flexible(
                                            child: Text(
                                              chat[index].text,
                                              textDirection: TextDirection.rtl,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Stack(
                                  alignment: Alignment.bottomLeft,
                                  children: <Widget>[
                                    chat[index].yourEmail != email
                                        ? chat[index].yourImage == null ||
                                                chat[index].yourImage == ''
                                            ? Container(
                                                width: 75.0,
                                                height: 75.0,
                                                decoration: new BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: new DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: chat[index]
                                                                .yourGender ==
                                                            '1'
                                                        ? NetworkImage(
                                                            'https://cdn4.iconfinder.com/data/icons/social-messaging-productivity-7/64/x-01-512.png')
                                                        : NetworkImage(
                                                            'https://cdn1.iconfinder.com/data/icons/business-planning-management-set-2/64/x-90-512.png'),
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
                                                      chat[index].yourImage,
                                                    ),
                                                  ),
                                                ),
                                              )
                                        : chat[index].hisImage == null ||
                                                chat[index].hisImage == ''
                                            ? Container(
                                                width: 75.0,
                                                height: 75.0,
                                                decoration: new BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: new DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: chat[index]
                                                                .hisGender ==
                                                            '1'
                                                        ? NetworkImage(
                                                            'https://cdn4.iconfinder.com/data/icons/social-messaging-productivity-7/64/x-01-512.png')
                                                        : NetworkImage(
                                                            'https://cdn1.iconfinder.com/data/icons/business-planning-management-set-2/64/x-90-512.png'),
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
                                                      chat[index].hisImage,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                    chat[index].yourEmail != email
                                        ? chat[index].yourOnline == '1'
                                            ? Container(
                                                width: 15.0,
                                                height: 15.0,
                                                decoration: new BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors
                                                      .lightGreenAccent[400],
                                                ),
                                              )
                                            : Container(
                                                width: 15.0,
                                                height: 15.0,
                                                decoration: new BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.grey,
                                                ),
                                              )
                                        : chat[index].hisOnline == '1'
                                            ? Container(
                                                width: 15.0,
                                                height: 15.0,
                                                decoration: new BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors
                                                      .lightGreenAccent[400],
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
                      )
                    : Container()
                : Container();
          },
        ),
      ),
    );
  }
}
