
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medio2/res/custom_colors.dart';
import 'package:medio2/screens/sign_in_screen.dart';
import 'package:medio2/utils/authentication.dart';
import 'package:medio2/globals.dart';





class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  late User _user;
  bool _isSigningOut = false;
  int currentIndex = 0;
  var data;




  Future<String> updatePulse ()  {
    return FirebaseFirestore.instance.collection("patients").doc(_user.uid).get().then((value){
      if(value.exists) {
        if (value.data()!["vitals"].length > 0) {
          int lengthOfVitals = value.data()!["vitals"].length;
          return value.data()!["vitals"][lengthOfVitals - 1]["heartRate"];
        }
      }
      return "N/A";
    });
  }

  Future<String> updateGeneralFeeling ()  {
    return FirebaseFirestore.instance.collection("patients").doc(_user.uid).get().then((value){
      if(value.exists) {
        if (value.data()!["vitals"].length > 0) {
          int lengthOfVitals = value.data()!["vitals"].length;
          return value.data()!["vitals"][lengthOfVitals - 1]["generalFeeling"]
              .round()
              .toString();
        }
      }
      return "N/A";
    });
  }

  Future<String> updateBodyTemp ()  {
    return FirebaseFirestore.instance.collection("patients").doc(FirebaseAuth.instance.currentUser!.uid).get().then((value){
      if(value.exists) {
        if (value.data()!["vitals"].length > 0) {
          int lengthOfVitals = value.data()!["vitals"].length;
          print(value.data()!["vitals"][lengthOfVitals - 1]["bodyTemp"]);
          return value.data()!["vitals"][lengthOfVitals - 1]["bodyTemp"];
        }
      }
      return "N/A";
    });
  }

  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SignInScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  void initState() {
    _user = widget._user;
    super.initState();
    updatePulse().then((value) => pulse = value);
    updateGeneralFeeling().then((value) => generalFeeling = value);
    updateBodyTemp().then((value) => bodyTemp = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFCE0606),
       elevation: 0,
        title: Text('Med.io',style: TextStyle(color: Colors.white),),
        actions: <Widget>[
         IconButton(
           icon: Icon(
            Icons.logout,
            color: Colors.white,
          ),
          onPressed: () async {
            setState(() {
              _isSigningOut = true;
            });
            await Authentication.signOut(context: context);
            setState(() {
              _isSigningOut = false;
            });
            Navigator.of(context)
                .pushReplacement(_routeToSignInScreen());
            },
        ),
        ]
      ),
      body: SafeArea(
        child: Center(child:
            Column(
            children: [
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                _user.photoURL != null
                    ? ClipOval(
                  child: Material(

                    color: CustomColors.firebaseGrey.withOpacity(0.3),
                    child: Image.network(
                      _user.photoURL!,
                      height: 35,
                      width: 35,
                      fit: BoxFit.fitHeight,

                    ),
                  ),
                )
                    : ClipOval(
                  child: Material(
                    color: CustomColors.firebaseGrey.withOpacity(0.3),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Icon(
                        Icons.person,
                        size: 30,
                        color: CustomColors.firebaseGrey,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                Text(
                  'Hello,',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 26,
                  ),
                ),
                SizedBox(width: 8.0),
                Text(
                  _user.displayName!,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 26,
                  ),
                ),
                ],
              ),
              SizedBox(height: 20.0),
              Container(child: Image.asset('assets/heart.png',  height: 120.0,width: 120.0,
                fit: BoxFit.cover,),),
              SizedBox(height: 40.0),
              buildFetchData(context),
            ],
            ),
          ),
        ),
    );
  }

  Widget buildFetchData(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headline2!,
      textAlign: TextAlign.justify,
      child: FutureBuilder<String>(
        future: updatePulse(), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          // if(generalFeeling == "N/A") {
          //   updatePulse().then((value) => pulse = value);
          //   updateGeneralFeeling().then((value) => generalFeeling = value);
          //   updateBodyTemp().then((value) => bodyTemp = value);
          //   CircularProgressIndicator();
          // }
          return bodyWidget(context);


          // else{
          //   return CircularProgressIndicator();
          //
          // }
        },


      ),
    );
  }


  bodyWidget(BuildContext context) {
    return Container(child:pulse == "" ? CircularProgressIndicator.adaptive()
        : Center(

      child:Column(
        children: [
          // Heart rate:
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text( pulse ,style: TextStyle(color:Colors.black,fontSize: 65)),
              SizedBox(width: 15.0),
              Text('bpm',style: TextStyle(color:Colors.black,fontSize: 20),),
            ],
          ),
          SizedBox(height: 20.0),
          // General feeling
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 15.0),
              Text(generalFeeling ,style: TextStyle(color:Colors.black,fontSize: 65)),
              SizedBox(width: 15.0),
              Column(

                children: [
                  Text('General',style: TextStyle(color:Colors.black,fontSize: 20),),
                  Text('Feeling',style: TextStyle(color:Colors.black,fontSize: 20),),
                ], 
              ),
            ],
          ),
          SizedBox(height: 20.0),
          //Body Temperature
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(bodyTemp,style: TextStyle(color:Colors.black,fontSize: 65)),
              SizedBox(width: 15.0),
              Text('°C',style: TextStyle(color:Colors.black,fontSize: 20),),
            ],
          ),
            ],
        )
      )
    );
  }

}
