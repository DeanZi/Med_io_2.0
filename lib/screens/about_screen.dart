import 'package:flutter/material.dart';
class AboutScreen extends StatefulWidget {
  @override
  _AboutScreen createState() => _AboutScreen();

}
class _AboutScreen extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFCE0606),
        title: Text('About Us',style: TextStyle(color: Colors.white),),),
      body: SingleChildScrollView(
        child:Container(
        padding: EdgeInsets.all(16.0),
        child: Column(children: [
          Text('We - Dean Zion, Simo Bitton & Tomer Yona created this project as part'
              'of our Final Project for BS.c. in Computer Science at Bar Ilan University',
              style:TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold)),
          SizedBox(height: 15),
          Text('The Problem \n',
              style:TextStyle(color: Colors.black, fontSize: 18,fontWeight: FontWeight.bold)),
          Text('Ever since COVID-19, we’ve noticed a surge in home hospitalized patients.'
              'This has revealed huge technological gaps in communication and management of treatment processes between health care provider s and patients.'
              'Moreover, the measurement of vital signs is subjective and initiated by the human factor.'
              'On the medical team’s side, the monitoring of the home hospitalized patients is done manually and therefore isn’t prioritized effectively.'
              'Due to insufficient tracking of vitals, patients fall between the cracks and this may cost them the ultimate price - life.',
              style:TextStyle(color: Colors.black, fontSize: 18)),
          SizedBox(height: 15),
          Text('The Solution \n',
              style:TextStyle(color: Colors.black, fontSize: 18,fontWeight: FontWeight.bold)
          ),
          Text('By analysing the problem, we have learned that there is importance in connecting between patients and healthcare providers seamlessly.'
            'Our solution is a mobile app for patients that collects vital signs from smart wristbands/watches and analyzes data about the patient’s breathing with help of their mobile phone’s integrated camera.'
            'On the other end, health care providers are able to track, monitor and analyze patients’ vital signs & overall health'
            'by using a smart dashboard that displays relevant data and helps the medical team prioritize and make life & death decisions in real time based on objective vital signs.'
            'By doing so, the treatment patients receive is faster and more-reliable.',
              style:TextStyle(color: Colors.black, fontSize: 18)),
            SizedBox(height: 15),
          Text('For any question or problem,\n contact us: \n'
              'med.io.biu@gmail.com',
              textAlign: TextAlign.center,

              style:TextStyle(color: Colors.black, fontSize: 22)
          ),
        ],)
        ),
      ),
    );
  }


}
