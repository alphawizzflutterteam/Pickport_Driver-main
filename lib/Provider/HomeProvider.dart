import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:jdx/services/api_services/api.dart';
import 'package:jdx/services/location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/order_history_response.dart';
import '../services/api_services/request_key.dart';

class HomeProvider extends GetxController{
  Position? _position;
  @override
  void onInit() async{
    // TODO: implement onInit
    super.onInit();

    _position = await getUserCurrentPosition();
    getOrders(status: '0');
  }
  Api api=Api();
  List<OrderHistoryData> orderHistoryList = [];
  List isActive = [];
  bool isLoading=false;
  Future<void> getOrders({required String status})async{
    try{
      SharedPreferences prefs1 = await SharedPreferences.getInstance();
      String userId = prefs1.getString('userId').toString();
      isLoading=true;
      update();
      Map<String, String> body = {};
      body[RequestKeys.lat] = _position?.latitude.toString() ?? '';
      body[RequestKeys.long] = _position?.longitude.toString() ?? '';
      body[RequestKeys.userId1] = userId.toString() ?? '';
      body[RequestKeys.status] = status.toString();
      var res = await api.getOrderHistoryData(body);
      print(body);
      print('____ffff__888888888____ggg_${res.data.toString()}__________');
      if (res.status ?? false) {

        orderHistoryList = res.data ;


        //Future.delayed(const Duration(seconds: 1), () {
        // print('One second has passed.'); // Prints after 1 second.
        isActive.clear();
        isLoading=false;

      update();
      } else {
        //  Fluttertoast.showToast(msg: '${res.message}');

        update();
      }
    }catch(e){}
  }
}