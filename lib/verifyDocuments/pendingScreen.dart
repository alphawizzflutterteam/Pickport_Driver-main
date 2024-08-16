import 'package:flutter/material.dart';
import 'package:jdx/Controller/BottomNevBar.dart';
import 'package:jdx/services/session.dart';

import '../Views/GetHelp.dart';
import '../Views/HelpScreen.dart';

class PendingScreen extends StatelessWidget {
  const PendingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(getTranslated(context, "Pending for approval") ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => NeedHelp()));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.white,
                    ),
                    child: Text( getTranslated(context, "Need Help?")
                      ,
                      style: TextStyle(color: Colors.blue.shade900, fontSize: 16),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            Future.delayed(Duration(seconds: 2));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/clock.png',
                height: 150,
              ),
              SizedBox(
                height: 20,
              ),
              Text(getTranslated(context, "Verification in Process")
                ,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
              ),
               Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 40.0, right: 40, top: 10),
                  child:
                  Text(getTranslated(context, "Thank you,We have received your application request, your application will be approved within 24 to 48 hrs and We will notify you once your application is approved.\n\nMeanwhile, Please go to the Need Help section to watch the training video."),
                   // "Thank you,We have received your application request, your application will be approved within 24 to 48 hrs and We will notify you once your application is approved.\n\nMeanwhile, Please go to the Need Help section to watch the training video.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                )
                ),

              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BottomNav()));
                  },
                  child: Text(getTranslated(context, "Refresh Status"))),
            ],
          ),
        ),
      ),
    );
  }
}
