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
    return TextFormField(
      decoration: InputDecoration(labelText: 'Body Temperature'),
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
    _getHeartRateFromGoogle().then((value) => _pulse = value);
    return SpinBox(
      decoration: InputDecoration(labelText: 'General Feeling 0-5'),
      min: 1,
      max: 5,
      value: 3,
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
      decoration: InputDecoration(labelText: 'Breathing Rate'),
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
      appBar: AppBar(title: Text("Personal information",
                style:TextStyle(color:Colors.orange),)
                ,backgroundColor: Colors.white,
                ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: new BoxDecoration(
        gradient: new LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromARGB(255, 238, 153, 25),
          Color.fromARGB(255, 236, 53, 21)
        ],
        )
    ),
    child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildTemp(),
                _buildBreathingRate(),
                _buildGeneralFeeling(),
                SizedBox(height: 80),
                RaisedButton(
                  color: Colors.white,
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.red, fontSize: 16),
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
