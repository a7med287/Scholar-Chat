import 'package:chat_scholar/constants.dart';
import 'package:chat_scholar/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/build_popup_menu.dart';
import '../widgets/chat_buble.dart';

class ChatPage extends StatelessWidget {
  static String id = "chatPage";
  final _controller = ScrollController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController controller = TextEditingController();
  CollectionReference messages = FirebaseFirestore.instance.collection(
    kMessagesCollection,
  );
  var msg;
  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments;
    return StreamBuilder(
      stream: messages.orderBy(kCreatedAt, descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<MessageModel> messagesList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            messagesList.add(MessageModel.fromJson(snapshot.data!.docs[i]));
          }
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: kPrimaryColor,
              title: Padding(
                padding: const EdgeInsets.only(left: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(kPathLogo, height: 50),
                    Text(
                      "Chat",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Pacifico",
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                buildPopupMenu(context),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    controller: _controller,
                    itemCount: messagesList.length,
                    itemBuilder: (context, index) {
                      return messagesList[index].id == email
                          ? ChatBuble(message: messagesList[index])
                          : ChatBubleForFriend(
                            message: messagesList[index],
                            userName: messagesList[index].id.substring(
                              0,
                              messagesList[index].id.indexOf("@"),
                            ),
                          );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8,
                  ),
                  child: TextField(
                    controller: controller,

                    onChanged: (data) {
                      final message = <String, dynamic>{
                        "massage": data,
                        kCreatedAt: DateTime.now(),
                        "id": email,
                      };
                      msg = message;
                    },

                    cursorColor: kPrimaryColor,
                    cursorRadius: Radius.circular(10),
                    style: TextStyle(color: kPrimaryColor),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        color: kPrimaryColor,
                        onPressed: () {
                          firestore.collection(kMessagesCollection).add(msg);
                          controller.clear();
                          _controller.animateTo(
                            0,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeIn,
                          );
                        },
                        icon: Icon(Icons.send_rounded),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: kPrimaryColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: kPrimaryColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: kPrimaryColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return progressWidget();
        }
      },
    );
  }
}

class progressWidget extends StatelessWidget {
  const progressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: LinearProgressIndicator(color: kPrimaryColor)),
    );
  }
}
