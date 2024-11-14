import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:jdx/Utils/ApiPath.dart';

import '../Models/privacypolicymodel.dart';
import '../Utils/Color.dart';
import '../services/session.dart';

class privacy_policy extends StatefulWidget {
  @override
  State<privacy_policy> createState() => _privacy_policyState();
}

class _privacy_policyState extends State<privacy_policy> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPrivacy();
  }

  var privacyData;

  PrivacypolicyModel? privacypolicy;

  getPrivacy() async {
    var headers = {
      'Cookie': 'ci_session=e27b9a709e79f067f9b5f2e6f6541ff1595521a5'
    };
    var request = http.MultipartRequest(
        'GET', Uri.parse('${Urls.baseUrl}users/Privacy?type=3'));
    // request.fields.addAll({
    //   'type': '3'
    // });

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print("privacy-----------");
      var finalResponse = await response.stream.bytesToString();
      var jsonResponse = PrivacypolicyModel.fromJson(jsonDecode(finalResponse));
      print(" this is privacypolicyyy${jsonResponse.toJson().toString()}");
      setState(() {
        privacyData = jsonResponse.data;
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: colors.primary,
      body: Column(
        children: [
          const SizedBox(
            height: 35,
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 20),
              child: Container(
                color: colors.primary,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100)),
                        child: const Center(child: Icon(Icons.arrow_back)),
                      ),
                    ),
                    Expanded(
                      child: Container(
                          child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Center(
                            child: Text(
                          getTranslated(context, "Privacy Policy"),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        )),
                      )),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 18,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFDDEDFA),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Html(data: "${privacyData}"),
                      privacyData == null
                          ? Center(child: CircularProgressIndicator())
                          : Html(data: '${privacyData?.pgDescri}'),
                      // Text(
                      //         '${privacyData?.pgDescri}',
                      //         style: const TextStyle(
                      //           fontSize: 16,
                      //         ),
                      //       ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
    // Scaffold(
    //   backgroundColor: colors.whiteTemp,
    //   appBar: PreferredSize(
    //       preferredSize: const Size.fromHeight(80),
    //       child: commonAppBar(context, text:
    //       getTranslated(context, "Privacy Policy"),
    //     //  "Privacy & Policy"
    //       )),
    //   body: Container(
    //       padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
    //       decoration: const BoxDecoration(
    //
    //       ),
    //       child: privacyData == null || privacyData == ""
    //           ? const Center(
    //               child: CircularProgressIndicator(),
    //             )
    //           : Container(
    //               padding: const EdgeInsets.symmetric(
    //                   horizontal: 16, vertical: 10),
    //               decoration: const BoxDecoration(
    //                   borderRadius:
    //                       BorderRadius.only(topRight: Radius.circular(0)),
    //                   color: Colors.white),
    //               width: size.width,
    //               height: size.height,
    //               child: SingleChildScrollView(
    //                 child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     // Html(data: "${privacyData}"),
    //                     Text(
    //                       '${privacyData?.pgDescri}',
    //                       style: const TextStyle(
    //                         fontSize: 16,
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             )));
  }
}
