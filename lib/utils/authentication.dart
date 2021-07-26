import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:medio2/screens/dashboard_screen.dart';
import 'package:medio2/screens/quetionnaire_screen.dart';
import 'package:medio2/globals.dart';

/***
 *
 * Authentication Class :
 *
 *  Checks that a user is a valid google user
 *  Communicates with signInButton functionality
 *  Communicates with signOut functionality
 *
 */
class Authentication {

  // init of firebase, kept in firebaseApp.
  static Future<FirebaseApp> initializeFirebase({
    required BuildContext context,
  }) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    // Keeps current user in user
    User? user = FirebaseAuth.instance.currentUser;
    // Check that an actual user has entered
    if (user != null) {
      // Critical to know if its a first time user or not
      Duration diff = user.metadata.creationTime!.difference(user.metadata.lastSignInTime!);
      bool firstTimeUser = diff.inMilliseconds > 1000;
      // sanity check
      print(diff.inMilliseconds);
      //case we are not first time sign in user
      // we gonna sign in into dashboard screen to see previous measurements
      if(!firstTimeUser){
        final GoogleSignIn googleSignIn = GoogleSignIn();
        final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
        accessToken = googleSignInAuthentication.accessToken.toString();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => DashboardScreen(user: user, id:"0",
            ),
          ),
        );
      }
      // is first time sign in user
      // being sent to initial FormScreen
      else{
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => FormScreen(user: user,id:"0"
            ),
          ),
        );
      }

    }

    return firebaseApp;
  }

  /***
   * Communication with GoogleSignInButton --> being called when
   * When we are not a "first time" user
   *
   *
   */
  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
    await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
      accessToken = googleSignInAuthentication.accessToken.toString();
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
        await auth.signInWithCredential(credential);

        user = userCredential.user;

        /*
        exceptions mainly for testing sanity checks
        not for production
         */
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
        }
        else if (e.code == 'invalid-credential') {
        }
      } catch (e) {
      }
    }

    return user;
  }

  /**
   * Util for signOut --> called when an error occurs
   */
  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  /**
   * Communication with GoogleSignOut
   */
  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }
}