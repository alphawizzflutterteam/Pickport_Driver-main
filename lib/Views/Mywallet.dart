import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:jdx/Utils/Color.dart';
import 'package:jdx/Views/NoInternetScreen.dart';
import 'package:jdx/Views/SupportNewScreen.dart';
import 'package:jdx/Views/withdrawal_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Controller/BottomNevBar.dart';
import '../Models/GetBalanceModel.dart';
import '../Models/GetProfileModel.dart';
import '../Models/WalletHistoryModel.dart';
import '../Utils/ApiPath.dart';
import '../services/session.dart';
import 'AddAmountwallet.dart';
import 'NotificationScreen.dart';
import 'package:http/http.dart' as http;

class MyWallet extends StatefulWidget {
  const MyWallet({Key? key}) : super(key: key);

  @override
  State<MyWallet> createState() => _MyWalletState();
}

class _MyWalletState extends State<MyWallet> {
  bool _isNetworkAvail = true;
  TextEditingController amountController = TextEditingController();

  WalletHistoryModel? walletHistorymodel;
  walletHistroy() async {
    _isNetworkAvail = await isNetworkAvailable();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString("userId");

    var headers = {
      'Content-Type': 'application/json',
      'Cookie': 'ci_session=fa798ca5ff74e60a6d79d768d0be8efac030321a'
    };
    var request = http.Request(
        'POST', Uri.parse('${Urls.baseUrl}Payment/wallet_history'));
    request.body = json.encode({
      "user_id": userId.toString(),
      'type': '0',
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    print(request.body);
    print(request.url);
    if (response.statusCode == 200) {
      print('Userr Id@@@@@@@${userId}');
      var finalResult = await response.stream.bytesToString();
      final jsonResponse =
          WalletHistoryModel.fromJson(json.decode(finalResult));
      setState(() {
        walletHistorymodel = jsonResponse;
        data.addAll(walletHistorymodel!.data!);
        filterList.addAll(data);
        print("Lengthhhhhh: ${data.length}");
        print(filterList.last.date);
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  GetProfileModel? getProfileModel;
  String qrCodeResult = "Not Yet Scanned";

  getProfile() async {
    _isNetworkAvail = await isNetworkAvailable();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString("userId");
    print(" this is  User++++++++++++++>$userId");
    var headers = {
      'Cookie': 'ci_session=6de5f73f50c4977cb7f3af6afe61f4b340359530'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('${Urls.baseUrl}User_Dashboard/getUserProfile'));
    request.fields.addAll({'user_id': userId.toString()});
    print(" this is  User++++++++++++++>${request.fields}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final result = await response.stream.bytesToString();
      var finalResult = GetProfileModel.fromJson(jsonDecode(result));
      print("thisi is============>$result");
      setState(() {
        getProfileModel = finalResult;
        wallet = "${getProfileModel!.data!.user!.wallet}";
        //Fluttertoast.showToast(msg: qrCodeResult);
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  List<WallethistoryData> data = [];
  List<WallethistoryData> filterList = [];
  applyFilters() {
    filterList.clear();
    print("Length: ${data.length}");
    for (var i = 0; i < data.length; i++) {
      print("DateTimw: ${DateTime.parse(data[i].date.toString())}");
      if (DateTime.parse(data[i].date.toString()).isAfter(startDate) &&
          (DateTime.parse(data[i].date.toString()).isBefore(endDate) ||
              DateTime.parse(data[i].date.toString()).day == endDate.day)) {
        print("asdf");
        filterList.add(data[i]);
      }
    }
    setState(() {});
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

  String? wallet;
  String? minimumBalance;
  @override
  void initState() {
    // TODO: implement initState
    getWalletBalance();
    walletHistroy();
    getProfile();
    super.initState();
  }

  GetBalanceModel? getBalanceModel;
  getWalletBalance() async {
    _isNetworkAvail = await isNetworkAvailable();
    var headers = {
      'Cookie': 'ci_session=c3663036678f59c6e1598643dc7b12f9ed509821'
    };
    var request = http.Request(
        'POST', Uri.parse('${Urls.baseUrl}Authentication/driver_min_wallet'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final result = await response.stream.bytesToString();
      var finalResult = GetBalanceModel.fromJson(jsonDecode(result));
      print("thisi is============>$result");
      setState(() {
        getBalanceModel = finalResult;
        minimumBalance = "${getBalanceModel!.data!.amt}";
        print("===============$minimumBalance===========");
        //Fluttertoast.showToast(msg: qrCodeResult);
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return _isNetworkAvail ?
          RefreshIndicator(
            onRefresh: ()async{
              walletHistroy();
              getProfile();
            },
            child: Scaffold(
      backgroundColor: colors.primary,
      body: Column(
        children: [
            const SizedBox(
              height: 35,
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BottomNav()));
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            color: colors.whiteTemp,
                            borderRadius: BorderRadius.circular(100)),
                        child: const Center(child: Icon(Icons.arrow_back)),
                      ),
                    ),
                    Spacer(),
                    Text(
                      getTranslated(context, "Pickport Wallet"),
                      //"Pickport Wallet",
                      style: TextStyle(color: colors.whiteTemp, fontSize: 18),
                    ),
                    Spacer(),
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
                                  builder: (context) => WithdrawalScreen()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ImageIcon(
                            AssetImage('assets/withdraw.png'),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
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
              flex: 17,
              child: Container(
                decoration: const BoxDecoration(
                    color: colors.background,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(35),
                        topLeft: Radius.circular(35))),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Center(
                            child: Text(
                          getTranslated(context, "Available Balance"),
                          //   "Available Balance",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        )),
                        const SizedBox(
                          height: 5,
                        ),
                        // Text( getTranslated(context, "Minimum Wallet Amount is ₹ $minimumBalance"),
                        //     style: const TextStyle(
                        //         fontSize: 15, fontWeight: FontWeight.w500)),
                        Text( "Minimum Wallet Amount is ₹ $minimumBalance",
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500)),
                        const SizedBox(
                          height: 5,
                        ),
                        // wallet == null || wallet == "" ? Text("₹ ${minimumBalance?? '0'}",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),):
                        Text(
                          wallet.toString() == "null"
                              ? "₹ 0"
                              : "₹ ${(wallet ?? '0')}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              //walletHistroy();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddAmount(
                                            walletBalance: wallet ?? '0.0',
                                          ))).then((value) => walletHistroy());
                              //  Get.to(AddAmount(walletBalance: wallet??'--',))?.then((value) => walletHistroy() );
                            }
                            // addMoney();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: colors.primary,
                            ),
                            height: 40,
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: Center(
                              child: Text(
                                getTranslated(context, "Add Money"),
                                // "Add Money",
                                style: TextStyle(
                                    color: colors.whiteTemp, fontSize: 15),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: [
                              Icon(
                                Icons.account_balance_wallet,
                                color: colors.primary,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                getTranslated(context, "Wallet History"),
                                // "WalletHistory",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
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
                                        horizontal: 12, vertical: 12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: Text(isStart
                                        ? DateFormat('d/MM/y').format(startDate)
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
                                        horizontal: 12, vertical: 12),
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
                        walletHistorymodel?.data != null
                            ? Container()
                            : SizedBox(
                                height: 20,
                              ),
                        walletHistorymodel?.data == null
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: colors.splashcolor,
                                ),
                              )
                            : filterList.isEmpty
                                ? Text(getTranslated(context, "No data available"))
                                : SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height * .5,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: filterList.length ?? 0,
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context, index) {
                                        var item = filterList[index];
                                        return Card(
                                          elevation: 2.0,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 4.0),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      getTranslated(
                                                          context, "Amount"),
                                                      style: TextStyle(
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      '₹${item?.amount}',
                                                      style: const TextStyle(
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 5.0),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      getTranslated(context,
                                                          "Payment Type"),
                                                      style: const TextStyle(
                                                          fontSize: 14.0),
                                                    ),
                                                    Text(
                                                      '${item?.paymentType}',
                                                      style: const TextStyle(
                                                          fontSize: 14.0),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 5.0),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      getTranslated(
                                                          context, "Status"),
                                                      style: const TextStyle(
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      '${item?.paymentStatus}',
                                                      style: const TextStyle(
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 5.0),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    // 'Date : ${item?.createDt}'
                                                    // "${DateFormat('dd/MM/yyyy').format( DateFormat('dd-MMM-yyyy').parse(item?.createDt))}",
                                                    Text( getTranslated(context,"Date" )
                                                      ,
                                                      style: const TextStyle(
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      "${DateFormat('dd/MM/yyyy').format(DateFormat('yyyy-MM-dd').parse(item?.date ?? ""))}", //createDt
                                                      style: const TextStyle(
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                      ],
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    ),
          )
        : NoInternetScreen(onPressed: (){
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
    });
  }
}
