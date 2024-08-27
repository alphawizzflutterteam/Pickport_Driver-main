import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jdx/AuthViews/SignUpScreen.dart';
import 'package:jdx/Controller/home_controller.dart';
import 'package:jdx/Models/Get_transaction_model.dart';
import 'package:jdx/Models/get_driver_rating_response.dart';
import 'package:jdx/Models/order_accept_response.dart';
import 'package:jdx/Models/order_history_response.dart';
import 'package:jdx/Provider/HomeProvider.dart';
import 'package:jdx/Views/DriverErningHistroy.dart';
import 'package:jdx/Views/Mywallet.dart';
import 'package:jdx/Views/order_details.dart';
import 'package:jdx/Views/parcel_details.dart';
import 'package:jdx/verifyDocuments/pendingScreen.dart';
import 'package:jdx/verifyDocuments/reviewScreens.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../AuthViews/AddBankDetails.dart';
import '../Models/Acceptorder.dart';
import '../Models/GetProfileModel.dart';
import '../Models/getSliderModel.dart';
import '../Models/parcel_history_response.dart';
import '../Utils/ApiPath.dart';
import '../Utils/Color.dart';
import '../Utils/CustomColor.dart';
import '../services/api_services/api.dart';
import '../services/api_services/request_key.dart';
import '../services/location/location.dart';
import 'package:http/http.dart' as http;

import '../services/session.dart';
import '../verifyDocuments/VerifyBankDetails.dart';
import '../verifyDocuments/verifyDocs.dart';
import 'MyAccount.dart';
import 'NotificationScreen.dart';
import 'ParcelDetails.dart';
import 'SupportNewScreen.dart';

