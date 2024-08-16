import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Utils/Color.dart';
import '../Models/Get_online_offline_Model.dart';
import '../Models/NewContactModel.dart';
import '../Models/contactus.dart';
import '../Utils/ApiPath.dart';
import '../services/session.dart';

class OnlineOfflineHistoryScreen extends StatefulWidget {
  const OnlineOfflineHistoryScreen({Key? key}) : super(key: key);

  @override
  State<OnlineOfflineHistoryScreen> createState() =>
      _OnlineOfflineHistoryScreenState();
}

class _OnlineOfflineHistoryScreenState
    extends State<OnlineOfflineHistoryScreen> {
  void initState() {
    // TODO: implement initState
    super.initState();
    onlineOfflineHistoryApi();
  }

  GetOnlineOfflineModel? getOnlineOfflineModel;
  List<OnlineData> data = [];
  List<OnlineData> filterList = [];

  applyFilters() {
    filterList.clear();
    print("Length: ${data.length}");
    for (var i = 0; i < data.length; i++) {
      print("DateTimw: ${DateTime.parse(data[i].createdAt.toString())}");
      if (DateTime.parse(data[i].createdAt.toString()).isAfter(startDate) &&
          (DateTime.parse(data[i].createdAt.toString()).isBefore(endDate) ||
              DateTime.parse(data[i].createdAt.toString()).day ==
                  endDate.day)) {
        filterList.add(data[i]);
      }
    }
    setState(() {});
  }

  onlineOfflineHistoryApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString("userId");

    var headers = {
      'Cookie': 'ci_session=ccd29ed97897179805eae4af31f61c9124290627'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('${Urls.baseUrl}Payment/login_logout_hrs'));
    request.fields.addAll({'user_id': userId.toString()});
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var finalResult = GetOnlineOfflineModel.fromJson(json.decode(result));
      setState(() {
        getOnlineOfflineModel = finalResult;
        data.addAll(getOnlineOfflineModel!.data!);
        filterList.addAll(data);
        print("Lengthhhhhh: ${data.length}");
        print(filterList.first.createdAt);
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  bool isStart = false;
  bool isEnd = false;
  Future<void> _selectDate(BuildContext context, int status) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2022),
        lastDate: DateTime.now());
    if (picked != null) {
      setState(() {
        if (status == 1) {
          startDate = picked;
          isStart = true;
        } else {
          endDate = picked;
          isEnd = true;
        }
      });
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
              padding: const EdgeInsets.only(left: 20, right: 20),
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
                    const SizedBox(
                      width: 45,
                    ),
                    Text(
                      getTranslated(context, "OnlineOffline"),
                      style: const TextStyle(color: Colors.white, fontSize: 18),
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
                child: getOnlineOfflineModel == null ||
                        getOnlineOfflineModel == ""
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.filter_alt_rounded,
                                  color: Colors.black,
                                ),
                                const VerticalDivider(
                                  color: Colors.transparent,
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => _selectDate(context, 1),
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                      ),
                                      child: Text(isStart
                                          ? DateFormat('d/MM/y')
                                              .format(startDate)
                                          : getTranslated(context, "Start Date")),
                                    ),
                                  ),
                                ),
                                const VerticalDivider(
                                  color: Colors.transparent,
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => _selectDate(context, 2),
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                      ),
                                      child: Text(isEnd
                                          ? DateFormat('d/MM/y').format(endDate)
                                          : getTranslated(context, "End Date")),
                                    ),
                                  ),
                                ),
                                const VerticalDivider(
                                  color: Colors.transparent,
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      if (isStart && isEnd) {
                                        applyFilters();
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "Please select dates");
                                      }
                                    },
                                    child: Text(getTranslated(context, "Apply")))
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: filterList.isEmpty
                                  ?  Center(
                                      child: Text(getTranslated(context, "No data available")))
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      itemCount: filterList.length ?? 0,
                                      itemBuilder: (context, i) {
                                        return Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(getTranslated(context, "Checkin Time")),
                                                    Text(
                                                        "${filterList[i].onlineTime}")
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(getTranslated(context, "Checkout Time")),
                                                    Text(
                                                        "${filterList[i].oflineTime}")
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(getTranslated(context, "Date")),
                                                    Text(DateFormat('d/MM/y')
                                                        .format(DateTime.parse(
                                                            filterList[i]
                                                                .createdAt
                                                                .toString())))
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                     Text(getTranslated(context, "Total Time")),
                                                    Text(convertMinutesToHoursMinutesSeconds(
                                                        filterList[i]
                                                                .totalTime
                                                                .toString() ??
                                                            ""))
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                            ),
                          ),
                        ],
                      )),
          )
        ],
      ),
    );
  }

  String convertMinutesToHoursMinutesSeconds(String minutes) {
    int hours = int.parse(minutes) ~/ 60;
    int remainingMinutes = int.parse(minutes) % 60;
    int seconds = remainingMinutes * 60;

    print(
        '$minutes minutes is equal to $hours hours, $remainingMinutes minutes');
    return "$hours hrs, $remainingMinutes min";
  }
}
