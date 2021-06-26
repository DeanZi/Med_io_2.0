import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medio2/res/custom_colors.dart';
import 'package:medio2/screens/sign_in_screen.dart';
import 'package:medio2/utils/Dimensions.dart';
import 'package:medio2/utils/authentication.dart';
import 'package:medio2/widgets/app_bar_title.dart';
import 'package:fit_kit/fit_kit.dart';

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
              bodyWidget(context),
            ],
            ),
          ),
        ),
    );
  }

  bodyWidget(BuildContext context) {
    return Container(child: Center(
      child:Column(
        children: [
          // Heart rate:
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('70',style: TextStyle(color:Colors.black,fontSize: 65)),//TODO change for parameter.
              SizedBox(width: 15.0),
              Text('BPM',style: TextStyle(color:Colors.black,fontSize: 20),),
            ],
          ),
          SizedBox(height: 20.0),
          // General feeling
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 15.0),
              Text('4',style: TextStyle(color:Colors.black,fontSize: 65)),//TODO change for parameter.
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
              Text('37',style: TextStyle(color:Colors.black,fontSize: 65)),//TODO change for parameter.
              SizedBox(width: 15.0),
              Text('°C',style: TextStyle(color:Colors.black,fontSize: 20),),
            ],
          ),
            ],
        )
      )
    );
  }
  Future<bool> readPermissions() async {
    try {
      final responses = await FitKit.hasPermissions([
        DataType.HEART_RATE,

      ]);

      if (!responses) {
        print("GIVENNNNNNNN");
        await FitKit.readLast(DataType.HEART_RATE).then((value) => print(value.value));
        final value = await FitKit.requestPermissions([
          DataType.HEART_RATE,

        ]);

        return value;
      } else {
        return true;
      }
    } on UnsupportedException catch (e) {
      // thrown in case e.dataType is unsupported
      print(e);
      return false;
    }
  }
  void readData() async {
    bool permissionsGiven = await readPermissions();

    if (permissionsGiven) {
      DateTime current = DateTime.now();
      DateTime dateFrom;
      DateTime dateTo;
      if (false) {
        dateFrom = DateTime.now().subtract(Duration(
          hours: current.hour + 24,
          minutes: current.minute,
          seconds: current.second,
        ));
        dateTo = dateFrom.add(Duration(
          hours: 23,
          minutes: 59,
          seconds: 59,
        ));
      } else {
        // 17 Jan 2021 12:53:64 - 12:53:5
        dateFrom = current.subtract(Duration(
          hours: current.hour,
          minutes: current.minute +30,
          seconds: current.second,
        ));
        dateTo = DateTime.now();
      }

      for (DataType type in DataType.values) {
        try {
          final results = await FitKit.read(
            type,
            dateFrom: dateFrom,
            dateTo: dateTo,
          );

          print(type);
          print(results);
          //addWidget(type, results);
        } on Exception catch (ex) {
          print(ex);
        }
      }
    }
  }

}
