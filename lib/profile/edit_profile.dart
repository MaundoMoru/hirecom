import 'package:flutter/material.dart';
import 'package:hirecom/profile/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _bio = TextEditingController();
  final TextEditingController _about = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? name;
  String? bio;
  XFile? img;
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getUserPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    buildProfileImg(snapshot.data!['imageUrl']),
                    const SizedBox(height: 12),
                    buildEditName(snapshot.data!['name']),
                    const SizedBox(height: 12),
                    buildBio(snapshot.data!['bio']),
                    const SizedBox(height: 12),
                    buildAbout(snapshot.data!['about']),
                    const SizedBox(height: 30),
                    buildSaveBtn(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildProfileImg(img) => isLoading == true
      ? Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        )
      : Stack(
          children: [
            // profile image
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(img),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 2,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    changeProfilePic();
                  },
                  icon: Icon(
                    Icons.camera_alt,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
              ),
            ),
          ],
        );

  Widget buildEditName(name) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Full Name',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _name,
            decoration: InputDecoration(
              hintText: '$name',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      );
  Widget buildBio(bio) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bio',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _bio,
            decoration: InputDecoration(
              hintText: '$bio',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      );
  Widget buildAbout(about) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About me',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _about,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: '$about',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      );
  Widget buildSaveBtn() => ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 80,
          ),
        ),
        onPressed: () async {
          await saveUserPrefs();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileScreen(),
            ),
          );
        },
        child: Text('Save'),
      );

  Future getUserPrefs() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      name = _prefs.getString('name');
      bio = _prefs.getString('bio');
    });
  }

  Future saveUserPrefs() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .update(
      {'name': _name.text, 'bio': _bio.text, 'about': _about.text},
    );

    _prefs.setString('name', _name.text);
    _prefs.setString('bio', _bio.text);
  }

  void changeProfilePic() async {
    isLoading = true;
    // pick image from gallery
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    // initialize to file variable
    setState(() {
      if (image == null) {
      } else {
        img = image;
      }
    });

    // create reference to firebase storage
    firebase_storage.Reference _reference = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('profile_images')
        .child(_auth.currentUser!.uid);

    // save file to the pointed reference
    firebase_storage.UploadTask _task = _reference.putFile(File(img!.path));

    // get downloadUrl from the reference
    String downLoadUrl = await (await _task).ref.getDownloadURL();

    // update the Firestore imageUrl
    FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .update({'imageUrl': downLoadUrl});

    isLoading = false;
  }
}
