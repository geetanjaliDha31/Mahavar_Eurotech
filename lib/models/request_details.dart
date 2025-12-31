import 'dart:convert';

RequestDetails RequestDetailsFromJson(String str) =>
    RequestDetails.fromJson(json.decode(str));

String RequestDetailsToJson(RequestDetails data) => json.encode(data.toJson());

class RequestDetails {
  String? response;
  bool? error;
  List<ResultArray>? resultArray;

  RequestDetails({this.response, this.error, this.resultArray});

  RequestDetails.fromJson(Map<String, dynamic> json) {
    response = json["response"];
    error = json["error"];
    resultArray = json["result_array"] == null
        ? null
        : (json["result_array"] as List)
            .map((e) => ResultArray.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["response"] = response;
    data["error"] = error;
    if (resultArray != null) {
      data["result_array"] = resultArray?.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class ResultArray {
  String? fullName;
  String? customerMobileNo;
  int? issueId;
  String? serviceDate;
  String? serviceTime;
  String? comments;
  String? serviceImage;

  ResultArray(
      {this.fullName,
      this.customerMobileNo,
      this.issueId,
      this.serviceDate,
      this.comments,
      this.serviceImage});

  ResultArray.fromJson(Map<String, dynamic> json) {
    fullName = json["full_name"];
    customerMobileNo = json["customer_mobile_no"];
    issueId = json["issue_id"];
    serviceDate = json["service_date"];
    serviceTime = json["service_time"];
    comments = json["comments"];
    serviceImage = json["service_image"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["full_name"] = fullName;
    data["customer_mobile_no"] = customerMobileNo;
    data["issue_id"] = issueId;
    data["service_date"] = serviceDate;
    data["service_time"] = serviceTime;
    data["comments"] = comments;
    data["service_image"] = serviceImage;
    return data;
  }
}
