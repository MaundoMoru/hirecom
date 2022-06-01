import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hirecom/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BioScreen extends StatefulWidget {
  const BioScreen({Key? key}) : super(key: key);

  @override
  _BioScreenState createState() => _BioScreenState();
}

class _BioScreenState extends State<BioScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _bio = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  'Enter Bio',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  'Provide your bio here, to tell others who you are',
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  controller: _bio,
                  maxLength: 25,
                  decoration: const InputDecoration(
                    prefix: Icon(Icons.info),
                    labelText: 'Bio',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: 'Enter your bio',
                  ),
                  validator: (value) {
                    if (value!.isEmpty && value == '') {
                      return 'Enter your bio';
                    }
                  },
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FlatButton(
                      onPressed: () {},
                      child: const Text('Skip'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_form.currentState!.validate()) {
                          if (_form.currentState!.validate()) {
                            // Add data to firestore
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(_auth.currentUser!.uid)
                                .set({
                              'bio': _bio.text,
                              'about':
                                  'bio is a small public summary about yourself or your business displayed under your profile picture'
                            }, SetOptions(merge: true));
                            // Add data to shared preferences
                            SharedPreferences _prefs =
                                await SharedPreferences.getInstance();
                            _prefs.setString('bio', _bio.text);
                            // Navigate to home screen
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Home(),
                              ),
                            );
                          }
                        }
                      },
                      child: const Text('Next'),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
