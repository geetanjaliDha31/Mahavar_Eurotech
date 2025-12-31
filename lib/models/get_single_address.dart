import 'dart:convert';

GetSingleAddress GetSingleAddressFromJson(String str) =>
    GetSingleAddress.fromJson(json.decode(str));

String GetSingleAddressToJson(GetSingleAddress data) => json.encode(data.toJson());

class GetSingleAddress {
    String? response;
    bool? error;
    List<ResultArray>? resultArray;

    GetSingleAddress({this.response, this.error, this.resultArray});

    GetSingleAddress.fromJson(Map<String, dynamic> json) {
        response = json["response"];
        error = json["error"];
        resultArray = json["result_array"] == null ? null : (json["result_array"] as List).map((e) => ResultArray.fromJson(e)).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data["response"] = response;
        data["error"] = error;
        if(resultArray != null) {
            data["result_array"] = resultArray?.map((e) => e.toJson()).toList();
        }
        return data;
    }
}

class ResultArray {
    int? addressId;
    String? pincode;
    String? area;
    String? addressLine1;
    String? landmark;
    String? addressType;

    ResultArray({this.addressId, this.pincode, this.area, this.addressLine1, this.landmark, this.addressType});

    ResultArray.fromJson(Map<String, dynamic> json) {
        addressId = json["address_id"];
        pincode = json["pincode"];
        area = json["area"];
        addressLine1 = json["address_line_1"];
        landmark = json["landmark"];
        addressType = json["address_type"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data["address_id"] = addressId;
        data["pincode"] = pincode;
        data["area"] = area;
        data["address_line_1"] = addressLine1;
        data["landmark"] = landmark;
        data["address_type"] = addressType;
        return data;
    }
}