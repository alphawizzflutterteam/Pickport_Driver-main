import 'package:flutter/material.dart';
import 'package:jdx/AuthViews/LoginScreen.dart';
import 'package:jdx/Views/HomeScreen.dart';

import '../Utils/Color.dart';
import '../services/session.dart';
import '../verifyDocuments/pendingScreen.dart';

class RegistrationSuccessScreen extends StatefulWidget {
  const RegistrationSuccessScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationSuccessScreen> createState() =>
      _RegistrationSuccessScreenState();
}

bool _allow = true;

class _RegistrationSuccessScreenState extends State<RegistrationSuccessScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PendingScreen()));
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/registration_success_img.png",
                    scale: 1.3,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                   Center(
                      child: Text( getTranslated(context, "Account created successfully")
                    ,
                    style: TextStyle(
                        color: colors.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                    // "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since"
                  )),
                  const SizedBox(
                    height: 8,
                  ),
                   Center(
                      child: Text(getTranslated(context, "Please wait, Until your account is approved by admin.")
                    ,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                    // "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since"
                  )),
                  const SizedBox(
                    height: 30,
                  ),
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => const PendingScreen()));
                  //   },
                  //   child: Container(
                  //     height: 50,
                  //     decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(10),
                  //         color: colors.primary),
                  //     child: Center(
                  //         child: Text(
                  //       getTranslated(context, "Done"),
                  //       // "Completed",
                  //       style: const TextStyle(
                  //           fontSize: 15, color: colors.whiteTemp),
                  //     )),
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
