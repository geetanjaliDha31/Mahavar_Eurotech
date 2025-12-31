import 'dart:convert';

GetAllAddress GetAllAddressFromJson(String str) =>
    GetAllAddress.fromJson(json.decode(str));

String GetAllAddressToJson(GetAllAddress data) => json.encode(data.toJson());

class GetAllAddress {
  String? response;
  bool? error;
  List<ResultArray>? resultArray;

  GetAllAddress({this.response, this.error, this.resultArray});

  GetAllAddress.fromJson(Map<String, dynamic> json) {
    response = json["response"];
    error = json["error"];
    resultArray = json["result_array"] == null
        ? null
        : (json["result_array"] as List)
            .map((e) => ResultArray.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["response"] = response;
    _data["error"] = error;
    if (resultArray != null) {
      _data["result_array"] = resultArray?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class ResultArray {
  int? addressId;
  String? addressLine1;
  String? area;
  String? landmark;
  String? pincode;
  String? addressType;
  double? latitude; // Changed from int? to double?
  double? longitude; // Changed from int? to double?

  ResultArray({
    this.addressId,
    this.addressLine1,
    this.area,
    this.landmark,
    this.pincode,
    this.addressType,
    this.latitude,
    this.longitude,
  });

  ResultArray.fromJson(Map<String, dynamic> json) {
    addressId = (json["address_id"] as num).toInt();
    addressLine1 = json["address_line_1"];
    area = json["area"];
    landmark = json["landmark"];
    pincode = json["pincode"];
    addressType = json["address_type"];
    latitude = (json["latitude"] as num).toDouble(); // Convert to double
    longitude = (json["longitude"] as num).toDouble(); // Convert to double
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["address_id"] = addressId;
    _data["address_line_1"] = addressLine1;
    _data["area"] = area;
    _data["landmark"] = landmark;
    _data["pincode"] = pincode;
    _data["address_type"] = addressType;
    _data["latitude"] = latitude;
    _data["longitude"] = longitude;
    return _data;
  }
}
