import 'package:flutter/material.dart';
import 'package:hirecom/screens/tasks_screen.dart';
import 'package:hirecom/screens/users_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? uid;

  bool isSearching = false;

  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const TasksScreen(),
    const UsersScreen(),
  ];

  void _getSharedPrefs() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      uid = _prefs.getString('uid');
    });
  }

  @override
  void initState() {
    super.initState();
    _getSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(),
        child: BottomNavigationBar(
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          currentIndex: _selectedIndex,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.work),
              label: 'Tasks',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Members',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: 'Promo',
            ),
          ],
        ),
      ),
    );
  }
}
