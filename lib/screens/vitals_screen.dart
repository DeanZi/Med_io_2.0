import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_spinbox/material.dart';

import '../globals.dart';


/***
 *
 * VitalsScreen Class:
 *  Connection with GoogleFit API inorder to get the pulse (BPM)
 */
class VitalsScreen extends StatefulWidget {
  const VitalsScreen({Key? key, required User user})
      : _user = user,
        super(key: key);
  final User _user;

  @override
  _VitalsScreenState createState() => _VitalsScreenState();
}

class _VitalsScreenState extends State<VitalsScreen> {
  late String _BodyTemp;
  late int _feeling;
  late String _BR;
  late User _user;
  late String _pulse;
  late bool _sendSubmit;


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildTemp() {
    _getHeartRateFromGoogle().then((value) => _pulse = value);
    return TextFormField(
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: 'Body Temperature',
        labelStyle: TextStyle(color: Colors.black,),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Valid temperature is Required';
        }

        return null;
      },
      onSaved: (value) {
        _BodyTemp = value!;
      },
    );
  }

  Widget _buildGeneralFeeling() {
    return SpinBox(
      textStyle: TextStyle(color:Colors.black, fontSize: 18),
      decoration: InputDecoration(
          labelText: 'General Feeling 0-5',
        labelStyle: TextStyle(color: Colors.black,fontSize: 22,),
        enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
        ),
      ),
      min: 1,
      max: 5,
      value: 3,
      spacing: 10,
      incrementIcon: Icon(Icons.keyboard_arrow_up, size: 40,color: Colors.red,),
      decrementIcon: Icon(Icons.keyboard_arrow_down, size: 40,color: Colors.red),
      onChanged: (value) {_feeling = value.toInt();},
    );
  }

  @override
  void initState() {
    _user = widget._user;
    _sendSubmit = false;
    super.initState();
  }

  Widget _buildBreathingRate() {
    return TextFormField(
        style: TextStyle(color: Colors.black),
    decoration: InputDecoration(
    labelText: 'Breathing Rate',
    labelStyle: TextStyle(color: Colors.black),
    enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.black),
    ),focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.red),
      ),
    ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Valid BR is Required';
        }

        return null;
      },
      onSaved: (value) {
        _BR = value!;
      },
    );
  }

  // Widget _buildInfo() {
  //   return EmptyWidget(
  //     image: null,
  //     packageImage: PackageImage.Image_3,
  //     title: 'Update your info',
  //     subTitle: 'We will extract your hear rate from google :)',
  //     titleTextStyle: TextStyle(
  //       fontSize: 22,
  //       color: Color(0xff9da9c7),
  //       fontWeight: FontWeight.w500,
  //     ),
  //     subtitleTextStyle: TextStyle(
  //       fontSize: 14,
  //       color: Color(0xffabb8d6),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Collect Vitals",
                style:TextStyle(color:Colors.white),)
                ,backgroundColor: Color(0xFFCE0606),
                ),
      body:  SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
               // _buildInfo(),
                _buildTemp(),
                SizedBox(height: 20),

                _buildBreathingRate(),
                SizedBox(height: 20),

                _buildGeneralFeeling(),
                SizedBox(height: 80),
                RaisedButton(
                  color: Colors.red,
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                   onPressed: ()  {
                    print(_feeling);
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    _formKey.currentState!.save();

                    var list = [{
                      'bodyTemp': _BodyTemp,
                      'generalFeeling': _feeling,
                      'breathingRate': _BR,
                      'heartRate': _pulse,
                      'oxygen': "95",
                      'date_time': new DateTime.now().toUtc().toString()
                    }];
                    FirebaseFirestore.instance
                        .collection('patients')
                        .doc(_user.uid)
                        .update({"vitals": FieldValue.arrayUnion(list)});
                    setState(() {
                      _sendSubmit = true;
                    });
                  },
                ),
                SizedBox(height: 20),

                _sendSubmit?
                Container(
                  child: Text('Thank you for updating us!',style: TextStyle(color:Colors.black, fontSize: 20),),) : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }


  /***
   * The Connection to GoogleFit API
   * connection via google oauth playground
   * Construct an HTTP request by specifying the URI, HTTP Method,
   * headers, content type and request body.
   *
   */
  Future<String> _getHeartRateFromGoogle() async {

    final bodyMsg = jsonEncode({
      "startTimeMillis": 1624395600000,
      "endTimeMillis": DateTime.now().millisecondsSinceEpoch,

      "aggregateBy": [
        {
          "dataSourceId": "derived:com.google.heart_rate.bpm:com.google.android.gms:merge_heart_rate_bpm"
        }
      ],
      "bucketByTime": {
        "durationMillis": 1800000,

      },

    });

    final response = await http.post(
      Uri.parse('https://www.googleapis.com/fitness/v1/users/me/dataset:aggregate'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer '+ accessToken,

      },
      body:bodyMsg,
    );

    int pulse = iterateJson(response.body);
    if(pulse == -1)
      _pulse = "N/A";
    else
      _pulse = pulse.toString();
    return _pulse;
  }

  /***
   * Parse process to get the desired value (Pulse)
   * from the respinse body
   */
  int iterateJson(String jsonStr) {
    Map<String, dynamic> myMap = json.decode(jsonStr);
    List<dynamic> entitlements = myMap["bucket"];
    int pulse = -1 ;
    entitlements.forEach((entitlement) {
      (entitlement as Map<String, dynamic>).forEach((key, value) {
        if(key == "dataset"){
          if(value[0]["point"].toString() != [].toString())
            pulse = (value[0]["point"][0]["value"][0]["fpVal"]).round();
        }

      });

    });

    return pulse;
  }


}
