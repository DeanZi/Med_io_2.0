import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medio2/res/custom_colors.dart';
import 'package:medio2/screens/sign_in_screen.dart';
import 'package:medio2/utils/Dimensions.dart';
import 'package:medio2/utils/authentication.dart';
import 'package:medio2/widgets/app_bar_title.dart';
import 'package:fit_kit/fit_kit.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  late User _user;
  bool _isSigningOut = false;
  int currentIndex = 0;

  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SignInScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  void initState() {
    _user = widget._user;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.firebaseNavy,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: CustomColors.firebaseNavy,
        title: AppBarTitle(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 300.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(),
              _user.photoURL != null
                  ? ClipOval(
                      child: Material(
                        color: CustomColors.firebaseGrey.withOpacity(0.3),
                        child: Image.network(
                          _user.photoURL!,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    )
                  : ClipOval(
                      child: Material(
                        color: CustomColors.firebaseGrey.withOpacity(0.3),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: CustomColors.firebaseGrey,
                          ),
                        ),
                      ),
                    ),
              SizedBox(height: 16.0),
              Text(
                'Hello',
                style: TextStyle(
                  color: CustomColors.firebaseGrey,
                  fontSize: 26,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                _user.displayName!,
                style: TextStyle(
                  color: CustomColors.firebaseYellow,
                  fontSize: 26,
                ),
              ),
              // SizedBox(height: 5.0),
              // Text(
              //   '( ${_user.email!} )',
              //   style: TextStyle(
              //     color: CustomColors.firebaseOrange,
              //     fontSize: 20,
              //     letterSpacing: 0.5,
              //   ),
              //),
              // SizedBox(height: 24.0),
              // Text(
              //   'You are now signed in using your Google account. To sign out of your account click the "Sign Out" button below.',
              //   style: TextStyle(
              //       color: CustomColors.firebaseGrey.withOpacity(0.8),
              //       fontSize: 14,
              //       letterSpacing: 0.2),
              // ),
              SizedBox(height: 8.0),
              _isSigningOut
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.redAccent,
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        setState(() {
                          _isSigningOut = true;
                        });
                        await Authentication.signOut(context: context);
                        setState(() {
                          _isSigningOut = false;
                        });
                        Navigator.of(context)
                            .pushReplacement(_routeToSignInScreen());
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Text(
                          'Sign Out',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
              bodyWidget(context),

            ],
          ),
        ),
      ),
    );
  }

  bodyWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Dimensions.heightSize / 8),
      child: Container(
        width: MediaQuery.of(context).size.width / 1.4,
        height: MediaQuery.of(context).size.height / 1.4,
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: Dimensions.marginSize,
                right: Dimensions.marginSize,
                top: Dimensions.heightSize,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: Dimensions.marginSize * 2,
                    right: Dimensions.marginSize * 2,
                  ),
                  // child: Text(
                  //   _user.displayName!,
                  //   style: TextStyle(
                  //     color: CustomColors.firebaseYellow,
                  //     fontSize: 26,
                  //   ),
                  // ),
                ),
                SizedBox(
                  height: Dimensions.heightSize * 2,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: Dimensions.marginSize * 2,
                    right: Dimensions.marginSize * 2,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: Dimensions.heightSize * 2,
            ),
            detailsWidget(context)
          ],
        ),
      ),
    );
  }

  detailsWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: Dimensions.marginSize,
        right: Dimensions.marginSize,
      ),
      child: Container(
        height: 200,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          itemCount: 1,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(
                  left: Dimensions.widthSize,
                  right: Dimensions.widthSize,
                  top: 10,
                  bottom: 10),
              child: GestureDetector(
                child: DataTable(
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Text(
                        'Time',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Heart Rate',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Saturation',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                  rows: const <DataRow>[
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('Mohit')),
                        DataCell(Text('23')),
                        DataCell(Text('Associate Software Developer')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('Akshay')),
                        DataCell(Text('25')),
                        DataCell(Text('Software Developer')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('Deepak')),
                        DataCell(Text('29')),
                        DataCell(Text('Team Lead ')),
                      ],
                    ),
                  ],
                ),
                onTap: () async {
                  readData();

                  //await FitKit.read(DataType.HEART_RATE, dateFrom: dateFrom, dateTo: dateTo);
                },
              ),
            );
          },
        ),
      ),
    );
  }



  Future<bool> readPermissions() async {
    try {
      final responses = await FitKit.hasPermissions([
        DataType.HEART_RATE,

      ]);

      if (!responses) {
        print("GIVENNNNNNNN");
        await FitKit.readLast(DataType.HEART_RATE).then((value) => print(value.value));
        final value = await FitKit.requestPermissions([
          DataType.HEART_RATE,

        ]);

        return value;
      } else {
        return true;
      }
    } on UnsupportedException catch (e) {
      // thrown in case e.dataType is unsupported
      print(e);
      return false;
    }
  }
  void readData() async {
    bool permissionsGiven = await readPermissions();

    if (permissionsGiven) {
      DateTime current = DateTime.now();
      DateTime dateFrom;
      DateTime dateTo;
      if (false) {
        dateFrom = DateTime.now().subtract(Duration(
          hours: current.hour + 24,
          minutes: current.minute,
          seconds: current.second,
        ));
        dateTo = dateFrom.add(Duration(
          hours: 23,
          minutes: 59,
          seconds: 59,
        ));
      } else {
        // 17 Jan 2021 12:53:64 - 12:53:5
        dateFrom = current.subtract(Duration(
          hours: current.hour,
          minutes: current.minute +30,
          seconds: current.second,
        ));
        dateTo = DateTime.now();
      }

      for (DataType type in DataType.values) {
        try {
          final results = await FitKit.read(
            type,
            dateFrom: dateFrom,
            dateTo: dateTo,
          );

          print(type);
          print(results);
          //addWidget(type, results);
        } on Exception catch (ex) {
          print(ex);
        }
      }
    }
  }

}
