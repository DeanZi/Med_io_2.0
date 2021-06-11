import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medio2/utils/Dimensions.dart';

class DetailsScreen extends StatefulWidget {
  @override
  _WatchScreenState createState() => _WatchScreenState();
}

class _WatchScreenState extends State<DetailsScreen> {

  TextEditingController searchController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            Image.asset(
              'assets/watch.png',
              height: MediaQuery.of(context).size.height ,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fill,
              //colorBlendMode: BlendMode.dst,
            ),
            Container(
              height: MediaQuery.of(context).size.height ,
              decoration: BoxDecoration(
                  gradient: LinearGradient (
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter,
                      colors: [
                        Colors.grey.withOpacity(0.5),
                        Color(0xFF4C6BFF),
                      ]
                  )
              ),
            ),
            bodyWidget(context),
            //Positioned(
             // bottom: 0,
             // left: Dimensions.marginSize,
             // right: Dimensions.marginSize,
            //  child: nearbyDoctorWidget(context),
            //)
          ],
        ),
      ),
    );
  }
  bodyWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: Dimensions.heightSize
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
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
                  child: Text(
                    "Mr Yona",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: Dimensions.extraLargeTextSize * 1.6,
                        fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: Dimensions.heightSize * 2,),
                Padding(
                  padding: const EdgeInsets.only(
                    left: Dimensions.marginSize * 2,
                    right: Dimensions.marginSize * 2,
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.heightSize * 2,),
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
                  left: Dimensions.widthSize ,
                  right: Dimensions.widthSize ,
                  top: 10,
                  bottom: 10
              ),
              child: GestureDetector(
                child:   DataTable(
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Text(
                        'Name',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Age',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Designation',
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
                onTap: () {
                  // Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                  //     DoctorDetailsScreen(
                  //       image: topDoctor.image,
                  //       name: topDoctor.type,
                  //       specialist: topDoctor.type,
                  //       available: topDoctor.date,
                  //     )));
                },
              ),
            );
          },
        ),
      ),
    );
  }
}