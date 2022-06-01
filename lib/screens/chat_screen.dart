import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen(
      {Key? key,
      @required this.name,
      @required this.imageUrl,
      @required this.bio,
      @required this.uid,
      @required this.typing})
      : super(key: key);

  final String? name;
  final String? imageUrl;
  final String? bio;
  final bool? typing;
  final String? uid;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _message = TextEditingController();

  String? myEmail;
  String? myName;
  String? myBio;
  String? myImageUrl;
  String? myUid;

  String? chatRoomId;

  bool showFileBtn = true;
  bool showMicBtn = true;
  bool showSendBtn = false;

  @override
  void initState() {
    super.initState();
    getUserDetails();
    createRoom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Row(
          children: [
            CachedNetworkImage(
              imageUrl: '${widget.imageUrl}',
              imageBuilder: (context, imageProvider) => Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 2,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 2,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  image: const DecorationImage(
                    image: AssetImage(
                      'images/profile_picture.png',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${widget.name}'),
                widget.typing == true
                    ? const SpinKitThreeBounce(
                        color: Colors.blue,
                        size: 20.0,
                      )
                    : const Text(
                        'Active 3 m ago',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      )
              ],
            ),
          ],
        ),
        actions: const [
          Icon(Icons.work_outline),
          SizedBox(
            width: 20,
          ),
          Icon(
            Icons.settings_outlined,
          )
        ],
      ),
      body: Stack(
        children: [
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('rooms')
                  .doc(chatRoomId)
                  .collection('chats')
                  .orderBy('time', descending: false)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return SingleChildScrollView(
                    physics: const ScrollPhysics(),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 100,
                          width: double.infinity,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: '${widget.imageUrl}',
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      width: 50.0,
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          width: 2,
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                        ),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      width: 50.0,
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          width: 2,
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                        ),
                                        image: const DecorationImage(
                                          image: AssetImage(
                                            'images/profile_picture.png',
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  CachedNetworkImage(
                                    imageUrl: '$myImageUrl',
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      width: 50.0,
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          width: 2,
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                        ),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      width: 50.0,
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          width: 2,
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                        ),
                                        image: const DecorationImage(
                                          image: AssetImage(
                                            'images/profile_picture.png',
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Center(
                                child: Text(
                                  '${widget.name} and $myName conversation',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        GroupedListView<dynamic, String>(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          elements: snapshot.data!.docs,
                          groupBy: (element) => element['time'] == null
                              ? DateTime.now().toString()
                              : DateFormat('yyyy-MM-dd').format(
                                  element['time'].toDate(),
                                ),
                          groupHeaderBuilder: (element) => Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 100),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20)),
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: Center(
                                child: element['time'] == null
                                    ? Text(DateTime.now().toString())
                                    : Text(
                                        DateFormat('yyyy-MM-dd').format(
                                          element['time'].toDate(),
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          itemBuilder: (BuildContext context, index) {
                            return index['sentBy'] == _auth.currentUser!.uid
                                ? ChatBubble(
                                    clipper: ChatBubbleClipper1(
                                        type: BubbleType.sendBubble),
                                    alignment: Alignment.topRight,
                                    margin: const EdgeInsets.only(
                                      top: 20,
                                    ),
                                    backGroundColor: Colors.blue[800],
                                    child: Container(
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            index['message'],
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                          index['time'] == null
                                              ? Text(DateTime.now().toString())
                                              : Text(
                                                  DateFormat('hh:mm a').format(
                                                      index['time'].toDate()),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12),
                                                ),
                                        ],
                                      ),
                                    ),
                                  )
                                : ChatBubble(
                                    clipper: ChatBubbleClipper1(
                                      type: BubbleType.receiverBubble,
                                    ),
                                    backGroundColor:
                                        Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.grey.shade200
                                            : Colors.grey.shade800,
                                    margin: const EdgeInsets.only(top: 20),
                                    child: Container(
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            index['message'],
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ),
                                          index['time'] == null
                                              ? Text(DateTime.now().toString())
                                              : Text(
                                                  DateFormat('hh:mm a').format(
                                                    index['time'].toDate(),
                                                  ),
                                                  style: const TextStyle(
                                                      // color: Colors.green,
                                                      fontSize: 12),
                                                ),
                                        ],
                                      ),
                                    ),
                                  );
                          },
                        ),
                        const SizedBox(height: 70)
                      ],
                    ),
                  );
                }
              }),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade200
                    : Colors.grey.shade800,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.sentiment_satisfied_alt_outlined),
                  ),
                  Expanded(
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Send message',
                      ),
                      controller: _message,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            showFileBtn = false;
                            showMicBtn = false;
                            showSendBtn = true;
                          });
                        } else {
                          setState(() {
                            showFileBtn = true;
                            showMicBtn = true;
                            showSendBtn = false;
                          });
                        }
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Visibility(
                        visible: showFileBtn,
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.attachment_outlined),
                        ),
                      ),
                      Visibility(
                        visible: showMicBtn,
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.mic),
                        ),
                      ),
                      Visibility(
                        visible: showSendBtn,
                        child: IconButton(
                          onPressed: () {
                            sendMessage();
                          },
                          icon: const Icon(Icons.send),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // load user details
  void getUserDetails() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      myEmail = _prefs.getString('email') ?? '';
      myName = _prefs.getString('name') ?? '';
      myBio = _prefs.getString('bio') ?? '';
      myImageUrl = _prefs.getString('imageUrl') ?? '';
      myUid = _prefs.getString('uid') ?? '';
    });
  }

  // create room
  createRoom() {
    var user1 = _auth.currentUser!.uid;
    var user2 = '${widget.uid}';
    var room = 'chat_' +
        (user1.substring(0).codeUnitAt(0) <= user2.substring(0).codeUnitAt(0)
            ? user1 + '_' + user2
            : user2 + '_' + user1);
    setState(() {
      chatRoomId = room;
    });
  }

  // send message
  void sendMessage() async {
    CollectionReference _ref = FirebaseFirestore.instance.collection('rooms');

    await _ref.doc(chatRoomId).set({
      "chatid": chatRoomId,
      "users": FieldValue.arrayUnion([widget.uid, _auth.currentUser!.uid]),
      "time": FieldValue.serverTimestamp(),
      "sentBy": _auth.currentUser!.uid,

      "receivedBy": widget.uid,
      "last_message": _message.text,
      "type": "text",
      // receiver
      "receiver_image": widget.imageUrl,
      "receiver_name": widget.name,
      "receiver_bio": widget.bio,
      "receiver_uid": widget.uid,
      "receiver_typing": false,
      "receiver_status": false,
      "is_read": false,

      // sender
      "sender_image": myImageUrl,
      "sender_name": myName,
      "sender_bio": myBio,
      "sender_uid": myUid,
      "sender_typing": false,
      "sender_status": false,
    }, SetOptions(merge: true));

    _ref.doc(chatRoomId).collection('chats').add(
      {
        "users": FieldValue.arrayUnion([widget.uid, _auth.currentUser!.uid]),
        "time": FieldValue.serverTimestamp(),
        "sentBy": _auth.currentUser!.uid,
        "message": _message.text,
        "receiver_typing": false,
        "sender_typing": false,
        "type": "text",
        "is_read": false
      },
    );
  }

  // mark message as read
  void markMessageAsRead() async {}
}
