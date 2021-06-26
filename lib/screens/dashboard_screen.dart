import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medio2/screens/vitals_screen.dart';
import 'package:medio2/screens/emergency_screen.dart';
import 'package:medio2/screens/quetionnaire_screen.dart';
import 'package:medio2/screens/user_info_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key, required User user, required String id})
      : _user = user,
        _id = id,
        super(key: key);
  final String _id;
  final User _user;
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late User _user;
  late String _id;
  int currentIndex = 0;

  @override
  void initState() {
    _user = widget._user;
    _id = widget._id;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF4285F4),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Color(0xFFECEFF1),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.perm_identity_outlined),
            label: 'Vitals',
            backgroundColor: Color(0xFFECEFF1),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital_rounded),
            label: 'SOS',
            backgroundColor: Color(0xFFECEFF1),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
            backgroundColor: Color(0xFFECEFF1),
          ),
        ],
        currentIndex: currentIndex,
        selectedItemColor: Colors.black,
        onTap: _onTapIndex,
      ),
      body: goToScreen(currentIndex),
    );
  }

  _onTapIndex(index) {
    setState(() {
      currentIndex = index;
      print('index: $index');
    });
    goToScreen(currentIndex);
  }

  goToScreen(int currentIndex) {
    print('indexx: $currentIndex');
    switch(currentIndex){
      case 0:
        return UserInfoScreen(user: _user);
      case 1:
        return VitalsScreen(user: _user);
      case 2:
        return EmergencyScreen(user: _user);
     // case 3:
        //return FormScreen(user: _user, id: _id);
    }
  }
}
