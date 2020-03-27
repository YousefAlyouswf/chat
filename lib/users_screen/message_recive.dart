import 'package:chatting/models/chat_model.dart';
import 'package:flutter/material.dart';

class MessageRecive extends StatelessWidget {
  final String current;
  final String email;
  final List<ChatModel> chatModel;
  MessageRecive({
    Key key,
    this.current,
    this.email,
    this.chatModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: ListView.builder(
          itemCount: chatModel.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {},
              child: Card(
                color: chatModel[index].gender == '2'
                    ? Colors.pink[100]
                    : Colors.blue[100],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Image.asset(
                      'icons/flags/png/${chatModel[index].code}.png',
                      package: 'country_icons',
                      height: 60,
                      width: 60,
                    ),
                    title: Text(
                      chatModel[index].msg,
                      textAlign: TextAlign.center,
                    ),
                    subtitle: Text(
                      chatModel[index].name,
                      textAlign: TextAlign.end,
                    ),
                    trailing: Image(
                      image: chatModel[index].image == null ||
                              chatModel[index].image == ''
                          ? chatModel[index].gender == '1'
                              ? NetworkImage(
                                  'https://www.pngitem.com/pimgs/m/184-1842706_transparent-like-a-boss-clipart-man-icon-png.png')
                              : NetworkImage(
                                  'https://www.nicepng.com/png/detail/207-2074651_png-file-woman-person-icon-png.png')
                          : NetworkImage(chatModel[index].image),
                      fit: BoxFit.fitWidth,
                      height: 60,
                      width: 60,
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
}
