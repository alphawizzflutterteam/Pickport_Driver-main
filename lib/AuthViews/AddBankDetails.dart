import 'dart:convert';
import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jdx/AuthViews/LoginScreen.dart';
import 'package:jdx/AuthViews/SignUpScreen.dart';
import 'package:jdx/AuthViews/registraionSuccess.dart';
import 'package:jdx/Utils/CustomColor.dart';
import 'package:http/http.dart' as http;
import 'package:jdx/Views/GetHelp.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/ApiPath.dart';
import '../Utils/Color.dart';
import '../Views/HelpScreen.dart';
import '../services/session.dart';

class AddBankDetails extends StatefulWidget {
  AddBankDetails(
      {Key? key,
      this.name,
      this.mobile,
      this.email,
      this.address,
      this.adhar,
      this.long,
      this.lat,
      this.cPass,
      this.Licence,
      this.pan,
      this.pass,
      this.rc,
      this.refer,
      this.vcNo,
      this.image,
      this.cID,
      this.sId,
      this.Insurance,
      this.pollution,
      this.vType})
      : super(key: key);
  String? name,
      email,
      mobile,
      adhar,
      Licence,
      rc,
      vcNo,
      pan,
      refer,
      pass,
      cPass,
      address,
      image,
      cID,
      sId,
      Insurance,
      pollution;
  int? vType;
  double? lat, long;
  @override
  State<AddBankDetails> createState() => _AddBankDetailsState();
}

class _AddBankDetailsState extends State<AddBankDetails> {
  String? bankName;
  TextEditingController accountHolderName = TextEditingController();
  TextEditingController accountNumber = TextEditingController();
  TextEditingController ifscCode = TextEditingController();

  List<String> banksList = [
    "Punjab National Bank (PNB)",
    "Bank of Baroda (BoB)",
    "Bank of India (BoI)",
    'Central Bank of India',
    'Canara Bank',
    'Union Bank of India',
    'Indian Overseas Bank (IOB)',
    'Punjab and Sind Bank',
    'Indian Bank',
    'UCO Bank',
    'Bank of Maharashtra',
    'State Bank of India (SBI)',
    "Axis Bank Ltd.",
    "Bandhan Bank Ltd.",
    "CSB Bank Ltd.",
    "City Union Bank Ltd.",
    "DCB Bank Ltd.",
    "Dhanlaxmi Bank Ltd.",
    "Federal Bank Ltd.",
    "HDFC Bank Ltd",
    "ICICI Bank Ltd.",
    "Induslnd Bank Ltd",
    "IDFC First Bank Ltd.",
    "Jammu & Kashmir Bank Ltd.",
    "Karnataka Bank Ltd.",
    "Karur Vysya Bank Ltd.",
    "Kotak Mahindra Bank Ltd",
    "Nainital Bank Ltd.",
    "RBL Bank Ltd.",
    "South Indian Bank Ltd.",
    "Tamilnad Mercantile Bank Ltd.",
    "YES Bank Ltd.",
    "IDBI Bank Ltd."
  ];

  int selected = 0;
  final _formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();
  File? imageFile1;

