import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'hire_screen.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: const Text('Users'),
        actions: const [
          Icon(Icons.search),
        ],
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 100,
                width: double.infinity,
                child: Row(
                  children: [
                    FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: Theme.of(context).accentColor,
                      onPressed: () {},
                      child: const Text(
                        'Active',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    FlatButton(
                      onPressed: () {},
                      child: const Text(
                        'Followed',
                      ),
                    )
                  ],
                ),
              ),
            ),
            StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.separated(
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.size,
                    itemBuilder: (BuildContext context, index) {
                      DocumentSnapshot ds = snapshot.data!.docs[index];
                      return ListTile(
                          leading: Stack(
                            children: [
                              InkWell(
                                onTap: () {
                                  showModal(ds);
                                },
                                child: CachedNetworkImage(
                                  imageUrl: snapshot.data!.docs[index]
                                      ['imageUrl'],
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
                              ),
                              snapshot.data!.docs[index]['status'] == true
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
                          title: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 55,
                                child: Text(
                                  ds['name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Row(
                                children: const [
                                  Icon(
                                    Icons.place_outlined,
                                    size: 16,
                                  ),
                                  Text(
                                    '3 km away',
                                    style: TextStyle(fontSize: 16),
                                  )
                                ],
                              )
                            ],
                          ),
                          subtitle: Text(
                            ds['bio'],
                          ),
                          trailing: const Icon(Icons.more_vert_outlined));
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future showModal(ds) => showModalBottomSheet(
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
                      CachedNetworkImage(
                        imageUrl: ds['imageUrl'],
                        imageBuilder: (context, imageProvider) => Container(
                          width: 90.0,
                          height: 90.0,
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
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
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
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 48),
                      //   child: Text(ds['about']),
                      // )
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
                                Text('Message')
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
                                          builder: (context) =>
                                              const HireScreen(),
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
}
