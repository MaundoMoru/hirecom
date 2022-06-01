import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hirecom/Auth/login.dart';
import 'package:hirecom/Auth/name_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmpassword = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference refs = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Sign up',
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Form(
            key: _form,
            child: ListView(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                      controller: _email,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: 'eg. chatapp@gmail.com',
                        prefixIcon: Icon(
                          Icons.email,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter email';
                        }
                      }),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _password,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: '******',
                      prefixIcon: Icon(
                        Icons.lock,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      if (value.length < 6) {
                        return 'Password is too short';
                      }
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _confirmpassword,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'confirm password ',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: '******',
                      prefixIcon: Icon(
                        Icons.lock,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter confirmation password';
                      }
                      if (value != _password.text) {
                        return 'Password not matching';
                      }
                      if (value.length < 6) {
                        return 'Password is too short';
                      }
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  height: 70,
                  child: RaisedButton(
                    // color: Theme.of(context).primaryColor,
                    onPressed: () async {
                      if (_form.currentState!.validate()) {
                        try {
                          await _auth
                              .createUserWithEmailAndPassword(
                                  email: _email.text, password: _password.text)
                              .then((value) async {
                            refs.doc(_auth.currentUser!.uid).set({
                              "uid": value.user!.uid,
                              "email": value.user!.email,
                              "imageUrl": "imageUrl",
                              "created_at": FieldValue.serverTimestamp()
                            });

                            // Add data to shared preferences
                            SharedPreferences _prefs =
                                await SharedPreferences.getInstance();
                            _prefs.setString('uid', value.user!.uid);
                            _prefs.setString('uid', _email.text);
                            _prefs.setString('imageUrl', _email.text);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NameScreen(),
                              ),
                            );
                          });
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'invalid-email') {
                            Fluttertoast.showToast(msg: 'invalid email');
                          } else if (e.code == 'email-already-in-use') {
                            Fluttertoast.showToast(msg: 'Email already in use');
                          }
                        }
                      }
                    },
                    child: const Text(
                      'Sign up',
                      // style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Text('Do you have account?'),
                      FlatButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Login(),
                              ),
                            );
                          },
                          child: const Text(
                            'Sign in',
                            style: TextStyle(color: Colors.blue, fontSize: 20),
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
