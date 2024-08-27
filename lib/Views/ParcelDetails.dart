import 'dart:convert';
import 'dart:developer';
import 'package:dotted_line/dotted_line.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:jdx/Controller/home_controller.dart';
import 'package:jdx/Models/driverFeedbackModel.dart';
import 'package:jdx/Utils/ApiPath.dart';
import 'package:jdx/services/location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Models/GetProfileModel.dart';
import '../Models/booking_single_details_,model.dart';
import '../Utils/Color.dart';

import 'package:http/http.dart' as http;

import '../services/session.dart';
import 'ConfirmScreen.dart';

class PercelDetails extends StatefulWidget {
  GetProfileModel? getProfileModel;

  PercelDetails({this.getProfileModel, this.pId, this.isCheck});
  String? pId;
  bool? isCheck;

  @override
  State<PercelDetails> createState() => _PercelDetailsState();
}

class _PercelDetailsState extends State<PercelDetails> {
  final _formKey = GlobalKey<FormState>();
  Position? _position;

  bool enablePickup = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOtpApi();
    inIt();
    bookingOrderDetailsApi();
  }

  String city = "";
  inIt() async {
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
    print("${_position!.longitude}______________");
  }

  void _launchPhoneDialer(String? phoneNumber) async {
    await launchUrl(Uri.parse("tel:$phoneNumber"),
        mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        Future.delayed(const Duration(seconds: 2));
        bookingOrderDetailsApi();
      },
      child: Scaffold(
        backgroundColor: colors.primary,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            getTranslated(context, "Parcel Details"),
            // 'Parcel Details',
            style: const TextStyle(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: Container(
            margin: const EdgeInsets.all(8),
            height: 35,
            width: 35,
            decoration:
                const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
          ),
        ),
        body: singleBookingModel == null
            ? const Center(
                child: CircularProgressIndicator(
                color: Colors.white,
              ))
            : Container(
                child: Stack(
                  children: [
                    Container(
                      // padding: EdgeInsets.symmetric(horizontal: 20),
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(color: colors.primary),
                      // child: Padding(
                      //   padding: const EdgeInsets.only(left: 10),
                      //   child: Row(
                      //     children: [
                      //       Container(
                      //         height: 35,
                      //         width: 35,
                      //         decoration: const BoxDecoration(
                      //             shape: BoxShape.circle,
                      //             color: Colors.white),
                      //         child: InkWell(
                      //           onTap: () {
                      //             Navigator.pop(context);
                      //           },
                      //           child: const Icon(
                      //             Icons.arrow_back,
                      //             color: Colors.black,
                      //           ),
                      //         ),
                      //       ),
                      //
                      //       Expanded(
                      //         child: Container(
                      //           child: Center(
                      //             child: Padding(
                      //               padding: const EdgeInsets.only(right: 20),
                      //               child: Text(
                      //                 getTranslated(context, "Parcel Details"),
                      //                 // 'Parcel Details',
                      //                 style: const TextStyle(
                      //                     fontSize: 18,
                      //                     color: Colors.white,
                      //                     fontWeight: FontWeight.bold),
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // )
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.13,
                      child: Container(
                          height: MediaQuery.of(context).size.height * 0.88,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          width: MediaQuery.of(context).size.width,
                          // height: MediaQuery.of(context).size.height * 0.85,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: SingleChildScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            getTranslated(context, "Parcel Id"),
                                            //   "Parcel Id"
                                            style: const TextStyle(
                                                color: colors.blackTemp,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                              "#${singleBookingModel?.data?.first.orderId}"),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            getTranslated(context, "Parcel Date"),
                                            // "Parcel Date",
                                            style: const TextStyle(
                                                color: colors.blackTemp,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(singleBookingModel
                                                  ?.data?.first.bookingDate
                                                  .toString() ??
                                              ""),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            getTranslated(context, "Parcel Time"),
                                            // "Parcel Time",
                                            style: const TextStyle(
                                                color: colors.blackTemp,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(singleBookingModel
                                                  ?.data?.first.bookingTime
                                                  .toString() ??
                                              ""),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                    elevation: 2,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: colors.whiteTemp,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              //color: Colors.red,
                                              child: Row(
                                                // mainAxisAlignment:
                                                //     MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        constraints: BoxConstraints(
                                                            maxWidth:
                                                                190), // Adjust the maxWidth as needed
                                                        child: Row(
                                                          children: [
                                                            Flexible(
                                                              child: Text(
                                                                getTranslated(
                                                                    context,
                                                                    "Sender Name"),
                                                                style: const TextStyle(
                                                                    color: colors
                                                                        .blackTemp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      Row(
                                                        children: [
                                                          const Icon(
                                                            Icons.person,
                                                            size: 20,
                                                          ),
                                                          Text(
                                                              "${singleBookingModel?.data?.first.senderName}"),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      _launchPhoneDialer(
                                                          "${singleBookingModel?.data?.first.phoneNo}");
                                                    },
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                            // constraints:
                                                            // BoxConstraints(
                                                            //     maxWidth: 200),
                                                            child: Container(
                                                          constraints: BoxConstraints(
                                                              maxWidth:
                                                                  100), // Adjust the maxWidth as needed
                                                          child: Row(
                                                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Flexible(
                                                                child: Text(
                                                                  getTranslated(
                                                                      context,
                                                                      "Sender Mobile No."),
                                                                  style: const TextStyle(
                                                                      color: colors
                                                                          .blackTemp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  maxLines: 1,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )

                                                            // Text(
                                                            //       getTranslated(context,
                                                            //           "Sender Mobile No."),
                                                            //       overflow: TextOverflow.ellipsis,
                                                            //       maxLines: 1,
                                                            //       // "Sender Mobile No.",
                                                            //       style: const TextStyle(
                                                            //           color:
                                                            //               colors.blackTemp,
                                                            //           fontWeight:
                                                            //               FontWeight.bold),
                                                            //     ),
                                                            ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          children: [
                                                            InkWell(
                                                                onTap: () {
                                                                  _launchPhoneDialer(
                                                                      "${singleBookingModel?.data?.first.phoneNo}");
                                                                },
                                                                child: const Icon(
                                                                  Icons.call,
                                                                  color: Colors
                                                                      .green,
                                                                )),
                                                            Text(
                                                                "${singleBookingModel?.data?.first.phoneNo}"),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              getTranslated(
                                                  context, "Sender Address"),
                                              //  "Sender Address",
                                              style: const TextStyle(
                                                  color: colors.blackTemp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                Image.asset(
                                                    "assets/images/gstlo-removebg-preview.png"),
                                                Container(
                                                    width: 250,
                                                    child: Text(
                                                      "${singleBookingModel?.data?.first.senderFulladdress}",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 3,
                                                    )),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            singleBookingModel
                                                        ?.data?.first.status ==
                                                    "4"
                                                ? const SizedBox.shrink()
                                                : singleBookingModel?.data?.first
                                                            .status ==
                                                        "3"
                                                    ? const SizedBox.shrink()
                                                    : Row(
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              enablePickup = true;
                                                              setState(() {});

                                                              print("Status ${singleBookingModel?.data?.first.status}");
                                                              if(singleBookingModel?.data?.first.status == "2"){
                                                                String lat =
                                                                    "${singleBookingModel?.data?.first.senderLatitude}" ??
                                                                        ''; //'22.7177'; //
                                                                String lon =
                                                                    "${singleBookingModel?.data?.first.senderLongitude}" ??
                                                                        ''; //'75.8545'; //
                                                                String CURENT_LAT =
                                                                    _position
                                                                        ?.latitude
                                                                        .toString() ??
                                                                        '';
                                                                String CURENT_LONG =
                                                                    _position
                                                                        ?.longitude
                                                                        .toString() ??
                                                                        '';

                                                                final Uri url = Uri.parse('https://www.google.com/maps/dir/?api=1&origin=' +
                                                                    CURENT_LAT +
                                                                    ',' +
                                                                    CURENT_LONG +
                                                                    ' &destination=' +
                                                                    lat.toString() +
                                                                    ',' +
                                                                    lon.toString() +
                                                                    '&travelmode=driving&dir_action=navigate');

                                                                _launchURL(
                                                                  url,
                                                                );
                                                              }else{

                                                                String lat =
                                                                    "${singleBookingModel?.data?.first.receiverLatitude}" ??
                                                                        ''; //'22.7177'; //
                                                                String lon =
                                                                    "${singleBookingModel?.data?.first.receiverLongitude}" ??
                                                                        ''; //'75.8545'; //
                                                                String CURENT_LAT =
                                                                    _position
                                                                        ?.latitude
                                                                        .toString() ??
                                                                        '';
                                                                String CURENT_LONG =
                                                                    _position
                                                                        ?.longitude
                                                                        .toString() ??
                                                                        '';

                                                                final Uri url = Uri.parse('https://www.google.com/maps/dir/?api=1&origin=' +
                                                                    CURENT_LAT +
                                                                    ',' +
                                                                    CURENT_LONG +
                                                                    ' &destination=' +
                                                                    lat.toString() +
                                                                    ',' +
                                                                    lon.toString() +
                                                                    '&travelmode=driving&dir_action=navigate');

                                                                _launchURL(
                                                                  url,
                                                                );

                                                              }


                                                            },
                                                            child: Container(
                                                              width: 300,
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 5,
                                                                      right: 10,
                                                                      top: 5,
                                                                      bottom: 5),
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                  color: colors
                                                                      .primary),
                                                              child: Center(
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Container(
                                                                      height: 20,
                                                                      width: 20,
                                                                      // padding: const EdgeInsets.all(8),
                                                                      decoration: const BoxDecoration(
                                                                          shape: BoxShape
                                                                              .circle,
                                                                          color: Colors
                                                                              .red),
                                                                      child:
                                                                          const Center(
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .pin_drop,
                                                                          size:
                                                                              14,
                                                                          color: Colors
                                                                              .white,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Text(
                                                                      getTranslated(
                                                                          context,
                                                                          "Go To Pickup Location"),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color: Colors
                                                                              .white),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                    elevation: 2,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: colors.whiteTemp,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // Text(
                                                    //   getTranslated(context,
                                                    //       "Receiver's Name"),
                                                    //   // "Receiver's Name",
                                                    //   style: const TextStyle(
                                                    //       color: colors.blackTemp,
                                                    //       fontWeight:
                                                    //           FontWeight.bold),
                                                    // ),
                                                    Container(
                                                      constraints: BoxConstraints(
                                                          maxWidth:
                                                              100), // Adjust the maxWidth as needed
                                                      child: Row(
                                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Flexible(
                                                            child: Text(
                                                              getTranslated(
                                                                  context,
                                                                  "Receiver's Name"),
                                                              style: const TextStyle(
                                                                  color: colors
                                                                      .blackTemp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 1,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 8,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Icon(
                                                          Icons.person,
                                                          size: 20,
                                                        ),
                                                        Text(
                                                            "${singleBookingModel?.data?.first.receiverName}"),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    _launchPhoneDialer(
                                                        "${singleBookingModel?.data?.first.receiverPhone}");
                                                  },
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      // Container(
                                                      //   child: Text(
                                                      //     getTranslated(context,
                                                      //         "Receiver's Mobile No."),
                                                      //     // "Receiver's Mobile No.",
                                                      //     style: const TextStyle(
                                                      //         color: colors
                                                      //             .blackTemp,
                                                      //         fontWeight:
                                                      //             FontWeight
                                                      //                 .bold),
                                                      //   ),
                                                      // ),

                                                      Container(
                                                        constraints: BoxConstraints(
                                                            maxWidth:
                                                            100), // Adjust the maxWidth as needed
                                                        child: Row(
                                                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Flexible(
                                                              child: Text(
                                                                getTranslated(
                                                                    context,
                                                                    "Receiver's Mobile No."),
                                                                style: const TextStyle(
                                                                    color: colors
                                                                        .blackTemp,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                                overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                                maxLines: 1,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      Row(
                                                        children: [
                                                          InkWell(
                                                              onTap: () {
                                                                _launchPhoneDialer(
                                                                    "${singleBookingModel?.data?.first.receiverPhone}");
                                                              },
                                                              child: Icon(
                                                                Icons.call,
                                                                color:
                                                                    Colors.green,
                                                              )),
                                                          Text(
                                                              "${singleBookingModel?.data?.first.receiverPhone}"),
                                                        ],
                                                      ),
                                                      // Row(
                                                      //   children: [
                                                      //     const Icon(
                                                      //       Icons.call,
                                                      //       size: 20,
                                                      //     ),
                                                      //     InkWell(
                                                      //       onTap: () {
                                                      //         _launchPhoneDialer(
                                                      //             "${singleBookingModel?.data?.first.receiverPhone}");
                                                      //       },
                                                      //       child: Text(
                                                      //           "${singleBookingModel?.data?.first.receiverPhone}"),
                                                      //     ),
                                                      //   ],
                                                      // ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              getTranslated(
                                                  context, "Receiver's Address"),
                                              // "Receiver's Address",
                                              style: const TextStyle(
                                                  color: colors.blackTemp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                              children: [
                                                Image.asset(
                                                    "assets/images/gstlo-removebg-preview.png"),
                                                SizedBox(
                                                  width: 250,
                                                  child: Text(
                                                    "${singleBookingModel?.data?.first.receiverAddress}",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 3,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            singleBookingModel
                                                        ?.data?.first.status ==
                                                    "4"
                                                ? const SizedBox.shrink()
                                                : selectedStatus == 'Delivered'
                                                    ? const SizedBox.shrink()
                                                    : singleBookingModel?.data
                                                                ?.first.status ==
                                                            "3"
                                                        ? Row(
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  enablePickup =
                                                                      true;
                                                                  setState(() {});

                                                                  String lat =
                                                                      "${singleBookingModel?.data?.first.receiverLatitude}" ??
                                                                          ''; //'22.7177'; //
                                                                  String lon =
                                                                      "${singleBookingModel?.data?.first.receiverLongitude}" ??
                                                                          ''; //'75.8545'; //
                                                                  String
                                                                      CURENT_LAT =
                                                                      _position
                                                                              ?.latitude
                                                                              .toString() ??
                                                                          '';
                                                                  String
                                                                      CURENT_LONG =
                                                                      _position
                                                                              ?.longitude
                                                                              .toString() ??
                                                                          '';

                                                                  final Uri url = Uri.parse('https://www.google.com/maps/dir/?api=1&origin=' +
                                                                      CURENT_LAT +
                                                                      ',' +
                                                                      CURENT_LONG +
                                                                      ' &destination=' +
                                                                      lat.toString() +
                                                                      ',' +
                                                                      lon.toString() +
                                                                      '&travelmode=driving&dir_action=navigate');

                                                                  _launchURL(url);
                                                                },
                                                                child: Container(
                                                                  width: 300,
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .only(
                                                                          left: 5,
                                                                          right:
                                                                              10,
                                                                          top: 5,
                                                                          bottom:
                                                                              5),
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15),
                                                                      color: colors
                                                                          .primary),
                                                                  child: Center(
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Container(
                                                                          height:
                                                                              20,
                                                                          width:
                                                                              20,
                                                                          // padding:
                                                                          // const EdgeInsets
                                                                          //     .all(8),
                                                                          decoration: const BoxDecoration(
                                                                              shape:
                                                                                  BoxShape.circle,
                                                                              color: Colors.red),
                                                                          child:
                                                                              const Icon(
                                                                            Icons
                                                                                .pin_drop,
                                                                            size:
                                                                                14,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              5,
                                                                        ),
                                                                        const Text(
                                                                          'Go To DropUp Location',
                                                                          style: TextStyle(
                                                                              fontSize:
                                                                                  12,
                                                                              color:
                                                                                  Colors.white),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        : const SizedBox.shrink()
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  singleBookingModel?.data?.first.status != "4"
                                      ? Container()
                                      : Card(
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Delivery Ratings",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    feedbacks.isNotEmpty
                                                        ? Row(
                                                            children: [
                                                              Icon(
                                                                Icons.star,
                                                                color:
                                                                    Colors.yellow,
                                                              ),
                                                              Text("(" +
                                                                  (feedbacks.first
                                                                          .rating ??
                                                                      "") +
                                                                  ")"),
                                                            ],
                                                          )
                                                        : Text(
                                                            "No Delivery Ratings yet..."),
                                                    feedbacks.isNotEmpty
                                                        ? Text(feedbacks
                                                                .first.feedback ??
                                                            "")
                                                        : Container(),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (ctx) => Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: AlertDialog(
                                                insetPadding: EdgeInsets.zero,
                                                contentPadding: EdgeInsets.zero,
                                                clipBehavior:
                                                    Clip.antiAliasWithSaveLayer,
                                                title: Card(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  elevation: 0,
                                                  child: Container(
                                                    width: 400,
                                                    decoration: BoxDecoration(
                                                        color: colors.whiteTemp,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                10)),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Center(
                                                            child: Text(
                                                              getTranslated(
                                                                  context,
                                                                  "Parcel Details"),
                                                              //"Parcel Details",
                                                              style: const TextStyle(
                                                                  color: colors
                                                                      .primary,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 18),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                getTranslated(
                                                                    context,
                                                                    "Material Category"),
                                                                // "Material Category",
                                                                style: const TextStyle(
                                                                    color: colors
                                                                        .blackTemp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize: 15),
                                                              ),
                                                              Text(
                                                                  "${singleBookingModel?.data?.first.title}"),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                getTranslated(
                                                                    context,
                                                                    "Parcel Weight"),
                                                                // "Parcel Weight",
                                                                style: const TextStyle(
                                                                    color: colors
                                                                        .blackTemp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize: 15),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                      "${singleBookingModel?.data?.first.parcelWeight}Kg"),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                  getTranslated(
                                                                      context,
                                                                      "Total Distance"),
                                                                  // "Total Distance",
                                                                  style: const TextStyle(
                                                                      color: colors
                                                                          .blackTemp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          15)),
                                                              Text(
                                                                  "${singleBookingModel?.data?.first.distance} Km."),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                  getTranslated(
                                                                      context,
                                                                      "Amount"),
                                                                  // "Amount",
                                                                  style: const TextStyle(
                                                                      color: colors
                                                                          .blackTemp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          15)),
                                                              Text(
                                                                  "₹ ${double.parse(singleBookingModel?.data?.first.totalAmount.toString() ?? "0.0") - double.parse(singleBookingModel?.data?.first.couponDiscount.toString() ?? '0.0')}"),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              const Text(
                                                                  "PickPort Fee",
                                                                  style: TextStyle(
                                                                      color: colors
                                                                          .blackTemp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          15)),
                                                              Text(
                                                                  "₹ ${singleBookingModel?.data?.first.adminCommission}"),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          // Row(
                                                          //   mainAxisAlignment:
                                                          //       MainAxisAlignment
                                                          //           .spaceBetween,
                                                          //   children: [
                                                          //     Text(
                                                          //       getTranslated(
                                                          //           context,
                                                          //           "Promo Code"),
                                                          //       //  "Payment Status",
                                                          //       style: const TextStyle(
                                                          //           color: colors
                                                          //               .blackTemp,
                                                          //           fontWeight:
                                                          //               FontWeight
                                                          //                   .bold,
                                                          //           fontSize: 15),
                                                          //     ),
                                                          //     Text(
                                                          //         "₹ ${singleBookingModel?.data?.first.couponDiscount == "" ? "0" : singleBookingModel?.data?.first.couponDiscount}"),
                                                          //   ],
                                                          // ),
                                                          // const SizedBox(
                                                          //   height: 10,
                                                          // ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                getTranslated(
                                                                    context,
                                                                    "Total Amount To be paid"),
                                                                // "Total Amount To be paid",
                                                                style: const TextStyle(
                                                                    color: colors
                                                                        .blackTemp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize: 15),
                                                              ),
                                                              Text(
                                                                  "₹ ${double.parse(singleBookingModel?.data?.first.totalAmount ?? "0") - double.parse(singleBookingModel?.data?.first.couponDiscount ?? "0")}"),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                getTranslated(
                                                                    context,
                                                                    "Payment Status"),
                                                                //  "Payment Status",
                                                                style: const TextStyle(
                                                                    color: colors
                                                                        .blackTemp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize: 15),
                                                              ),
                                                              (singleBookingModel
                                                                              ?.data
                                                                              ?.first
                                                                              .paymentMethod ==
                                                                          "Online Payment" ||
                                                                      singleBookingModel
                                                                              ?.data
                                                                              ?.first
                                                                              .status ==
                                                                          "4")
                                                                  ? Text(
                                                                      getTranslated(
                                                                          context,
                                                                          "Paid"),
                                                                      // "Paid",
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .green,
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    )
                                                                  : Text(
                                                                      getTranslated(
                                                                          context,
                                                                          "UnPaid"),
                                                                      //  "UnPaid",
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .red,
                                                                          fontWeight:
                                                                              FontWeight.w600))
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                  getTranslated(
                                                                      context,
                                                                      "Payment Method"),
                                                                  //"Payment Method",
                                                                  style: const TextStyle(
                                                                      color: colors
                                                                          .red,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          15)),
                                                              singleBookingModel
                                                                          ?.data
                                                                          ?.first
                                                                          .paymentMethod ==
                                                                      getTranslated(
                                                                          context,
                                                                          "Cash On Delivery")
                                                                  ? Text(
                                                                      getTranslated(
                                                                        context,
                                                                        "Cash Payment",
                                                                      ),
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .red))
                                                                  : Text(
                                                                      "${singleBookingModel?.data?.first.paymentMethod}",
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .red))
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width: 100,
                                          height: 30,
                                          padding: const EdgeInsets.only(
                                              left: 5,
                                              right: 10,
                                              top: 5,
                                              bottom: 5),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: colors.primary),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  getTranslated(
                                                      context, "View Detail"),
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  statusDelivery(),
                                ],
                              ),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> getDriverFeedback(String user_id, String parcelId) async {
    var headers = {
      'Cookie': 'ci_session=9e8fdef277e1d8cbe9bb3dbf010b09b848f2297a'
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://pickport.in/api/payment/get_driver_feedback'));
    request.fields.addAll({'user_id': user_id, 'parcel_id': parcelId});

    request.headers.addAll(headers);
    print(request.fields.toString());

    log(request.fields.toString());

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      try {
        var finalResult = await response.stream.bytesToString();
        final jsonResponse = driverFeedbackModelFromJson(finalResult);
        feedbacks.addAll(jsonResponse.data ?? []);
        log(finalResult.toString());
        log(feedbacks.toString());

        setState(() {});
        print(feedbacks.length.toString() + "Feedbacks length");
      } catch (stacktrace, error) {
        print(stacktrace.toString() + "Feedbacks error");
        print(error.toString() + "Feedbacks error");
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  List<DatumFeedback> feedbacks = [];

  statusDelivery() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          // DottedLine(
          //   direction: Axis.horizontal,
          //   alignment: WrapAlignment.center,
          //   lineLength: double.infinity,
          //   lineThickness: 1.0,
          //   dashLength: 4.0,
          //   //dashColor: Colors.black,
          //   dashGradient: [
          //     Colors.grey,
          //     Colors.grey
          //   ],
          //   dashRadius: 0.0,
          //   dashGapLength: 4.0,
          //   dashGapColor: Colors.transparent,
          //   dashGapGradient: [
          //     Colors.grey,
          //     Colors.grey
          //   ],
          //   dashGapRadius: 0.0,
          // ),

          Container(
            height: 40,
            width: 150,
            decoration: BoxDecoration(
                // border: Border.all(),
                borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Text(
                getTranslated(context, "Delivery Status"),
                // "Delivery Status",
                style: const TextStyle(
                    color: colors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          singleBookingModel?.data?.first.status == "4"
              ? Center(
                  child: Image.asset(
                      "assets/images/delivered-removebg-preview.png"))
              : Center(child: Image.asset("assets/images/status.png")),
          const SizedBox(
            height: 5,
          ),
          singleBookingModel?.data?.first.status == "4"
              ? Center(
                  child: Text(
                  getTranslated(context, "Delivered"),
                  //  "Delivered",
                  style: const TextStyle(
                      color: colors.blackTemp, fontWeight: FontWeight.bold),
                ))
              : singleBookingModel?.data?.first.status == "3"
                  ? Center(
                      child: Text(
                      getTranslated(context, "Order Picked Up"),
                      //  "Delivered",
                      style: const TextStyle(
                          color: colors.blackTemp, fontWeight: FontWeight.bold),
                    ))
                  : Center(
                      child: Text(
                      getTranslated(context, "Pending"),
                      // "Pending",
                      style: const TextStyle(
                          color: colors.blackTemp, fontWeight: FontWeight.bold),
                    )),
          const SizedBox(
            height: 12,
          ),
          singleBookingModel?.data?.first.status == "4"
              ? const SizedBox.shrink()
              : InkWell(
                  onTap: () {
                    if (enablePickup) {
                      showUpdateOrderStatusDialog();
                    } else {
                      if (singleBookingModel?.data?.first.status == "3") {
                        Fluttertoast.showToast(
                            msg: "Please click on the drop location first.");
                      } else {
                        Fluttertoast.showToast(
                            msg: "Please click on the pickup location first.");
                      }
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: enablePickup ? colors.primary : Colors.grey),
                      child: Center(
                          child: Text(
                        // getTranslated(context, "Submit"),
                        singleBookingModel?.data?.first.status == "3"
                            ? getTranslated(context, "Deliver")
                            : getTranslated(context, "Pick Up"),
                        // "Update",
                        style: const TextStyle(
                            fontSize: 15, color: colors.whiteTemp),
                      )),
                    ),
                  ),
                ),
          // widget.isCheck == true
          //     ? const SizedBox.shrink()
          //     : Column(
          //   children: [
          //     Padding(
          //       padding:
          //       const EdgeInsets.all(8.0),
          //       child: Card(
          //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          //         elevation: 2,
          //         child: Container(
          //           decoration: BoxDecoration(
          //               color: colors
          //                   .whiteTemp,
          //               borderRadius:
          //               BorderRadius
          //                   .circular(
          //                   10)),
          //           child:
          //           DropdownButtonHideUnderline(
          //             child:
          //             DropdownButton2<
          //                 String>(
          //               value:
          //               selectedStatus,
          //               hint: Text(
          //                 getTranslated(
          //                     context,
          //                     "Update Delivery Status"),
          //                 // "Update Delivery Status"
          //                 style: const TextStyle(
          //                     color: colors
          //                         .blackTemp,
          //                     fontWeight:
          //                     FontWeight
          //                         .bold),
          //               ),
          //               isExpanded: true,
          //               onChanged: (String?
          //               newValue) {
          //                 if (selectedStatus == "Cancel") {
          //                   orderUpdateApi(
          //                       selectedStatus);
          //                 }
          //
          //                 setState(() {
          //                   selectedStatus =
          //                   newValue!;
          //                 });
          //               },
          //               items: <String>[
          //                 'Order Picked Up',
          //                 'Delivered',
          //               /*  'Cancel'*/
          //               ].map<
          //                   DropdownMenuItem<
          //                       String>>((String
          //               value) {
          //                 return DropdownMenuItem<
          //                     String>(
          //                   value: value,
          //                   child: Text(
          //                       value),
          //                 );
          //               }).toList(),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //     if (selectedStatus == 'Delivered' || selectedStatus == 'Order Picked Up')
          //       Column(
          //         crossAxisAlignment:
          //         CrossAxisAlignment
          //             .start,
          //         children: [
          //           selectedStatus ==
          //               'Order Picked Up'
          //               ? Padding(
          //             padding: const EdgeInsets
          //                 .only(
          //                 left: 20),
          //             child: Text(
          //            "OTP:${senderOTP}"),
          //           )
          //               : Padding(
          //             padding: const EdgeInsets
          //                 .only(
          //                 left: 20),
          //             child: Text(
          //                 "OTP:${receiverOtp}"),
          //           ),
          //           Padding(
          //             padding:
          //             const EdgeInsets.only(top: 16.0, left: 20, right: 20),
          //             child: Container(
          //               height: 45,
          //               decoration: BoxDecoration(
          //                   border: Border
          //                       .all(),
          //                   borderRadius:
          //                   BorderRadius
          //                       .circular(
          //                       10)),
          //               child:
          //               TextFormField(
          //                 maxLength: 6,
          //                 controller:
          //                 _otpController,
          //                 decoration:
          //                 InputDecoration(
          //                   counterText:
          //                   "",
          //                   contentPadding:
          //                   const EdgeInsets.only(
          //                       left:
          //                       5),
          //                   border:
          //                   InputBorder
          //                       .none,
          //                   hintText: getTranslated(
          //                       context,
          //                       "Enter OTP"),
          //                   // 'Enter OTP',
          //                 ),
          //                 keyboardType:
          //                 TextInputType
          //                     .number,
          //               ),
          //             ),
          //           ),
          //         ],
          //       )
          //   ],
          // ),
          // const SizedBox(
          //   height: 10,
          // ),
          // selectedStatus == 'Order Picked Up' || selectedStatus == "Delivered"
          //     ? InkWell(
          //   onTap: () {
          //     orderDelevertCompleteByOtp();
          //   },
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 10),
          //     child: Container(
          //       height: 50,
          //       decoration: BoxDecoration(
          //           borderRadius:
          //           BorderRadius.circular(10),
          //           color: colors.primary),
          //       child: Center(
          //           child: Text(
          //             getTranslated(context, "Submit"),
          //             // "Update",
          //             style: const TextStyle(
          //                 fontSize: 15,
          //                 color: colors.whiteTemp),
          //           )),
          //     ),
          //   ),
          // )
          //     : const SizedBox.shrink(),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  showUpdateOrderStatusDialog() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(
              getTranslated(context, "Update Delivery Status"),
              // "Update Delivery Status"
              style: const TextStyle(
                color: colors.blackTemp,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                singleBookingModel?.data?.first.status == "3"
                    ?
                Text("")
                    : Text(""),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  maxLength: 6,
                  controller: _otpController,
                  decoration: InputDecoration(
                    counterText: "",
                    isDense: true,
                    border: const OutlineInputBorder(),
                    hintText:
                        getTranslated(context, "Enter OTP"), //'Enter OTP',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(
                  height: 12,
                ),
                InkWell(
                  onTap: () async{
                  await  orderDelevertCompleteByOtp()
                        .then((value) => bookingOrderDetailsApi());
                  Get.back();
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: colors.primary),
                    child: Center(
                        child: Text(
                      getTranslated(context, "Submit"),
                      // "Update",
                      style: const TextStyle(
                          fontSize: 15, color: colors.whiteTemp),
                    )),
                  ),
                ),
              ],
            ),
          );
        });
  }

  showDialogCompleted(String receiverAddress, String senderAddress,
      String parcelId, String amount) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(getTranslated(context, 'Parcel Information')),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildInfoRow(
                    getTranslated(context, "Sender Address"), senderAddress),
                _buildInfoRow(getTranslated(context, "Receiver Address"),
                    receiverAddress),
                _buildInfoRow(getTranslated(context, "Amount"), "Rs " + amount),
                _buildInfoRow(
                    getTranslated(context, "Parcel ID"), "#" + parcelId),
                Center(
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ConfimeScreen()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(getTranslated(context, "Okay")),
                      )),
                )
              ],
            ),
          );
        });
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.black, fontSize: 16.0),
          children: [
            TextSpan(
              text: '$title: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: value,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  final _otpController = TextEditingController();
  String? selectedStatus; // Default status
  String? orderId, senderOTP, receiverOtp;
  SingleBookingModel? singleBookingModel;
  bookingOrderDetailsApi() async {
    enablePickup = false;
    var headers = {
      'Cookie': 'ci_session=7e0de117fa84bd318ef38c6fd83f368d5bbc9700'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('${Urls.baseUrl}Payment/api_single_parcel_details'));
    request.fields.addAll({'order_id': widget.pId.toString()});
    print('____Som___ggg___${request.fields}_________');
    request.headers.addAll(headers);
    print("kkkkkkkkkkkkkkkkkkkkkk---${request.url}");

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      log('____Som_+++_____${result}_________');
      var finalResult = SingleBookingModel.fromJson(json.decode(result));
      setState(() {
        singleBookingModel = finalResult;
        orderId = singleBookingModel?.data?.first.orderId.toString();
        senderOTP = singleBookingModel?.data?.first.senderOtp.toString();
        receiverOtp = singleBookingModel?.data?.first.receiverOtp.toString();
        print('____Som______${receiverOtp}_________');

        getDriverFeedback(
            singleBookingModel?.data?.first.userId ?? "", orderId!);

        //  if (singleBookingModel?.data?.first.status == "3") {
        // enablePickup = true;
        //   }
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  Future orderDelevertCompleteByOtp() async {
    if (_otpController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: getTranslated(context, "please enter otp"),
        //'please enter otp'
      );
    } else if (_otpController.text.length < 4) {
      Fluttertoast.showToast(
        msg: getTranslated(context, "please enter right otp"),
        // 'please enter right otp'
      );
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');

      var headers = {
        'Cookie': 'ci_session=27190b0a94b885f1a7656c45b1492a2c7a91a862'
      };
      var request = http.MultipartRequest('POST',
          Uri.parse('${Urls.baseUrl}Authentication/otp_order_complete'));
      request.fields.addAll({
        'user_id': userId ?? '300',
        'otp': _otpController.text,
        'deliveryboy_order_status':
            singleBookingModel?.data?.first.status == "3" ? "4" : "3",
        'order_id': widget.pId.toString(),
        "city": city
      });
      print(request.url);
      print('otp_order_complete____Som______${request.fields}_________');
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        _otpController.clear();
        var result = await response.stream.bytesToString();
        var finalResult = jsonDecode(result);
        debugPrint("+++++++++++++$finalResult");
        if (finalResult['status'] == true) {
          Fluttertoast.showToast(msg: "${finalResult['meassge']}");
          if (singleBookingModel?.data?.first.status == "3") {
            showDialogCompleted(
                singleBookingModel?.data?.first.reciverFullAddress ?? "",
                singleBookingModel?.data?.first.senderAddress ?? "",
                singleBookingModel?.data?.first.saleId ?? "0",
                singleBookingModel?.data?.first.totalAmount ?? "");
          } else {
            // Get.back();
          }
        } else {
          Fluttertoast.showToast(msg: 'Wrong Otp...please enter correct otp');
        }

        // if(finalResult['status']) {
        //   // if (status == '3') {
        //   //   Fluttertoast.showToast(msg: 'Order Picked Successfully');
        //   //   Navigator.pop(context);
        //   //
        //   // } else if (status == '4') {
        //   //   Fluttertoast.showToast(
        //   //       msg: 'Order has been delivered successfully');
        //   //   // Navigator.pushReplacement(
        //   //   //     context, MaterialPageRoute(builder: (context) => BottomNav()));
        //   // }
        // }else{
        //  //
        // }
      } else {
        _otpController.clear();
        print(response.reasonPhrase);
      }
    }
  }

  void _launchURL(Uri url) async {
    print("url ....$url");
    if (await launchUrl(url, mode: LaunchMode.externalApplication)) {
      //await launch(url);
    } else {
      Fluttertoast.showToast(
        msg: getTranslated(context, "Could not launch "),
        //  'Could not launch '
      );
      throw 'Could not launch $url';
    }
  }

  orderUpdateApi(String? status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    var headers = {
      'Cookie': 'ci_session=5f7e1cc6f4bb283533aa8649c10608e57fef7dd1'
    };
    var request = http.MultipartRequest('POST',
        Uri.parse('${Urls.baseUrl}Authentication/api_order_change_status'));
    request.fields.addAll({
      'user_id': userId ?? '323',
      'order_id': orderId.toString(),
      'deliveryboy_order_status': status == "Order Picked Up"
          ? "3"
          : status == "Out for Delivery"
              ? "4"
              : status == "Cancel"
                  ? "0"
                  : ""
    });
    print('____Som______${request.fields}_________');
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var finalResult = jsonDecode(result);

      // if (status == 'Order Picked Up') {
      //   Fluttertoast.showToast(msg: 'Order Picked Successfully');
      //  // Navigator.pop(context);
      //
      // }
      if (status == 'Out for Delivery') {
        Fluttertoast.showToast(
          msg: getTranslated(context, "Out For Delivery"),
          // 'Out for Delivery'
        );
        //Navigator.pop(context);
      } else if (status == 'Cancel') {
        Fluttertoast.showToast(
          msg: getTranslated(context, "Order Canceled Success"),
          // 'Order Canceled Success'
        );
      }
      setState(() {
        // Fluttertoast.showToast(msg: "${finalResult['message']}");
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  String? Otp;
  getOtpApi() async {
    var headers = {
      'Cookie': 'ci_session=127419c90abafa0b72f2bc62ac629ffdb6745994'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('${Urls.baseUrl}Authentication/api_delivery_otp'));
    request.fields.addAll({'order_id': widget.pId.toString()});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var finalResult = jsonDecode(result);
      setState(() {
        Otp = finalResult['data'];
      });
    } else {
      print(response.reasonPhrase);
    }
  }
}
