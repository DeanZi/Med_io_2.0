import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medio2/globals.dart' as globals;
import 'package:flutter_spinbox/material.dart';
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
      ),
    );
  }
}
