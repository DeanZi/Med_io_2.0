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
      decoration: InputDecoration(labelText: 'First Name',filled: true),
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
      decoration: InputDecoration(labelText: 'Last Name',filled: true),
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
      decoration: InputDecoration(labelText: 'Age', filled: true),
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
    return DropDownFormField(
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
    );
  }
  Widget _buildLivesAlone() {
    return DropDownFormField(
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
    );
  }


  Widget _buildDiseases() {
    return TextFormField(

      decoration: InputDecoration(labelText: 'Diseases',filled: true,
          ),

      onSaved: ( value) {
        _diseases = value!;
      },
    );
  }

  Widget _buildMedications() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Medications',filled: true),

      onSaved: ( value) {
        _medications = value!;
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Personal information",style:TextStyle(color:Colors.orange),),backgroundColor: Colors.white,),
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
      child:SingleChildScrollView(
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
                  color: Colors.white,
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.red, fontSize: 16),
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
                         .collection('patients')
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
    )
    );
  }

  updateItemID(String id) {
     globals.itemID = id;
    FirebaseFirestore.instance.collection('patients').doc(id).update({'itemID':id});

  }
}