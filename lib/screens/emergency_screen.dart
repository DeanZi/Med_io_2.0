import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medio2/res/custom_colors.dart';
import 'package:medio2/utils/Dimensions.dart';

class EmergencyScreen extends StatefulWidget {
  @override
  _EmergencyScreenState createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {

  TextEditingController searchController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            Image.asset(
              'assets/emergency.png',
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
                        // Colors.grey.withOpacity(0.5),
                        Color(0xFF4C6BFF),
                      ]
                  )
              ),
            ),

            bodyWidget(context)
          ],
        ),
      ),
    );
  }
  categoryWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: Dimensions.heightSize * 2
      ),
      child: Container(
        height:
        390,
        width: 100,
        child: Container(

              padding: const EdgeInsets.only(
                  left: Dimensions.widthSize * 2,
                  right: Dimensions.widthSize,
                  top: 10,
                  bottom: 10
              ),
              child: GestureDetector(
                child: Container(
                  height: 350,
                  width: 80,
                  decoration: BoxDecoration(
                    color: currentIndex == 18 ? CustomColors.firebaseNavy : Colors.transparent,
                    borderRadius: BorderRadius.circular(Dimensions.radius),
                    boxShadow: [
                      BoxShadow(
                        color: CustomColors.firebaseNavy,
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/sos.png',
                      ),
                      SizedBox(height: 15,),
                      Text(
                        "Press for Medical assistance",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: Dimensions.extraLargeTextSize
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
                onTap: () {
                  setState(() {
                    currentIndex = 0;
                    print(currentIndex);
                  });
                },
              ),
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
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Dimensions.radius * 2),
              topRight: Radius.circular(Dimensions.radius * 2),
            )
        ),
        child: ListView(
          //physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
           // categoryWidget(context),
            goToWidget(currentIndex)
          ],
        ),
      ),
    );
  }



  goToWidget(int currentIndex) {
    switch(currentIndex) {
      case 0:
        return categoryWidget(context);

    }
  }

}