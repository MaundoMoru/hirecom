import 'package:flutter/material.dart';
import 'package:hirecom/Auth/bio_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NameScreen extends StatefulWidget {
  const NameScreen({Key? key}) : super(key: key);

  @override
  _NameScreenState createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();

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
                  'Enter Name',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  'Provide your name, that will be visible by other members',
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  controller: _name,
                  maxLength: 25,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: 'Name',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: 'Enter your name',
                  ),
                  validator: (value) {
                    if (value!.isEmpty && value == '') {
                      return 'Enter your name';
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
                                .set({'name': _name.text},
                                    SetOptions(merge: true));
                            // Add data to shared preferences
                            SharedPreferences _prefs =
                                await SharedPreferences.getInstance();
                            _prefs.setString('name', _name.text);
                            // Navigate to bio screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const BioScreen(),
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
