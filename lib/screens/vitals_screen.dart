import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medio2/globals.dart' as globals;
import 'package:flutter_spinbox/material.dart';
class VitalsScreen extends StatefulWidget {
  const VitalsScreen({Key? key, required User user, required String id})
      : _user = user,
        _id = id,
        super(key: key);
  final String _id;
  final User _user;

  @override
  _VitalsScreenState createState() => _VitalsScreenState();
}

class _VitalsScreenState extends State<VitalsScreen> {
  late String _BodyTemp;
  late double _feeling;
  late String _BR;
  late User _user;
  late String _id;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildTemp() {
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
    _id = widget._id;
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
                  onPressed: () {
                    print(_feeling);
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }

                    _formKey.currentState!.save();

                    // FirebaseFirestore.instance
                    //     .collection('patient_test')
                    //     .add({
                    //   'disease': _diseases,
                    //   'gender': _sex,
                    //   'lives_alone': _livesAlone,
                    //   'medication': _medications,
                    //   'vitals': _vitals,
                    // }).then((value) => id = value.id);

                    var list = [{
                      'bodyTemp': _BodyTemp,
                      'generalFeeling': _feeling,
                      'breathingRate': _BR,
                      'heartRate': "70",
                      'oxygen': "95",
                      'date_time': new DateTime.now().toUtc().toString()
                    }];
                    FirebaseFirestore.instance
                        .collection('patient_test')
                        .doc(_user.uid)
                        .update({"vitals": FieldValue.arrayUnion(list)});

                    // Navigator.of(context).pushReplacement(
                    //   MaterialPageRoute(
                    //     builder: (context) =>
                    //         DashboardScreen(id: _id,
                    //           user: _user,
                    //         ),
                    //   ),
                    // );

                    //userSetup(user);
                    //Send to API
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