String? driverEraning;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Api api = Api();
  bool isSwitched = true;
  bool isdocumetsVerified = true;
  List<OrderHistoryData> orderHistoryList = [];
  Position? _position;
  String city = "";

  bool isLoading = false;
  String? name, image;
  GetDriverRating? _driverRating;
  bool isOnline = true;

  ///active order

  //List<AccepetedOrderList> parcelDataList = [];
  Acceptorder? parcelDataList;
  bool isLoading2 = false;
  List<ParcelHistoryDataList> pastParcelDataList = [];
  bool isLoading3 = false;
  String? userId;

  List isActive = [];

  @override
  void initState() {
    // TODO: implement initState
    fetchAndUploadLocation();
    inIt();
    getProfile();
    getSliderApi();
    getDriverApi();
    getCheckStatusApi();
    startTimer();
    super.initState();
  }

  GetProfileModel? getProfileModel;
  String qrCodeResult = "Not Yet Scanned";

  final CarouselController carouselController = CarouselController();

  showDocumentDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Icon(
            Icons.warning,
            color: Colors.red,
            size: 45,
          ),
          content: const Text(
            "Some of your Documents has been rejected or you have not uploaded the documents for verification, Please upload the new documents.",
            style: TextStyle(fontSize: 15),
          ),
          actions: <Widget>[
            ElevatedButton(
                onPressed: () {},
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      var bankVerified = true;
                      if (getProfileModel!.data!.verified!.aadhaarCardPhoto ==
                              null ||
                          getProfileModel!
                                  .data!.verified!.aadhaarCardPhoto ==
                              "2" ||
                          getProfileModel!
                                  .data!.verified!.drivingLicencePhoto ==
                              null ||
                          getProfileModel!
                                  .data!.verified!.drivingLicencePhoto ==
                              "2" ||
                          getProfileModel!.data!.verified!.pan_card_photof ==
                              null ||
                          getProfileModel!.data!.verified!.pan_card_photof ==
                              "2" ||
                          getProfileModel!.data!.verified!.userImage == null ||
                          getProfileModel!.data!.verified!.userImage == "2" ||
                          getProfileModel!.data!.verified!.rcCardPhoto ==
                              null ||
                          getProfileModel!.data!.verified!.rcCardPhoto == "2") {
                        if (getProfileModel!.data!.verified!.accountNumber ==
                                null ||
                            getProfileModel!.data!.verified!.accountNumber ==
                                "2") {
                          bankVerified = false;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VerifyDocs(
                              adharVerified: getProfileModel!
                                          .data!.verified!.aadhaarCardPhoto ==
                                      null
                                  ? "0"
                                  : getProfileModel!.data!.verified!
                                              .aadhaarCardPhoto ==
                                          "2"
                                      ? "0"
                                      : "1",
                              drivingLicenseVerified: getProfileModel!.data!
                                          .verified!.drivingLicencePhoto ==
                                      null
                                  ? "0"
                                  : getProfileModel!.data!.verified!
                                              .drivingLicencePhoto ==
                                          "2"
                                      ? "0"
                                      : "1",
                              panVerified: getProfileModel!
                                          .data!.verified!.pan_card_photof ==
                                      null
                                  ? "0"
                                  : getProfileModel!.data!.verified!
                                              .pan_card_photof ==
                                          "2"
                                      ? "0"
                                      : "1",
                              rcVerified: getProfileModel!
                                          .data!.verified!.rcCardPhoto ==
                                      null
                                  ? "0"
                                  : getProfileModel!
                                              .data!.verified!.rcCardPhoto ==
                                          "2"
                                      ? "0"
                                      : "1",
                              vehicleNum:
                                  getProfileModel!.data!.user!.vehicleNo == null
                                      ? ""
                                      : getProfileModel!
                                                  .data!.user!.vehicleNo ==
                                              "2"
                                          ? ""
                                          : "1",
                              imageVerified:
                                  getProfileModel!.data!.verified!.userImage ==
                                          null
                                      ? "0"
                                      : getProfileModel!
                                                  .data!.verified!.userImage ==
                                              "2"
                                          ? "0"
                                          : "1",
                              vehicleImageVerified: getProfileModel!
                                          .data!.verified!.vehicle_image ==
                                      null
                                  ? "0"
                                  : getProfileModel!
                                              .data!.verified!.vehicle_image ==
                                          "2"
                                      ? "0"
                                      : "1",
                              isBankAdded: bankVerified,
                            ),
                          ),
                        );
                      } else if (getProfileModel!
                                  .data!.verified!.accountNumber ==
                              null ||
                          getProfileModel!.data!.verified!.accountNumber ==
                              "2") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VerifyBankDetails(),
                            ));
                      }
                    },
                    child: Text('OK'))),
          ],
        );
      },
    );
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

  getProfile() async {
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
        }
        //  print(
        //      '____Som______${getProfileModel!.data!.user!.userFullname}_________');
        // // Fluttertoast.showToast(msg: qrCodeResult);
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  inIt() async {

    setState(() {
      isLoading = true;
    });
    // ctrl.getOrders(status: selectedSegmentVal.toString());

    SharedPreferences prefs1 = await SharedPreferences.getInstance();
    userId = prefs1.getString('userId');
    name = prefs1.getString('userName');
    image = prefs1.getString('userImage');

    _position = await getUserCurrentPosition();

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _position!.latitude,
        _position!.longitude,
      );
      city = placemarks[0].locality.toString();
      print(placemarks[0].locality.toString() + "PLACE CMAKR");
      print(placemarks[0].subLocality.toString() + "PLACE CMAKR");
      print(placemarks[0].subAdministrativeArea.toString() + "PLACE CMAKR");
      print(placemarks[0].street.toString() + "PLACE CMAKR");
    } catch (err, stacktrace) {
      print("PLACE CMAKR ERRR $stacktrace");
      print("PLACE CMAKR ERRR $err");
    }

    getUserOrderHistory("0");
    getDriverRating(userId ?? '300');
    getDriverRating(userId ?? '300');
    getDriverApi();
  }

  GetSliderModel? getSliderModel;

  Future<void> fetchAndUploadLocation() async {
    try {

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final response = await http.post(
        Uri.parse("https://pickport.in/api/Authentication/driver_lat_lang_update"),
        body: {
          'user_id':userId.toString(),
          'latitude': position.latitude.toString(),
          'longitude': position.longitude.toString(),
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        print('Location uploaded successfully!');
      } else {
        print('Error uploading location: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e);
    }
  }



  getSliderApi() async {
    var headers = {
      'Cookie': 'ci_session=8c63df600f4c9c930d8b1e2d1e10feb8278887c0'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('${Urls.baseUrl}Authentication/delivery_bannerList'));
    request.fields.addAll({'type': '3'});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      print(result);
      var finalResult = GetSliderModel.fromJson(json.decode(result));
      setState(() {
        getSliderModel = finalResult;
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  int _currentPost = 0;

  _buildDots() {
    List<Widget> dots = [];
    if (getSliderModel == null) {
    } else {
      for (int i = 0; i < getSliderModel!.data!.length; i++) {
        dots.add(
          Container(
            margin: const EdgeInsets.all(1.5),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentPost == i ? colors.primary : colors.secondary,
            ),
          ),
        );
      }
    }
    return dots;
  }

  bool isButtonDisabled = false;

  void startTimer() {
    // setState(() {
    //   isButtonDisabled = true;
    // });

    Timer(const Duration(seconds: 10), () {
      // setState(() {
      //   isButtonDisabled = false;
      // });
      fetchAndUploadLocation();
    });
  }

  int status = 0;

  @override
  Widget build(BuildContext context) {
    return getProfileModel == null
        ? CircularProgressIndicator()
        : RefreshIndicator(
      onRefresh: () async {
        Future.delayed(const Duration(seconds: 2));
        inIt();
        setSegmentValue(0);
      },
      child: Scaffold(
        // FloatingActionButton
        floatingActionButtonLocation:
        FloatingActionButtonLocation.centerFloat,
        //    bottomSheet:  Padding(
        //      padding: const EdgeInsets.all(8.0),
        //      child: Container(
        //        child: Row(
        //          children: [
        //            Row(
        //              children: [
        //                isOnline
        //                    ? const Text(
        //                  "Online",
        //                  style: TextStyle(color: Colors.green),
        //                )
        //                    : const Text(
        //                  "Offline",
        //                  style: TextStyle(color: Colors.red),
        //                ),
        //                const SizedBox(
        //                  width: 10,
        //                ),
        //                Switch.adaptive(
        //                    activeColor: Colors.green,
        //                    inactiveTrackColor: Colors.red,
        //                    value: isOnline,
        //                    onChanged: (val) {
        //                      setState(() {
        //                        isOnline = val;
        //                        getUserStatusOnlineOrOffline();
        //                      });
        //                    }),
        //              ],
        //            ),
        //          ],
        //        ),
        //      ),
        //    ),
        floatingActionButton: Container(
          decoration: BoxDecoration(
              color: CustomColors.primaryColor,
              border: Border.all(color: CustomColors.secondaryColor),
              borderRadius: BorderRadius.circular(10)),
          width: 110,
          height: 50,
          child: Center(
            child: Row(
              children: [
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Text(
                    status == 1 ? getTranslated(context,'Online',)
                        : getTranslated(context,'Offline'),
                    style: TextStyle(
                        fontSize: 12,
                        color: status == 2 ? Colors.red : Colors.green),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Switch(
                  activeColor: Colors.green,
                  inactiveTrackColor: Colors.red,
                  value: status == 1,
                  onChanged: (value) {
                    setState(() {
                      status = value ? 1 : 2;
                      getStatus(status);
                      value ? Fluttertoast.showToast(msg: "Driver is Online", gravity: ToastGravity.CENTER)
                          : Fluttertoast.showToast(msg: "Driver is Offline", gravity: ToastGravity.CENTER);
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        backgroundColor: colors.primary,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: colors.primary,
          elevation: 0,
          toolbarHeight: 70,
          leadingWidth: 0,
          title: Row(
            children: [
              InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyAccount()),
                    ).then((value) {
                      setState(() {
                        getProfile();
                        getDriverApi();
                      });
                    });
                  },
                  child: Icon(Icons.menu)),
              // const SizedBox(
              //   width: 10,
              // ),
              Container(
                height: 70,
                width: 70,
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(),
                child: getProfileModel?.data?.user?.userImage == null
                    ? const Center(
                  child: CircularProgressIndicator(),
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(80),
                  child: Image.network(
                    "${getProfileModel!.data!.user!.userImage}",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              getProfileModel?.data?.user?.userFullname == null
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //    getTranslated(context, "Hello"),
                  //   // 'Hello,',
                  //    style: const TextStyle(fontSize: 16, color: Colors.white),
                  //  ),
                  Text(
                    '${getProfileModel!.data!.user!.userFullname}',
                    style: const TextStyle(
                        fontSize: 14, color: Colors.white),
                  ),
                  Text(
                    '${getProfileModel!.data!.user!.vehicleNo}',
                    style: const TextStyle(
                        fontSize: 14, color: Colors.white),
                  ),
                  Text(
                    '${getProfileModel!.data!.user!.vehicleTypeString}',
                    style: const TextStyle(
                        fontSize: 12, color: Colors.white),
                  )
                ],
              ),
            ],
          ),

          actions: [
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                        const NotificationScreen()));
              },
              child: Container(
                height: 40,
                width: 40,
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.white),
                child: const Icon(
                  Icons.notifications_active,
                  color: CustomColors.primaryColor,
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                        const SupportNewScreen()));
              },
              child: Container(
                height: 40,
                width: 40,
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.white),
                child: const Icon(
                  Icons.headset_rounded,
                  color: CustomColors.primaryColor,
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
          ],
          // leading: Image.asset('assets/images/jdx_logo.png',
          //     color: Colors.transparent),
          // backgroundColor: Colors.cyan.withOpacity(0.10),
          // elevation: 0,
          // actions: [
          //
          //   // Container(
          //   //   height: 10,
          //   //   width: 80,
          //   //   child: CupertinoSwitch(
          //   //     value: _switchValue,
          //   //     onChanged: (value) {
          //   //       setState(() {
          //   //         _switchValue = value;
          //   //       });
          //   //     },
          //   //   ),
          //   // ),
          // ],
        ),
        body: getProfileModel == null
            ? const Center(child: CircularProgressIndicator())
            : Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 20),
                  decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(35),
                          topRight: Radius.circular(35))),
                  child: ListView(
                    children: [
                      Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          getSliderModel == null
                              ? const Center(
                              child:
                              CircularProgressIndicator())
                              : CarouselSlider(
                              items: getSliderModel?.data!
                                  .map(
                                    (item) => Stack(
                                    alignment: Alignment
                                        .center,
                                    children: [
                                      Padding(
                                        padding:
                                        const EdgeInsets
                                            .all(
                                            8.0),
                                        child:
                                        ClipRRect(
                                            borderRadius:
                                            BorderRadius.circular(
                                                10),
                                            child:
                                            Container(
                                              height:
                                              200,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                        "${item.sliderImage}",
                                                      ),
                                                      fit: BoxFit.fill)),
                                            )),
                                      ),
                                    ]),
                              )
                                  .toList(),
                              carouselController:
                              carouselController,
                              options: CarouselOptions(
                                  height: 150,
                                  scrollPhysics:
                                  const BouncingScrollPhysics(),
                                  autoPlay: true,
                                  aspectRatio: 1.8,
                                  viewportFraction: 1,
                                  onPageChanged:
                                      (index, reason) {
                                    setState(() {
                                      _currentPost = index;
                                    });
                                  })),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: _buildDots(),
                          ),
                          // sliderPointers (items , currentIndex),
                        ],
                      ),
                      const SizedBox(height: 10),
                      walletAmount(),
                      status == 0
                          ? Container()
                          : _segmentButton(),
                      const SizedBox(
                        height: 0,
                      ),
                      status == 0
                          ? Container()
                          : selectedSegmentVal == 0
                          ? currentDelivery(context)
                          : selectedSegmentVal == 1
                          ? scheduleDelivery(context)
                          : completeOrder(),
                      const SizedBox(
                        height: 50,
                      )
                    ],
                  ),
                ),
              )
              // const SizedBox(
              //   height: 10,
              // ),
              // _driverRating?.rating == null
              //     ? const SizedBox()
              //     : Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Text(
              //             'Hi, ${name.toString().capitalizeFirst}',
              //             style: TextStyle(
              //                 color: Colors.green,
              //                 fontWeight: FontWeight.w400,
              //                 fontSize: 30),
              //           ),
              //           Row(
              //             children: [
              //               RatingBar.builder(
              //                 itemSize: 18,
              //                 ignoreGestures: true,
              //                 initialRating:
              //                     double.parse(_driverRating?.rating ?? ''),
              //                 minRating: 1,
              //                 direction: Axis.horizontal,
              //                 allowHalfRating: true,
              //                 itemCount: 5,
              //                 itemPadding: EdgeInsets.zero,
              //                 itemBuilder: (context, _) => Icon(
              //                   Icons.star,
              //                   color: Colors.red,
              //                 ),
              //                 onRatingUpdate: (rating) {
              //                   print(rating);
              //                 },
              //               ),
              //               const SizedBox(
              //                 width: 10,
              //               ),
              //               Text.rich(TextSpan(children: [
              //                 TextSpan(
              //                     text: '${_driverRating?.rating}',
              //                     style: const TextStyle(color: Colors.red)),
              //                 const TextSpan(
              //                     text: '/5.0',
              //                     style: TextStyle(color: Colors.grey)),
              //               ]))
              //             ],
              //           ),
              //         ],
              //       ),
              // const SizedBox(
              //   height: 20,
              // // ),
              // const Text(
              //   'Current Leads',
              //   style: TextStyle(
              //       color: Colors.redAccent,
              //       fontWeight: FontWeight.w400,
              //       fontSize: 17),
              // ),
            ],
          ),
        ),
        // bottomSheet: Container(
        //   color: colors.primary,
        //   height: 60,
        //   width: MediaQuery.of(context).size.width,
        //   child: Row(children: [
        //     Expanded(
        //         child: InkWell(
        //       onTap: () {
        //         setState(() {
        //           isOnline = true;
        //           getUserStatusOnlineOrOffline();
        //         });
        //       },
        //       child: Container(
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             Icon(
        //               Icons.check_circle_rounded,
        //               color: isOnline ? Colors.green : Colors.white,
        //             ),
        //             const SizedBox(width: 5,),
        //             Text(
        //               getTranslated(context, "Online"),
        //               //'Online',
        //               style: TextStyle(
        //                   fontSize: 16,
        //                   color: isOnline ? Colors.green : Colors.white),
        //             )
        //           ],
        //         ),
        //       ),
        //     )),
        //     Container(
        //       width: 1,
        //       height: 60,
        //       color: Colors.white,
        //     ),
        //     Expanded(
        //         child: InkWell(
        //       onTap: () {
        //         setState(() {
        //           isOnline = false;
        //           getUserStatusOnlineOrOffline();
        //           print('____Som______${isOnline}_________');
        //         });
        //       },
        //       child: Container(
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           Icon(
        //             Icons.wifi_tethering_off,
        //             color: isOnline ? Colors.white : Colors.red,
        //           ),
        //           const SizedBox(width: 5,),
        //           Text(
        //             getTranslated(context, "Offline"),
        //             // 'Offline',
        //             style: TextStyle(
        //                 fontSize: 16,
        //                 color: isOnline ? Colors.white : Colors.red),
        //           ),
        //         ],
        //         ),
        //       ),
        //     ))
        //   ]),
        // ),
      ),
    );
  }

  currentDelivery(BuildContext context) {
    return GetBuilder(
      init: HomeController(),
      dispose: (state) {
        ctrl.timer?.cancel();
      },
      builder: (HomeController ctrl) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.maxFinite,
              child: ctrl.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ctrl.currentOrderHistoryList.length == 0
                      ? Center(
                          child: Text(
                          "No Orders Found",
                          //   'Data not available'
                        ))
                      : ListView.builder(
                          // reverse: true,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: ctrl.currentOrderHistoryList.length,
                          itemBuilder: (context, index) {
                            bool isAccepted = ctrl.currentOrderHistoryList[index]
                                        .parcelDetails
                                        .first
                                        .status ==
                                    "2"
                                ? true
                                : false;
                            // isButtonDisabled = isAccepted? false: true;
                            return InkWell(
                              onTap: () {
                                if (ctrl.currentOrderHistoryList[index]
                                        .parcelDetails
                                        .first
                                        .status ==
                                    "2") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PercelDetails(
                                              pId: ctrl.currentOrderHistoryList[index]
                                                  .orderId)));
                                }
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                elevation: 2,
                                color: Colors.white,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0),
                                                // child: Text(
                                                //     getTranslated(
                                                //         context, "Customer Name"),
                                                //     //  "Customer Name",
                                                //     style: const TextStyle(
                                                //         fontSize: 14,
                                                //         color: colors.black54)),
                                              ),
                                              Row(
                                                children: [
                                                  Text('Parcel Id #',
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          color: colors.primary)), Text(
                                                      ctrl.currentOrderHistoryList[index]
                                                          .orderId ??
                                                          '',
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          color: colors.primary)),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0),
                                                child: Text(
                                                    getTranslated(
                                                        context, "Customer Name"),
                                                    //  "Customer Name",
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: colors.black54)),
                                              ),
                                              Text(
                                                  ctrl. currentOrderHistoryList[index]
                                                          .senderName ??
                                                      '',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: colors.primary)),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              // "${orderHistoryList[index].parcelDetails
                                              //     .first.bookingDate ?? ''}"

                                              Text(
                                                  "${DateFormat('dd/MM/yyyy').format(DateFormat('dd-MMM-yyyy').parse(ctrl.currentOrderHistoryList[index].parcelDetails.first.bookingDate ?? ''))} ${ctrl.currentOrderHistoryList[index].parcelDetails.first.bookingTime}",
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: colors.blackTemp,
                                                      fontFamily: 'lora')),
                                              Text(
                                                  "₹ ${ctrl.currentOrderHistoryList[index].total_amount ?? ''}",
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: colors.blackTemp,
                                                      fontFamily: 'lora')),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.all(8),
                                                  decoration: const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.red),
                                                  child: const Icon(
                                                    Icons.pin_drop,
                                                    size: 14,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Container(
                                                  height: 40,
                                                  width: 1,
                                                  color: Colors.black,
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.all(8),
                                                  decoration: const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.grey),
                                                  child: const Icon(
                                                    Icons.pin_drop,
                                                    size: 14,
                                                    color: Colors.yellow,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        getTranslated(context,
                                                            "Pick up Point"),
                                                        // "Pick up Point",
                                                        style: const TextStyle(
                                                            color: colors.primary,
                                                            fontSize: 12),
                                                      ),
                                                      Container(
                                                        width:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                0.65,
                                                        child: Text(
                                                          ctrl. currentOrderHistoryList[index]
                                                              .senderAddress,
                                                          style: const TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Container(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        getTranslated(
                                                            context, "Drop Point"),
                                                        //  "Drop Point",
                                                        style: const TextStyle(
                                                            color: colors.primary,
                                                            fontSize: 12),
                                                      ),
                                                      Container(
                                                        width:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                0.65,
                                                        child: Text(
                                                          ctrl. currentOrderHistoryList[index]
                                                                  .parcelDetails
                                                                  .first
                                                                  .receiverAddress ??
                                                              "",
                                                          style: const TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(getTranslated(context, 'Pickup Distance')),
                                          Text(
                                              "${ctrl.currentOrderHistoryList[index].orderDis} Km"),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(getTranslated(
                                              context, "Total Distance")),
                                          Text(
                                              "${double.parse(ctrl.currentOrderHistoryList[index].parcelDetails.first.distance.toString()) + double.parse(ctrl.currentOrderHistoryList[index].orderDis.toString())} Km"),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: (isButtonDisabled == true &&
                                                ctrl.currentOrderHistoryList[index]
                                                            .status ==
                                                        '0')
                                                ? Container(
                                                    height: 35,
                                                    width: double.maxFinite,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                30),
                                                        color: colors.primary),
                                                    child: const Center(
                                                      child: Text(
                                                        "Wait For 5 Second..",
                                                        style: TextStyle(
                                                            color:
                                                                colors.whiteTemp),
                                                      ),
                                                    ),
                                                  )
                                                : InkWell(
                                                    onTap:
                                                        // orderHistoryList[index].isAccepted ?? false
                                                        //     ? null
                                                        //     :
                                                        () async {
                                                      var min =
                                                          await getMinimumWallet();
                                                      if (double.parse(
                                                              driverAmount ?? "0") <
                                                          min) {
                                                        _showAlertDialog(
                                                            context, min);
                                                        // Fluttertoast.showToast(
                                                        //     msg:
                                                        //         "To begin accepting order, please ensure your Wallet is Topped up with a Minimum Balance of 150 and Provide an option to recharge using Our wallet recharge method.");
                                                      } else {
                                                        if (ctrl.currentOrderHistoryList[index]
                                                                    .parcelDetails
                                                                    .first
                                                                    .status ==
                                                                "2" ||
                                                            ctrl. currentOrderHistoryList[index]
                                                                    .parcelDetails
                                                                    .first
                                                                    .status ==
                                                                "3") {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      PercelDetails(
                                                                          pId: ctrl.currentOrderHistoryList[
                                                                                  index]
                                                                              .orderId)));
                                                        }

                                                          ctrl.currentOrderHistoryList[index]
                                                              .isAccepted = true;

                                                          ctrl.orderRejectedOrAccept(
                                                              index, context, "0",city);

                                                      }
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(10),
                                                      width: MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.30,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  20),
                                                          color: (ctrl.currentOrderHistoryList[
                                                                              index]
                                                                          .parcelDetails
                                                                          .first
                                                                          .status ==
                                                                      "2" ||
                                                              ctrl.currentOrderHistoryList[
                                                                              index]
                                                                          .parcelDetails
                                                                          .first
                                                                          .status ==
                                                                      "3")
                                                              ? Colors.grey
                                                              : Colors.green),
                                                      child: Center(
                                                        child: Text(
                                                            (ctrl.currentOrderHistoryList[index]
                                                                            .parcelDetails
                                                                            .first
                                                                            .status ==
                                                                        "2" ||
                                                                ctrl.currentOrderHistoryList[
                                                                                index]
                                                                            .parcelDetails
                                                                            .first
                                                                            .status ==
                                                                        "3")
                                                                ? getTranslated(
                                                                    context,
                                                                    "View Detail") //'Accepted'
                                                                : getTranslated(
                                                                    context,
                                                                    "Accept"), //'Accept',
                                                            style: const TextStyle(
                                                                color:
                                                                    Colors.white)),
                                                      ),
                                                    ),
                                                  ),
                                          ),

                                          // orderHistoryList[
                                          //                 index]
                                          //             .isAccepted ??
                                          //         false
                                          //     ? SizedBox
                                          //         .shrink()
                                          //     : Expanded(
                                          //         child:
                                          //             InkWell(
                                          //           onTap:
                                          //               () {
                                          //             orderRejectedOrAccept(
                                          //                 index,
                                          //                 context,
                                          //                 isRejected:
                                          //                     true);
                                          //           },
                                          //           child:
                                          //               Container(
                                          //             width: MediaQuery.of(context).size.width *
                                          //                 0.35,
                                          //             padding:
                                          //                 const EdgeInsets.all(10),
                                          //             decoration: BoxDecoration(
                                          //                 borderRadius:
                                          //                     BorderRadius.circular(20),
                                          //                 color: Colors.red),
                                          //             child:
                                          //                  Center(
                                          //               child:
                                          //                   Text(
                                          //                     getTranslated(context, "Reject"),
                                          //               //  'Reject',
                                          //                 style:
                                          //                     TextStyle(color: Colors.white),
                                          //               ),
                                          //             ),
                                          //           ),
                                          //         ),
                                          //       ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        );
      }
    );
  }

  void _showAlertDialog(BuildContext context, int mini) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: const [
              Icon(
                Icons.warning,
                color: Colors.orange,
              ),
              SizedBox(width: 8),
              Text('Alert'),
            ],
          ),
          content: Text(
            'To begin accepting orders, please ensure your Wallet is Topped up with a Minimum Balance of $mini and Provide an option to recharge using Our wallet recharge method.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<int> getMinimumWallet() async {
    var headers = {
      'Cookie': 'ci_session=30f7a5a1f9dd96a4fc44ef6aa7de3f031bc38734'
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://pickport.in/api/authentication/driver_min_wallet'));
    request.fields.addAll({'user_id': '613'});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var res = await response.stream.bytesToString();

      var respo = jsonDecode(res);

      print(respo["data"]["amt"]);
      return int.parse(respo["data"]["amt"]);
    } else {
      print(response.reasonPhrase);

      return 0;
    }
  }

  scheduleDelivery(BuildContext context) {
    return GetBuilder(
      init: HomeController(),
      builder: (HomeController ctrl) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.maxFinite,
              child: ctrl.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ctrl.schedOrderHistoryList.length == 0
                      ? Center(
                          child: Text(
                          'No Data Found',
                          //   'Data not available'
                        ))
                      : ListView.builder(
                          // reverse: true,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: ctrl.schedOrderHistoryList.length,
                          itemBuilder: (context, index) {
                            bool isAccepted = ctrl.schedOrderHistoryList[index]
                                        .parcelDetails
                                        .first
                                        .status ==
                                    "2"
                                ? true
                                : false;
                            // isButtonDisabled = isAccepted? false: true;
                            return InkWell(
                              onTap: isAccepted
                                  ? () {
                                      print(
                                          '____Som___jj___${ctrl.schedOrderHistoryList[index].orderId}_________');
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //       builder: (context) =>
                                      //           OrderDetailView(orderDetail: orderHistoryList[index]),
                                      //     ));
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => PercelDetails(
                                                  pId:ctrl. schedOrderHistoryList[index]
                                                      .orderId)));
                                    }
                                  : null,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                elevation: 2,
                                color: Colors.white,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Parcel Id #${ctrl. schedOrderHistoryList[index].orderId ?? ''}"),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0),
                                                child: Text(
                                                    getTranslated(
                                                        context, "Customer Name"),
                                                    //  "Customer Name",
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: colors.black54)),
                                              ),
                                              Text(
                                                  ctrl. schedOrderHistoryList[index]
                                                          .senderName ??
                                                      '',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: colors.primary)),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              // Text(
                                              //     DateFormat(
                                              //         'yyyy-MM-dd')
                                              //         .format(orderHistoryList[index]
                                              //         .onDate),
                                              //     style: const TextStyle(
                                              //         fontSize:
                                              //         14,
                                              //         color: colors
                                              //             .black54)),

                                              // DateFormat('dd/MM/yyyy').format(date)
                                              // Text("${DateFormat('dd/MM/yyyy').format( DateFormat('dd-MMM-yyyy').parse(tripDetailsModel!.data!.first.newDate ?? ""))}",style: TextStyle(
                                              // orderHistoryList[index].parcelDetails.first.bookingDate  ?? ""
                                              Text(
                                                  "${DateFormat('dd/MM/yyyy').format(DateFormat('dd-MMM-yyyy').parse(ctrl.schedOrderHistoryList[index].parcelDetails.first.bookingDate ?? ""))}  " +
                                                      (ctrl.schedOrderHistoryList[index]
                                                              .parcelDetails
                                                              .first
                                                              .bookingTime ??
                                                          ""),
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: colors.blackTemp,
                                                      fontFamily: 'lora')),
                                              Text(
                                                  "₹ ${double.parse(ctrl.schedOrderHistoryList[index].parcelDetails.first.totalAmount!) - double.parse(ctrl.schedOrderHistoryList[index].parcelDetails.first.couponDiscount!) ?? ''}",
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: colors.blackTemp,
                                                      fontFamily: 'lora')),
                                            ],
                                          ),
                                        ],
                                      ),

                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.all(8),
                                                  decoration: const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.red),
                                                  child: const Icon(
                                                    Icons.pin_drop,
                                                    size: 14,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Container(
                                                  height: 40,
                                                  width: 1,
                                                  color: Colors.black,
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.all(8),
                                                  decoration: const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.grey),
                                                  child: const Icon(
                                                    Icons.pin_drop,
                                                    size: 14,
                                                    color: Colors.yellow,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        getTranslated(context,
                                                            "Pick up Point"),
                                                        // "Pick up Point",
                                                        style: const TextStyle(
                                                            color: colors.primary,
                                                            fontSize: 12),
                                                      ),
                                                      Container(
                                                        width:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                0.65,
                                                        child: Text(
                                                          ctrl.schedOrderHistoryList[index]
                                                              .senderAddress,
                                                          style: const TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Container(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        getTranslated(
                                                            context, "Drop Point"),
                                                        //  "Drop Point",
                                                        style: const TextStyle(
                                                            color: colors.primary,
                                                            fontSize: 12),
                                                      ),
                                                      Container(
                                                        width:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                0.65,
                                                        child: Text(
                                                          ctrl. schedOrderHistoryList[index]
                                                                  .parcelDetails
                                                                  .first
                                                                  .receiverAddress ??
                                                              "",
                                                          style: const TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Pickup Distance"),
                                          Text(
                                              "${ctrl.schedOrderHistoryList[index].orderDis} Km"),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(getTranslated(
                                              context, "Total Distance")),
                                          Text(
                                              "${ctrl.schedOrderHistoryList[index].parcelDetails.first.distance} Km"),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: isButtonDisabled == true
                                                ? Container(
                                                    height: 35,
                                                    width: double.maxFinite,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                30),
                                                        color: colors.primary),
                                                    child: const Center(
                                                      child: Text(
                                                        "Wait For 5 Second..",
                                                        style: TextStyle(
                                                            color:
                                                                colors.whiteTemp),
                                                      ),
                                                    ),
                                                  )
                                                : InkWell(
                                                    onTap: () async {
                                                      var min =
                                                          await getMinimumWallet();
                                                      if (double.parse(
                                                              driverAmount ?? "0") <
                                                          min) {
                                                        _showAlertDialog(
                                                            context, min);
                                                        // Fluttertoast.showToast(
                                                        //     msg:
                                                        //         "To begin accepting order, please ensure your Wallet is Topped up with a Minimum Balance of 150 and Provide an option to recharge using Our wallet recharge method.");
                                                      } else {

                                                        ctrl.schedOrderHistoryList[index]
                                                              .isAccepted = true;
                                                        ctrl. orderRejectedOrAccept(
                                                              index, context, "1",city);

                                                        if (ctrl.schedOrderHistoryList[index]
                                                                .parcelDetails
                                                                .first
                                                                .status ==
                                                            "2") {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      PercelDetails(
                                                                          pId: ctrl.schedOrderHistoryList[
                                                                                  index]
                                                                              .orderId)));
                                                        }
                                                      }
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(10),
                                                      width: MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.30,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  20),
                                                          color: isButtonDisabled
                                                              ? Colors.blue
                                                              : (ctrl.schedOrderHistoryList[index]
                                                                              .parcelDetails
                                                                              .first
                                                                              .status ==
                                                                          "2" ||
                                                              ctrl. schedOrderHistoryList[
                                                                                  index]
                                                                              .parcelDetails
                                                                              .first
                                                                              .status ==
                                                                          "3")
                                                                  ? Colors.grey
                                                                  : Colors.green),
                                                      child: Center(
                                                        child: Text(
                                                            (ctrl.schedOrderHistoryList[index]
                                                                            .parcelDetails
                                                                            .first
                                                                            .status ==
                                                                        "2" ||
                                                                ctrl.schedOrderHistoryList[
                                                                                index]
                                                                            .parcelDetails
                                                                            .first
                                                                            .status ==
                                                                        "3")
                                                                ? getTranslated(
                                                                    context,
                                                                    "View Detail") //'Accepted'
                                                                : getTranslated(
                                                                    context,
                                                                    "Accept"), //'Accept',
                                                            style: const TextStyle(
                                                                color:
                                                                    Colors.white)),
                                                      ),
                                                    ),
                                                  ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          // orderHistoryList[
                                          //                 index]
                                          //             .isAccepted ??
                                          //         false
                                          //     ? SizedBox
                                          //         .shrink()
                                          //     : Expanded(
                                          //         child:
                                          //             InkWell(
                                          //           onTap:
                                          //               () {
                                          //             orderRejectedOrAccept(
                                          //                 index,
                                          //                 context,
                                          //                 isRejected:
                                          //                     true);
                                          //           },
                                          //           child:
                                          //               Container(
                                          //             width: MediaQuery.of(context).size.width *
                                          //                 0.35,
                                          //             padding:
                                          //                 const EdgeInsets.all(10),
                                          //             decoration: BoxDecoration(
                                          //                 borderRadius:
                                          //                     BorderRadius.circular(20),
                                          //                 color: Colors.red),
                                          //             child:
                                          //                  Center(
                                          //               child:
                                          //                   Text(
                                          //                     getTranslated(context, "Reject"),
                                          //               //  'Reject',
                                          //                 style:
                                          //                     TextStyle(color: Colors.white),
                                          //               ),
                                          //             ),
                                          //           ),
                                          //         ),
                                          //       ),
                                        ],
                                      ),

                                      // Row(
                                      //   mainAxisAlignment:
                                      //   MainAxisAlignment
                                      //       .spaceBetween,
                                      //   children: [
                                      //     Expanded(
                                      //       child: isButtonDisabled == true ? Container(
                                      //         height: 35,
                                      //         width: double.maxFinite,
                                      //         decoration: BoxDecoration(
                                      //             borderRadius: BorderRadius.circular(30),
                                      //             color: colors.primary
                                      //         ),
                                      //
                                      //         child: const Center(
                                      //           child: Text(
                                      //             "Wait For 5 Second..", style: TextStyle(
                                      //               color: colors.whiteTemp
                                      //           ),),
                                      //         ),
                                      //       ) : InkWell(
                                      //         onTap:
                                      //         // orderHistoryList[index].isAccepted ?? false
                                      //         //     ? null
                                      //         //     :
                                      //             () {
                                      //           setState(() {
                                      //             orderHistoryList[index].isAccepted = true;
                                      //             orderRejectedOrAccept(index, context);
                                      //           });
                                      //         },
                                      //         child:
                                      //         Container(
                                      //           padding:
                                      //           const EdgeInsets.all(10),
                                      //           width: MediaQuery
                                      //               .of(context)
                                      //               .size
                                      //               .width *
                                      //               0.30,
                                      //           decoration: BoxDecoration(
                                      //               borderRadius:
                                      //               BorderRadius.circular(
                                      //                   20),
                                      //               color: isButtonDisabled
                                      //                   ? Colors.blue
                                      //                   : orderHistoryList[index]
                                      //                   .isAccepted ?? false
                                      //                   ? Colors.grey
                                      //                   : Colors.green),
                                      //           child: Center(
                                      //             child: Text(
                                      //                 orderHistoryList[index].isAccepted ??
                                      //                     false
                                      //                     ? getTranslated(context,
                                      //                     "View Detail") //'Accepted'
                                      //                     : getTranslated(
                                      //                     context, "Accept"), //'Accept',
                                      //                 style: const TextStyle(
                                      //                     color:
                                      //                     Colors.white)),
                                      //           ),
                                      //         ),
                                      //       ),
                                      //     ),
                                      //     const SizedBox(
                                      //       width: 20,
                                      //     ),
                                      //     // orderHistoryList[
                                      //     //                 index]
                                      //     //             .isAccepted ??
                                      //     //         false
                                      //     //     ? SizedBox
                                      //     //         .shrink()
                                      //     //     : Expanded(
                                      //     //         child:
                                      //     //             InkWell(
                                      //     //           onTap:
                                      //     //               () {
                                      //     //             orderRejectedOrAccept(
                                      //     //                 index,
                                      //     //                 context,
                                      //     //                 isRejected:
                                      //     //                     true);
                                      //     //           },
                                      //     //           child:
                                      //     //               Container(
                                      //     //             width: MediaQuery.of(context).size.width *
                                      //     //                 0.35,
                                      //     //             padding:
                                      //     //                 const EdgeInsets.all(10),
                                      //     //             decoration: BoxDecoration(
                                      //     //                 borderRadius:
                                      //     //                     BorderRadius.circular(20),
                                      //     //                 color: Colors.red),
                                      //     //             child:
                                      //     //                  Center(
                                      //     //               child:
                                      //     //                   Text(
                                      //     //                     getTranslated(context, "Reject"),
                                      //     //               //  'Reject',
                                      //     //                 style:
                                      //     //                     TextStyle(color: Colors.white),
                                      //     //               ),
                                      //     //             ),
                                      //     //           ),
                                      //     //         ),
                                      //     //       ),
                                      //   ],
                                      // )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
            ),
          ],
        );
      }
    );
  }

  // withdrawalRequest(){
  //   return  getTransactionModel == null? /*Center(child: CircularProgressIndicator()) : getTransactionModel?.data?.isEmpty ?*/  const Center(child: Text("No Withdrawal List Found!!")):Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Container(
  //       // height:  MediaQuery.of(context).size.height,
  //       child: ListView.builder(
  //           physics: const NeverScrollableScrollPhysics(),
  //           shrinkWrap: true,
  //           itemCount: getTransactionModel?.data?.length ??0,
  //           itemBuilder: (context,i){
  //             return Card(
  //               child: Padding(
  //                 padding: const EdgeInsets.fromLTRB(8, 8, 8, 32),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     const SizedBox(height: 3,),
  //                     Text("₹ ${getTransactionModel?.data?[i].amount}"),
  //                     const SizedBox(height: 3,),
  //                     Text("${getTransactionModel?.data?[i].date}"),
  //                     const SizedBox(height: 3,),
  //                     Text("${getTransactionModel?.data?[i].notes}"),
  //                     const SizedBox(height: 3,),
  //                     Text("${getTransactionModel?.data?[i].paymentStatus}"),
  //                   ],
  //                 ),
  //               ),
  //             );
  //           }),
  //     ),
  //   );
  // }
  // GetTransactionModel? getTransactionModel;
  //
  String? driverAmount;

  getDriverApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString("userId");
    var headers = {
      'Cookie': 'ci_session=84167892b4c1be830d2a6845f3443f5df00291c5'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('${Urls.baseUrl}Payment/driverAmounts'));
    request.fields.addAll({'user_id': userId.toString()});
    request.headers.addAll(headers);
    print("driverAmounts----------${request.url}");
    print("driverAmounts----------${request.fields}");

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      log("result: ${result.toString()}");
      var finalResult = jsonDecode(result);
      driverAmount = finalResult['data'];
      driverEraning = finalResult['driver_amont'];
      print('____Som______${driverAmount}_________');

      setState(() {
        print('aaaaaaaa${driverEraning}');
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  walletAmount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyWallet(),
                  ));
            },
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(getTranslated(context, "Pickport Wallet"),
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    driverAmount == null
                        ? Text(
                            "₹ 0",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "lora",
                                fontSize: 20),
                          )
                        : Text(
                            "₹ ${driverAmount}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "lora",
                                fontSize: 20),
                          )
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DriverErningHistroy(),
                  )
              );
            },
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  //  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(getTranslated(context, 'Today Earning'),
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    driverEraning == null
                        ? Text(
                            "₹ No Available Amount",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "lora",
                                fontSize: 12),
                          )
                        : Text(
                            "₹ ${driverEraning}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "lora",
                                fontSize: 20),
                          )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  getUserStatusOnlineOrOffline(String status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    try {
      Map<String, String> body = {};
      body[RequestKeys.userId] = userId ?? '';
      body[RequestKeys.status] = status.toString();
      var res = await api.userOfflineOnlineApi(body);
      if (res.status) {
      } else {
        // Fluttertoast.showToast(msg: '');
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: getTranslated(context, "Invalid Email & Password"),
      );
    } finally {}
  }

  getStatus(int status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    var headers = {
      'Cookie': 'ci_session=8380ff83d04889e6ff2ef0c0cd5e47f95872c1d4'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('${Urls.baseUrl}Payment/driver_online_offline'));
    request.fields
        .addAll({'user_id': userId.toString(), 'status': status.toString()});
    print('____Som______${request.fields}_________');
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var finalResult = jsonDecode(result);
      print('finalResult__________${finalResult}_________');
      setState(() {});
    } else {
      print(response.reasonPhrase);
    }
  }

  getCheckStatusApi() async {
    print("order is ---------3");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    var headers = {
      'Cookie': 'ci_session=2747e6c4d835602c8ddba0682c7ea48a33b6856c'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('${Urls.baseUrl}Payment/online_ofline_status'));
    request.fields.addAll({'user_id': userId.toString()});

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var finalResult = jsonDecode(result);
      print('finalResult__________${finalResult}_________');
      setState(() {
        status = int.parse(finalResult["data"].toString());
        print('____Som______${status}_________');
      });
      // Fluttertoast.showToast(msg: "${finalResult['']}");
    } else {
      print(response.reasonPhrase);
    }
  }

