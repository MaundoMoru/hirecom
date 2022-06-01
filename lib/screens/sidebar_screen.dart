import 'package:flutter/material.dart';
import 'package:hirecom/Auth/login.dart';
import 'package:hirecom/profile/profile_screen.dart';
import 'package:hirecom/screens/home.dart';
import 'package:hirecom/screens/themes.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SideBarScreen extends StatefulWidget {
  const SideBarScreen({Key? key}) : super(key: key);

  @override
  _SideBarScreenState createState() => _SideBarScreenState();
}

class _SideBarScreenState extends State<SideBarScreen> {
  String? name;
  String? bio;
  bool? theme;

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future getSharedPrefs() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      name = _prefs.getString('name');
      bio = _prefs.getString('bio');
      theme = _prefs.getBool('theme');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const Home(),
              ),
            );
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildTop(),
            buildContent(),
          ],
        ),
      ),
    );
  }

  Widget buildTop() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage('images/profile.jfif'),
                          fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$name',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        '+254 708655407',
                        style: TextStyle(),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ListTile(
              leading: theme == true
                  ? const Icon(
                      Icons.dark_mode_outlined,
                    )
                  : const Icon(
                      Icons.light_mode_outlined,
                    ),
              title: const Text(
                'Appearance',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                customTheme.toggleTheme();
              },
            ),
            const Divider()
          ],
        ),
      );

  Widget buildContent() => Column(
        children: [
          ListTile(
            onTap: () {},
            leading: const Icon(
              Icons.settings_outlined,
            ),
            title: const Text(
              'Accout Settings',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('Privacy, Security, Language'),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.notification_important_outlined),
            title: const Text(
              'Notifications',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('Newsletter, App Updates'),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(
              Icons.delete_outline_outlined,
            ),
            title: const Text(
              'Delete Account',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(),
          ListTile(
            onTap: () async {
              SharedPreferences _prefs = await SharedPreferences.getInstance();
              _prefs.remove('email');
              _prefs.remove('name');
              _prefs.remove('uid');

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Login(),
                ),
              );
            },
            leading: const Icon(
              Icons.logout_outlined,
            ),
            title: const Text(
              'Log out',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
}
