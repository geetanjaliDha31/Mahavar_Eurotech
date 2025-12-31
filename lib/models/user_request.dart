import 'dart:convert';

UserRequest UserRequestFromJson(String str) =>
    UserRequest.fromJson(json.decode(str));

String UserRequestToJson(UserRequest data) => json.encode(data.toJson());

class UserRequest {
  String? response;
  bool? error;
  String? message;
  List<ResultArray>? resultArray;

  UserRequest({this.response, this.error, this.message, this.resultArray});

  UserRequest.fromJson(Map<String, dynamic> json) {
    response = json["response"];
    error = json["error"];
    message = json["message"];
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
    data["message"] = message;
    if (resultArray != null) {
      data["result_array"] = resultArray?.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class ResultArray {
  List<PendingCallDetailsArray>? pendingCallDetailsArray;
  List<CompletedCallDetailsArray>? completedCallDetailsArray;

  ResultArray({this.pendingCallDetailsArray, this.completedCallDetailsArray});

  ResultArray.fromJson(Map<String, dynamic> json) {
    pendingCallDetailsArray = json["pending_call_details_array"] == null
        ? null
        : (json["pending_call_details_array"] as List)
            .map((e) => PendingCallDetailsArray.fromJson(e))
            .toList();
    completedCallDetailsArray = json["completed_call_details_array"] == null
        ? null
        : (json["completed_call_details_array"] as List)
            .map((e) => CompletedCallDetailsArray.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (pendingCallDetailsArray != null) {
      data["pending_call_details_array"] =
          pendingCallDetailsArray?.map((e) => e.toJson()).toList();
    }
    if (completedCallDetailsArray != null) {
      data["completed_call_details_array"] =
          completedCallDetailsArray?.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class CompletedCallDetailsArray {
  int? serviceId;
  String? issueName;
  String? serviceDate;
  String? serviceTime;
  String? label;
  String? status;

  CompletedCallDetailsArray(
      {this.serviceId,
      this.issueName,
      this.serviceDate,
      this.label,
      this.status});

  CompletedCallDetailsArray.fromJson(Map<String, dynamic> json) {
    serviceId = json["service_id"];
    issueName = json["issue_name"];
    serviceDate = json["service_date"];
    serviceTime = json["service_time"];
    label = json["label"];
    status = json["status"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["service_id"] = serviceId;
    data["issue_name"] = issueName;
    data["service_date"] = serviceDate;
    data["service_time"] = serviceTime;
    data["label"] = label;
    data["status"] = status;
    return data;
  }
}

class PendingCallDetailsArray {
  int? serviceId;
  String? issueName;
  String? serviceDate;
  String? serviceTime;
  String? label;
  String? status;

  PendingCallDetailsArray(
      {this.serviceId,
      this.issueName,
      this.serviceDate,
      this.label,
      this.status});

  PendingCallDetailsArray.fromJson(Map<String, dynamic> json) {
    serviceId = json["service_id"];
    issueName = json["issue_name"];
    serviceDate = json["service_date"];
    serviceTime = json["service_time"];
    label = json["label"];
    status = json["status"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["service_id"] = serviceId;
    data["issue_name"] = issueName;
    data["service_time"] = serviceTime;
    data["service_date"] = serviceDate;
    data["label"] = label;
    data["status"] = status;
    return data;
  }
}
