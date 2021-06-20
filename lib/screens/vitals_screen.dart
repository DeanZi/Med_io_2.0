import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medio2/globals.dart' as globals;

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
  late String _feeling;
  late String _BR;
  late User _user;
  late String _id;

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
    return ListView(shrinkWrap: true, children: <Widget>[
      Text('General Feeling 0-5'),
      DropdownButton<String>(
        items: <String>['0', '1', '2', '3', '4', '5'].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: new Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() => _feeling = value!);
        },
      )
    ]);
  }

  @override
  void initState() {
    _user = widget._user;
    _id = widget._id;
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
      appBar: AppBar(title: Text("Personal information")),
      body: SingleChildScrollView(
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
                SizedBox(height: 100),
                RaisedButton(
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                  onPressed: () {
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
                    print("This is ID:" + globals.itemID);
                    FirebaseFirestore.instance
                        .collection('patient_test')
                        .doc(globals.itemID)
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
