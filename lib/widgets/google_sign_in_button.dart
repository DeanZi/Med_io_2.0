import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medio2/screens/dashboard_screen.dart';
import 'package:medio2/screens/quetionnaire_screen.dart';
import 'package:medio2/utils/authentication.dart';

class GoogleSignInButton extends StatefulWidget {
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: _isSigningIn
          ? CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      )
          : OutlinedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        ),
        onPressed: ()  async {
          setState(() {
            _isSigningIn = true;
          });

          User? user =
          await Authentication.signInWithGoogle(context: context);

          setState(() {
            _isSigningIn = false;
          });



          if (user != null ) {

            print('this is last sign in: ' + user.metadata.lastSignInTime.toString());
            print('this is creation time: ' + user.metadata.creationTime.toString());
            Duration signUpInterval = new Duration(milliseconds: 1000);
            DateTime lastSignIn = DateTime.parse(user.metadata.lastSignInTime.toString());
            DateTime creationTime = DateTime.parse(user.metadata.creationTime.toString());
            if(user.metadata.creationTime!.minute !=null && user.metadata.lastSignInTime != null){
              if((lastSignIn.difference(creationTime) ) >= signUpInterval){
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => DashboardScreen(id: "0",
                      user: user,
                    ),
                  ),
                );
              }else{
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    //TODO: to replace the EmergencyScreen with questionnaire
                    builder: (context) => FormScreen( user: user, id: "0",
                    ),
                  ),
                );
              }
            }


          }


        },

        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage("assets/google_logo.png"),
                height: 35.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Sign in with Google',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

