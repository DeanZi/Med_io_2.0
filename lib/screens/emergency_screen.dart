import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medio2/utils/Dimensions.dart';


class EmergencyScreen extends StatefulWidget {
  @override
  _EmergencyScreenState createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {

  TextEditingController searchController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  int currentIndex = 0;

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
                        print('test');
                        },
                        child: Image.asset('assets/sos.png'),
                     ),
                ]
              )
          )
        );
  }
}