import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jdx/Controller/BottomNevBar.dart';
import 'package:jdx/Models/GetProfileModel.dart';
import 'package:jdx/Utils/ApiPath.dart';
import 'package:jdx/Views/NoInternetScreen.dart';
import 'package:jdx/services/session.dart';
import 'package:jdx/verifyDocuments/VerifyBankDetails.dart';
import 'package:jdx/verifyDocuments/reviewScreens.dart';
import 'package:jdx/verifyDocuments/verifyDocs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Views/HelpScreen.dart';
import 'package:http/http.dart' as http;

class PendingScreen extends StatefulWidget {
  const PendingScreen({Key? key}) : super(key: key);

  @override
  State<PendingScreen> createState() => _PendingScreenState();
}

class _PendingScreenState extends State<PendingScreen> {
  bool _isNetworkAvail = true;
  bool isdocumetsVerified = true;
  GetProfileModel? getProfileModel;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: _isNetworkAvail ?
            Scaffold(
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
          child: _isLoading ? Center(child: CircularProgressIndicator())
          : Column(
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
                    getProfile();
                  },
                  child: Text(getTranslated(context, "Refresh Status"))),
            ],
          ),
        ),
      )
          : NoInternetScreen(
        onPressed: () {
          Future.delayed(Duration(seconds: 1)).then((_) async {
            _isNetworkAvail = await isNetworkAvailable();
            if (_isNetworkAvail) {
              if (mounted)
                setState(() {
                  _isNetworkAvail = true;
                });
              // callApi();
            }
          });
        },
      ),
    );
  }

  getProfile() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString("userId");
    print(" this is  User++++++++++++++>$userId");
    var headers = {
      'Cookie': 'ci_session=6de5f73f50c4977cb7f3af6afe61f4b340359530'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('${Urls.baseUrl}User_Dashboard/getUserProfile'));
    request.fields.addAll({'user_id': userId.toString()});
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      setState(() {
        _isLoading = true;
      });
      isdocumetsVerified = false;

      var result = await response.stream.bytesToString();
      log(result.toString());
      var finalResult = GetProfileModel.fromJson(jsonDecode(result));
      setState(() {
        getProfileModel = finalResult;
        // Fluttertoast.showToast(
        //     msg: getProfileModel!.data!.verified!.accountNumber.toString());

        if (getProfileModel?.data?.verified == null) {
          showDocumentScree();
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => ReviewScreen(
          //       getProfileModel: getProfileModel,
          //     ),
          //   ),
          // );
        } else if (getProfileModel!.data!.user!.vehicleNo == "" ||
            getProfileModel!.data!.user!.vehicleNo == null) {
          showDocumentScree();
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => ReviewScreen(
          //       getProfileModel: getProfileModel,
          //     ),
          //   ),
          // );

          //null -> not updated
          //0->pending
          //1 - >verified
//2-> rejected
        } else if (getProfileModel!.data!.verified!.aadhaarCardPhoto == null ||
            getProfileModel!.data!.verified!.drivingLicencePhoto == null ||
            getProfileModel!.data!.verified!.pan_card_photof == null ||
            getProfileModel!.data!.verified!.userImage == null ||
            getProfileModel!.data!.verified!.rcCardPhoto == null) {
          showDocumentScree();
        } else if (getProfileModel!.data!.verified!.aadhaarCardPhoto == "2" ||
            getProfileModel!.data!.verified!.drivingLicencePhoto == "2" ||
            getProfileModel!.data!.verified!.pan_card_photof == "2" ||
            getProfileModel!.data!.verified!.userImage == "2" ||
            getProfileModel!.data!.verified!.vehicle_image == "2" ||
            getProfileModel!.data!.verified!.rcCardPhoto == "2") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReviewScreen(
                getProfileModel: getProfileModel,
              ),
            ),
          );
        } else if (getProfileModel!.data!.verified!.accountNumber == null) {
          //open edit bank page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyBankDetails(),
            ),
          );

          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => ReviewScreen(
          //       getProfileModel: getProfileModel,
          //     ),
          //   ),
          // );
        } else if (getProfileModel!.data!.verified!.accountNumber == "2") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReviewScreen(
                getProfileModel: getProfileModel,
              ),
            ),
          );
        } else if (getProfileModel!.data!.verified!.aadhaarCardPhoto == "0" ||
            getProfileModel!.data!.verified!.drivingLicencePhoto == "0" ||
            getProfileModel!.data!.verified!.pan_card_photof == "0" ||
            getProfileModel!.data!.verified!.userImage == "0" ||
            getProfileModel!.data!.verified!.rcCardPhoto == "0" ||
            getProfileModel!.data!.verified!.accountNumber == "0") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PendingScreen(),
            ),
          );
          // // showunverifiedDialog();
        } else if (getProfileModel!.data!.verified!.accountNumber == null ||
            getProfileModel!.data!.verified!.accountNumber == "0") {
          showunverifiedDialog();
        } else {
          isdocumetsVerified = true;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const BottomNav(),
            ),
          );
        }
        //  print(
        //      '____Som______${getProfileModel!.data!.user!.userFullname}_________');
        // // Fluttertoast.showToast(msg: qrCodeResult);
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  showDocumentScree() {
    var bankVerified = true;
    if (getProfileModel!.data!.verified!.aadhaarCardPhoto == null ||
        getProfileModel!.data!.verified!.aadhaarCardPhoto == "2" ||
        getProfileModel!.data!.verified!.drivingLicencePhoto == null ||
        getProfileModel!.data!.verified!.drivingLicencePhoto == "2" ||
        getProfileModel!.data!.verified!.pan_card_photof == null ||
        getProfileModel!.data!.verified!.pan_card_photof == "2" ||
        getProfileModel!.data!.verified!.userImage == null ||
        getProfileModel!.data!.verified!.userImage == "2" ||
        getProfileModel!.data!.verified!.rcCardPhoto == null ||
        getProfileModel!.data!.verified!.rcCardPhoto == "2") {
      if (getProfileModel!.data!.verified!.accountNumber == null ||
          getProfileModel!.data!.verified!.accountNumber == "2") {
        bankVerified = false;
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyDocs(
            adharVerified:
            getProfileModel!.data!.verified!.aadhaarCardPhoto == null
                ? "0"
                : getProfileModel!.data!.verified!.aadhaarCardPhoto == "2"
                ? "0"
                : "1",
            drivingLicenseVerified: getProfileModel!
                .data!.verified!.drivingLicencePhoto ==
                null
                ? "0"
                : getProfileModel!.data!.verified!.drivingLicencePhoto == "2"
                ? "0"
                : "1",
            panVerified:
            getProfileModel!.data!.verified!.pan_card_photof == null
                ? "0"
                : getProfileModel!.data!.verified!.pan_card_photof == "2"
                ? "0"
                : "1",
            rcVerified: getProfileModel!.data!.verified!.rcCardPhoto == null
                ? "0"
                : getProfileModel!.data!.verified!.rcCardPhoto == "2"
                ? "0"
                : "1",
            vehicleNum: getProfileModel!.data!.user!.vehicleNo == null
                ? ""
                : getProfileModel!.data!.user!.vehicleNo == "2"
                ? ""
                : "1",
            imageVerified: getProfileModel!.data!.verified!.userImage == null
                ? "0"
                : getProfileModel!.data!.verified!.userImage == "2"
                ? "0"
                : "1",
            vehicleImageVerified:
            getProfileModel!.data!.verified!.vehicle_image == null
                ? "0"
                : getProfileModel!.data!.verified!.vehicle_image == "2"
                ? "0"
                : "1",
            isBankAdded: bankVerified,
          ),
        ),
      );
    } else if (getProfileModel!.data!.verified!.accountNumber == null ||
        getProfileModel!.data!.verified!.accountNumber == "2") {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyBankDetails(),
          ));
    }
  }

  showunverifiedDialog() {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Icon(
            Icons.info,
            color: Colors.green,
            size: 45,
          ),
          content: Text(
            "Your documents are being reviewed. Please wait while the documents are approved.",
            style: TextStyle(fontSize: 15),
          ),
        );
      },
    );
  }
}
