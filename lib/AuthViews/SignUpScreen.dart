import 'dart:convert';
import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jdx/AuthViews/LoginScreen.dart';
import 'package:http/http.dart' as http;
import 'package:jdx/Models/SignUpModel.dart';
import 'package:jdx/Utils/ApiPath.dart';
import 'package:jdx/Views/PrivacyPolicy.dart';
import 'package:jdx/Views/TermsAndConditions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Controller/BottomNevBar.dart';
import '../CustomWidgets/CustomElevetedButton.dart';
import '../CustomWidgets/CustomTextformfield.dart';
import '../Models/get_city_model.dart';
import '../Models/get_status_model.dart';
import '../Utils/Color.dart';
import '../Utils/CustomColor.dart';
import '../Views/GetHelp.dart';
import '../Views/HelpScreen.dart';
import '../services/location/location.dart';
import '../services/session.dart';
import 'AddBankDetails.dart';

File? imageFile;
File? rcFrontFile;
File? rcBackFile;
File? drivingLicenseFile;
File? vehicleImage;
File? drivingLicenseBackFile;
File? pancardBackFile;
File? aadharCardFrontFile;
File? aadharCardBackFile;
File? panCardFile;

class SignUpScreen extends StatefulWidget {
  SignUpScreen(
      {Key? key, this.name, this.mobile, this.email, this.pass, this.cPass})
      : super(key: key);
  String? name, email, mobile, pass, cPass;

  @override
  State<SignUpScreen> createState() => _SignUpScreen();
}

class _SignUpScreen extends State<SignUpScreen> {
  singUpModel? information;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobController = TextEditingController();
  TextEditingController cPassController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController panController = TextEditingController();

  TextEditingController VhicleController = TextEditingController();
  TextEditingController VhicletypeController = TextEditingController();
  TextEditingController LicenceController = TextEditingController();
  TextEditingController aadharController = TextEditingController();
  TextEditingController referController = TextEditingController();
  TextEditingController rcController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  double? lat;
  double? long;

