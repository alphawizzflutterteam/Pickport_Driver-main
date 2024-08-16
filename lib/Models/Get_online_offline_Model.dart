/// status : false
/// message : "Data Get Successfully!"
/// data : [{"id":"10","user_id":"469","online_time":"18:28 PM","ofline_time":"18:28 PM","created_at":"2024-01-27 18:28:38","total_time":0},{"id":"11","user_id":"469","online_time":"18:30 PM","ofline_time":"18:31 PM","created_at":"2024-01-27 18:31:59","total_time":1}]

class GetOnlineOfflineModel {
  GetOnlineOfflineModel({
    bool? status,
    String? message,
    List<OnlineData>? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  GetOnlineOfflineModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(OnlineData.fromJson(v));
      });
    }
  }
  bool? _status;
  String? _message;
  List<OnlineData>? _data;
  GetOnlineOfflineModel copyWith({
    bool? status,
    String? message,
    List<OnlineData>? data,
  }) =>
      GetOnlineOfflineModel(
        status: status ?? _status,
        message: message ?? _message,
        data: data ?? _data,
      );
  bool? get status => _status;
  String? get message => _message;
  List<OnlineData>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : "10"
/// user_id : "469"
/// online_time : "18:28 PM"
/// ofline_time : "18:28 PM"
/// created_at : "2024-01-27 18:28:38"
/// total_time : 0

class OnlineData {
  OnlineData({
    String? id,
    String? userId,
    String? onlineTime,
    String? oflineTime,
    String? createdAt,
    num? totalTime,
  }) {
    _id = id;
    _userId = userId;
    _onlineTime = onlineTime;
    _oflineTime = oflineTime;
    _createdAt = createdAt;
    _totalTime = totalTime;
  }

  OnlineData.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['user_id'];
    _onlineTime = json['online_time'];
    _oflineTime = json['ofline_time'];
    _createdAt = json['created_at'];
    _totalTime = json['total_time'];
  }
  String? _id;
  String? _userId;
  String? _onlineTime;
  String? _oflineTime;
  String? _createdAt;
  num? _totalTime;
  OnlineData copyWith({
    String? id,
    String? userId,
    String? onlineTime,
    String? oflineTime,
    String? createdAt,
    num? totalTime,
  }) =>
      OnlineData(
        id: id ?? _id,
        userId: userId ?? _userId,
        onlineTime: onlineTime ?? _onlineTime,
        oflineTime: oflineTime ?? _oflineTime,
        createdAt: createdAt ?? _createdAt,
        totalTime: totalTime ?? _totalTime,
      );
  String? get id => _id;
  String? get userId => _userId;
  String? get onlineTime => _onlineTime;
  String? get oflineTime => _oflineTime;
  String? get createdAt => _createdAt;
  num? get totalTime => _totalTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['user_id'] = _userId;
    map['online_time'] = _onlineTime;
    map['ofline_time'] = _oflineTime;
    map['created_at'] = _createdAt;
    map['total_time'] = _totalTime;
    return map;
  }
}