  _getFromGallery(int vall) async {
    PickedFile? pickedFile = await _picker.getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      if (vall == 1) {
        setState(() {
          imageFile1 = File(pickedFile.path);
        });
      }
    }
  }

  _getCamera(int vall) async {
    PickedFile? pickedFile = await _picker.getImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      if (vall == 1) {
        setState(() {
          imageFile1 = File(pickedFile.path);
        });
      }
    }
  }

  Future<bool> camGallPopup(int value) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Center(
              child: Text(
                getTranslated(context, "Upload Passbook/ Cancel Check"),
                // getTranslated(context, "Pic Image"),
                // 'Pic Image',
                style: const TextStyle(
                    fontSize: 18,
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

  @override
  Widget build(BuildContext context) {
    print('____Som___ddddd___${widget.vType}_________');
    return Scaffold(
      backgroundColor: colors.primary,
      body: Container(
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              //  padding: EdgeInsets.only(top: 50, left: 20, right: 20),
              height: MediaQuery.of(context).size.height * 0.12,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(color: colors.primary),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        getTranslated(context, "Add Bank Details"),
                        //  'Add Bank Details',
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
                              borderRadius: BorderRadius.circular(5)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Text(
                            getTranslated(context, "NEED_HELP"),
                            // 'Get Help ?',
                            style: const TextStyle(
                                color: colors.primary, fontSize: 12),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        getTranslated(context,
                            "For Verification , Please  upload a bank  details"),
                        //  getTranslated(context, "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters"),
                        // 'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
              ),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Card(
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
                              Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Image.asset(
                                      'assets/images/BANK NAME.png',
                                      scale: 1.3,
                                      color: colors.secondary,
                                    ),
                                  )),
                              Expanded(
                                flex: 10,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2<String>(
                                    isExpanded: true,
                                    //hint:  Text(getTranslated(context, "State"),
                                    hint: Text(
                                      getTranslated(context, "Bank Name"),
                                      // "State",
                                      style: const TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18),
                                    ),
                                    value: bankName,

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
                                    onChanged: (String? value) {
                                      setState(() {
                                        bankName = value;
                                        //animalCountApi(animalCat!.id);
                                      });
                                    },
                                    items: banksList.map((items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 2),
                                              child: Container(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 0),
                                                  child: Text(
                                                    items,
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
                    const SizedBox(
                      height: 15,
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
                          controller: accountHolderName,
                          keyboardType: TextInputType.name,
                          textCapitalization: TextCapitalization.words,
                          onTap: () {
                            if (bankName == null) {
                              Fluttertoast.showToast(
                                  msg: "Please Select Bank Name");
                            }
                          },
                          readOnly: bankName == null ? true : false,
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Image.asset(
                                'assets/images/Name.png',
                                scale: 1.7,
                                color: colors.secondary,
                              ),
                            ),
                            contentPadding:
                                const EdgeInsets.only(top: 22, left: 5),
                            border: InputBorder.none,
                            hintText: getTranslated(context, "Enter name mentioned in your Bank account")
                                , // getTranslated(context, "Account Holder Name"),
                            // "Account Holder Name",
                          ),
                          validator: (v) {
                            if (v!.isEmpty) {
                              return getTranslated(
                                  context, "Account Holder Name is required");
                              // return "Account Holder Name is required";
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
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
                            controller: accountNumber,
                            maxLength: 18,
                            onTap: () {
                              if (accountHolderName.text.isEmpty) {
                                Fluttertoast.showToast(
                                    msg: "Please Enter Account Holder Name");
                              }
                            },
                            readOnly:
                                accountHolderName.text.isEmpty ? true : false,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Image.asset(
                                    'assets/images/ACCOUNT  NUMBER.png',
                                    scale: 1.3,
                                    color: colors.secondary,
                                  ),
                                ),
                                counterText: "",
                                contentPadding:
                                    const EdgeInsets.only(top: 18, left: 5),
                                border: InputBorder.none,
                                hintText:
                                    getTranslated(context, "Account Number")
                                // "Account Number",
                                ),
                            validator: (v) {
                              if (v!.isEmpty) {
                                return getTranslated(
                                    context, "Account Number is required");
                                // "IFSC Code is required";
                              } else if (v.length < 8) {
                                return "Enter Minimum 8 Digit Account Number";
                              }
                              // else if(v.length < 18){
                              //   return "Enter Maximum 18 Digit Account Number ";
                              // }
                            }),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
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
                          inputFormatters: [UpperCaseTextFormatter()],
                          textCapitalization: TextCapitalization.characters,
                          controller: ifscCode,
                          onTap: () {
                            if (accountNumber.text.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Please Enter Account Number");
                            } else if (accountNumber.text.length < 9) {
                              Fluttertoast.showToast(
                                  msg: "Enter Minimum 9 Digit Account Number");
                            }
                          },
                          readOnly: accountNumber.text.isEmpty ||
                                  accountNumber.text.length < 9
                              ? true
                              : false,
                          maxLength: 11,
                          // keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Image.asset(
                                  'assets/images/IFSC CODE.png',
                                  scale: 1.3,
                                  color: colors.secondary,
                                ),
                              ),
                              counterText: "",
                              contentPadding:
                                  const EdgeInsets.only(top: 18, left: 5),
                              border: InputBorder.none,
                              hintText: getTranslated(context, "IFSC Code")
                              //"IFSC Code",
                              ),
                          validator: (v) {
                            if (v!.isEmpty) {
                              return getTranslated(
                                  context, "IFSC Code is required");
                              // "IFSC Code is required";
                            } else if (v.length < 11) {
                              return "Enter Valid IFSC Code";
                            }
                          },
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 15,
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
                            if (ifscCode.text.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Please Enter IFSC Code");
                            } else if (ifscCode.text.length < 11) {
                              Fluttertoast.showToast(
                                  msg: "Enter Valid IFSC Code");
                            } else {
                              camGallPopup(1);
                            }
                          },
                          // controller: addressController,
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
                                const EdgeInsets.only(top: 20, left: 5),
                            border: InputBorder.none,
                            hintText: getTranslated(
                                context, "Upload Passbook/ Cancel Check"),
                            //"Upload passbook/ Cancel Check",
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

                    imageFile1 != null
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
                                  height: 115,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: CustomColors.TransparentColor,
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          image:
                                              FileImage(File(imageFile1!.path)),
                                          fit: BoxFit.fill)),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),

                    Text(
                      getTranslated(context, "Account Type"),
                      // 'Account Type',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              selected = 0;
                            });
                          },
                          child: Container(
                            child: Row(
                              children: [
                                Icon(
                                  selected == 0
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_off_outlined,
                                  color: colors.secondary,
                                  size: 16,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  getTranslated(context, "Saving Account "),
                                  // 'Saving Account',
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              selected = 1;
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
                                  size: 16,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  getTranslated(context, "Current Account "),
                                  //'Current Account',
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 70.0),
                      child: InkWell(
                        onTap: () {
                          if (bankName == null) {
                            Fluttertoast.showToast(
                                msg: "Please Select Bank Name");
                          } else if (imageFile1 == null) {
                            Fluttertoast.showToast(
                                msg: "Please Upload Passbook/ Cancel Check");
                          } else if (_formKey.currentState!.validate() &&
                              imageFile1 != null &&
                              bankName != null) {
                            // signUpApi();
                            signUp();
                          }
                          // else if(selected == ""){
                          //   Fluttertoast.showToast(msg:
                          //   getTranslated(context, "Select Account Type"),
                          //     // "Select Account Type"
                          //   );
                          // }
                          else {
                            Fluttertoast.showToast(
                              msg:
                                  getTranslated(context, "Fill All The Fields"),
                            );
                          }
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: colors.primary,
                                borderRadius: BorderRadius.circular(15)),
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Center(
                              child: isLoding == true
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : Text(
                                      getTranslated(context, "Sign Up"),
                                      // 'Sign Up',
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // Center(
                    //   child: Container(
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         Text('Already have an Account?'),
                    //         InkWell(
                    //             onTap: () {
                    //               Navigator.push(
                    //                   context,
                    //                   MaterialPageRoute(
                    //                       builder: (context) => LoginScreen()));
                    //             },
                    //             child: Text(
                    //               ' Login',
                    //               style: TextStyle(color: colors.secondary),
                    //             ))
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 50,
                      width: 290,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 38.0),
                        child: Row(
                          children: [
                            Text(
                              getTranslated(
                                  context, "Already have an account?"),
                              //    'Already have an Account?'
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
                                  //  'Login',
                                  style:
                                      const TextStyle(color: colors.secondary),
                                ))
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  bool? isLoding = false;

  signUp() async {
    setState(() {
      isLoding = true;
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
      'bank_name': bankName ?? "",
      'account_holder_name': accountHolderName.text,
      'account_number': accountNumber.text,
      'ifsc_code': ifscCode.text,
      'account_type': selected.toString()
    });

    print('____Som______${request.fields}_________');

    request.files.add(
        await http.MultipartFile.fromPath('check_book', '${imageFile1?.path}'));
    print('____Som___request.files___${request.files}_________');
    request.headers.addAll(headers);
    print('____Som___request.files___${request.files}_________');
    http.StreamedResponse response = await request.send();
    //print(await response.stream.bytesToString());
    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var finalResult = jsonDecode(result);
      setState(() {
        isLoding = false;
      });
      if (finalResult['status'] == true) {
        Fluttertoast.showToast(msg: "${finalResult['message']}");
        setState(() {});
        imageFile = null;
        drivingLicenseBackFile = null;
        drivingLicenseFile = null;
        rcBackFile = null;
        rcFrontFile = null;
        aadharCardBackFile = null;
        aadharCardFrontFile = null;
        panCardFile = null;
        pancardBackFile = null;
        imageFile1 = null;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RegistrationSuccessScreen()));
      } else {
        setState(() {
          isLoding = false;
        });
        Fluttertoast.showToast(msg: "${finalResult['message']}");
      }
    } else {
      setState(() {
        isLoding = false;
      });
      print(response.reasonPhrase);
    }
  }

  signUpApi() async {
    setState(() {
      isLoding = true;
    });
    var headers = {
      'Cookie': 'ci_session=f71fdd0b4cece7410bf8aa176b4fbff6e9afb34c'
    };
    var request = http.MultipartRequest('POST',
        Uri.parse('${Urls.baseUrl}Authentication/deliveryBoyRegistration'));
    request.fields.addAll({
      'user_fullname': widget.name.toString(),
      'user_phone': widget.mobile.toString(),
      'user_email': widget.email.toString(),
      'vehicle_no': widget.vcNo.toString(),
      'pan_card': widget.pan.toString(),
      'driving_licence_no': widget.Licence.toString(),
      'aadhaar_card_no': widget.adhar.toString(),
      'rc_number': widget.rc.toString(),
      'address': widget.address.toString(),
      'state_id': widget.sId.toString(),
      'city_id': widget.cID.toString(),
      'user_password': widget.pass.toString(),
      'refferal_code': widget.refer.toString(),
      'vehicle_type': widget.vType.toString(),
      'vehicle_insurance': widget.Insurance.toString(),
      'pollution_emission': widget.pollution.toString(),
      'firebaseToken': '',
      'bank_name': bankName ?? "",
      'account_holder_name': accountNumber.text,
      'account_number': accountHolderName.text,
      'ifsc_code': ifscCode.text,
      'account_type': selected.toString()
    });
    print('____Som______${request.fields}_________');
    request.files.add(
        await http.MultipartFile.fromPath('user_image', imageFile?.path ?? ""));
    print('____Som______${request.files}_________');
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var finalResult = jsonDecode(result);
      Fluttertoast.showToast(msg: "${finalResult['message']}");
      setState(() {
        isLoding = false;
      });
      if (finalResult['status'] == true) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        Fluttertoast.showToast(msg: "${finalResult['message']}");
      }
    } else {
      setState(() {
        isLoding = false;
      });
      print(response.reasonPhrase);
    }
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
        text: newValue.text.toUpperCase(), selection: newValue.selection);
  }
}