  getNewSignUp() async {
    var headers = {
      'Cookie': 'ci_session=cd3c13dc5a076f38e4c94afe64948ac08bf8b17c'
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://pickport.in/api/Authentication/deliveryBoyRegistration'));
    request.fields.addAll({
      'user_fullname': '210',
      'user_phone': '6879889798',
      'user_email': 'test11@gmail.com',
      'vehicle_no': '7',
      'user_password': '12345678',
      'firebaseToken': '4',
      // 'aadhaar_card_no': '6486',
      'vehicle_type': '9+',
      // 'driving_licence_no': '7',
      // 'account_holder_name': '5',
      // 'account_number': '7',
      // 'ifsc_code': '4',
      'user_image': '',
      // 'driving_licence_photo': ''
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
    } else {
      print(response.reasonPhrase);
    }
  }

  signUpApi() async {
    var headers = {
      'Cookie': 'ci_session=441db6d062b9f121348edb7be09465992a51c601'
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://pickport.in/api/Authentication/deliveryBoyRegistration'));
    request.fields.addAll({
      'user_fullname': nameController.text,
      'user_email': emailController.text,
      'user_password': passController.text,
      'user_phone': mobController.text,
      'firebaseToken': '4',
      'aadhaar_card_no': aadharController.text,
      'vehicle_type': VhicletypeController.text,
      'vehicle_no': VhicleController.text,
      'driving_licence_no': LicenceController.text,
      'account_holder_name': '5',
      'account_number': '7',
      'ifsc_code': '4',
      'user_image': '',
      'address': addressController.text,
      'lat': '${lat}',
      'lang': '${long}'
    });

    request.files.add(await http.MultipartFile.fromPath(
        'driving_licence_photo', imageFile?.path ?? ''));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final str = await response.stream.bytesToString();
      var finalData = json.decode(str);
      Fluttertoast.showToast(msg: "${finalData['message']}");
      setState(() {
        nameController.clear();
        emailController.clear();
        mobController.clear();
        passController.clear();
        VhicleController.clear();
        VhicletypeController.clear();
        LicenceController.clear();
        aadharController.clear();
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("userId", finalData['data']['user_id'] ?? '');
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } else {
      print(response.reasonPhrase);
    }
  }

  final ImagePicker _picker = ImagePicker();

  _getFromGallery(int vall) async {
    PickedFile? pickedFile = await _picker.getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      if (vall == 1) {
        setState(() {
          drivingLicenseFile = File(pickedFile.path);
        });
      } else if (vall == 2) {
        setState(() {
          drivingLicenseBackFile = File(pickedFile.path);
        });
      } else if (vall == 3) {
        setState(() {
          aadharCardFrontFile = File(pickedFile.path);
        });
      } else if (vall == 4) {
        setState(() {
          aadharCardBackFile = File(pickedFile.path);
        });
      } else if (vall == 5) {
        setState(() {
          rcFrontFile = File(pickedFile.path);
        });
      } else if (vall == 6) {
        setState(() {
          rcBackFile = File(pickedFile.path);
        });
      } else if (vall == 7) {
        setState(() {
          imageFile = File(pickedFile.path);
        });
      } else if (vall == 8) {
        setState(() {
          panCardFile = File(pickedFile.path);
        });
      } else if (vall == 9) {
        setState(() {
          pancardBackFile = File(pickedFile.path);
        });
      } else if (vall == 10) {
        setState(() {
          vehicleImage = File(pickedFile.path);
        });
      }
    }
  }

  _getCamera(int vall) async {
    PickedFile? pickedFile = await _picker.getImage(
      source: ImageSource.camera,
      imageQuality: 90,
    );
    if (pickedFile != null) {
      if (vall == 1) {
        setState(() {
          drivingLicenseFile = File(pickedFile.path);
        });
      } else if (vall == 2) {
        setState(() {
          drivingLicenseBackFile = File(pickedFile.path);
        });
      } else if (vall == 3) {
        setState(() {
          aadharCardFrontFile = File(pickedFile.path);
        });
      } else if (vall == 4) {
        setState(() {
          aadharCardBackFile = File(pickedFile.path);
        });
      } else if (vall == 5) {
        setState(() {
          rcFrontFile = File(pickedFile.path);
        });
      } else if (vall == 6) {
        setState(() {
          rcBackFile = File(pickedFile.path);
        });
      } else if (vall == 7) {
        setState(() {
          imageFile = File(pickedFile.path);
        });
      } else if (vall == 8) {
        setState(() {
          panCardFile = File(pickedFile.path);
        });
      } else if (vall == 9) {
        setState(() {
          pancardBackFile = File(pickedFile.path);
        });
      } else if (vall == 10) {
        setState(() {
          vehicleImage = File(pickedFile.path);
        });
      }
    }
  }

  signUpAPISECOND() async {
    setState(() {
      isLoading = true;
    });
    var headers = {
      'Cookie': 'ci_session=321abd54770ce394b6c89c07e2d20a0996c1cff8'
    };
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("userId");

    print('${Urls.baseUrl}Authentication/deliveryBoyRegistration/$id');

    var request = http.MultipartRequest('POST',
        Uri.parse('${Urls.baseUrl}Authentication/deliveryBoyRegistration/$id'));
    request.fields.addAll({
      'user_fullname': widget.name.toString(),
      'user_phone': widget.mobile.toString(),
      'user_email': widget.email.toString(),
      'vehicle_no': VhicleController.text.toString(),
      // 'pan_card':widget.pan.toString(),
      'address': addressController.text.toString(),
      'state_id': stateId.toString().toString(),
      'city_id': cityId.toString(),
      'user_password': widget.pass.toString(),
      'refferal_code': referController.text.toString(),
      'vehicle_type': selected.toString(),
      'firebaseToken': '',
      "pollution_emission": _value.toString(),
      "vehicle_insurance": _value1.toString()
    });

    print('____Som______${request.fields}_________');
    request.files.add(
        await http.MultipartFile.fromPath('user_image', '${imageFile?.path}'));
    request.files.add(await http.MultipartFile.fromPath(
        'driving_licence_photob', '${drivingLicenseBackFile?.path}'));
    request.files.add(await http.MultipartFile.fromPath(
        'driving_licence_photof', '${drivingLicenseFile?.path}'));
    request.files.add(await http.MultipartFile.fromPath(
        'vehicle_image', '${vehicleImage?.path}'));
    request.files.add(
        await http.MultipartFile.fromPath('rc_imageb', '${rcBackFile?.path}'));
    request.files.add(
        await http.MultipartFile.fromPath('rc_imagef', '${rcFrontFile?.path}'));
    request.files.add(await http.MultipartFile.fromPath(
        'aadhaar_card_photob', '${aadharCardBackFile?.path}'));
    request.files.add(await http.MultipartFile.fromPath(
        'aadhaar_card_photof', '${aadharCardFrontFile?.path}'));
    request.files.add(await http.MultipartFile.fromPath(
        'pan_card_photof', '${panCardFile?.path}'));
    request.files.add(await http.MultipartFile.fromPath(
        'pan_card_photob', '${pancardBackFile?.path}'));

    print('____Som___request.files___${request.files}_________');
    request.headers.addAll(headers);
    print('____Som___request.files___${request.files}_________');
    http.StreamedResponse response = await request.send();
    //print(await response.stream.bytesToString());
    print('____Som___response___${response.statusCode}_________');

    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      var result = await response.stream.bytesToString();
      var finalResult = jsonDecode(result);

      if (finalResult['status'] == true) {
        Fluttertoast.showToast(msg: "${finalResult['message']}");
        setState(() {});

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddBankDetails(
              mobile: widget.mobile,
              name: widget.name,
              address: addressController.text,
              adhar: aadharController.text,
              cPass: widget.cPass,
              email: widget.email,
              Licence: LicenceController.text,
              pan: panController.text,
              pass: widget.pass,
              rc: rcController.text,
              refer: referController.text,
              vcNo: VhicleController.text,
              lat: lat,
              long: long,
              image: imageFile!.path.toString(),
              sId: stateId.toString(),
              cID: cityId.toString(),
              Insurance: _value.toString(),
              pollution: _value1.toString(),
              vType: selected,
            ),
          ),
        );
      } else {
        Fluttertoast.showToast(msg: "${finalResult['message']}");
      }
    } else {
      setState(() {
        isLoading = false;
      });
      print(response.reasonPhrase);
    }
  }

