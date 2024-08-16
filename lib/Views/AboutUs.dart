import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:jdx/Utils/ApiPath.dart';
import '../Models/About_model.dart';
import '../Models/GetTmc.dart';
import '../Models/privacypolicymodel.dart';
import '../Utils/AppBar.dart';
import '../Utils/Color.dart';
import 'package:http/http.dart' as http;

import '../services/session.dart';
import 'SupportNewScreen.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTermCondition();
  }

  var privacyData;

  AboutModel? aboutModel;
  GetTmc? gettmc;

  //  Text("${aboutModel?.data?.first.title}"),
  //                   Text("${aboutModel?.data?.first.description}")

  getTermCondition() async {
    var headers = {
      'Cookie': 'ci_session=c6e9b8fa5907fd26fe43fffdfc36c4433f340576'
    };
    var request = http.MultipartRequest(
        'GET', Uri.parse('${Urls.baseUrl}Users/About?type=3'));
    // request.fields.addAll({
    //   'type': '3'
    // });
    log('${Urls.baseUrl}Users/About?type=3');

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final result = await response.stream.bytesToString();
      var ResultTMC = GetTmc.fromJson(jsonDecode(result));
      print(" this is tmccccccccccccccccc${ResultTMC.toJson().toString()}");
      setState(() {
        try {
          gettmc = ResultTMC;
        } catch (stactrace, error) {
          log(stactrace.toString());
          log(error.toString());
        }
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  get() async {
    var headers = {
      'Cookie': 'ci_session=4598d6ec5c3975e6954777d948d0580900a0e8e6'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('${Urls.baseUrl}Authentication/about_us_both'));
    request.fields.addAll({'type': '2'});

    http.StreamedResponse response = await request.send();
    print('____Som______${request}_________');
    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var finaResult = AboutModel.fromJson(jsonDecode(result));
      setState(() {
        aboutModel = finaResult;
        print('____Som______${aboutModel}_________');
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
          SizedBox(
            height: 25,
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: colors.whiteTemp,
                          borderRadius: BorderRadius.circular(100)),
                      child: Center(child: Icon(Icons.arrow_back)),
                    ),
                  ),
                  Text(
                    getTranslated(context, "About Us"),
                    style: TextStyle(color: colors.whiteTemp, fontSize: 18),
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        color: colors.splashcolor,
                        borderRadius: BorderRadius.circular(100)),
                    child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const SupportNewScreen()));
                        },
                        child: const Icon(
                          Icons.headset_rounded,
                          color: Colors.black,
                        )),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 18,
            child: Container(
              decoration: BoxDecoration(
                  color: colors.background,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(35),
                      topLeft: Radius.circular(35))),
              child: gettmc == null || gettmc == ""
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView(
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Html(data: "${gettmc!.data!.pgDescri}"),
                        ],
                      ),
                    ),
            ),
          )
        ],
      ),
    );
  }
}