//Cuurrent Delivery api
  getUserOrderHistory(String status) async {
    print("order is ---------2");
    orderHistoryList.clear();
    setState(() {
      isLoading = true;
    });

    /*SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');*/
    try {
      Map<String, String> body = {};
      body[RequestKeys.lat] = _position?.latitude.toString() ?? '';
      body[RequestKeys.long] = _position?.longitude.toString() ?? '';
      body[RequestKeys.userId1] = userId.toString() ?? '';
      body[RequestKeys.status] = status.toString();
      var res = await api.getOrderHistoryData(body);
      if (res.status ?? false) {
        orderHistoryList = res.data;

        //Future.delayed(const Duration(seconds: 1), () {
        // print('One second has passed.'); // Prints after 1 second.
        isActive.clear();

        setState(() {
          isLoading = false;
        });
      } else {
        //  Fluttertoast.showToast(msg: '${res.message}');

        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: getTranslated(context, "Invalid Email & Password"),
        //   "Invalid Email & Password"
      );
    } finally {
      isLoading = false;
      setState(() {});
    }
  }



  getDriverRating(String driverId) async {
    var headers = {
      'Cookie': 'ci_session=6e2bbfaeac31fb0c3fcbcd0ae36ef35cb60a73d9'
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://pickport.in/api/Authentication/get_delivery_boy_rating'));
    request.fields.addAll({RequestKeys.deliveryBoyId: driverId});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
print("RatingAPI----${request.url}");
    print('__________${request.fields}_____________');

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var finalResult = GetDriverRating.fromJson(jsonDecode(result));
      _driverRating = finalResult;
    } else {
      print(response.reasonPhrase);
    }
    setState(() {});
  }
  final ctrl= Get.put(HomeController());
  int selectedSegmentVal = 0;

  Widget _segmentButton() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  setSegmentValue(0);
                  // getTransactionApi();
                },
                child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: selectedSegmentVal == 0
                                ? colors.primary
                                : Colors.white
                        ),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(
                      child: Text(
                        getTranslated(context, "Current Delivery"),
                        // 'Current Delivery',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: colors.primary),
                      ),
                    )
                    //
                    // MaterialButton(
                    //   shape: const StadiumBorder(),
                    //   onPressed: () => setSegmentValue(0),
                    //   child: const Text(
                    //     'Current Delivery',
                    //     style: TextStyle(
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: 13,
                    //         color: colors.primary),
                    //   ),
                    // ),
                    ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: InkWell(
                onTap: () => setSegmentValue(1),
                child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: selectedSegmentVal == 1
                                ? colors.primary
                                : Colors.white),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(
                      child: Text(
                        getTranslated(context, "Scheduled Delivery"),
                        // 'Scheduled Delivery',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: colors.primary
                        ),
                      ),
                    )
                    // MaterialButton(
                    //   shape: const StadiumBorder(),
                    //   onPressed: () => setSegmentValue(1),
                    //   child: const FittedBox(
                    //     child:
                    //     Text(
                    //       'schedule Delivery',
                    //       style: TextStyle(
                    //           fontWeight: FontWeight.bold,
                    //           fontSize: 13,
                    //           color: colors.primary),
                    //     ),
                    //   ),
                    // ),
                    ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: InkWell(
                onTap: () => setSegmentValue(2),
                child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: selectedSegmentVal == 2
                                ? colors.primary
                                : Colors.white),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        getTranslated(context, "Parcel History"),
                        // 'Parcel History',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: colors.primary),
                      ),
                    )
                    // MaterialButton(
                    //   shape: const StadiumBorder(),
                    //   onPressed: () => setSegmentValue(2),
                    //   child: const FittedBox(
                    //     child: Text(
                    //       'Parcel History',
                    //       style: TextStyle(
                    //           fontWeight: FontWeight.bold,
                    //           fontSize: 13,
                    //           color: colors.primary),
                    //     ),
                    //   ),
                    // ),
                    ),
              ),
            ),
          ],
        ),
      );

  setSegmentValue(int i) {
    isSelected = "Completed Orders";

    selectedSegmentVal = i;
    String status;
    if (i == 0) {
      // getUserOrderHistory('0');
      ctrl.getOrders(status: '0');
      // parcelHistory(2);
    } else if (i == 1) {
      print("scheduled delivery--");
      // getUserOrderHistory("1");
      ctrl.getOrders(status: '1');
      //getAcceptedOrder('2');
    } else {
      getAcceptedOrder('4');
      ctrl.getOrders(status: '4');
      // getParcelHistory();
    }
    setState(() {});
    // getOrderList(status: status);
  }

  // Widget activeOrder() {
  //   return Column(
  //     children: [
  //       isLoading2
  //           ? const Center(child: CircularProgressIndicator())
  //           : parcelDataList?.data?.isEmpty ?? true
  //               ? const Center(child: Text("Data Not Available"))
  //               : ListView.builder(
  //                   scrollDirection: Axis.vertical,
  //                   physics: const NeverScrollableScrollPhysics(),
  //                   shrinkWrap: true,
  //                   itemCount: parcelDataList?.data?.length ?? 0,
  //                   itemBuilder: (context, index) {
  //                     return InkWell(
  //                         onTap: () {},
  //                         child: Card(
  //                           shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(15.0),
  //                           ),
  //                           elevation: 2,
  //                           color: Colors.white,
  //                           child: Container(
  //                             padding: const EdgeInsets.symmetric(
  //                                 horizontal: 20, vertical: 20),
  //                             child: Column(
  //                               crossAxisAlignment: CrossAxisAlignment.start,
  //                               children: [
  //                                 Row(
  //                                   mainAxisAlignment:
  //                                       MainAxisAlignment.spaceBetween,
  //                                   crossAxisAlignment:
  //                                       CrossAxisAlignment.start,
  //                                   children: [
  //                                     Column(
  //                                       crossAxisAlignment:
  //                                           CrossAxisAlignment.start,
  //                                       children: [
  //                                         Padding(
  //                                           padding: const EdgeInsets.only(
  //                                               right: 8.0),
  //                                           child: Text(
  //                                               getTranslated(
  //                                                   context, "Customer Name"),
  //                                               //  "Customer Name",
  //                                               style: const TextStyle(
  //                                                   fontSize: 14,
  //                                                   color: colors.black54)),
  //                                         ),
  //                                         Text(
  //                                             parcelDataList
  //                                                     ?.data?[index].senderName
  //                                                     .toString() ??
  //                                                 '',
  //                                             style: const TextStyle(
  //                                                 fontSize: 16,
  //                                                 color: colors.primary)),
  //                                       ],
  //                                     ),
  //                                     Column(
  //                                       crossAxisAlignment:
  //                                           CrossAxisAlignment.end,
  //                                       children: [
  //                                         Text(
  //                                             // DateFormat(
  //                                             //     'yyyy-MM-dd')
  //                                             //     .format(parcelDataList?.data?[index].onDate.toString()),
  //                                             parcelDataList
  //                                                     ?.data?[index].onDate
  //                                                     .toString()
  //                                                     .substring(0, 10) ??
  //                                                 "_",
  //                                             style: const TextStyle(
  //                                                 fontSize: 14,
  //                                                 color: colors.black54)),
  //                                         Text(
  //                                             "₹ ${parcelDataList?.data?[index].parcelDetails!.first.materialInfo!.price ?? ''}",
  //                                             style: const TextStyle(
  //                                                 fontSize: 14,
  //                                                 color: colors.blackTemp,
  //                                                 fontFamily: 'lora')),
  //                                       ],
  //                                     ),
  //                                   ],
  //                                 ),
  //
  //                                 const SizedBox(
  //                                   height: 20,
  //                                 ),
  //                                 Row(
  //                                   children: [
  //                                     Container(
  //                                       child: Column(
  //                                         children: [
  //                                           Container(
  //                                             padding: const EdgeInsets.all(8),
  //                                             decoration: const BoxDecoration(
  //                                                 shape: BoxShape.circle,
  //                                                 color: Colors.red),
  //                                             child: const Icon(
  //                                               Icons.pin_drop,
  //                                               size: 14,
  //                                               color: Colors.white,
  //                                             ),
  //                                           ),
  //                                           Container(
  //                                             height: 40,
  //                                             width: 1,
  //                                             color: Colors.black,
  //                                           ),
  //                                           Container(
  //                                             padding: const EdgeInsets.all(8),
  //                                             decoration: const BoxDecoration(
  //                                                 shape: BoxShape.circle,
  //                                                 color: Colors.grey),
  //                                             child: const Icon(
  //                                               Icons.pin_drop,
  //                                               size: 14,
  //                                               color: Colors.yellow,
  //                                             ),
  //                                           )
  //                                         ],
  //                                       ),
  //                                     ),
  //                                     const SizedBox(
  //                                       width: 10,
  //                                     ),
  //                                     Container(
  //                                       child: Column(
  //                                         mainAxisAlignment:
  //                                             MainAxisAlignment.spaceBetween,
  //                                         children: [
  //                                           Container(
  //                                             child: Column(
  //                                               crossAxisAlignment:
  //                                                   CrossAxisAlignment.start,
  //                                               children: [
  //                                                 Text(
  //                                                   getTranslated(context,
  //                                                       "Pick up Point"),
  //                                                   // "Pick up Point",
  //                                                   style: const TextStyle(
  //                                                       color: colors.primary,
  //                                                       fontSize: 12),
  //                                                 ),
  //                                                 Container(
  //                                                   width:
  //                                                       MediaQuery.of(context)
  //                                                               .size
  //                                                               .width *
  //                                                           0.65,
  //                                                   child: Text(
  //                                                     parcelDataList
  //                                                             ?.data?[index]
  //                                                             .senderAddress
  //                                                             .toString() ??
  //                                                         "",
  //                                                     style: const TextStyle(
  //                                                         color: Colors.black,
  //                                                         fontSize: 12),
  //                                                   ),
  //                                                 ),
  //                                               ],
  //                                             ),
  //                                           ),
  //                                           const SizedBox(
  //                                             height: 20,
  //                                           ),
  //                                           Container(
  //                                             child: Column(
  //                                               crossAxisAlignment:
  //                                                   CrossAxisAlignment.start,
  //                                               children: [
  //                                                 Text(
  //                                                   getTranslated(
  //                                                       context, "Drop Point"),
  //                                                   //  "Drop Point",
  //                                                   style: const TextStyle(
  //                                                       color: colors.primary,
  //                                                       fontSize: 12),
  //                                                 ),
  //                                                 Container(
  //                                                   width:
  //                                                       MediaQuery.of(context)
  //                                                               .size
  //                                                               .width *
  //                                                           0.65,
  //                                                   child: Text(
  //                                                     parcelDataList
  //                                                             ?.data?[index]
  //                                                             .parcelDetails
  //                                                             ?.first
  //                                                             .receiverAddress
  //                                                             .toString() ??
  //                                                         "",
  //                                                     style: const TextStyle(
  //                                                         color: Colors.black,
  //                                                         fontSize: 12),
  //                                                   ),
  //                                                 ),
  //                                               ],
  //                                             ),
  //                                           )
  //                                         ],
  //                                       ),
  //                                     )
  //                                   ],
  //                                 ),
  //                                 const SizedBox(
  //                                   height: 20,
  //                                 ),
  //
  //                                 Row(
  //                                   mainAxisAlignment:
  //                                       MainAxisAlignment.spaceBetween,
  //                                   children: [
  //                                     Expanded(
  //                                       child:
  //                                           // isButtonDisabled? Container(
  //                                           //   height: 35,
  //                                           //   width: double.maxFinite,
  //                                           //   decoration: BoxDecoration(
  //                                           //       borderRadius: BorderRadius.circular(30),
  //                                           //       color: colors.primary
  //                                           //   ),
  //                                           //
  //                                           //   child: Center(
  //                                           //     child: Text("Wait For 5 Second..",style: TextStyle(
  //                                           //         color: colors.whiteTemp
  //                                           //     ),),
  //                                           //   ),
  //                                           // ):
  //
  //                                           InkWell(
  //                                         // onTap: orderHistoryList[index].isAccepted ?? false
  //                                         //     ? null
  //                                         //     : () {
  //                                         //   getUserOrderHistory();
  //                                         //   setState(() {
  //                                         //           orderHistoryList[index].isAccepted = true;
  //                                         //           orderRejectedOrAccept(index, context);
  //                                         //         });
  //                                         //       },
  //                                         onTap: (parcelDataList
  //                                                         ?.data?[index]
  //                                                         .parcelDetails
  //                                                         ?.first
  //                                                         .status
  //                                                         .toString() ==
  //                                                     "2" ||
  //                                                 parcelDataList
  //                                                         ?.data?[index]
  //                                                         .parcelDetails
  //                                                         ?.first
  //                                                         .status
  //                                                         .toString() ==
  //                                                     "3")
  //                                             ? () {
  //                                                 Navigator.push(
  //                                                     context,
  //                                                     MaterialPageRoute(
  //                                                         builder: (context) =>
  //                                                             PercelDetails(
  //                                                                 pId: orderHistoryList[
  //                                                                         index]
  //                                                                     .orderId)));
  //                                               }
  //                                             : () {
  //                                                 setState(() {
  //                                                   // getUserOrderHistory("");
  //                                                   orderRejectedOrAccept(
  //                                                       index, context, "0");
  //                                                 });
  //                                               },
  //                                         child: Container(
  //                                           padding: const EdgeInsets.all(10),
  //                                           width: MediaQuery.of(context)
  //                                                   .size
  //                                                   .width *
  //                                               0.30,
  //                                           // decoration: BoxDecoration(
  //                                           //     borderRadius:
  //                                           //     BorderRadius.circular(
  //                                           //         20),
  //                                           //     color:
  //                                           //     // isButtonDisabled ? Colors.blue :
  //                                           //     // orderHistoryList[index].isAccepted ?? false
  //                                           //     parcelDataList?.data?[index].parcelDetails?.first.status.toString() == "2"
  //                                           //         ? Colors.grey
  //                                           //         : Colors.green),
  //                                           child: Center(
  //                                             child: Text(
  //                                                 // orderHistoryList[index].isAccepted??false
  //                                                 parcelDataList
  //                                                             ?.data?[index]
  //                                                             .parcelDetails
  //                                                             ?.first
  //                                                             .status
  //                                                             .toString() ==
  //                                                         "4"
  //                                                     ? "Accepted"
  //                                                     : (parcelDataList
  //                                                                     ?.data?[
  //                                                                         index]
  //                                                                     .parcelDetails
  //                                                                     ?.first
  //                                                                     .status
  //                                                                     .toString() ==
  //                                                                 "2" ||
  //                                                             parcelDataList
  //                                                                     ?.data?[
  //                                                                         index]
  //                                                                     .parcelDetails
  //                                                                     ?.first
  //                                                                     .status
  //                                                                     .toString() ==
  //                                                                 "3")
  //                                                         ? getTranslated(
  //                                                             context,
  //                                                             "View Detail") //'Accepted'
  //                                                         : getTranslated(
  //                                                             context,
  //                                                             "Accept"), //'Accept',
  //                                                 style: const TextStyle(
  //                                                     color: Colors.white)),
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                     const SizedBox(
  //                                       width: 20,
  //                                     ),
  //                                     // orderHistoryList[
  //                                     //                 index]
  //                                     //             .isAccepted ??
  //                                     //         false
  //                                     //     ? SizedBox
  //                                     //         .shrink()
  //                                     //     : Expanded(
  //                                     //         child:
  //                                     //             InkWell(
  //                                     //           onTap:
  //                                     //               () {
  //                                     //             orderRejectedOrAccept(
  //                                     //                 index,
  //                                     //                 context,
  //                                     //                 isRejected:
  //                                     //                     true);
  //                                     //           },
  //                                     //           child:
  //                                     //               Container(
  //                                     //             width: MediaQuery.of(context).size.width *
  //                                     //                 0.35,
  //                                     //             padding:
  //                                     //                 const EdgeInsets.all(10),
  //                                     //             decoration: BoxDecoration(
  //                                     //                 borderRadius:
  //                                     //                     BorderRadius.circular(20),
  //                                     //                 color: Colors.red),
  //                                     //             child:
  //                                     //                  Center(
  //                                     //               child:
  //                                     //                   Text(
  //                                     //                     getTranslated(context, "Reject"),
  //                                     //               //  'Reject',
  //                                     //                 style:
  //                                     //                     TextStyle(color: Colors.white),
  //                                     //               ),
  //                                     //             ),
  //                                     //           ),
  //                                     //         ),
  //                                     //       ),
  //                                   ],
  //                                 )
  //                               ],
  //                             ),
  //                           ),
  //                         )
  //                         // Card(
  //                         //   shape: RoundedRectangleBorder(
  //                         //     borderRadius: BorderRadius.circular(15.0),
  //                         //   ),
  //                         //   elevation: 2,
  //                         //   color: Colors.white,
  //                         //   child: SizedBox(
  //                         //     width: MediaQuery.of(context).size.width / 1.1,
  //                         //     child: Padding(
  //                         //       padding: const EdgeInsets.all(8.0),
  //                         //       child: Column(
  //                         //         children: [
  //                         //           Row(
  //                         //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         //             children: [
  //                         //               Column(
  //                         //                 children: [
  //                         //                   Column(
  //                         //                     crossAxisAlignment:
  //                         //                     CrossAxisAlignment.start,
  //                         //                     children: [
  //                         //                       Text(
  //                         //                           getTranslated(context, "Order Id"),
  //                         //                           //"Order Id",
  //                         //                           style: const TextStyle(
  //                         //                               fontSize: 14,
  //                         //                               color:
  //                         //                               CustomColors.primary2,
  //                         //                               fontWeight:
  //                         //                               FontWeight.bold)),
  //                         //                       SizedBox(
  //                         //                         width: 100,
  //                         //                         child: Text(
  //                         //                           parcelDataList
  //                         //                               ?.data?[index].orderId ??
  //                         //                               '-',
  //                         //                           style: const TextStyle(
  //                         //                               fontWeight: FontWeight.bold),
  //                         //                         ),
  //                         //                       ),
  //                         //                     ],
  //                         //                   ),
  //                         //                   const SizedBox(height: 5,),
  //                         //                   Column(
  //                         //                     crossAxisAlignment:
  //                         //                     CrossAxisAlignment.start,
  //                         //                     children: [
  //                         //                       Text(
  //                         //                           getTranslated(context, "Sender Name"),
  //                         //                           // "Sender Name",
  //                         //                           style: TextStyle(
  //                         //                               fontSize: 13,
  //                         //                               color: Color(0xFFBF2331))),
  //                         //                       SizedBox(
  //                         //                         width: 100,
  //                         //                         child: Text(parcelDataList
  //                         //                             ?.data?[index].senderName ??
  //                         //                             '-'),
  //                         //                       ),
  //                         //                     ],
  //                         //                   ),
  //                         //                   Column(
  //                         //                     crossAxisAlignment:
  //                         //                     CrossAxisAlignment.start,
  //                         //                     children: [
  //                         //                       Text(
  //                         //                         getTranslated(context, "Sender Address"),
  //                         //                         // "Sender Address",
  //                         //                         style: TextStyle(
  //                         //                             fontSize: 13,
  //                         //                             color: Color(0xFFBF2331)),
  //                         //                       ),
  //                         //                       SizedBox(
  //                         //                         width: 100,
  //                         //                         child: Text(
  //                         //                             parcelDataList?.data?[index]
  //                         //                                 .senderAddress ??
  //                         //                                 '-',
  //                         //                             overflow: TextOverflow.clip),
  //                         //                       ),
  //                         //                     ],
  //                         //                   ),
  //                         //                   Column(
  //                         //                     crossAxisAlignment:
  //                         //                     CrossAxisAlignment.start,
  //                         //                     children: [
  //                         //                       Text(
  //                         //                         getTranslated(context, "Date"),
  //                         //                         //  "Date",
  //                         //                         style: TextStyle(
  //                         //                             fontSize: 13,
  //                         //                             color: Color(0xFFBF2331)),
  //                         //                       ),
  //                         //                       SizedBox(
  //                         //                         width: 100,
  //                         //                         child: Text(parcelDataList
  //                         //                             ?.data?[index].onDate
  //                         //                             .toString()
  //                         //                             .substring(0, 10) ??
  //                         //                             '-'),
  //                         //                       ),
  //                         //                     ],
  //                         //                   ),
  //                         //                 ],
  //                         //               ),
  //                         //               Column(
  //                         //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                         //                 children: [
  //                         //                   Column(
  //                         //                     crossAxisAlignment:
  //                         //                     CrossAxisAlignment.start,
  //                         //                     children: [
  //                         //                       Row(
  //                         //                         children: [
  //                         //                           Text(
  //                         //                               getTranslated(context, "Phone"),
  //                         //                               //  "Phone",
  //                         //                               style: const TextStyle(
  //                         //                                   fontSize: 13,
  //                         //                                   color: CustomColors
  //                         //                                       .primary2)),
  //                         //                           const SizedBox(
  //                         //                             width: 12,
  //                         //                           ),
  //                         //                           InkWell(
  //                         //                               onTap: () async {
  //                         //                                 var url =
  //                         //                                     "tel:${parcelDataList?.data?[index].phoneNo}";
  //                         //                                 if (await canLaunch(
  //                         //                                     url)) {
  //                         //                                   await launch(url);
  //                         //                                 } else {
  //                         //                                   throw 'Could not launch $url';
  //                         //                                 }
  //                         //                               },
  //                         //                               child: const Icon(
  //                         //                                 Icons.local_phone,
  //                         //                                 size: 20,
  //                         //                                 color:
  //                         //                                 CustomColors.primary2,
  //                         //                               )),
  //                         //                           const SizedBox(
  //                         //                             width: 12,
  //                         //                           ),
  //                         //                           InkWell(
  //                         //                               onTap: () {
  //                         //                                 whatsAppLaunch(
  //                         //                                     parcelDataList
  //                         //                                         ?.data?[index]
  //                         //                                         .phoneNo ??
  //                         //                                         '');
  //                         //                               },
  //                         //                               child: Image.asset(
  //                         //                                 'assets/whatsapplogo.webp',
  //                         //                                 scale: 45,
  //                         //                               ))
  //                         //                         ],
  //                         //                       ),
  //                         //                       SizedBox(
  //                         //                         width: 100,
  //                         //                         child: Text(parcelDataList
  //                         //                             ?.data?[index].phoneNo ??
  //                         //                             '-'),
  //                         //                       ),
  //                         //                     ],
  //                         //                   ),
  //                         //                   Column(
  //                         //                     crossAxisAlignment:
  //                         //                     CrossAxisAlignment.start,
  //                         //                     children: [
  //                         //                       Row(
  //                         //                         children: [
  //                         //                           Text(
  //                         //                               getTranslated(context, "Receiver Name"),
  //                         //                               // "Receiver Name",
  //                         //                               style: TextStyle(
  //                         //                                   fontSize: 13,
  //                         //                                   color: Color(0xFFBF2331))),
  //                         //                         ],
  //                         //                       ),
  //                         //                       Row(
  //                         //                         children: [
  //                         //                           SizedBox(
  //                         //                             width: 100,
  //                         //                             child: Text(parcelDataList
  //                         //                                 ?.data?[index].senderName ??
  //                         //                                 '-'),
  //                         //                           ),
  //                         //                         ],
  //                         //                       ),
  //                         //                     ],
  //                         //                   ),
  //                         //                   Column(
  //                         //                     crossAxisAlignment:
  //                         //                     CrossAxisAlignment.start,
  //                         //                     children: [
  //                         //                       Text(
  //                         //                         getTranslated(context, "Receiver Address"),
  //                         //                         // "Receiver Address",
  //                         //                         style: TextStyle(
  //                         //                             fontSize: 13,
  //                         //                             color: Color(0xFFBF2331)),
  //                         //                       ),
  //                         //                       SizedBox(
  //                         //                         width: 100,
  //                         //                         child: Text(
  //                         //                             parcelDataList?.data?[index]
  //                         //                                 .senderAddress ??
  //                         //                                 '-',
  //                         //                             overflow: TextOverflow.fade,
  //                         //                             maxLines: 3),
  //                         //                       ),
  //                         //                     ],
  //                         //                   ),
  //                         //                   Column(
  //                         //                     crossAxisAlignment:
  //                         //                     CrossAxisAlignment.start,
  //                         //                     children: [
  //                         //                       Text(
  //                         //                         getTranslated(context, "Amount"),
  //                         //                         //  "Amount",
  //                         //                         style: TextStyle(
  //                         //                             fontSize: 13,
  //                         //                             color: Color(0xFFBF2331)),
  //                         //                       ),
  //                         //                       SizedBox(
  //                         //                         width: 100,
  //                         //                         child: Text("₹ ${orderHistoryList[index].parcelDetails.first.materialInfo?.price ?? ''}",style: TextStyle(
  //                         //                             fontFamily: "lora"
  //                         //                         ),),
  //                         //                       ),
  //                         //                     ],
  //                         //                   ),
  //                         //                 ],
  //                         //               )
  //                         //
  //                         //             ],
  //                         //           ),
  //                         //           const SizedBox(
  //                         //             height: 10,
  //                         //           ),
  //                         //           Row(
  //                         //             mainAxisAlignment:
  //                         //             MainAxisAlignment.spaceBetween,
  //                         //             children: [
  //                         //               Expanded(
  //                         //                 child: InkWell(
  //                         //                   onTap: orderHistoryList[index]
  //                         //                       .isAccepted ??
  //                         //                       false
  //                         //                       ? null
  //                         //                       : () {
  //                         //                     setState(() {
  //                         //                       orderHistoryList[index]
  //                         //                           .isAccepted = true;
  //                         //                       orderRejectedOrAccept(
  //                         //                           index, context);
  //                         //                     });
  //                         //                   },
  //                         //                   child: Container(
  //                         //                     padding: const EdgeInsets.all(10),
  //                         //                     width: MediaQuery.of(context)
  //                         //                         .size
  //                         //                         .width *
  //                         //                         0.35,
  //                         //                     decoration: BoxDecoration(
  //                         //                         borderRadius:
  //                         //                         BorderRadius.circular(20),
  //                         //                         color: orderHistoryList[index]
  //                         //                             .isAccepted ??
  //                         //                             false
  //                         //                             ? Colors.grey
  //                         //                             : Colors.green),
  //                         //                     child: Center(
  //                         //                       child: Text(
  //                         //                           orderHistoryList[index]
  //                         //                               .isAccepted ??
  //                         //                               false
  //                         //                               ? getTranslated(context, "Accepted")//'Accepted'
  //                         //                               : getTranslated(context, "Accept"),//'Accept',
  //                         //                           style: const TextStyle(
  //                         //                               color: Colors.white)),
  //                         //                     ),
  //                         //                   ),
  //                         //                 ),
  //                         //               ),
  //                         //               const SizedBox(
  //                         //                 width: 20,
  //                         //               ),
  //                         //               orderHistoryList[index].isAccepted ??
  //                         //                   false
  //                         //                   ? SizedBox.shrink()
  //                         //                   : Expanded(
  //                         //                 child: InkWell(
  //                         //                   onTap: () {
  //                         //                     orderRejectedOrAccept(
  //                         //                         index, context,
  //                         //                         isRejected: true);
  //                         //                   },
  //                         //                   child: Container(
  //                         //                     width: MediaQuery.of(context)
  //                         //                         .size
  //                         //                         .width *
  //                         //                         0.35,
  //                         //                     padding:
  //                         //                     const EdgeInsets.all(10),
  //                         //                     decoration: BoxDecoration(
  //                         //                         borderRadius:
  //                         //                         BorderRadius.circular(
  //                         //                             20),
  //                         //                         color: Colors.red),
  //                         //                     child: Center(
  //                         //                       child: Text(
  //                         //                         getTranslated(context, "Reject"),
  //                         //                         // 'Reject',
  //                         //                         style: TextStyle(
  //                         //                             color: Colors.white),
  //                         //                       ),
  //                         //                     ),
  //                         //                   ),
  //                         //                 ),
  //                         //               ),
  //                         //             ],
  //                         //           ),
  //                         //           const SizedBox(
  //                         //             height: 10,
  //                         //           ),
  //                         //           orderHistoryList[index].isAccepted ?? false
  //                         //               ? InkWell(
  //                         //                   onTap: () {
  //                         //                     Navigator.push(
  //                         //                         context,
  //                         //                         //  MaterialPageRoute(builder: (context) => ParcelDetailsView(parcelFullDetail: parcelDataList!.data![index].parcelDetails)))
  //                         //                         MaterialPageRoute(
  //                         //                             builder: (context) =>
  //                         //                                 PercelDetails(
  //                         //                                     pId: parcelDataList
  //                         //                                             ?.data?[
  //                         //                                                 index]
  //                         //                                             .orderId ??
  //                         //                                         ""))).then(
  //                         //                         (value) =>
  //                         //                             getAcceptedOrder('2'));
  //                         //                   },
  //                         //                   child:  Align(
  //                         //                       alignment: Alignment.bottomCenter,
  //                         //                       child: Text(
  //                         //                         getTranslated(context, "See full details"),
  //                         //                      //   'See full details',
  //                         //                         style: TextStyle(
  //                         //                             decoration: TextDecoration
  //                         //                                 .underline,
  //                         //                             color: Colors.red),
  //                         //                       )),
  //                         //                 )
  //                         //               : const SizedBox.shrink()
  //                         //
  //                         //           /* Row(
  //                         //               children: [
  //                         //                 Column(
  //                         //                   crossAxisAlignment:
  //                         //                       CrossAxisAlignment.start,
  //                         //                   children: [
  //                         //                     const Text(
  //                         //                       "Payment Method",
  //                         //                       style: TextStyle(
  //                         //                           fontSize: 13,
  //                         //                           color: Color(0xFFBF2331)),
  //                         //                     ),
  //                         //                     Text(parcelDataList[index]
  //                         //                         .paymentMethod
  //                         //                         .toString()),
  //                         //                   ],
  //                         //                 ),
  //                         //               ],
  //                         //             ),
  //                         //             SizedBox(
  //                         //               height: 10,
  //                         //             ),*/
  //                         //         ],
  //                         //       ),
  //                         //     ),
  //                         //   ),
  //                         // ),
  //                         );
  //                   }),
  //     ],
  //   );
  // }

  String isSelected = "Completed Orders";

  Widget completeOrder() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FilterChip(
              label:  Text(getTranslated(context, 'Completed Orders')),
              selected: isSelected == "Completed Orders",
              selectedColor: Colors.green,
              onSelected: (bool value) {
                setState(() {
                  isSelected = "Completed Orders";
                  getAcceptedOrder("4");
                });
              },
            ),
            FilterChip(
              label: Text(getTranslated(context, 'Cancelled Orders')),
              selected: isSelected == "Cancelled Orders",
              selectedColor: Colors.red,
              onSelected: (bool value) {
                setState(() {
                  isSelected = "Cancelled Orders";
                  getAcceptedOrder("7");
                });
              },
            )
          ],
        ),
        isLoading2
            ? const Center(child: CircularProgressIndicator())
            : parcelDataList?.data?.isEmpty ?? false
                ? Center(
                    child: Text(
                    getTranslated(context, "Data not available"),
                    //  'Data Not Available'
                  ))
                : ListView.builder(
                    reverse: true,
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: parcelDataList?.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      print(
                          '___________${pastParcelDataList.length}__________');

                      return InkWell(
                        onTap: () {
                          if (parcelDataList
                                  ?.data?[index].parcelDetails?.first.status ==
                              "4") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PercelDetails(
                                          pId: parcelDataList
                                              ?.data?[index].orderId,
                                          isCheck: true,
                                        )));
                          } else {}
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 2,
                          color: Colors.white,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 1.1,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(right: 8.0),
                                            child: Text("Parcel ID",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: colors.blackTemp,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Text(
                                              "#${parcelDataList?.data?[index].orderId ?? '-'}"),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          parcelDataList
                                                      ?.data?[index]
                                                      .parcelDetails
                                                      ?.first
                                                      .status ==
                                                  "4"
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 20),
                                                  child: Text(
                                                      getTranslated(
                                                          context, "Delivered"),
                                                      //"Delivered",
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.green,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                )
                                              : Text(
                                                  getTranslated(
                                                      context, "Cancelled"),
                                                  //"Cancel",
                                                  style: const TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold))
                                        ],
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            getTranslated(
                                                context, "Receiver's Name :"),
                                            //"Receiver's Name :",
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: colors.blackTemp,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(parcelDataList
                                                  ?.data?[index]
                                                  .parcelDetails
                                                  ?.first
                                                  .receiverName ??
                                              '-'),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            getTranslated(
                                                context, "Order Date :"),
                                            // "Order Date :",
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: colors.blackTemp,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                              "${parcelDataList?.data?[index].parcelDetails?.first.onDate ?? ""}"),
                                          //  Text(parcelDataList?.data?[index].onDate.toString()),
                                        ],
                                      ),
                                    ],
                                  ),
                                  parcelDataList?.data?[index].parcelDetails
                                              ?.first.status ==
                                          "4"
                                      ? Container()
                                      : parcelDataList
                                                  ?.data?[index]
                                                  .parcelDetails
                                                  ?.first
                                                  .message ==
                                              ""
                                          ? Container()
                                          : Text(
                                              "Reason: ${parcelDataList?.data?[index].parcelDetails?.first.message ?? ""}"),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  /*InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) =>  ParcelDetailsView(parcelFullDetail: parcelDataList!.data![index].parcelDetails)));
                                },
                                child: const Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Text('See full details', style: TextStyle(decoration: TextDecoration.underline, color: Colors.red),)),
                              )*/

                                  /* Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Payment Method",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Color(0xFFBF2331)),
                                              ),
                                              Text(parcelDataList[index]
                                                  .paymentMethod
                                                  .toString()),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),*/
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
      ],
    );
  }

  void whatsAppLaunch(String num) async {
    var whatsapp = "${num}";
    // var whatsapp = "+919644595859";
    var whatsappURl_android = "whatsapp://send?phone=" +
        whatsapp +
        "&text=Hello, I am messaging from Courier Delivery App, I am interested to pick your parcel, Can we have chat? ";
    var whatappURL_ios = "https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatappURL_ios)) {
        await launch(whatappURL_ios, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Whatsapp does not exist in this device")));
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURl_android)) {
        await launch(whatsappURl_android);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Whatsapp does not exist in this device")));
      }
    }
  }

  getAcceptedOrder(
    String status,
  ) async {
    isLoading2 = true;
    setState(() {});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString("userId");

    var headers = {
      'Cookie': 'ci_session=fa3033d7e1f26d8d6379dca4f207a9d5d5606476'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('${Urls.baseUrl}Payment/get_order_request'));
    request.fields.addAll({
      'user_id': userId ?? '328',
      'status': status,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print('_____fffff___ddddddddddd___ggggggggg${request.fields}__________');
      print(
          '_____fffff___ddddddddddd___ggggggggg${Urls.baseUrl}Payment/get_order_request');
      final result = await response.stream.bytesToString();
      print('___________${result}__________');
      var finalResult = Acceptorder.fromJson(jsonDecode(result));
      isLoading2 = false;
      log("thisi is ============>${finalResult.toJson().toString()}");
      setState(() {
        parcelDataList = finalResult;
      });
    } else {
      isLoading2 = false;
      print(response.reasonPhrase);
    }
  }

/*  void getParcelHistory() async {
    Api api =Api();
    isLoading3 = true;
    setState(() {

    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    try {
      Map<String, String> body = {};
      body[RequestKeys.userId] = userId ?? '';
      var res = await api.getParcelHistoryData(body);
      if (res.status == 1) {
        print('_____success____');
        // responseData = res.data?.userid.toString();
        pastParcelDataList = res.data ?? [];
        setState(() {});
      } else {
        Fluttertoast.showToast(msg: '${res.status}');
        setState(() {
          isLoading3 = false;
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong");
    } finally {
      isLoading3 = false;
    }
  }*/
}
