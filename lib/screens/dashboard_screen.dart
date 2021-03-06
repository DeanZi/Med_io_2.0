import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medio2/screens/about_screen.dart';
import 'package:medio2/screens/vitals_screen.dart';
import 'package:medio2/screens/emergency_screen.dart';
import 'package:medio2/screens/user_info_screen.dart';

/***
 * Class DashBoard:
 *  The main screen holds the BottomNavigationBar and sends user to either ---
 *    UserInfoScreen
 *    VitalsScreen
 *    EmergencyScreen
 *    AboutScreen
 *
 *
 */
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
      //backgroundColor: Color(0xFFCE0606),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home,color: Colors.white),
            label: 'Home',
            backgroundColor: Color(0xFFCE0606),

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.perm_identity_outlined, color: Colors.white,),
            label: 'Vitals',
            backgroundColor: Color(0xFFCE0606),

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital_rounded, color: Colors.white,),
            label: 'SOS',
            backgroundColor: Color(0xFFCE0606),

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.announcement_outlined,color: Colors.white,),
            label: 'About',
            backgroundColor: Color(0xFFCE0606),

          ),
        ],
        currentIndex: currentIndex,
        selectedItemColor: Colors.white,
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
    //print('indexx: $currentIndex');
    switch(currentIndex){
      case 0:
        return UserInfoScreen(user: _user);
      case 1:
        return VitalsScreen(user: _user);
      case 2:
        return EmergencyScreen(user: _user,);
      case 3:
        return AboutScreen();

    }
  }
}
