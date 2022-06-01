import 'package:flutter/material.dart';
import 'package:hirecom/profile/edit_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? name;
  String? bio;

  @override
  void initState() {
    super.initState();
    getUserPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              buildProfileImg(),
              const SizedBox(height: 10),
              buildName(),
              const SizedBox(height: 10),
              buildEditButton(),
              const SizedBox(height: 30),
              buildAbout(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfileImg() => Stack(
        children: [
          // profile image
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
              shape: BoxShape.circle,
              image: const DecorationImage(
                image: AssetImage('images/profile.jfif'),
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
                color: Theme.of(context).accentColor,
                shape: BoxShape.circle,
                border: Border.all(
                  width: 2,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfile(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
            ),
          ),
        ],
      );
  Widget buildName() => Column(
        children: [
          Text(
            '$name',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Text('$bio'),
        ],
      );

  Widget buildEditButton() => ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        onPressed: () {},
        child: const Text('Edit Profile'),
      );

  Widget buildAbout() => Container(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'About',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'bio is the section on your profile page where you include some information about yourself and/or your business.',
              style: TextStyle(),
            )
          ],
        ),
      );

  Future getUserPrefs() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      name = _prefs.getString('name');
      bio = _prefs.getString('bio');
    });
  }
}
