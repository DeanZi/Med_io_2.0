import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medio2/utils/Dimensions.dart';
import 'package:medio2/globals.dart' as globals;


class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({Key? key, required User user})
      : _user = user,
        super(key: key);
  final User _user;



  @override
  _EmergencyScreenState createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {

  TextEditingController searchController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  int currentIndex = 0;
  late User _user;
  late bool _pushTheButton;

  @override
  void initState() {
    _user = widget._user;
    _pushTheButton = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body:Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
                  children:[
                      SizedBox(height: MediaQuery.of(context).size.height/3),
                    Text( "Press for medical assistance",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: Dimensions.extraLargeTextSize
                        ),
                        textAlign: TextAlign.center
                    ),
                    SizedBox(height: 10),
                    FlatButton(
                        onPressed: (){

                          var _fullName = _user.displayName.toString().split(" ");
                          var _firstName = _fullName[0];
                          var _lastName = _fullName[1];
                          FirebaseFirestore.instance
                              .collection('emergencyCall')
                              .doc(_user.uid)
                              .set({
                            'phoneNumber' : globals.phoneNumber,
                            'date_time' : DateTime.now().millisecondsSinceEpoch,
                            'firstName' : _firstName,
                            'lastName' : _lastName,
                          });
                          setState(() {
                            _pushTheButton = true;
                          });
                        },
                        child: Image.asset('assets/sos.png'),
                     ),
                    SizedBox(height: 20),
                    _pushTheButton?
                    Container(
                        child: Text('We\'ve received your emergency call!',
                          style: TextStyle(color:Colors.black, fontSize: 20),
                        ),
                    ) : Container(),
                ]
              )
          )
        );
  }
}