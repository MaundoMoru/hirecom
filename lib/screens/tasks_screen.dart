import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hirecom/screens/chat_screen.dart';
import 'package:hirecom/screens/hire_screen.dart';
import 'package:hirecom/screens/image_screen.dart';
import 'package:hirecom/screens/sidebar_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hirecom/screens/users_screen.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const SideBarScreen(),
              ),
            );
          },
          icon: Container(
            height: 50,
            width: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('images/profile.jfif'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Hirecom',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [Icon(Icons.more_vert_outlined)],
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildUsersList(),
            const SizedBox(
              height: 10,
            ),
            buildTasksList(),
          ],
        ),
      ),
    );
  }

  Widget buildUsersList() => Container(
        height: 130,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Colors.grey.shade300.withOpacity(0.05),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Top Profiles',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UsersScreen(),
                      ),
                    );
                  },
                  child: Row(
                    children: const [
                      Text(
                        'View All',
                        style: TextStyle(
                          color: Colors.lightBlueAccent,
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: Colors.lightBlueAccent,
                      )
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: Text(''),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, index) {
                        DocumentSnapshot ds = snapshot.data!.docs[index];
                        return InkWell(
                          onTap: () {
                            showUsersModal(ds);
                          },
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, top: 20, right: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Stack(
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: snapshot.data!.docs[index]
                                              ['imageUrl'],
                                          imageBuilder:
                                              (context, imageProvider) =>
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
                                        snapshot.data!.docs[index]['status'] ==
                                                true
                                            ? Positioned(
                                                top: 0,
                                                right: 6,
                                                child: Container(
                                                  height: 10,
                                                  width: 10,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.green,
                                                    border: Border.all(
                                                        color: Theme.of(context)
                                                            .scaffoldBackgroundColor),
                                                  ),
                                                ),
                                              )
                                            : const Text('')
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    SizedBox(
                                      width: 50,
                                      child: Center(
                                        child: Text(
                                          snapshot.data!.docs[index]['name'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      );

  Future showUsersModal(ds) => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return DraggableScrollableSheet(
            initialChildSize: 0.64,
            minChildSize: 0.2,
            maxChildSize: 1.0,
            builder: (context, scrollController) {
              return Container(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.white
                    : const Color(0xFF212121),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Stack(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ImageScreen(image: ds['imageUrl']),
                                ),
                              );
                            },
                            child: CachedNetworkImage(
                              imageUrl: ds['imageUrl'],
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: 90.0,
                                height: 90.0,
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
                              errorWidget: (context, url, error) => Container(
                                width: 90.0,
                                height: 90.0,
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
                          ),
                          ds['status'] == true
                              ? Positioned(
                                  top: 0,
                                  right: 14,
                                  child: Container(
                                    height: 15,
                                    width: 15,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.green,
                                      border: Border.all(
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor),
                                    ),
                                  ),
                                )
                              : const Text('')
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        ds['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(ds['bio']),
                      const SizedBox(
                        height: 10,
                      ),

                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.grey.shade200
                                        : Colors.grey.shade300
                                            .withOpacity(0.05),
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChatScreen(
                                            imageUrl: ds['imageUrl'],
                                            name: ds['name'],
                                            bio: ds['bio'],
                                            uid: ds['uid'],
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.message_outlined),
                                  ),
                                ),
                                const Text('Message')
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.grey.shade200
                                        : Colors.grey.shade300
                                            .withOpacity(0.05),
                                  ),
                                  // child: Icon(Icons.work_outline),
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HireScreen(
                                            imageUrl: ds['imageUrl'],
                                            name: ds['name'],
                                            bio: ds['bio'],
                                            uid: ds['uid'],
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.work_outline),
                                  ),
                                ),
                                const Text('Hire me')
                              ],
                            ),
                          )
                        ],
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 10,
                      ),

                      // tasks
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );

  Widget buildTasksList() => StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('rooms')
            .where('users', arrayContains: _auth.currentUser!.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text(''),
            );
          } else {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FlatButton(
                        color: Colors.blue[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: const BorderSide(
                            color: Colors.blue,
                            // width: 2.0,
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'All',
                          style: TextStyle(),
                        ),
                      ),
                      FlatButton(
                        // color: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: const BorderSide(
                            color: Colors.blue,
                            // width: 2.0,
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Chats',
                          style: TextStyle(),
                        ),
                      ),
                      FlatButton(
                        // color: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: const BorderSide(
                            color: Colors.blue,
                            // width: 2.0,
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Tasks',
                          style: TextStyle(),
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  separatorBuilder: (BuildContext context, index) {
                    return const Divider();
                  },
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, index) {
                    DocumentSnapshot ds = snapshot.data!.docs[index];

                    return ds['sentBy'] == _auth.currentUser!.uid
                        ? ListTile(
                            leading: InkWell(
                              onTap: () {
                                showTasksModal(ds);
                              },
                              child: Stack(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: snapshot.data!.docs[index]
                                        ['receiver_image'],
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
                                  ds['receiver_status'] == true
                                      ? Positioned(
                                          top: 0,
                                          right: 6,
                                          child: Container(
                                            height: 10,
                                            width: 10,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.green,
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .scaffoldBackgroundColor),
                                            ),
                                          ),
                                        )
                                      : const Text('')
                                ],
                              ),
                            ),
                            title: Text(
                              ds['receiver_name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              ds['last_message'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: const Text('2 m'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    imageUrl: ds['receiver_image'],
                                    name: ds['receiver_name'],
                                    uid: ds['receiver_uid'],
                                    bio: ds['receiver_bio'],
                                    typing: ds['receiver_typing'],
                                  ),
                                ),
                              );
                            },
                          )
                        : ListTile(
                            leading: InkWell(
                              onTap: () {
                                showTasksModal(ds);
                              },
                              child: Stack(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: snapshot.data!.docs[index]
                                        ['sender_image'],
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
                                  ds['sender_status'] == true
                                      ? Positioned(
                                          top: 0,
                                          right: 6,
                                          child: Container(
                                            height: 10,
                                            width: 10,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.green,
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .scaffoldBackgroundColor),
                                            ),
                                          ),
                                        )
                                      : const Text('')
                                ],
                              ),
                            ),
                            title: Text(
                              ds['sender_name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              ds['last_message'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Text('2 m'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    imageUrl: ds['sender_image'],
                                    name: ds['sender_name'],
                                    uid: ds['sender_uid'],
                                    bio: ds['sender_bio'],
                                    typing: ds['sender_typing'],
                                  ),
                                ),
                              );
                            },
                          );
                  },
                ),
              ],
            );
          }
        },
      );

  Future showTasksModal(ds) => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return DraggableScrollableSheet(
            initialChildSize: 0.64,
            minChildSize: 0.2,
            maxChildSize: 1.0,
            builder: (context, scrollController) {
              return Container(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.white
                    : const Color(0xFF212121),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Stack(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImageScreen(
                                    image:
                                        ds['sentBy'] == _auth.currentUser!.uid
                                            ? ds['receiver_image']
                                            : ds['sender_image'],
                                  ),
                                ),
                              );
                            },
                            child: CachedNetworkImage(
                              imageUrl: ds['sentBy'] == _auth.currentUser!.uid
                                  ? ds['receiver_image']
                                  : ds['sender_image'],
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: 90.0,
                                height: 90.0,
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
                              errorWidget: (context, url, error) => Container(
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
                          ),
                          ds['receiver_status'] == true
                              ? Positioned(
                                  top: 0,
                                  right: 6,
                                  child: Container(
                                    height: 10,
                                    width: 10,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.green,
                                      border: Border.all(
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor),
                                    ),
                                  ),
                                )
                              : const Text('')
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ds['sentBy'] == _auth.currentUser!.uid
                          ? Text(
                              ds['receiver_name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            )
                          : Text(
                              ds['sender_name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                      const SizedBox(
                        height: 5,
                      ),
                      ds['sentBy'] == _auth.currentUser!.uid
                          ? Text(ds['receiver_bio'])
                          : Text(ds['sender_bio']),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.grey.shade200
                                        : Colors.grey.shade300
                                            .withOpacity(0.05),
                                  ),
                                  child: Icon(Icons.message_outlined),
                                ),
                                const Text('Message')
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.grey.shade200
                                        : Colors.grey.shade300
                                            .withOpacity(0.05),
                                  ),
                                  // child: Icon(Icons.work_outline),
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: ds['sentBy'] ==
                                                  _auth.currentUser!.uid
                                              ? (context) => HireScreen(
                                                    imageUrl:
                                                        ds['receiver_image'],
                                                    name: ds['receiver_name'],
                                                    bio: ds['receiver_bio'],
                                                    // uid: ds['uid'],
                                                  )
                                              : (context) => HireScreen(
                                                    imageUrl:
                                                        ds['sender_image'],
                                                    name: ds['sender_name'],
                                                    bio: ds['sender_bio'],
                                                    // uid: ds['uid'],
                                                  ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.work_outline),
                                  ),
                                ),
                                const Text('Hire me')
                              ],
                            ),
                          )
                        ],
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
}
