import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_spinbox/material.dart';

import '../globals.dart';

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
  late double _feeling;
  late String _BR;
  late User _user;
  late String _pulse;


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
      onChanged: (value) {_feeling = value;},
    );
  }

  @override
  void initState() {
    _user = widget._user;
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


                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

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
        //'Authorization': 'Bearer ya29.a0AfH6SMAKy7qtorGSFtX84kCgQ30ji-c5EYNqXmjPjWk6i7cfK7j0fVbwPI83-g2Akmyn0jW2BpGZQvpNtG6MN0kLkqIN4VTgLCns1qbBsTPhkUWObz31iF7gHcZL7rmapUqHAY396EvANb8UhkScF37XiXca',

      },
      body:bodyMsg,
    );

    int pulse = iterateJson(response.body);
    if(pulse == -1)
      _pulse = "N/A";
    else
      _pulse = pulse.toString();
    //print(jsonDecode(response.body));
    return _pulse;
  }


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

    //print(pulse);
    return pulse;
  }


}
