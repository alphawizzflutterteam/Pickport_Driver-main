import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jdx/Controller/BottomNevBar.dart';
import 'package:jdx/Models/GetProfileModel.dart';
import 'package:jdx/Views/GetHelp.dart';
import 'package:jdx/Views/HelpScreen.dart';
import 'package:jdx/services/session.dart';
import 'package:jdx/verifyDocuments/VerifyBankDetails.dart';
import 'package:jdx/verifyDocuments/verifyDocs.dart';

class DocumentStatus {
  final String name;
  final String status;

  DocumentStatus({
    required this.name,
    required this.status,
  });
}

class ReviewScreen extends StatefulWidget {
  final GetProfileModel? getProfileModel;
  ReviewScreen({Key? key, required this.getProfileModel}) : super(key: key);

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  List<DocumentStatus> customList = [];

  @override
  void initState() {
    super.initState();

    if (widget.getProfileModel!.data!.verified!.aadhaarCardPhoto == "0" ||
        widget.getProfileModel!.data!.verified!.drivingLicencePhoto == "0" ||
        widget.getProfileModel!.data!.verified!.pan_card_photof == "0" ||
        widget.getProfileModel!.data!.verified!.userImage == "0" ||
        widget.getProfileModel!.data!.verified!.rcCardPhoto == "0") {}

    if (widget.getProfileModel!.data!.verified!.aadhaarCardPhoto == null) {
      customList
          .add(DocumentStatus(name:  "Aadhar Card" , status:  "Please Upload"));
    }
    if (widget.getProfileModel!.data!.verified!.drivingLicencePhoto == null) {
      customList.add(
          DocumentStatus(name: "Driving License", status:  "Please Upload"));
    }
    if (widget.getProfileModel!.data!.verified!.pan_card_photof == null) {
      customList.add(DocumentStatus(name:  "Pan Card" , status: "Please Upload"));
    }
    if (widget.getProfileModel!.data!.verified!.rcCardPhoto == null) {
      customList.add(DocumentStatus(name:  "Rc Image", status: "Please Upload"));
    }
    if (widget.getProfileModel!.data!.verified!.userImage == null) {
      customList
          .add(DocumentStatus(name:  "Profile Image", status: "Please Upload"));
    }
    if (widget.getProfileModel!.data!.verified!.accountNumber == null) {
      customList
          .add(DocumentStatus(name:"Bank Details", status:  "Please Add"));
    }
    if (widget.getProfileModel!.data!.verified!.vehicle_image == null) {
      customList
          .add(DocumentStatus(name: "Vehicle Image", status:  "Please Add"));
    }
    if (widget.getProfileModel!.data!.verified!.aadhaarCardPhoto == "0") {
      customList.add(DocumentStatus(name:"Aadhar Card", status:  "Pending"));
    }
    if (widget.getProfileModel!.data!.verified!.drivingLicencePhoto == "0") {
      customList
          .add(DocumentStatus(name:"Driving License", status: "Pending"));
    }
    if (widget.getProfileModel!.data!.verified!.pan_card_photof == "0") {
      customList.add(DocumentStatus(name: "Pan Card", status:  "Pending"));
    }
    if (widget.getProfileModel!.data!.verified!.rcCardPhoto == "0") {
      customList.add(DocumentStatus(name:  "Rc Image", status: "Pending"));
    }
    if (widget.getProfileModel!.data!.verified!.userImage == "0") {
      customList.add(DocumentStatus(name:"Profile Image", status:  "Pending"));
    }
    if (widget.getProfileModel!.data!.verified!.accountNumber == "0") {
      customList.add(DocumentStatus(name: "Bank Details", status:  "Pending"));
    }
    if (widget.getProfileModel!.data!.verified!.vehicle_image == "0") {
      customList.add(DocumentStatus(name:"Vehicle Image", status:  "Pending"));
    }

    if (widget.getProfileModel!.data!.verified!.aadhaarCardPhoto == "1") {
      customList.add(DocumentStatus(name:  "Aadhar Card", status:  "Approved"));
    }
    if (widget.getProfileModel!.data!.verified!.drivingLicencePhoto == "1") {
      customList
          .add(DocumentStatus(name:  "Driving License", status:  "Approved"));
    }
    if (widget.getProfileModel!.data!.verified!.pan_card_photof == "1") {
      customList.add(DocumentStatus(name:  "Pan Card", status: "Approved"));
    }
    if (widget.getProfileModel!.data!.verified!.rcCardPhoto == "1") {
      customList.add(DocumentStatus(name: "Please Upload", status:  "Approved"));
    }
    if (widget.getProfileModel!.data!.verified!.userImage == "1") {
      customList.add(DocumentStatus(name: "Profile Image", status: "Approved"));
    }
    if (widget.getProfileModel!.data!.verified!.accountNumber == "1") {
      customList.add(DocumentStatus(name: "Bank Details", status: "Approved"));
    }
    if (widget.getProfileModel!.data!.verified!.vehicle_image == "1") {
      customList.add(DocumentStatus(name: "Vehicle Image", status: "Approved"));
    }

    if (widget.getProfileModel!.data!.verified!.aadhaarCardPhoto == "2") {
      customList.add(
          DocumentStatus(name: "Aadhar Card", status: "Rejected - Resubmit"));
    }
    if (widget.getProfileModel!.data!.verified!.drivingLicencePhoto == "2") {
      customList.add(DocumentStatus(
          name: "Driving License", status: "Rejected - Resubmit"));
    }
    if (widget.getProfileModel!.data!.verified!.pan_card_photof == "2") {
      customList
          .add(DocumentStatus(name: "Pan Card", status: "Rejected - Resubmit"));
    }
    if (widget.getProfileModel!.data!.verified!.rcCardPhoto == "2") {
      customList
          .add(DocumentStatus(name: "Rc Image", status: "Rejected - Resubmit"));
    }
    if (widget.getProfileModel!.data!.verified!.userImage == "2") {
      customList.add(
          DocumentStatus(name: "Profile Image", status: "Rejected - Resubmit"));
    }
    if (widget.getProfileModel!.data!.verified!.accountNumber == "2") {
      customList.add(
          DocumentStatus(name: "Bank Details", status: "Rejected - Resubmit"));
    }
    if (widget.getProfileModel!.data!.verified!.vehicle_image == "2") {
      customList.add(
          DocumentStatus(name: "Vehicle Image", status: "Rejected - Resubmit"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text( getTranslated(context, "Review Status")),
          actions: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NeedHelp()),
                      );
                    },
                    child: Text(getTranslated(context, "Need Help?")
                      ,
                      style: TextStyle(fontSize: 16),
                    )),
              ),
            )
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            Future.delayed(Duration(seconds: 2));
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const BottomNav()));
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                   Text(getTranslated(context,"Finish these steps to get \nverified!" )
                    ,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                   Text(getTranslated(context, "Last steps")
                    ,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // const Text(
                  //   "Some of your documents are still need to be uploaded for verification, please upload them",
                  //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  // ),
                  // Center(
                  //   child: ElevatedButton(
                  //       onPressed: () {
                  //         var bankVerified = false;

                  //         if (widget.getProfileModel!.data!.verified!
                  //                     .aadhaarCardPhoto ==
                  //                 null ||
                  //             widget.getProfileModel!.data!.verified!
                  //                     .aadhaarCardPhoto ==
                  //                 "2" ||
                  //             widget.getProfileModel!.data!.verified!
                  //                     .drivingLicencePhoto ==
                  //                 null ||
                  //             widget.getProfileModel!.data!.verified!
                  //                     .drivingLicencePhoto ==
                  //                 "2" ||
                  //             widget.getProfileModel!.data!.verified!
                  //                     .pan_card_photof ==
                  //                 null ||
                  //             widget.getProfileModel!.data!.verified!
                  //                     .pan_card_photof ==
                  //                 "2" ||
                  //             widget.getProfileModel!.data!.verified!.userImage ==
                  //                 null ||
                  //             widget.getProfileModel!.data!.verified!
                  //                     .userImage ==
                  //                 "2" ||
                  //             widget.getProfileModel!.data!.verified!
                  //                     .rcCardPhoto ==
                  //                 null ||
                  //             widget.getProfileModel!.data!.verified!
                  //                     .rcCardPhoto ==
                  //                 "2") {
                  //           if (widget.getProfileModel!.data!.verified!
                  //                       .accountNumber ==
                  //                   null ||
                  //               widget.getProfileModel!.data!.verified!
                  //                       .accountNumber ==
                  //                   "2") {
                  //             bankVerified = false;
                  //           }
                  //           Navigator.push(
                  //             context,
                  //             MaterialPageRoute(
                  //               builder: (context) => VerifyDocs(
                  //                 adharVerified: widget.getProfileModel!.data!
                  //                             .verified!.aadhaarCardPhoto ==
                  //                         null
                  //                     ? "0"
                  //                     : widget.getProfileModel!.data!.verified!
                  //                                 .aadhaarCardPhoto ==
                  //                             "2"
                  //                         ? "0"
                  //                         : "1",
                  //                 drivingLicenseVerified: widget
                  //                             .getProfileModel!
                  //                             .data!
                  //                             .verified!
                  //                             .drivingLicencePhoto ==
                  //                         null
                  //                     ? "0"
                  //                     : widget.getProfileModel!.data!.verified!
                  //                                 .drivingLicencePhoto ==
                  //                             "2"
                  //                         ? "0"
                  //                         : "1",
                  //                 panVerified: widget.getProfileModel!.data!
                  //                             .verified!.pan_card_photof ==
                  //                         null
                  //                     ? "0"
                  //                     : widget.getProfileModel!.data!.verified!
                  //                                 .pan_card_photof ==
                  //                             "2"
                  //                         ? "0"
                  //                         : "1",
                  //                 rcVerified: widget.getProfileModel!.data!
                  //                             .verified!.rcCardPhoto ==
                  //                         null
                  //                     ? "0"
                  //                     : widget.getProfileModel!.data!.verified!
                  //                                 .rcCardPhoto ==
                  //                             "2"
                  //                         ? "0"
                  //                         : "1",
                  //                 vehicleNum: widget.getProfileModel!.data!
                  //                             .user!.vehicleNo ==
                  //                         null
                  //                     ? ""
                  //                     : widget.getProfileModel!.data!.user!
                  //                                 .vehicleNo ==
                  //                             "2"
                  //                         ? ""
                  //                         : "1",
                  //                 imageVerified: widget.getProfileModel!.data!
                  //                             .verified!.userImage ==
                  //                         null
                  //                     ? "0"
                  //                     : widget.getProfileModel!.data!.verified!
                  //                                 .userImage ==
                  //                             "2"
                  //                         ? "0"
                  //                         : "1",
                  //                 vehicleImageVerified: widget.getProfileModel!
                  //                             .data!.verified!.vehicle_image ==
                  //                         null
                  //                     ? "0"
                  //                     : widget.getProfileModel!.data!.verified!
                  //                                 .vehicle_image ==
                  //                             "2"
                  //                         ? "0"
                  //                         : "1",
                  //                 isBankAdded: bankVerified,
                  //               ),
                  //             ),
                  //           );
                  //         } else if (widget.getProfileModel!.data!.verified!
                  //                     .accountNumber ==
                  //                 null ||
                  //             widget.getProfileModel!.data!.verified!
                  //                     .accountNumber ==
                  //                 "2") {
                  //           Navigator.push(
                  //               context,
                  //               MaterialPageRoute(
                  //                 builder: (context) => VerifyBankDetails(),
                  //               ));
                  //         }
                  //       },
                  //       child: Text("Upload Document",
                  //           style: TextStyle(fontSize: 15))),
                  // ),

                  SizedBox(
                    height: 85 * customList.length.toDouble(),
                    child: ListView.builder(
                        itemCount: customList.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              var bankVerified = false;

                              if (customList[index].status == getTranslated(context, "Approved") ) {
                                Fluttertoast.showToast(
                                    msg: getTranslated(context, "Document is already approved") );
                              } else if (customList[index].status ==
                                  getTranslated(context, "Pending")) {
                                Fluttertoast.showToast(
                                    msg: getTranslated(context,  "Document is pending for approval"));
                              } else {
                                if (widget.getProfileModel!.data!.verified!.aadhaarCardPhoto == null ||
                                    widget.getProfileModel!.data!.verified!
                                            .aadhaarCardPhoto ==
                                        "2" ||
                                    widget.getProfileModel!.data!.verified!
                                            .vehicle_image ==
                                        "2" ||
                                    widget.getProfileModel!.data!.verified!
                                            .drivingLicencePhoto ==
                                        null ||
                                    widget.getProfileModel!.data!.verified!
                                            .drivingLicencePhoto ==
                                        "2" ||
                                    widget.getProfileModel!.data!.verified!
                                            .pan_card_photof ==
                                        null ||
                                    widget.getProfileModel!.data!.verified!
                                            .pan_card_photof ==
                                        "2" ||
                                    widget.getProfileModel!.data!.verified!
                                            .userImage ==
                                        null ||
                                    widget.getProfileModel!.data!.verified!
                                            .userImage ==
                                        "2" ||
                                    widget.getProfileModel!.data!.verified!
                                            .rcCardPhoto ==
                                        null ||
                                    widget.getProfileModel!.data!.verified!
                                            .rcCardPhoto ==
                                        "2") {
                                  if (widget.getProfileModel!.data!.verified!
                                              .accountNumber ==
                                          null ||
                                      widget.getProfileModel!.data!.verified!
                                              .accountNumber ==
                                          "2") {
                                    bankVerified = false;
                                  }
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VerifyDocs(
                                        adharVerified: widget
                                                    .getProfileModel!
                                                    .data!
                                                    .verified!
                                                    .aadhaarCardPhoto ==
                                                null
                                            ? "0"
                                            : widget
                                                        .getProfileModel!
                                                        .data!
                                                        .verified!
                                                        .aadhaarCardPhoto ==
                                                    "2"
                                                ? "0"
                                                : "1",
                                        drivingLicenseVerified: widget
                                                    .getProfileModel!
                                                    .data!
                                                    .verified!
                                                    .drivingLicencePhoto ==
                                                null
                                            ? "0"
                                            : widget
                                                        .getProfileModel!
                                                        .data!
                                                        .verified!
                                                        .drivingLicencePhoto ==
                                                    "2"
                                                ? "0"
                                                : "1",
                                        panVerified: widget
                                                    .getProfileModel!
                                                    .data!
                                                    .verified!
                                                    .pan_card_photof ==
                                                null
                                            ? "0"
                                            : widget
                                                        .getProfileModel!
                                                        .data!
                                                        .verified!
                                                        .pan_card_photof ==
                                                    "2"
                                                ? "0"
                                                : "1",
                                        rcVerified: widget
                                                    .getProfileModel!
                                                    .data!
                                                    .verified!
                                                    .rcCardPhoto ==
                                                null
                                            ? "0"
                                            : widget
                                                        .getProfileModel!
                                                        .data!
                                                        .verified!
                                                        .rcCardPhoto ==
                                                    "2"
                                                ? "0"
                                                : "1",
                                        vehicleNum: widget.getProfileModel!
                                                    .data!.user!.vehicleNo ==
                                                null
                                            ? ""
                                            : widget.getProfileModel!.data!
                                                        .user!.vehicleNo ==
                                                    "2"
                                                ? ""
                                                : "1",
                                        imageVerified: widget
                                                    .getProfileModel!
                                                    .data!
                                                    .verified!
                                                    .userImage ==
                                                null
                                            ? "0"
                                            : widget.getProfileModel!.data!
                                                        .verified!.userImage ==
                                                    "2"
                                                ? "0"
                                                : "1",
                                        vehicleImageVerified: widget
                                                    .getProfileModel!
                                                    .data!
                                                    .verified!
                                                    .vehicle_image ==
                                                null
                                            ? "0"
                                            : widget
                                                        .getProfileModel!
                                                        .data!
                                                        .verified!
                                                        .vehicle_image ==
                                                    "2"
                                                ? "0"
                                                : "1",
                                        isBankAdded: bankVerified,
                                      ),
                                    ),
                                  );
                                } else if (widget.getProfileModel!.data!
                                            .verified!.accountNumber ==
                                        null ||
                                    widget.getProfileModel!.data!.verified!
                                            .accountNumber ==
                                        "2") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            VerifyBankDetails(),
                                      ));
                                }
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8, top: 4, bottom: 4),
                              child: Container(
                                height: 70,
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        customList[index].status,
                                        style: TextStyle(
                                          color: customList[index].status ==
                                                  getTranslated(context, "Pending")
                                              ? Color.fromARGB(255, 4, 63, 166)
                                              : customList[index].status ==
                                                      getTranslated(context, "Approved")
                                                  ? Colors.green
                                                  : Colors.red,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            customList[index].name,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          Icon(
                                            customList[index].status ==
                                                    getTranslated(context, "Pending")
                                                ? Icons.access_time
                                                : customList[index].status ==
                                                       getTranslated(context,  "Approved")
                                                    ? Icons.check_box
                                                    : Icons.warning,
                                            color: customList[index].status ==
                                                    getTranslated(context, "Pending")
                                                ? Color.fromARGB(
                                                    255, 4, 63, 166)
                                                : customList[index].status ==
                                                        getTranslated(context, "Approved")
                                                    ? Colors.green
                                                    : Colors.red,
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );

                          // ListTile(
                          //   title: Text(items[index]),
                          //   onTap: () {
                          //     // You can add onTap functionality here if needed
                          //   },
                          //  // Light yellow color
                        }),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
