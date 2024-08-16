// To parse this JSON data, do
//
//     final driverFeedbackModel = driverFeedbackModelFromJson(jsonString);

import 'dart:convert';

DriverFeedbackModel driverFeedbackModelFromJson(String str) =>
    DriverFeedbackModel.fromJson(json.decode(str));

String driverFeedbackModelToJson(DriverFeedbackModel data) =>
    json.encode(data.toJson());

class DriverFeedbackModel {
  bool? status;
  String? message;
  List<DatumFeedback>? data;

  DriverFeedbackModel({
    this.status,
    this.message,
    this.data,
  });

  factory DriverFeedbackModel.fromJson(Map<String, dynamic> json) =>
      DriverFeedbackModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<DatumFeedback>.from(
                json["data"]!.map((x) => DatumFeedback.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class DatumFeedback {
  String? id;
  String? parcelId;
  String? deliveryBoyId;
  String? userId;
  String? rating;
  String? feedback;
  DateTime? createdDate;
  String? userFullname;

  DatumFeedback({
    this.id,
    this.parcelId,
    this.deliveryBoyId,
    this.userId,
    this.rating,
    this.feedback,
    this.createdDate,
    this.userFullname,
  });

  factory DatumFeedback.fromJson(Map<String, dynamic> json) => DatumFeedback(
        id: json["id"],
        parcelId: json["parcel_id"],
        deliveryBoyId: json["delivery_boy_id"],
        userId: json["user_id"],
        rating: json["rating"],
        feedback: json["feedback"],
        createdDate: json["created_date"] == null
            ? null
            : DateTime.parse(json["created_date"]),
        userFullname: json["user_fullname"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "parcel_id": parcelId,
        "delivery_boy_id": deliveryBoyId,
        "user_id": userId,
        "rating": rating,
        "feedback": feedback,
        "created_date": createdDate?.toIso8601String(),
        "user_fullname": userFullname,
      };
}
