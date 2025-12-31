import 'dart:convert';

GetBrand GetBrandFromJson(String str) => GetBrand.fromJson(json.decode(str));

String GetBrandToJson(GetBrand data) => json.encode(data.toJson());

class GetBrand {
  String? response;
  bool? error;
  String? message;
  List<ResultArray>? resultArray;

  GetBrand({this.response, this.error, this.message, this.resultArray});

  GetBrand.fromJson(Map<String, dynamic> json) {
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
  List<PriorityArray>? priorityArray;
  List<IssueArray>? issueArray;
  List<BrandsArray>? brandsArray;

  ResultArray({this.priorityArray, this.issueArray, this.brandsArray});

  ResultArray.fromJson(Map<String, dynamic> json) {
    priorityArray = json["priority_array"] == null
        ? null
        : (json["priority_array"] as List)
            .map((e) => PriorityArray.fromJson(e))
            .toList();
    issueArray = json["issue_array"] == null
        ? null
        : (json["issue_array"] as List)
            .map((e) => IssueArray.fromJson(e))
            .toList();
    brandsArray = json["brands_array"] == null
        ? null
        : (json["brands_array"] as List)
            .map((e) => BrandsArray.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (priorityArray != null) {
      data["priority_array"] = priorityArray?.map((e) => e.toJson()).toList();
    }
    if (issueArray != null) {
      data["issue_array"] = issueArray?.map((e) => e.toJson()).toList();
    }
    if (brandsArray != null) {
      data["brands_array"] = brandsArray?.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class BrandsArray {
  String? brandId;
  String? brandName;
  String? brandPhoto;
  List<dynamic>? modelsArray;

  BrandsArray(
      {this.brandId, this.brandName, this.brandPhoto, this.modelsArray});

  BrandsArray.fromJson(Map<String, dynamic> json) {
    brandId = json["brand_id"];
    brandName = json["brand_name"];
    brandPhoto = json["brand_photo"];
    modelsArray = json["models_array"] ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["brand_id"] = brandId;
    data["brand_name"] = brandName;
    data["brand_photo"] = brandPhoto;
    if (modelsArray != null) {
      data["models_array"] = modelsArray;
    }
    return data;
  }
}

class IssueArray {
  String? issueId;
  String? issueName;

  IssueArray({this.issueId, this.issueName});

  IssueArray.fromJson(Map<String, dynamic> json) {
    issueId = json["issue_id"];
    issueName = json["issue_name"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["issue_id"] = issueId;
    data["issue_name"] = issueName;
    return data;
  }
}

class PriorityArray {
  String? priorityId;
  String? priorityName;

  PriorityArray({this.priorityId, this.priorityName});

  PriorityArray.fromJson(Map<String, dynamic> json) {
    priorityId = json["priority_id"];
    priorityName = json["priority_name"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["priority_id"] = priorityId;
    data["priority_name"] = priorityName;
    return data;
  }
}
