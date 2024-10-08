// To parse this JSON data, do
//
//     final getDriverRating = getDriverRatingFromJson(jsonString);

import 'dart:convert';

GetDriverRating getDriverRatingFromJson(String str) => GetDriverRating.fromJson(json.decode(str));

String getDriverRatingToJson(GetDriverRating data) => json.encode(data.toJson());


class GetDriverRating {
  bool? status;
  String? message;
  List<Rating>? rating;

  GetDriverRating({this.status, this.message, this.rating});

  GetDriverRating.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['rating'] != null) {
      rating = <Rating>[];
      json['rating'].forEach((v) {
        rating!.add(new Rating.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.rating != null) {
      data['rating'] = this.rating!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Rating {
  String? id;
  String? parcelId;
  String? deliveryBoyId;
  String? userId;
  String? rating;
  String? feedback;
  String? createdDate;
  String? userType;
  String? userPhone;
  Null? firstname;
  Null? lastname;
  String? userFullname;
  String? userEmail;
  Null? userBdate;
  String? userPassword;
  String? userCity;
  String? userState;
  String? varificationCode;
  Null? userImage;
  Null? pincode;
  Null? socityId;
  Null? houseNo;
  Null? mobileVerified;
  String? userGcmCode;
  Null? userIosToken;
  Null? varifiedToken;
  Null? address;
  String? status;
  Null? regCode;
  String? wallet;
  String? balance;
  String? rewards;
  Null? created;
  Null? modified;
  String? otp;
  String? otpStatus;
  Null? social;
  Null? facebookID;
  Null? isEmailVerified;
  Null? vehicleType;
  Null? vehicleNo;
  Null? vehicleImage;
  Null? drivingLicenceNo;
  Null? drivingLicencePhoto;
  Null? drivingLicencePhotoBack;
  Null? loginStatus;
  Null? isAvaible;
  Null? latitude;
  Null? longitude;
  String? referralCode;
  String? referralBy;
  Null? aadhaarCardNo;
  Null? aadhaarCardPhoto;
  Null? aadhaarCardPhotoBack;
  Null? qrCode;
  Null? accountHolderName;
  Null? accountNumber;
  Null? ifscCode;
  Null? bankName;
  String? accountType;
  Null? panCard;
  Null? panCardBack;
  Null? rcCardPhoto;
  Null? rcCardPhotoBack;
  Null? serviceBill;
  Null? cashCollection;
  Null? toPay;
  Null? cheque;
  String? gstType;
  String? gstNumber;
  String? gstAddress;
  String? pollutionEmission;
  String? vehicleInsurance;
  String? insertDate;
  Null? refAmount;
  Null? panCardPhotof;
  Null? panCardPhotob;
  Null? checkBook;
  String? cancelCount;
  String? cancelAmt;

  Rating(
      {this.id,
        this.parcelId,
        this.deliveryBoyId,
        this.userId,
        this.rating,
        this.feedback,
        this.createdDate,
        this.userType,
        this.userPhone,
        this.firstname,
        this.lastname,
        this.userFullname,
        this.userEmail,
        this.userBdate,
        this.userPassword,
        this.userCity,
        this.userState,
        this.varificationCode,
        this.userImage,
        this.pincode,
        this.socityId,
        this.houseNo,
        this.mobileVerified,
        this.userGcmCode,
        this.userIosToken,
        this.varifiedToken,
        this.address,
        this.status,
        this.regCode,
        this.wallet,
        this.balance,
        this.rewards,
        this.created,
        this.modified,
        this.otp,
        this.otpStatus,
        this.social,
        this.facebookID,
        this.isEmailVerified,
        this.vehicleType,
        this.vehicleNo,
        this.vehicleImage,
        this.drivingLicenceNo,
        this.drivingLicencePhoto,
        this.drivingLicencePhotoBack,
        this.loginStatus,
        this.isAvaible,
        this.latitude,
        this.longitude,
        this.referralCode,
        this.referralBy,
        this.aadhaarCardNo,
        this.aadhaarCardPhoto,
        this.aadhaarCardPhotoBack,
        this.qrCode,
        this.accountHolderName,
        this.accountNumber,
        this.ifscCode,
        this.bankName,
        this.accountType,
        this.panCard,
        this.panCardBack,
        this.rcCardPhoto,
        this.rcCardPhotoBack,
        this.serviceBill,
        this.cashCollection,
        this.toPay,
        this.cheque,
        this.gstType,
        this.gstNumber,
        this.gstAddress,
        this.pollutionEmission,
        this.vehicleInsurance,
        this.insertDate,
        this.refAmount,
        this.panCardPhotof,
        this.panCardPhotob,
        this.checkBook,
        this.cancelCount,
        this.cancelAmt});

  Rating.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parcelId = json['parcel_id'];
    deliveryBoyId = json['delivery_boy_id'];
    userId = json['user_id'];
    rating = json['rating'];
    feedback = json['feedback'];
    createdDate = json['created_date'];
    userType = json['user_type'];
    userPhone = json['user_phone'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    userFullname = json['user_fullname'];
    userEmail = json['user_email'];
    userBdate = json['user_bdate'];
    userPassword = json['user_password'];
    userCity = json['user_city'];
    userState = json['user_state'];
    varificationCode = json['varification_code'];
    userImage = json['user_image'];
    pincode = json['pincode'];
    socityId = json['socity_id'];
    houseNo = json['house_no'];
    mobileVerified = json['mobile_verified'];
    userGcmCode = json['user_gcm_code'];
    userIosToken = json['user_ios_token'];
    varifiedToken = json['varified_token'];
    address = json['address'];
    status = json['status'];
    regCode = json['reg_code'];
    wallet = json['wallet'];
    balance = json['balance'];
    rewards = json['rewards'];
    created = json['created'];
    modified = json['modified'];
    otp = json['otp'];
    otpStatus = json['otp_status'];
    social = json['social'];
    facebookID = json['facebookID'];
    isEmailVerified = json['is_email_verified'];
    vehicleType = json['vehicle_type'];
    vehicleNo = json['vehicle_no'];
    vehicleImage = json['vehicle_image'];
    drivingLicenceNo = json['driving_licence_no'];
    drivingLicencePhoto = json['driving_licence_photo'];
    drivingLicencePhotoBack = json['driving_licence_photo_back'];
    loginStatus = json['login_status'];
    isAvaible = json['is_avaible'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    referralCode = json['referral_code'];
    referralBy = json['referral_by'];
    aadhaarCardNo = json['aadhaar_card_no'];
    aadhaarCardPhoto = json['aadhaar_card_photo'];
    aadhaarCardPhotoBack = json['aadhaar_card_photo_back'];
    qrCode = json['qr_code'];
    accountHolderName = json['account_holder_name'];
    accountNumber = json['account_number'];
    ifscCode = json['ifsc_code'];
    bankName = json['bank_name'];
    accountType = json['account_type'];
    panCard = json['pan_card'];
    panCardBack = json['pan_card_back'];
    rcCardPhoto = json['rc_card_photo'];
    rcCardPhotoBack = json['rc_card_photo_back'];
    serviceBill = json['service_bill'];
    cashCollection = json['cash_collection'];
    toPay = json['to_pay'];
    cheque = json['cheque'];
    gstType = json['gst_type'];
    gstNumber = json['gst_number'];
    gstAddress = json['gst_address'];
    pollutionEmission = json['pollution_emission'];
    vehicleInsurance = json['vehicle_insurance'];
    insertDate = json['insert_date'];
    refAmount = json['ref_amount'];
    panCardPhotof = json['pan_card_photof'];
    panCardPhotob = json['pan_card_photob'];
    checkBook = json['check_book'];
    cancelCount = json['cancel_count'];
    cancelAmt = json['cancel_amt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parcel_id'] = this.parcelId;
    data['delivery_boy_id'] = this.deliveryBoyId;
    data['user_id'] = this.userId;
    data['rating'] = this.rating;
    data['feedback'] = this.feedback;
    data['created_date'] = this.createdDate;
    data['user_type'] = this.userType;
    data['user_phone'] = this.userPhone;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['user_fullname'] = this.userFullname;
    data['user_email'] = this.userEmail;
    data['user_bdate'] = this.userBdate;
    data['user_password'] = this.userPassword;
    data['user_city'] = this.userCity;
    data['user_state'] = this.userState;
    data['varification_code'] = this.varificationCode;
    data['user_image'] = this.userImage;
    data['pincode'] = this.pincode;
    data['socity_id'] = this.socityId;
    data['house_no'] = this.houseNo;
    data['mobile_verified'] = this.mobileVerified;
    data['user_gcm_code'] = this.userGcmCode;
    data['user_ios_token'] = this.userIosToken;
    data['varified_token'] = this.varifiedToken;
    data['address'] = this.address;
    data['status'] = this.status;
    data['reg_code'] = this.regCode;
    data['wallet'] = this.wallet;
    data['balance'] = this.balance;
    data['rewards'] = this.rewards;
    data['created'] = this.created;
    data['modified'] = this.modified;
    data['otp'] = this.otp;
    data['otp_status'] = this.otpStatus;
    data['social'] = this.social;
    data['facebookID'] = this.facebookID;
    data['is_email_verified'] = this.isEmailVerified;
    data['vehicle_type'] = this.vehicleType;
    data['vehicle_no'] = this.vehicleNo;
    data['vehicle_image'] = this.vehicleImage;
    data['driving_licence_no'] = this.drivingLicenceNo;
    data['driving_licence_photo'] = this.drivingLicencePhoto;
    data['driving_licence_photo_back'] = this.drivingLicencePhotoBack;
    data['login_status'] = this.loginStatus;
    data['is_avaible'] = this.isAvaible;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['referral_code'] = this.referralCode;
    data['referral_by'] = this.referralBy;
    data['aadhaar_card_no'] = this.aadhaarCardNo;
    data['aadhaar_card_photo'] = this.aadhaarCardPhoto;
    data['aadhaar_card_photo_back'] = this.aadhaarCardPhotoBack;
    data['qr_code'] = this.qrCode;
    data['account_holder_name'] = this.accountHolderName;
    data['account_number'] = this.accountNumber;
    data['ifsc_code'] = this.ifscCode;
    data['bank_name'] = this.bankName;
    data['account_type'] = this.accountType;
    data['pan_card'] = this.panCard;
    data['pan_card_back'] = this.panCardBack;
    data['rc_card_photo'] = this.rcCardPhoto;
    data['rc_card_photo_back'] = this.rcCardPhotoBack;
    data['service_bill'] = this.serviceBill;
    data['cash_collection'] = this.cashCollection;
    data['to_pay'] = this.toPay;
    data['cheque'] = this.cheque;
    data['gst_type'] = this.gstType;
    data['gst_number'] = this.gstNumber;
    data['gst_address'] = this.gstAddress;
    data['pollution_emission'] = this.pollutionEmission;
    data['vehicle_insurance'] = this.vehicleInsurance;
    data['insert_date'] = this.insertDate;
    data['ref_amount'] = this.refAmount;
    data['pan_card_photof'] = this.panCardPhotof;
    data['pan_card_photob'] = this.panCardPhotob;
    data['check_book'] = this.checkBook;
    data['cancel_count'] = this.cancelCount;
    data['cancel_amt'] = this.cancelAmt;
    return data;
  }
}


// class GetDriverRating {
//   GetDriverRating({
//     required this.status,
//     required this.message,
//     required this.rating,
//   });
//
//   bool status;
//   String message;
//   String rating;
//
//   factory GetDriverRating.fromJson(Map<String, dynamic> json) => GetDriverRating(
//     status: json["status"],
//     message: json["message"],
//     rating: json["rating"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "status": status,
//     "message": message,
//     "rating": rating,
//   };
// }
