/// status : true
/// total : 1035
/// data : [{"order_id":"319","title":"Agricultural Equipment","shipping_charge":"0","parcel_weight":"10","admin_commission":"5","driver_amount":"45"},{"order_id":"318","title":"Test","shipping_charge":"0","parcel_weight":"10","admin_commission":"5","driver_amount":"45"},{"order_id":"317","title":"Agricultural Equipment","shipping_charge":"0","parcel_weight":"10","admin_commission":0,"driver_amount":0},{"order_id":"316","title":"Agricultural Equipment","shipping_charge":"0","parcel_weight":"0","admin_commission":0,"driver_amount":0},{"order_id":"315","title":"Machinery","shipping_charge":"0","parcel_weight":"10","admin_commission":"5","driver_amount":"45"},{"order_id":"314","title":"Machinery","shipping_charge":"0","parcel_weight":"0","admin_commission":"0","driver_amount":"0"},{"order_id":"313","title":"Machinery","shipping_charge":"0","parcel_weight":"0","admin_commission":0,"driver_amount":0},{"order_id":"309","title":"Ceramic","shipping_charge":"0","parcel_weight":"10","admin_commission":0,"driver_amount":0},{"order_id":"274","title":"Ceramic","shipping_charge":"0","parcel_weight":"500","admin_commission":"100","driver_amount":"900"},{"order_id":"264","title":"Machinery","shipping_charge":"0","parcel_weight":"0","admin_commission":"0","driver_amount":"0"}]
/// message : "successfully"

class DriverEarnModel {
  DriverEarnModel({
      bool? status, 
      String? total, 
      List<DriverEarningData>? data, 
      String? message, String? total_cod,}){
    _status = status;
    _total = total;
    _total_cod = total_cod;
    _data = data;
    _message = message;
}

  DriverEarnModel.fromJson(dynamic json) {
    _status = json['status'];
    _total = json['total'];
    _total_cod = json['total_cod'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(DriverEarningData.fromJson(v));
      });
    }
    _message = json['message'];
  }
  bool? _status;
  String? _total;
  String? _total_cod;
  List<DriverEarningData>? _data;
  String? _message;
DriverEarnModel copyWith({  bool? status,
  String? total,
  String? total_cod,
  List<DriverEarningData>? data,
  String? message,
}) => DriverEarnModel(  status: status ?? _status,
  total: total ?? _total,
  total_cod: total_cod ?? _total_cod,
  data: data ?? _data,
  message: message ?? _message,
);
  bool? get status => _status;
  String? get total => _total;
  String? get total_cod => _total_cod;
  List<DriverEarningData>? get data => _data;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['total'] = _total;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    map['message'] = _message;
    return map;
  }

}

/// order_id : "319"
/// title : "Agricultural Equipment"
/// shipping_charge : "0"
/// parcel_weight : "10"
/// admin_commission : "5"
/// driver_amount : "45"

class DriverEarningData {
  DriverEarningData({
      String? orderId, 
      String? title,
      String? payment_method,
      String? date_time,
      String? shippingCharge, 
      String? parcelWeight, 
      dynamic adminCommission,
    dynamic driverAmount,}){
    _orderId = orderId;
    _title = title;
    _payment_method = payment_method;
    _date_time=date_time;
    _shippingCharge = shippingCharge;
    _parcelWeight = parcelWeight;
    _adminCommission = adminCommission;
    _driverAmount = driverAmount;
}

  DriverEarningData.fromJson(dynamic json) {
    _orderId = json['order_id'];
    _title = json['title'];
    _payment_method = json['payment_method'];
    _date_time=json['date_time'];
    _shippingCharge = json['shipping_charge'];
    _parcelWeight = json['parcel_weight'];
    _adminCommission = json['admin_commission'];
    _driverAmount = json['driver_amount'];
  }
  String? _orderId;
  String? _title;
  String? _payment_method;
  String? _date_time;
  String? _shippingCharge;
  String? _parcelWeight;
  dynamic _adminCommission;
  dynamic _driverAmount;
DriverEarningData copyWith({  String? orderId,
  String? title,
  String? shippingCharge,
  String? payment_method,
  String? date_time,
  String? parcelWeight,
  dynamic adminCommission,
  dynamic driverAmount,
}) => DriverEarningData(  orderId: orderId ?? _orderId,
  title: title ?? _title,
  shippingCharge: shippingCharge ?? _shippingCharge,
  date_time: date_time??_date_time,
  parcelWeight: parcelWeight ?? _parcelWeight,
  payment_method: payment_method ?? _payment_method,
  adminCommission: adminCommission ?? _adminCommission,
  driverAmount: driverAmount ?? _driverAmount,
);
  String? get orderId => _orderId;
  String? get title => _title;
  String? get shippingCharge => _shippingCharge;
  String? get parcelWeight => _parcelWeight;
  String? get payment_method => _payment_method;
  String? get dateTime => _date_time;
  dynamic get adminCommission => _adminCommission;
  dynamic get driverAmount => _driverAmount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['order_id'] = _orderId;
    map['title'] = _title;
    map['shipping_charge'] = _shippingCharge;
    map['parcel_weight'] = _parcelWeight;
    map['admin_commission'] = _adminCommission;
    map['driver_amount'] = _driverAmount;
    return map;
  }

}