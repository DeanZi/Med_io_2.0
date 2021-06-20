import 'package:medio2/globals.dart' as globals;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'dashboard_screen.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key, required User user, required String id})
      : _user = user,
        _id = id,
        super(key: key);
  final String _id;
  final User _user;

  @override
  State<StatefulWidget> createState() {
    return FormScreenState();
  }
}

class FormScreenState extends State<FormScreen> {
  late String _firstName;
  late String _lastName;
  late String _age;
  late String _sex;
  late String _livesAlone;
  late String _diseases;
  late String _medications;
  late var _vitals = [];
  late User _user;
  late String _id;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildFirstName() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'First Name'),
        validator: ( value) {


        if (value!.isEmpty) {
          return 'Name is Required';
        }

        return null;
      },
      onSaved: ( value) {
        _firstName = value!;
       },
    );
  }

  Widget _buildLastName() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Last Name'),
      validator: ( value) {


        if (value!.isEmpty) {
          return 'Name is Required';
        }

        return null;
      },
      onSaved: ( value) {
        _lastName = value!;
      },
    );
  }





  Widget _buildAge() {
    return TextFormField(
              decoration: InputDecoration(labelText: 'Age'),
    keyboardType: TextInputType.number,
    validator: (value) {
    if (value!.isEmpty) {
    return 'Valid age is Required';
    }

    return null;
    },
    onSaved: (value) {
    _age = value!;
    },
    );




  }
  @override
  void initState() {
    _user = widget._user;
    _id = widget._id;
    super.initState();
  }

  Widget _buildSex() {
    return ListView(
        shrinkWrap: true,
        children: <Widget>[

        Text('Sex'),
        DropdownButton<String>(
      items: <String>['Male', 'Female', 'Not declared'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: new Text(value),
        );
      }).toList(),
      onChanged: (value) {
        setState(() => _sex = value!);
      },
       )
        ]
    );
  }
  Widget _buildLivesAlone() {
    return ListView(
        shrinkWrap: true,
        children: <Widget>[

          Text('Do you live alone?'),
          DropdownButton<String>(
            items: <String>['Yes', 'No'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => _livesAlone = value!);
            },
          )
        ]
    );
  }


  Widget _buildDiseases() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Diseases'),

      onSaved: ( value) {
        _diseases = value!;
      },
    );
  }

  Widget _buildMedications() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Medications'),

      onSaved: ( value) {
        _medications = value!;
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
                _buildFirstName(),
                _buildLastName(),
                _buildAge(),
                _buildSex(),
                _buildLivesAlone(),
                _buildDiseases(),
                _buildMedications(),
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
                    print(_firstName);
                    print(_lastName);
                    print(_age);
                    print(_sex);
                    print(_livesAlone);
                    print(_diseases);
                    print(_medications);

                     FirebaseFirestore.instance
                         .collection('patient_test')
                         .add({'age':_age,
                          'disease' :_diseases,
                          'firstName' : _firstName,
                          'gender' : _sex,
                          'lastName' : _lastName,
                          'lives_alone' : _livesAlone,
                          'medication' : _medications,
                          'vitals': _vitals,
                          'itemID': "",
                          }).then((value) => (updateItemID(value.id)));
                     Navigator.of(context).pushReplacement(
                       MaterialPageRoute(
                         builder: (context) => DashboardScreen(id: _id,
                           user: _user,
                         ),
                       ),
                     );

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

  updateItemID(String id) {
     globals.itemID = id;
    FirebaseFirestore.instance.collection('patient_test').doc(id).update({'itemID':id});

  }
}