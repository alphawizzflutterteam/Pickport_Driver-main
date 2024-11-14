import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jdx/AuthViews/LoginScreen.dart';
import 'package:jdx/Controller/base_Controller/base_controller.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/order_history_response.dart';
import '../Utils/ApiPath.dart';
import '../services/api_services/api.dart';
import '../services/api_services/request_key.dart';
import '../services/location/location.dart';


class HomeController extends AppBaseController {
  bool isSwitched = true;

  Position? _position;

  @override
  void onInit() async{
    // TODO: implement onInit
    super.onInit();
    _position = await getUserCurrentPosition();
    startTimer();
    _initLocationService();

    // getOrders(status: '0');
  }
  Api api=Api();
  List<OrderHistoryData> currentOrderHistoryList = [];
  List<OrderHistoryData> schedOrderHistoryList = [];
  List isActive = [];
  bool isLoading=false;
  Timer? timer;

  Location location = Location();
  LocationData? _currentLocation;
  StreamSubscription<LocationData>? _locationSubscription;

  cancelTimer(){
    timer?.cancel();
  }

  startTimer(){
     timer = Timer.periodic(Duration(seconds: 10), (Timer t) async {
      _position = await getUserCurrentPosition();
      print("_position ${_position!.latitude}");
    });
  }

  Future<void> getOrders({required String status, required BuildContext context,})async{

    try{
      if(status=="0"){
        currentOrderHistoryList.clear();
      }else{
        schedOrderHistoryList.clear();
      }

      SharedPreferences prefs1 = await SharedPreferences.getInstance();
      String userId = prefs1.getString('userId').toString();
      String userToken = prefs1.getString('userToken').toString();
      print("UserToken>>>$userToken");
      isLoading=true;
      update();

      Map<String, String> body = {};
      body[RequestKeys.lat] = _position?.latitude.toString() ?? '';
      body[RequestKeys.long] = _position?.longitude.toString() ?? '';
      body[RequestKeys.userId1] = userId.toString() ?? '';
      body[RequestKeys.status] = status.toString();
      body[RequestKeys.uToken] = userToken.toString();
      var res = await api.getOrderHistoryData(body);
      if (res.status ?? false) {

        if(status=="0"){
          currentOrderHistoryList=res.data;
          update();
        }else{
          schedOrderHistoryList=res.data;
          update();
        }
        isActive.clear();
        isLoading=false;
        update();
      } else {
        //  Fluttertoast.showToast(msg: '${res.message}');
        if(res.message == "Invalid Token") {
           Fluttertoast.showToast(msg: '${res.message}');
           print("Logout Now-----------");
           prefs1.setString('userId', "");
           prefs1.setString("userToken", "");
           Fluttertoast.showToast(msg: res.message.toString());
           Navigator.pushReplacement(
               context, MaterialPageRoute(builder: (context) => LoginScreen()));
        } else {
          isLoading = false;
          update();
        }
      }
    }catch(e){
      throw Exception(e);
    }
  }

  Future <void> orderRejectedOrAccept(int index, BuildContext context, String status,String city,
      {bool? isRejected}) async {

    if (isRejected ?? false) {
      if(status=="0"){
        currentOrderHistoryList.removeAt(index);
      }else{
        schedOrderHistoryList.removeAt(index);
      }
      update();
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    var request = http.MultipartRequest(
        'POST', Uri.parse('${Urls.baseUrl}Payment/accept_order_request'));
    request.fields.addAll({
      'user_id': userId ?? '',
      'order_id':status=='0'?currentOrderHistoryList[index].orderId  :schedOrderHistoryList[index].orderId,
      'status': isRejected ?? false ? '0' : '2',
      "city": city
    });
    print('____Som___accept_order_request___${request.fields}_________');


    http.StreamedResponse response = await request.send();
    http.Response.fromStream(response).then((response) {
      print('___________${response.statusCode}__________');
      if (response.statusCode == 200) {
        print("____Som___accept_order_RESPONSE-----${response.body}");
        var json=jsonDecode(response.body);
        Fluttertoast.showToast(msg: json['message']);
        log(response.body);
        // getOrders(status: status, context: context);
      }
    });

    /*try {
      Map<String, String> body = {};
      body[RequestKeys.userId] = userId ?? '';
      body[RequestKeys.orderId] = orderHistoryList[index].orderId;
      body[RequestKeys.status] = isRejected ?? false ? '1' : '2';
      var res = await api.getedOrderData(body);


      if (res.status == 1) {
        print('_____success____');
        // responseData = res.data?.userid.toString();
        Fluttertoast.showToast(msg: res.message ?? '');
        setState(() {});  Fluttertoast.showToast(msg: "Something went wrong");
      } else {
        Fluttertoast.showToast(msg: res.message ?? '');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong");
    } finally {}*/
  }

  Future<void> _initLocationService() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    // Check if location services are enabled
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    // Check for location permissions
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

// Listen to location updates
    _locationSubscription =
        location.onLocationChanged.listen((LocationData currentLocation) {

            _currentLocation = currentLocation;

          // _updateLocationInFirebase(currentLocation);
        });
  }


  // Future<void> _updateLocationInFirebase(LocationData currentLocation) async {
  //   try {
  //     await FirebaseFirestore.instance.collection('drivers').doc('driverId').update({
  //       'latitude': currentLocation.latitude,
  //       'longitude': currentLocation.longitude,
  //     });
  //     print('Location updated in Firebase');
  //   } catch (e) {
  //     print('Error updating location: $e');
  //   }
  // }


}
