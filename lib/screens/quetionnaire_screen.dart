import 'package:dropdown_formfield/dropdown_formfield.dart';
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
  late String _livesAlone ='';
  late String _diseases;
  late String _medications;
  late var _vitals = [];
  late User _user;
  late String _id;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _user = widget._user;
    _id = widget._id;
    super.initState();
    _sex = 'Male';
    _livesAlone = 'Yes';
  }

  Widget _buildFirstName() {
    return TextFormField(
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: 'First Name',
        labelStyle: TextStyle(color: Colors.black),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
      ),

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
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: 'Last Name',
        labelStyle: TextStyle(color: Colors.black),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
      ),
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
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: 'Age',
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
      return 'Valid age is Required';
    }

    return null;
    },
    onSaved: (value) {
    _age = value!;
    },
    );




  }

  Widget _buildSex() {
    return Theme(
        data: new ThemeData(
        canvasColor: Colors.white,
        primaryColor: Colors.black,
        accentColor: Colors.black,
        hintColor: Colors.black,
        ),
    child:DropDownFormField(
        titleText:'Sex',
        value: _sex,
        onSaved: (value) {
          setState(() {
            _sex = value!;
          });
        },
        onChanged: (value) {
          setState(() {
            _sex = value!;
          });
        },
        dataSource: [
          {
            "display": "Male",
            "value": "Male",
          },
          {
            "display": "Female",
            "value": "Female",
          },
          {
            "display": "Not declared",
            "value": "Not declared",
          },
        ],
      textField: 'display',
      valueField: 'value',
    )
    );
  }
  Widget _buildLivesAlone() {
    return Theme(
        data: new ThemeData(
        canvasColor: Colors.white,
        primaryColor: Colors.black,
        accentColor: Colors.black,
        hintColor: Colors.black),
    child:DropDownFormField(
      titleText:'Do you live alone?',
      value: _livesAlone,
      onSaved: (value) {
        setState(() {
          _livesAlone = value!;
        });
      },
      onChanged: (value) {
        setState(() {
          _livesAlone = value!;
        });
      },
      dataSource: [
        {
          "display": "Yes",
          "value": "Yes",
        },
        {
          "display": "No",
          "value": "No",
        }
      ],
      textField: 'display',
      valueField: 'value',
    )
    );
  }


  Widget _buildDiseases() {
    return TextFormField(
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: 'Diseases',
        labelStyle: TextStyle(color: Colors.black),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
      ),
      onSaved: ( value) {
        _diseases = value!;
      },
    );
  }

  Widget _buildMedications() {
    return TextFormField(
        style: TextStyle(color: Colors.black),
    decoration: InputDecoration(
    labelText: 'Medications',
    labelStyle: TextStyle(color: Colors.black),
    enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.black),
    ),focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.red),
    ),
    ),
      onSaved: ( value) {
        _medications = value!;
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Personal information",
        style:TextStyle(color:Colors.white),),
        backgroundColor: Color(0xFFCE0606),),
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
                SizedBox(height: 80),
                RaisedButton(
                  color: Colors.red,
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white, fontSize: 16),
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
                         .doc(_user.uid)
                         .set({'age':_age,
                       'disease' :_diseases,
                       'firstName' : _firstName,
                       'gender' : _sex,
                       'lastName' : _lastName,
                       'lives_alone' : _livesAlone,
                       'medication' : _medications,
                       'vitals': _vitals,
                       'itemID': _user.uid,
                     });

                     // FirebaseFirestore.instance
                     //     .collection('patient_test')
                     //     .add({'age':_age,
                     //      'disease' :_diseases,
                     //      'firstName' : _firstName,
                     //      'gender' : _sex,
                     //      'lastName' : _lastName,
                     //      'lives_alone' : _livesAlone,
                     //      'medication' : _medications,
                     //      'vitals': _vitals,
                     //      'itemID': "",
                     //    }).then((value) => (updateItemID(value.id)));
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