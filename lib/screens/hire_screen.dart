import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HireScreen extends StatefulWidget {
  const HireScreen({
    Key? key,
    @required this.imageUrl,
    @required this.name,
    @required this.bio,
    @required this.uid,
  }) : super(key: key);

  final String? imageUrl;
  final String? name;
  final String? bio;
  final String? uid;

  @override
  _HireScreenState createState() => _HireScreenState();
}

class _HireScreenState extends State<HireScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _currentIndex = 0;

  String? roomId;

  String? myEmail;
  String? myImageUrl;
  String? myName;
  String? myBio;
  String? myUid;

  // load current user details
  void getUserDetails() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    myEmail = _prefs.getString('email') ?? '';
    myImageUrl = _prefs.getString('imageUrl') ?? '';
    myName = _prefs.getString('name') ?? '';
    myBio = _prefs.getString('bio') ?? '';
    myUid = _prefs.getString('uid') ?? '';
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
      roomId = room;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
    createRoom();
  }

  String dropdownValue = 'Agriculture, Food, and Natural Resources';

  var items = [
    'Agriculture, Food, and Natural Resources',
    'Architecture and Construction',
    'Arts, Audio/Video Technology, and Communication',
    'Business and Finance',
    'Education and Training',
    'Government and Public Administration',
    'Health Science',
    'Information Technology',
    'Law, Public Safety, Corrections, and Security',
    'Marketing',
    'Science, Technology, Engineering, and Math'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: const Text('Hire me'),
      ),
      body: Stepper(
        steps: getSteps(),
        type: StepperType.horizontal,
        currentStep: _currentIndex,
        onStepContinue: () {
          setState(() {
            _currentIndex += 1;
          });
        },
      ),
      // body: Stack(
      //   children: [
      //     SingleChildScrollView(
      //       child: Center(
      //         child: Column(
      //           children: [
      //             CachedNetworkImage(
      //               imageUrl: '${widget.imageUrl}',
      //               imageBuilder: (context, imageProvider) => Container(
      //                 width: 90.0,
      //                 height: 90.0,
      //                 decoration: BoxDecoration(
      //                   shape: BoxShape.circle,
      //                   border: Border.all(
      //                     width: 2,
      //                     color: Theme.of(context).scaffoldBackgroundColor,
      //                   ),
      //                   image: DecorationImage(
      //                     image: imageProvider,
      //                     fit: BoxFit.cover,
      //                   ),
      //                 ),
      //               ),
      //               placeholder: (context, url) =>
      //                   const CircularProgressIndicator(),
      //               errorWidget: (context, url, error) => Container(
      //                 width: 50.0,
      //                 height: 50.0,
      //                 decoration: BoxDecoration(
      //                   shape: BoxShape.circle,
      //                   border: Border.all(
      //                     width: 2,
      //                     color: Theme.of(context).scaffoldBackgroundColor,
      //                   ),
      //                   image: const DecorationImage(
      //                     image: AssetImage(
      //                       'images/profile_picture.png',
      //                     ),
      //                     fit: BoxFit.cover,
      //                   ),
      //                 ),
      //               ),
      //             ),
      //             const SizedBox(
      //               height: 10,
      //             ),
      //             SizedBox(
      //               height: 300,
      //               child: Padding(
      //                 padding: const EdgeInsets.all(8.0),
      //                 child: Stepper(
      //                   // elevation: 0,
      //                   currentStep: _currentIndex,
      //                   steps: getSteps(),
      //                   // type: StepperType.horizontal,
      //                 ),
      //               ),
      //             )
      //           ],
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }

  List<Step> getSteps() => [
        Step(
          title: const Text('Account'),
          content: Container(),
          isActive: _currentIndex >= 0,
        ),
        Step(
          title: const Text('Address'),
          content: Container(),
          isActive: _currentIndex >= 1,
        ),
        Step(
          title: const Text('Confirm'),
          content: Container(),
          isActive: _currentIndex >= 2,
        ),
      ];
}
