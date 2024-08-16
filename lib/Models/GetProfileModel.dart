class GetProfileModel {
  bool? status;
  String? message;
  Data? data;

  GetProfileModel({this.status, this.message, this.data});

  GetProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  User? user;
  Verified? verified;

  Data({this.user, this.verified});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    verified = json['verified'] != null
        ? new Verified.fromJson(json['verified'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.verified != null) {
      data['verified'] = this.verified!.toJson();
    }
    return data;
  }
}

class User {
  String? userId;
  String? userType;
  String? userPhone;
  String? firstname;
  String? lastname;
  String? userFullname;
  String? userEmail;
  String? userBdate;
  String? userPassword;
  String? userCity;
  String? userState;
  String? varificationCode;
  String? userImage;
  String? pincode;
  String? socityId;
  String? houseNo;
  String? mobileVerified;
  String? userGcmCode;
  String? userIosToken;
  String? varifiedToken;
  String? address;
  String? status;
  String? regCode;
  String? wallet;
  String? rewards;
  String? created;
  String? modified;
  String? otp;
  String? otpStatus;
  String? social;
  String? facebookID;
  String? isEmailVerified;
  String? vehicleType;
  String? vehicleNo;
  String? drivingLicenceNo;
  String? drivingLicencePhoto;
  String? drivingLicencePhotoBack;
  String? loginStatus;
  String? vehicle_image;
  String? isAvaible;
  String? latitude;
  String? longitude;
  String? referralCode;
  String? referralBy;
  String? aadhaarCardNo;
  String? aadhaarCardPhoto;
  String? aadhaarCardPhotoBack;
  String? qrCode;
  String? accountHolderName;
  String? accountNumber;
  String? ifscCode;
  String? bankName;
  String? accountType;
  String? panCard;
  String? panCardBack;
  String? rcCardPhoto;
  String? rcCardPhotoBack;
  String? serviceBill;
  String? cashCollection;
  String? toPay;
  String? cheque;
  String? gstType;
  String? gstNumber;
  String? gstAddress;
  String? pollutionEmission;
  String? vehicleInsurance;
  String? insertDate;
  String? refAmount;
  String? panCardPhotof;
  String? panCardPhotob;
  String? checkBook;
  String? cancelCount;
  String? cancelAmt;
  String? stateName;
  String? cityName;
  String? vehicleTypeString;

  User(
      {this.userId,
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
      this.rewards,
      this.created,
      this.modified,
      this.otp,
      this.vehicle_image,
      this.otpStatus,
      this.social,
      this.facebookID,
      this.isEmailVerified,
      this.vehicleType,
      this.vehicleNo,
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
      this.cancelAmt,
      this.stateName,
      this.cityName,
      this.vehicleTypeString});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
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
    vehicle_image = json['vehicle_image'];
    mobileVerified = json['mobile_verified'];
    userGcmCode = json['user_gcm_code'];
    userIosToken = json['user_ios_token'];
    varifiedToken = json['varified_token'];
    address = json['address'];
    status = json['status'];
    regCode = json['reg_code'];
    wallet = json['wallet'];
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
    stateName = json['state_name'];
    cityName = json['city_name'];
    vehicleTypeString = json['vehicle_type_string'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
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
    data['vehicle_image'] = this.vehicle_image;
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
    data['state_name'] = this.stateName;
    data['city_name'] = this.cityName;
    data['vehicle_type_string'] = this.vehicleTypeString;
    return data;
  }
}

class Verified {
  String? id;
  String? userImage;
  String? drivingLicenceNo;
  String? drivingLicencePhoto;
  String? drivingLicencePhotoBack;
  String? aadhaarCardNo;
  String? aadhaarCardPhoto;
  String? aadhaarCardPhotoBack;
  String? accountNumber;
  String? pan_card_photof;
  String? rcCardPhoto;
  String? rcCardPhotoBack;
  String? userId;
  String? vehicle_image;

  Verified(
      {this.id,
      this.userImage,
      this.drivingLicenceNo,
      this.drivingLicencePhoto,
      this.drivingLicencePhotoBack,
      this.aadhaarCardNo,
      this.aadhaarCardPhoto,
      this.aadhaarCardPhotoBack,
      this.accountNumber,
      this.pan_card_photof,
      this.rcCardPhoto,
      this.rcCardPhotoBack,
      this.vehicle_image,
      this.userId});

  Verified.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userImage = json['user_image'];
    drivingLicenceNo = json['driving_licence_no'];
    drivingLicencePhoto = json['driving_licence_photo'];
    drivingLicencePhotoBack = json['driving_licence_photo_back'];
    aadhaarCardNo = json['aadhaar_card_no'];
    aadhaarCardPhoto = json['aadhaar_card_photo'];
    aadhaarCardPhotoBack = json['aadhaar_card_photo_back'];
    accountNumber = json['account_number'];
    pan_card_photof = json['pan_card_photof'];
    rcCardPhoto = json['rc_card_photo'];
    rcCardPhotoBack = json['rc_card_photo_back'];
    vehicle_image = json['vehicle_image'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_image'] = this.userImage;
    data['driving_licence_no'] = this.drivingLicenceNo;
    data['driving_licence_photo'] = this.drivingLicencePhoto;
    data['driving_licence_photo_back'] = this.drivingLicencePhotoBack;
    data['aadhaar_card_no'] = this.aadhaarCardNo;
    data['aadhaar_card_photo'] = this.aadhaarCardPhoto;
    data['aadhaar_card_photo_back'] = this.aadhaarCardPhotoBack;
    data['account_number'] = this.accountNumber;
    data['pan_card_photof'] = this.pan_card_photof;
    data['rc_card_photo'] = this.rcCardPhoto;
    data['rc_card_photo_back'] = this.rcCardPhotoBack;
    data['user_id'] = this.userId;
    data['vehicle_image'] = this.vehicle_image;
    return data;
  }
}
