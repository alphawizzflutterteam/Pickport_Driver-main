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
import 'package:jdx/AuthViews/sign.dart';
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
import 'SignUpScreen.dart';

class SignUpScreenBasicDetails extends StatefulWidget {
  const SignUpScreenBasicDetails({Key? key}) : super(key: key);

  @override
  State<SignUpScreenBasicDetails> createState() => _SignUpScreenBasicDetails();
}

class _SignUpScreenBasicDetails extends State<SignUpScreenBasicDetails> {
  singUpModel? information;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobController = TextEditingController();
  TextEditingController cPassController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController panController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isValidPhone = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.primary,
      body: Container(
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Image.asset(
                                'assets/images/Name.png',
                                scale: 1.3,
                                color: colors.secondary,
                              ),
                            ),
                            contentPadding:
                                const EdgeInsets.only(top: 22, left: 5),
                            border: InputBorder.none,
                            hintText: getTranslated(context, "Name"),
                            //"Name",
                          ),
                          validator: (v) {
                            if (v!.isEmpty) {
                              return getTranslated(context, "Name is required");
                              // "Name is required";
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
                          onTap: () {
                            if (nameController.text.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Please Enter Name First");
                            }
                          },
                          maxLength: 10,
                          readOnly: nameController.text.isEmpty ? true : false,
                          controller: mobController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              counterText: "",
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Image.asset(
                                  'assets/images/MOBILE NUMBER.png',
                                  scale: 1.3,
                                  color: colors.secondary,
                                ),
                              ),
                              contentPadding:
                                  const EdgeInsets.only(top: 22, left: 5),
                              border: InputBorder.none,
                              hintText: getTranslated(context, "Mobile number")
                              //"Mobile Number",
                              ),
                          validator: (v) {
                            if (v!.isEmpty) {
                              setState(() {
                                isValidPhone = false;
                              });
                              return getTranslated(
                                  context, "Mobile Number is required");
                              // "  Mobile Number is required";
                            } else if (v.length != 10) {
                              setState(() {
                                isValidPhone = false;
                              });
                              return getTranslated(
                                  context, "Mobile Number must be of 10 digit");
                              //"  Mobile Number must be of 10 digit";
                            } else {
                              setState(() {
                                isValidPhone = true;
                              });
                              return null;
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        //set border radius more than 50% of height and width to make circle
                      ),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: TextFormField(
                          onTap: () {
                            if (mobController.text.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Please Enter Mobile Number");
                            } else if (mobController.text.length != 10) {
                              Fluttertoast.showToast(
                                  msg: getTranslated(context,
                                      "Mobile Number must be of 10 digit"));
                            }
                          },
                          controller: emailController,
                          readOnly: mobController.text.isEmpty ||
                                  mobController.text.length != 10
                              ? true
                              : false,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Image.asset(
                                  'assets/images/EMAIL ID.png',
                                  scale: 1.3,
                                  color: colors.secondary,
                                ),
                              ),
                              contentPadding:
                                  const EdgeInsets.only(top: 22, left: 5),
                              border: InputBorder.none,
                              hintText: getTranslated(context, "Email id")
                              //  "Email Id",
                              ),
                          validator: (v) {
                            if (!v!.isEmpty && !v.contains("@")) {
                              return getTranslated(
                                  context, "Enter Valid Email Id");
                              // "  Email id is required";
                            }
                            // if (!v.contains("@")) {
                            //   return getTranslated(
                            //       context, "Enter Valid Email Id");
                            //   //"  Enter Valid Email Id";
                            // }
                          },
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 8,
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        //set border radius more than 50% of height and width to make circle
                      ),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: TextFormField(
                          onTap: () {
                            if (!emailRegExp.hasMatch(emailController.text) &&
                                emailController.text.isNotEmpty) {
                              Fluttertoast.showToast(
                                  msg: getTranslated(
                                      context, "Enter Valid Email Id"));
                            }
                          },
                          maxLength: 10,
                          obscureText: !isVisible,
                          readOnly: emailController.text.isNotEmpty
                              ? (emailRegExp.hasMatch(emailController.text))
                                  ? false
                                  : true
                              : false,
                          controller: passController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(top: 22),
                            counterText: "",
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none),
                            // hintText: getTranslated(context, "Password"),
                            hintText: getTranslated(context, "Password"),
                            // "Password",
                            prefixIcon: Image.asset(
                              'assets/images/Icon ionic-ios-lock.png',
                              scale: 1.3,
                              color: colors.secondary,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isVisible
                                      ? isVisible = false
                                      : isVisible = true;
                                });
                              },
                              icon: Icon(
                                isVisible
                                    ? Icons.remove_red_eye
                                    : Icons.visibility_off,
                                color: Colors.green,
                              ),
                            ),
                          ),
                          validator: (v) {
                            if (v!.isEmpty) {
                              return getTranslated(
                                  context, "Password is required");
                              //"  Password is required";
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        //set border radius more than 50% of height and width to make circle
                      ),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: TextFormField(
                          onTap: () {
                            if (passController.text.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Please Enter Password");
                            }
                          },
                          maxLength: 10,
                          readOnly: passController.text.isEmpty ? true : false,
                          obscureText: !isVisible1,
                          controller: cPassController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(top: 18),
                            counterText: "",
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none),
                            hintText:
                                getTranslated(context, "Confirm Password"),
                            // "Confirm Password",
                            prefixIcon: Image.asset(
                              'assets/images/Icon ionic-ios-lock.png',
                              scale: 1.3,
                              color: colors.secondary,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isVisible1
                                      ? isVisible1 = false
                                      : isVisible1 = true;
                                });
                              },
                              icon: Icon(
                                isVisible1
                                    ? Icons.remove_red_eye
                                    : Icons.visibility_off,
                                color: Colors.green,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return getTranslated(
                                  context, "Please confirm your password");
                              // '  Please confirm your password';
                            } else if (value != passController.text) {
                              return getTranslated(
                                  context, "Passwords do not match");
                              // '  Passwords do not match';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),

                    Container(
                      child: Row(children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              isTerm = !isTerm;
                            });
                          },
                          child: Icon(
                            isTerm
                                ? Icons.check_box_outlined
                                : Icons.check_box_outline_blank,
                            color: colors.secondary,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          getTranslated(context, "I agree to all"),
                          //'I agree to all ',
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TermsConditionsWidget()));
                          },
                          // onTap: () {

                          //   //Navigator.push(context, MaterialPageRoute(builder: (context)=>TermsAndConditionScreen()));
                          // },
                          child: Text(
                            getTranslated(context, "T&C"),
                            // "T&C",
                            // getTranslated(context, "Terms and Conditions"),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: colors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Text(
                          '& ',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => privacy_policy()));
                          },
                          child: Text(
                            getTranslated(context, "Privacy Policy"),
                            //"Privacy Policy",
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: colors.primary),
                          ),
                        ),
                      ]),
                    ),
                    // : Container(),

                    Padding(
                      padding: const EdgeInsets.only(top: 70.0),
                      child: InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            if (cPassController.text.isEmpty ||
                                (cPassController.text == passController.text)) {
                              if (isTerm == false) {
                                Fluttertoast.showToast(
                                    msg:
                                        "Please agree to all Terms & Conditions and Privacy Policy"
                                    // getTranslated(
                                    //     context, "I agree to all")
                                    );
                                // "I agree to all ");
                              } else {
                                checkEmail();
                              }
                              return;
                            } else if (cPassController.text !=
                                passController.text) {
                              Fluttertoast.showToast(
                                  msg: getTranslated(
                                      context, "Passwords do not match"));
                            } else {
                              Fluttertoast.showToast(
                                  msg: getTranslated(
                                      context, "Please confirm your password"));
                              // "All field are required");
                            }
                          }
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: colors.primary,
                                borderRadius: BorderRadius.circular(15)),
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: Text(
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
            ),
          ],
        ),
      ),
    );
  }

  validateForm(val) {
    if (val == "Email") {}
  }

  checkEmail() async {
    var headers = {
      'Cookie': 'ci_session=023100c1035f5f0b55db582760dbd86312368c54'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('${Urls.baseUrl}Authentication/checkField/email'));
    request.fields
        .addAll({'email': emailController.text, 'mobile': mobController.text});
    print('____Som______${request.fields}_________');
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var finalResult = jsonDecode(result);
      if (finalResult['status'] == false) {
        Fluttertoast.showToast(msg: "${finalResult['message']}");
      } else {
        signUpApi();
      }
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
      'firebaseToken': '',
    });

    print(request.fields.toString());

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final str = await response.stream.bytesToString();
      var finalData = json.decode(str);
      print(str.toString());
      Fluttertoast.showToast(msg: "${finalData['message']}");
      setState(() {
        // nameController.clear();
        // emailController.clear();
        // mobController.clear();
        // passController.clear();
      });
      // Fluttertoast.showToast(msg: "${finalData['data']['user_id']}");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("userId", finalData['data']['user_id'] ?? '');

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignUpScreen(
            mobile: mobController.text,
            name: nameController.text,
            cPass: cPassController.text,
            email: emailController.text,
            pass: passController.text,
          ),
        ),
      );
    } else {
      print(response.reasonPhrase);
    }
  }

  bool isLoading = false;

  RegExp emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

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
