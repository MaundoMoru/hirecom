import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hirecom/screens/home.dart';
import 'package:hirecom/screens/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Auth/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Future<String> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _email = prefs.getString('email') ?? '';
    return _email;
  }

  @override
  void initState() {
    super.initState();
    customTheme.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: customTheme.currentTheme,
      home: FutureBuilder<String>(
        future: getSharedPrefs(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Text('Error');
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return const Home();
            } else {
              return const Login();
            }
          } else {
            return Text('State: ${snapshot.connectionState}');
          }
        },
      ),
    );
  }
}