  // Future<bool> camGallPopup(int value) async {
  //   return await showDialog(
  //     //show confirm dialogue
  //     //the return value will be from "Yes" or "No" options
  //     context: context,
  //     builder: (context) => AlertDialog(
  //         title:  Center(child: Text('PIC IMAGE',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Color(0xFF0F368C)))),
  //         content: Row(
  //           // crossAxisAlignment: CrossAxisAlignment.s,
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Expanded(
  //               child: InkWell(
  //                 onTap: () {
  //                  _getFromGallery(value);
  //                 },
  //                 child: Container(
  //                     padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
  //                     decoration: BoxDecoration(
  //                         border: Border.all(color: Colors.black),
  //                         borderRadius: BorderRadius.circular(10)
  //                     ),
  //                     child: const Text('    From Gallery',style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Color(0xff757575)))),
  //               ),
  //             ),
  //             const SizedBox(
  //               width: 10,
  //             ),
  //             Expanded(
  //               child: InkWell(
  //                 onTap: () {
  //
  //                 _getCamera(value);
  //                 },
  //                 child: Container(
  //                     padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
  //                     decoration: BoxDecoration(
  //                         border: Border.all(color: colors.primary),
  //                         borderRadius: BorderRadius.circular(10)
  //                     ),
  //
  //                     child: Row(
  //                       children: [
  //
  //                         const Text('   From Camera',style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Color(0xff757575))),
  //                       ],
  //                     )),
  //               ),
  //             ),
  //           ],
  //         )),
  //   ) ??
  //       false; //if showDialouge had returned null, then return false
  // }

  Future<bool> camGallPopup(int value) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Center(
              child: Text(
                getTranslated(context, "Pic Image"),
                // 'Pic Image',
                style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F368C)),
              ),
            ),
            content: Container(
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      _getFromGallery(value);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: colors.primary),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                          child: Text(getTranslated(context, "From Gallery"),
                              //'From Gallery',
                              style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F368C)))),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      getTranslated(context, "OR"),
                      //'OR',
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F368C)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      _getCamera(value);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: colors.primary),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(getTranslated(context, "From Camera"),
                            // 'From Camera',
                            style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F368C))),
                      ),
                    ),
                  ),
                  // const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ) ??
        false;
  }

  Future<bool> showExitPopupl(int valuef, valueb) async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => AlertDialog(
            title: Center(
                child: Text(getTranslated(context, "Upload Driving License"),
                    //'Upload Driving License',
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F368C)))),
            content: Row(
              // crossAxisAlignment: CrossAxisAlignment.s,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      camGallPopup(valuef);
                    },
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: colors.primary),
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                            getTranslated(context, "Driving License Front"),
                            //'Driving License Front',
                            style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff757575)))),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      camGallPopup(valueb);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: colors.primary),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          Text(
                            getTranslated(context, "Driving License Back"),
                            //   'Driving License Back',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff757575),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }

  Future<bool> showExitPanCard(int valuef, valueb) async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => AlertDialog(
            title: Center(
                child: Text(getTranslated(context, "Pan card"),
                    //'Pan Card',
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F368C)))),
            content: Row(
              // crossAxisAlignment: CrossAxisAlignment.s,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      camGallPopup(valuef);
                    },
                    child: Container(
                      width: 150,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: colors.primary),
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        getTranslated(context, "Pan Card Front"),
                        // 'Pan Card Front',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff757575),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      camGallPopup(valueb);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: colors.primary),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          Text(
                            getTranslated(context, "Pan Card Back"),
                            //'Pan Card Back',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff757575),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ) ??
        false;
  }

  Future<bool> showExitPopupa(int valuef, valueb) async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => AlertDialog(
              title: Center(
                  child: Text(getTranslated(context, "Upload Aadhar Card"),
                      //'Upload Aadhar Card',
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F368C)))),
              content: Row(
                // crossAxisAlignment: CrossAxisAlignment.s,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);

                        camGallPopup(valuef);
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: colors.primary),
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                              getTranslated(context, "Aadhar Card Front"),
                              //'Aadhar Card Front',
                              style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff757575)))),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);

                        camGallPopup(valueb);
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: colors.primary),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              Text(getTranslated(context, "Aadhar Card Back"),
                                  //'Aadhar Card Back',
                                  style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff757575))),
                            ],
                          )),
                    ),
                  ),
                ],
              )),
        ) ??
        false; //if showDialouge had returned null, then return false
  }

  Future<bool> showExitPopupr(int valuef, valueb) async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => AlertDialog(
              title: Center(
                  child: Text(getTranslated(context, "Upload Rc"),
                      //  'Upload Rc',
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F368C)))),
              content: Row(
                // crossAxisAlignment: CrossAxisAlignment.s,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);

                        camGallPopup(valuef);
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: colors.primary),
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(getTranslated(context, "Rc Front"),
                              //'Rc Front',
                              style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff757575)))),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);

                        camGallPopup(valueb);
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: colors.primary),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              Text(getTranslated(context, "Rc Back"),
                                  //'Rc Back',
                                  style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff757575))),
                            ],
                          )),
                    ),
                  ),
                ],
              )),
        ) ??
        false; //if showDialouge had returned null, then return false
  }

  Position? location;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //inIt();
    //getStateApi();
  }

  inIt() async {
    location = await getUserCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.primary,
      body: Form(
        key: _formKey,
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: ListView(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                //  padding: EdgeInsets.only(top: 50, left: 20, right: 20),
                height: MediaQuery.of(context).size.height * 0.15,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(color: colors.primary),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          getTranslated(context, "Sign Up"),
                          // 'Sign Up',
                          style: const TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NeedHelp()));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Text(
                              getTranslated(context, "NEED_HELP"),
                              // 'Need Help ?',
                              style: const TextStyle(
                                  color: colors.primary, fontSize: 12),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      getTranslated(context, "Welcome to PickPort"),
                      // 'Welcome to Pickport',
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: TextFormField(
                          inputFormatters: [UpperCaseTextFormatter()],
                          textCapitalization: TextCapitalization.characters,
                          controller: VhicleController,
                          keyboardType: TextInputType.name,
                          maxLength: 10,
                          decoration: InputDecoration(
                              counterText: "",
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Image.asset(
                                  'assets/images/VEHICLE NUMBER.png',
                                  scale: 1.4,
                                  color: colors.secondary,
                                ),
                              ),
                              contentPadding:
                                  const EdgeInsets.only(top: 22, left: 0),
                              border: InputBorder.none,
                              hintText: getTranslated(context, "Vehicle_number")
                              //  "  Vehicle Number",
                              ),
                          validator: (v) {
                            if (v!.isEmpty) {
                              return getTranslated(
                                  context, "Vehicle Number is required");
                              // "  Vehicle Number is required";
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: TextFormField(
                          readOnly: true,
                          maxLength: 10,
                          onTap: () {
                            if (VhicleController.text.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Please Enter Vehicle Number");
                            } else {
                              camGallPopup(7);
                            }
                          },
                          // controller: addressController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            counterText: "",
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Image.asset(
                                'assets/images/PROFILE PHOTO.png',
                                scale: 1.3,
                                color: colors.secondary,
                              ),
                            ),
                            contentPadding:
                                const EdgeInsets.only(top: 22, left: 5),
                            border: InputBorder.none,
                            hintText: getTranslated(context, "Profile Photo"),
                            // "Profile Photo",
                          ),
                          // validator: (v) {
                          //   if (v!.isEmpty) {
                          //     return "Profile Photo is required";
                          //   }
                          // },
                        ),
                      ),
                    ),
                    imageFile != null
                        ? Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Card(
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Container(
                                  height: 140,
                                  width: 150,
                                  decoration: BoxDecoration(
                                      color: CustomColors.TransparentColor,
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          image:
                                              FileImage(File(imageFile!.path)),
                                          fit: BoxFit.fill)),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),

                    // InkWell(
                    //   onTap: () => showExitPopup3(),
                    //   child: Card(
                    //     elevation: 1,
                    //     shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(10)),
                    //     child: Container(
                    //       height: 115,
                    //       width: double.infinity,
                    //       decoration: BoxDecoration(
                    //           color: CustomColors.TransparentColor,
                    //           borderRadius: BorderRadius.circular(10)),
                    //       child: Column(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           const Icon(
                    //             Icons.file_copy,
                    //             color: CustomColors.accentColor,
                    //           ),
                    //           const Text(
                    //             'Upload(Profile Photo)*',
                    //             style: TextStyle(color: Colors.red),
                    //           ),
                    //           const SizedBox(
                    //             height: 5,
                    //           ),
                    //           imageFile == null
                    //               ? const SizedBox()
                    //               : Container(
                    //             height: 60,
                    //             width: 200,
                    //             child: ClipRRect(
                    //                 borderRadius:
                    //                 BorderRadius.circular(10),
                    //                 child: Image.file(
                    //                   imageFile ?? File(''),
                    //                   fit: BoxFit.fill,
                    //                 )),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    const SizedBox(
                      height: 5,
                    ),
                    Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: TextFormField(
                          readOnly: true,
                          maxLength: 10,
                          onTap: () {
                            // camGallPopup(8);
                            // if(imageFile != null){
                            if (imageFile == null) {
                              Fluttertoast.showToast(
                                  msg: "Please Upload Profile");
                            } else {
                              showExitPanCard(8, 9);
                            }

                            // }
                          },
                          controller: panController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            counterText: "",
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Icon(
                                Icons.location_city,
                                size: 30,
                                color: CustomColors.accentColor,
                              ),
                            ),
                            contentPadding:
                                const EdgeInsets.only(top: 22, left: 5),
                            border: InputBorder.none,
                            hintText: getTranslated(context, "Pan card"),
                            //  "Pan Card",
                          ),
                          // validator: (v) {
                          //   if (v!.isEmpty) {
                          //     return "Pan Card is required";
                          //   }
                          // },
                        ),
                      ),
                    ),
                    panCardFile != null
                        ? Row(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Expanded(
                                child: Card(
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Container(
                                    height: 115,
                                    decoration: BoxDecoration(
                                      color: CustomColors.TransparentColor,
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          image: FileImage(
                                              File(panCardFile!.path)),
                                          fit: BoxFit.fill),
                                    ),
                                  ),
                                ),
                              ),
                              pancardBackFile != null
                                  ? Expanded(
                                      child: Card(
                                        elevation: 1,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Container(
                                          height: 115,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color:
                                                CustomColors.TransparentColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: DecorationImage(
                                                image: FileImage(
                                                  File(pancardBackFile!.path),
                                                ),
                                                fit: BoxFit.fill),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Expanded(child: const SizedBox.shrink()),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                    // Card(
                    //   elevation: 1,
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(10),
                    //   ),
                    //   child: Container(
                    //     height: 60,
                    //     decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(10),
                    //         color: CustomColors.TransparentColor),
                    //     child: TextFormField(
                    //       controller: LicenceController,
                    //       decoration: const InputDecoration(
                    //         prefixIcon: Padding(
                    //           padding: EdgeInsets.only(top: 10),
                    //           child: Icon(
                    //             Icons.lock,
                    //             color: CustomColors.accentColor,
                    //           ),
                    //         ),
                    //         contentPadding: EdgeInsets.only(top: 22, left: 5),
                    //         border: InputBorder.none,
                    //         hintText: "Driving License",
                    //       ),
                    //       validator: (v) {
                    //         if (v!.isEmpty) {
                    //           return "  Driving License is required";
                    //         }
                    //       },
                    //     ),
                    //   ),
                    // ),
                    Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: TextFormField(
                          readOnly: true,
                          maxLength: 10,
                          onTap: () {
                            // if(panCardFile != null && pancardBackFile != null){
                            if (panCardFile == null) {
                              Fluttertoast.showToast(
                                  msg: "Please Upload Pan Card Image");
                            } else if (pancardBackFile == null) {
                              Fluttertoast.showToast(
                                  msg: "Please Upload Pan Card Back Image");
                            } else {
                              showExitPopupl(1, 2);
                            }
                          },
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            counterText: "",
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Image.asset(
                                'assets/images/DRIVING LICENSE.png',
                                scale: 1.5,
                                color: colors.secondary,
                              ),
                            ),
                            contentPadding:
                                const EdgeInsets.only(top: 22, left: 0),
                            border: InputBorder.none,
                            hintText: getTranslated(context, "Driving License"),
                            // "Driving License ",
                          ),
                          // validator: (v) {
                          //   if (v!.isEmpty) {
                          //     return "Driving License is required";
                          //   }
                          // },
                        ),
                      ),
                    ),

                    drivingLicenseFile != null
                        ? Row(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Expanded(
                                child: Card(
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Container(
                                    height: 115,
                                    decoration: BoxDecoration(
                                        color: CustomColors.TransparentColor,
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                            image: FileImage(
                                                File(drivingLicenseFile!.path)),
                                            fit: BoxFit.fill)),
                                  ),
                                ),
                              ),
                              drivingLicenseBackFile != null
                                  ? Expanded(
                                      child: Card(
                                        elevation: 1,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Container(
                                          height: 115,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              color:
                                                  CustomColors.TransparentColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                  image: FileImage(File(
                                                      drivingLicenseBackFile!
                                                          .path)),
                                                  fit: BoxFit.fill)),
                                        ),
                                      ),
                                    )
                                  : Expanded(child: const SizedBox.shrink()),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                    const SizedBox(
                      height: 5,
                    ),
                    Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: TextFormField(
                          readOnly: true,
                          maxLength: 10,
                          onTap: () {
                            // if(panCardFile != null && pancardBackFile != null){
                            if (drivingLicenseFile == null) {
                              Fluttertoast.showToast(
                                  msg: "Please Upload Driving Card Image");
                            } else if (drivingLicenseBackFile == null) {
                              Fluttertoast.showToast(
                                  msg: "PleaseUpload Driving Card Back Image");
                            } else {
                              camGallPopup(10);
                            }
                          },
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            counterText: "",
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Image.asset(
                                'assets/images/autonomous-car.png',
                                scale: 1,
                                color: colors.secondary,
                              ),
                            ),
                            contentPadding:
                                const EdgeInsets.only(top: 22, left: 0),
                            border: InputBorder.none,
                            hintText: getTranslated(context, "Vehicle Image"),
                          ),
                        ),
                      ),
                    ),

                    vehicleImage != null
                        ? Row(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Expanded(
                                child: Card(
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Container(
                                    height: 115,
                                    decoration: BoxDecoration(
                                        color: CustomColors.TransparentColor,
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                            image: FileImage(
                                                File(vehicleImage!.path)),
                                            fit: BoxFit.fill)),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                    const SizedBox(
                      height: 5,
                    ),
                    Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: TextFormField(
                          readOnly: true,
                          maxLength: 10,
                          onTap: () {
                            // if(drivingLicenseFile != null && drivingLicenseBackFile != null){
                            if (vehicleImage == null) {
                              Fluttertoast.showToast(
                                  msg: "Please Upload Vehicle Image");
                            } else {
                              showExitPopupa(3, 4);
                            }

                            // }

                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => PlacePicker(
                            //       apiKey: Platform.isAndroid
                            //           ? "AIzaSyBzuKMLLDC-mXOCj13b8Gsyd93pmIoZwRM"
                            //           : "AIzaSyBzuKMLLDC-mXOCj13b8Gsyd93pmIoZwRM",
                            //       onPlacePicked: (result) {
                            //         print(result.formattedAddress);
                            //         setState(() {
                            //           addressController.text =
                            //               result.formattedAddress.toString();
                            //           lat = result.geometry!.location.lat;
                            //           long = result.geometry!.location.lng;
                            //         });
                            //         Navigator.of(context).pop();
                            //       },
                            //       initialPosition: const LatLng(22.719568, 75.857727),
                            //       useCurrentLocation: true,
                            //     ),
                            //   ),
                            // );
                          },
                          //    controller: addressController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            counterText: "",
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Image.asset(
                                'assets/images/AADHAR CARD.png',
                                scale: 1.5,
                                color: colors.secondary,
                              ),
                            ),
                            contentPadding:
                                const EdgeInsets.only(top: 22, left: 0),
                            border: InputBorder.none,
                            hintText: getTranslated(context, "Aadhar Card"),
                            //  "Aadhar Card ",
                          ),
                          // validator: (v) {
                          //   if (v!.isEmpty) {
                          //     return "Aadhar Card  is required";
                          //   }
                          // },
                        ),
                      ),
                    ),

                    aadharCardFrontFile != null
                        ? Row(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Expanded(
                                child: Card(
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Container(
                                    height: 115,
                                    decoration: BoxDecoration(
                                        color: CustomColors.TransparentColor,
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                            image: FileImage(File(
                                                aadharCardFrontFile!.path)),
                                            fit: BoxFit.fill)),
                                  ),
                                ),
                              ),
                              aadharCardBackFile != null
                                  ? Expanded(
                                      child: Card(
                                        elevation: 1,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Container(
                                          height: 115,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              color:
                                                  CustomColors.TransparentColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                  image: FileImage(File(
                                                      aadharCardBackFile!
                                                          .path)),
                                                  fit: BoxFit.fill)),
                                        ),
                                      ),
                                    )
                                  : Expanded(child: const SizedBox.shrink()),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),

                    const SizedBox(
                      height: 5,
                    ),
                    // Card(
                    //   elevation: 1,
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(10),
                    //   ),
                    //   child: Container(
                    //     height: 60,
                    //     decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(10),
                    //         color: CustomColors.TransparentColor),
                    //     child: TextFormField(
                    //       controller: rcController,
                    //       decoration: const InputDecoration(
                    //         prefixIcon: Padding(
                    //           padding: EdgeInsets.only(top: 10),
                    //           child: Icon(
                    //             Icons.lock,
                    //             color: CustomColors.accentColor,
                    //           ),
                    //         ),
                    //         contentPadding: EdgeInsets.only(top: 22, left: 5),
                    //         border: InputBorder.none,
                    //         hintText: "RC",
                    //       ),
                    //       validator: (v) {
                    //         if (v!.isEmpty) {
                    //           return "  RC is required";
                    //         }
                    //       },
                    //     ),
                    //   ),
                    // ),

                    Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: TextFormField(
                          readOnly: true,
                          maxLength: 10,
                          onTap: () {
                            // if(aadharCardFrontFile != null && aadharCardBackFile != null){
                            if (aadharCardFrontFile == null) {
                              Fluttertoast.showToast(
                                  msg: "Please Upload Aadhar Card Image");
                            } else if (aadharCardBackFile == null) {
                              Fluttertoast.showToast(
                                  msg: "Please Upload Aadhar Card Back Image");
                            } else {
                              showExitPopupr(5, 6);
                            }

                            // }

                            // showExitPopup(3);
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => PlacePicker(
                            //       apiKey: Platform.isAndroid
                            //           ? "AIzaSyBzuKMLLDC-mXOCj13b8Gsyd93pmIoZwRM"
                            //           : "AIzaSyBzuKMLLDC-mXOCj13b8Gsyd93pmIoZwRM",
                            //       onPlacePicked: (result) {
                            //         print(result.formattedAddress);
                            //         setState(() {
                            //           addressController.text =
                            //               result.formattedAddress.toString();
                            //           lat = result.geometry!.location.lat;
                            //           long = result.geometry!.location.lng;
                            //         });
                            //         Navigator.of(context).pop();
                            //       },
                            //       initialPosition: const LatLng(22.719568, 75.857727),
                            //       useCurrentLocation: true,
                            //     ),
                            //   ),
                            // );
                          },
                          //  controller: addressController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            counterText: "",
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Image.asset(
                                'assets/images/RC.png',
                                scale: 1.4,
                                color: colors.secondary,
                              ),
                            ),
                            contentPadding:
                                const EdgeInsets.only(top: 22, left: 0),
                            border: InputBorder.none,
                            hintText: getTranslated(context, "RC"),
                            //"RC ",
                          ),
                          // validator: (v) {
                          //   if (v!.isEmpty) {
                          //     return "RC is required";
                          //   }
                          // },
                        ),
                      ),
                    ),

                    rcFrontFile != null
                        ? Row(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Expanded(
                                child: Card(
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Container(
                                    height: 115,
                                    decoration: BoxDecoration(
                                        color: CustomColors.TransparentColor,
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                            image: FileImage(
                                                File(rcFrontFile!.path)),
                                            fit: BoxFit.fill)),
                                  ),
                                ),
                              ),
                              rcBackFile != null
                                  ? Expanded(
                                      child: Card(
                                        elevation: 1,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Container(
                                          height: 115,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              color:
                                                  CustomColors.TransparentColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                  image: FileImage(
                                                      File(rcBackFile!.path)),
                                                  fit: BoxFit.fill)),
                                        ),
                                      ),
                                    )
                                  : Expanded(child: const SizedBox.shrink()),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                    const SizedBox(
                      height: 5,
                    ),
                    Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: TextFormField(
                          controller: addressController,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(
                                top: 20,
                              ),
                              prefixIcon: Image.asset(
                                'assets/images/ADDRESS.png',
                                height: 10,
                                width: 10,
                                color: colors.secondary,
                              ),
                              hintText: getTranslated(context, "Address"),
                              // "Address",
                              border: InputBorder.none),
                          readOnly: true,
                          onTap: () {
                            if (rcFrontFile == null) {
                              Fluttertoast.showToast(
                                  msg: "Please Upload RC Image");
                            } else if (rcBackFile == null) {
                              Fluttertoast.showToast(
                                  msg: "Please Upload RC Back Image");
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlacePicker(
                                    hintText: "Address",
                                    apiKey: Platform.isAndroid
                                        ? "AIzaSyBzuKMLLDC-mXOCj13b8Gsyd93pmIoZwRM"
                                        : "AIzaSyBzuKMLLDC-mXOCj13b8Gsyd93pmIoZwRM",
                                    onPlacePicked: (result) {
                                      print(result.formattedAddress);
                                      setState(() {
                                        addressController.text =
                                            result.formattedAddress.toString();
                                        lat = result.geometry!.location.lat;
                                        long = result.geometry!.location.lng;
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    initialPosition:
                                        const LatLng(22.719568, 75.857727),
                                    useCurrentLocation: true,
                                  ),
                                ),
                              );
                              // .then((value) => getStateApi());
                            }
                          },
                          validator: (v) {
                            if (v!.isEmpty) {
                              return getTranslated(
                                  context, "Address is required");
                              // "  Address is required";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),

                    GestureDetector(
                      onTap: () {
                        if (addressController.text.isEmpty) {
                          Fluttertoast.showToast(msg: "Please Enter Address");
                        } else {
                          if (getStatusModel == null) {
                            getStateApi();
                          }
                        }
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          //set border radius more than 50% of height and width to make circle
                        ),
                        elevation: 1,
                        child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white),
                            child: Row(
                              children: [
                                const Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 8),
                                      child: Icon(
                                        Icons.location_city,
                                        size: 30,
                                        color: CustomColors.accentColor,
                                      ),
                                    )),
                                Expanded(
                                  flex: 10,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2<GetCityList>(
                                      isExpanded: true,
                                      //hint:  Text(getTranslated(context, "State"),
                                      hint: Text(
                                        getTranslated(context, "State"),
                                        // "State",
                                        style: const TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18),
                                      ),
                                      value: getCityList,

                                      // icon:  Icon(Icons.keyboard_arrow_down_rounded,  color:Secondry,size: 25,),
                                      style: const TextStyle(
                                          color: colors.secondary,
                                          fontWeight: FontWeight.bold),
                                      underline: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 0, top: 4),
                                        child: Container(
                                          // height: 2,
                                          color: colors.whiteTemp,
                                        ),
                                      ),
                                      onChanged: (GetCityList? value) {
                                        setState(() {
                                          getStateList = null;
                                          getCityList = value!;
                                          stateId = getCityList?.stateId;
                                          getCityApi(stateId!);
                                          //animalCountApi(animalCat!.id);
                                        });
                                      },
                                      items: getStatusModel?.data?.map((items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 2),
                                                child: Container(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 0),
                                                    child: Text(
                                                      items.stateName
                                                          .toString(),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (getCityList == null) {
                          Fluttertoast.showToast(msg: "Please Select State");
                        } else {
                          // if(getCityModel == null) {
                          //   getCityApi(getCityList!.stateId.toString());
                          // }
                        }
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          //set border radius more than 50% of height and width to make circle
                        ),
                        elevation: 1,
                        child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white),
                            child: Row(
                              children: [
                                const Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 8),
                                      child: Icon(
                                        Icons.location_city,
                                        size: 30,
                                        color: CustomColors.accentColor,
                                      ),
                                    )),
                                Expanded(
                                  flex: 10,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2<GetStateList>(
                                      isExpanded: true,
                                      //hint:  Text(getTranslated(context, "City"),
                                      hint: Text(
                                        getTranslated(context, "City"),
                                        //"City",
                                        style: const TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18),
                                      ),
                                      value: getStateList,

                                      // icon:  Icon(Icons.keyboard_arrow_down_rounded,  color:Secondry,size: 25,),
                                      style: const TextStyle(
                                          color: colors.secondary,
                                          fontWeight: FontWeight.bold),
                                      underline: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 0, top: 4),
                                        child: Container(
                                          // height: 2,
                                          color: colors.whiteTemp,
                                        ),
                                      ),
                                      onChanged: (GetStateList? value) {
                                        setState(() {
                                          getStateList = value!;
                                          cityId = getStateList?.cityId;
                                          //animalCountApi(animalCat!.id);
                                        });
                                      },
                                      items: getCityModel?.data?.map((items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 2),
                                                child: Container(
                                                    child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 0),
                                                  child: Text(
                                                    items.cityName.toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                )),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),

                    Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: TextFormField(
                          controller: referController,
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Image.asset(
                                'assets/images/REFERAL ODE.png',
                                scale: 1.3,
                                color: colors.secondary,
                              ),
                            ),
                            contentPadding:
                                const EdgeInsets.only(top: 22, left: 5),
                            border: InputBorder.none,
                            hintText: getTranslated(
                                context, "Referral Code (Optional)"),
                            //  "Referral Code (Optional)",
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getTranslated(context, "Vehicle type"),
                            // "Vehicle type",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 8,
                          ),

                          Column(
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            selected = 1;
                                            print(
                                                '____Som______${selected}_________');
                                          });
                                        },
                                        child: Container(
                                          child: Row(
                                            children: [
                                              Icon(
                                                selected == 1
                                                    ? Icons.radio_button_checked
                                                    : Icons.radio_button_off_outlined,
                                                color: colors.secondary,
                                                size: 20,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                getTranslated(
                                                    context, "2 Wheeler Gear"),
                                                // '2 Wheeler Gear',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            selected = 5;
                                          });
                                        },
                                        child: Container(
                                          child: Row(
                                            children: [
                                              Icon(
                                                selected == 5
                                                    ? Icons.radio_button_checked
                                                    : Icons.radio_button_off_outlined,
                                                color: colors.secondary,
                                                size: 20,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "${getTranslated(context, "3 Wheeler")}     ",

                                                // 'Mahindra Pickup',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            selected = 3;
                                            print(
                                                '____Som__ddd____${selected}_________');
                                          });
                                        },
                                        child: Container(
                                          child: Row(
                                            children: [
                                              Icon(
                                                selected == 3
                                                    ? Icons.radio_button_checked
                                                    : Icons.radio_button_off_outlined,
                                                color: colors.secondary,
                                                size: 20,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                getTranslated(
                                                    context, "Mahindra Pickup"),
                                                //'3 Wheeler',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            selected = 6;
                                          });
                                        },
                                        child: Container(
                                          child: Row(
                                            children: [
                                              Icon(
                                                selected == 6
                                                    ? Icons.radio_button_checked
                                                    : Icons.radio_button_off_outlined,
                                                color: colors.secondary,
                                                size: 20,
                                              ),
                                              const SizedBox(
                                                width: 2,
                                              ),
                                              Text(
                                                getTranslated(
                                                    context, "2 Wheeler Non Gear"),
                                                // '2 Wheeler Non Gear',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            selected = 4;
                                          });
                                        },
                                        child: Container(
                                          child: Row(
                                            children: [
                                              Icon(
                                                selected == 4
                                                    ? Icons.radio_button_checked
                                                    : Icons.radio_button_off_outlined,
                                                color: colors.secondary,
                                                size: 20,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "${getTranslated(context, "Tata Ace")}                 ",

                                                // 'Tata 407',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            selected = 2;
                                          });
                                        },
                                        child: Container(
                                          child: Row(
                                            children: [
                                              Icon(
                                                selected == 2
                                                    ? Icons.radio_button_checked
                                                    : Icons.radio_button_off_outlined,
                                                color: colors.secondary,
                                                size: 20,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                getTranslated(context, "Tato 407"),
                                                // 'Tata Ace',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            getTranslated(context, "Insurance"),
                            //  "Insurance",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Radio(
                                value: 0,
                                fillColor: MaterialStateColor.resolveWith(
                                        (states) => colors.secondary),
                                activeColor: colors.secondary,
                                groupValue: _value,
                                onChanged: (int? value) {
                                  setState(() {
                                    _value = value!;
                                    isNonAvailable = false;
                                  });
                                },
                              ),
                              Text(
                                getTranslated(context, "YES"),
                                // "Yes",
                                style: const TextStyle(fontSize: 15),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Radio(
                                  value: 1,
                                  fillColor: MaterialStateColor.resolveWith(
                                          (states) => colors.secondary),
                                  activeColor: colors.secondary,
                                  groupValue: _value,
                                  onChanged: (int? value) {
                                    setState(() {
                                      _value = value!;
                                      isAvailable = true;
                                    });
                                  }),
                              // SizedBox(width: 10.0,),
                              Text(
                                getTranslated(context, "NO"),
                                //"No",
                                style: const TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            getTranslated(context, "Pollution Emission"),
                            // "Pollution Emission",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Radio(
                                value: 0,
                                fillColor: MaterialStateColor.resolveWith(
                                        (states) => colors.secondary),
                                activeColor: colors.secondary,
                                groupValue: _value1,
                                onChanged: (int? value) {
                                  setState(() {
                                    _value1 = value!;
                                    isNonAvailable1 = false;
                                  });
                                },
                              ),
                              Text(
                                getTranslated(context, "YES"),
                                //   "Yes",
                                style: const TextStyle(fontSize: 15),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Radio(
                                  value: 1,
                                  fillColor: MaterialStateColor.resolveWith(
                                          (states) => colors.secondary),
                                  activeColor: colors.secondary,
                                  groupValue: _value1,
                                  onChanged: (int? value) {
                                    setState(() {
                                      _value1 = value!;
                                      isAvailable1 = true;
                                    });
                                  }),
                              // SizedBox(width: 10.0,),
                              Text(
                                getTranslated(context, "NO"),
                                //  "No",
                                style: const TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // selected == 0
                    //     ?
                    // Container(
                    //   child: Row(children: [
                    //     InkWell(
                    //       onTap: () {
                    //         setState(() {
                    //           isTerm = !isTerm;
                    //         });
                    //       },
                    //       child: Icon(
                    //         isTerm
                    //             ? Icons.check_box_outlined
                    //             : Icons.check_box_outline_blank,
                    //         color: colors.secondary,
                    //       ),
                    //     ),
                    //     const SizedBox(
                    //       width: 5,
                    //     ),
                    //      Text(
                    //       getTranslated(context, "I agree to all"),
                    //       //'I agree to all ',
                    //       style: const TextStyle(
                    //           fontSize: 12, fontWeight: FontWeight.bold),
                    //     ),
                    //     InkWell(
                    //       onTap: () {
                    //         Navigator.push(
                    //             context,
                    //             MaterialPageRoute(
                    //                 builder: (context) =>
                    //                     TermsConditionsWidget()));
                    //       },
                    //       // onTap: () {
                    //
                    //       //   //Navigator.push(context, MaterialPageRoute(builder: (context)=>TermsAndConditionScreen()));
                    //       // },
                    //       child: Text(
                    //         getTranslated(context, "T&C"),
                    //        // "T&C",
                    //         // getTranslated(context, "Terms and Conditions"),
                    //         style: const TextStyle(
                    //           fontSize: 12,
                    //           fontWeight: FontWeight.bold,
                    //           color: colors.primary,
                    //         ),
                    //       ),
                    //     ),
                    //     const SizedBox(
                    //       width: 5,
                    //     ),
                    //     const Text(
                    //       '& ',
                    //       style: TextStyle(
                    //           fontSize: 12, fontWeight: FontWeight.bold),
                    //     ),
                    //     const SizedBox(
                    //       width: 2,
                    //     ),
                    //     InkWell(
                    //       onTap: () {
                    //         Navigator.push(
                    //             context,
                    //             MaterialPageRoute(
                    //                 builder: (context) => privacy_policy()));
                    //       },
                    //       child: Text(
                    //          getTranslated(context, "Privacy Policy"),
                    //         //"Privacy Policy",
                    //         style: const TextStyle(
                    //             fontSize: 12,
                    //             fontWeight: FontWeight.bold,
                    //             color: colors.primary),
                    //       ),
                    //     ),
                    //   ]),
                    // ),
                    // : Container(),

                    Padding(
                      padding: const EdgeInsets.only(top: 70.0),
                      child: InkWell(
                        onTap: () {
                          bool isValidateFiles = isValidate();
                          if (_formKey.currentState!.validate() &&
                              isValidateFiles) {
                            signUpAPISECOND();
                          } else {
                            // Fluttertoast.showToast(
                            //     msg: getTranslated(context, "All field are required"));
                            // "All field are required");
                          }
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: colors.primary,
                                borderRadius: BorderRadius.circular(15)),
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: isLoading ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                getTranslated(context, "Next"),
                                // 'Next',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            )),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 320,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 38.0),
                        child: Row(
                          children: [
                            Text(
                              getTranslated(
                                  context, "Already have an account?"),
                              //   'Already have an Account?'
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()));
                                },
                                child: Text(
                                  getTranslated(context, "Login"),
                                  // 'Login',
                                  style:
                                      const TextStyle(color: colors.secondary),
                                ))
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 80,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isValidate() {
    // if (imageFile == null ||
    //     panCardFile == null ||
    //     pancardBackFile == null ||
    //     drivingLicenseFile == null ||
    //     drivingLicenseBackFile == null ||
    //     aadharCardFrontFile == null ||
    //     aadharCardBackFile == null ||
    //     rcFrontFile == null ||
    //     rcBackFile == null ||
    //     getCityList == null ||
    //     getStateList == null) {

    //   Fluttertoast.showToast(msg: "Please Select All Fields");
    // }
    if (panCardFile == null) {
      Fluttertoast.showToast(msg: "Please Select Pan Card Front Image");
    }
    if (VhicleController.text == "") {
      Fluttertoast.showToast(msg: "Please enter vehicle number");
    }
    if (pancardBackFile == null) {
      Fluttertoast.showToast(msg: "Please Select Pan Card Back Image");
    }
    if (drivingLicenseFile == null) {
      Fluttertoast.showToast(msg: "Please Select Driving License Front Image");
    }
    if (drivingLicenseBackFile == null) {
      Fluttertoast.showToast(msg: "Please Select Driving License Back Image");
    }
    if (aadharCardFrontFile == null) {
      Fluttertoast.showToast(msg: "Please Select Aadhar Card Front Image");
    }
    if (aadharCardBackFile == null) {
      Fluttertoast.showToast(msg: "Please Select Aadhar Card Back Image");
    }
    if (rcFrontFile == null) {
      Fluttertoast.showToast(msg: "Please Select RC Front Image");
    }
    if (rcBackFile == null) {
      Fluttertoast.showToast(msg: "Please Select RC Back Image");
    }
    if (getCityList == null) {
      Fluttertoast.showToast(msg: "Please Select State");
    }
    if (getStateList == null) {
      Fluttertoast.showToast(msg: "Please Select City");
    } else {
      if (pancardBackFile != null &&
          imageFile != null &&
          drivingLicenseFile != null &&
          drivingLicenseBackFile != null &&
          aadharCardFrontFile != null &&
          aadharCardBackFile != null &&
          rcFrontFile != null &&
          rcBackFile != null &&
          getCityList != null &&
          getStateList != null) {
        return true;
      } else {
        Fluttertoast.showToast(msg: "Please Select All Fields");
        return false;
      }
    }
    return false;
  }

  String? stateId;
  GetCityList? getCityList;
  GetStatusModel? getStatusModel;
  getStateApi() async {
    var headers = {
      'Cookie': 'ci_session=72caa85cedaa1a0d8ccc629445189f73af6a9946'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('${Urls.baseUrl}Authentication/api_get_state'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var finalResult = GetStatusModel.fromJson(json.decode(result));
      setState(() {
        getStatusModel = finalResult;
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  bool isLoading = false;
  String? cityId;
  GetStateList? getStateList;
  GetCityModel? getCityModel;

  getCityApi(String stateId) async {
    var headers = {
      'Cookie': 'ci_session=c59791396657a1155df9f32cc7d7b547a40d648c'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('${Urls.baseUrl}Authentication/api_get_city'));
    request.fields.addAll({'state_id': stateId.toString()});

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var finalResult = GetCityModel.fromJson(json.decode(result));
      setState(() {
        getCityModel = finalResult;
      });
      setState(() {
        // Fluttertoast.showToast(msg: "${finalResult['message']}");
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  bool isVisible = false;
  bool isVisible1 = false;
  bool isTerm = false;
  int selected = 1;

  int _value = 0;
  bool isNonAvailable = false;
  bool isAvailable = false;

  int _value1 = 0;
  bool isNonAvailable1 = false;
  bool isAvailable1 = false;
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
        text: newValue.text.toUpperCase(), selection: newValue.selection);
  }
}
