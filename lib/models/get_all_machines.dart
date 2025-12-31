import 'dart:convert';

UserMachines UserMachinesFromJson(String str) =>
    UserMachines.fromJson(json.decode(str));

String UserMachinesToJson(UserMachines data) => json.encode(data.toJson());


class UserMachines {
    String? response;
    bool? error;
    String? message;
    List<ResultArray>? resultArray;

    UserMachines({this.response, this.error, this.message, this.resultArray});

    UserMachines.fromJson(Map<String, dynamic> json) {
        response = json["response"];
        error = json["error"];
        message = json["message"];
        resultArray = json["result_array"] == null ? null : (json["result_array"] as List).map((e) => ResultArray.fromJson(e)).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["response"] = response;
        _data["error"] = error;
        _data["message"] = message;
        if(resultArray != null) {
            _data["result_array"] = resultArray?.map((e) => e.toJson()).toList();
        }
        return _data;
    }
}

class ResultArray {
    int? machineId;
    String? brandName;
    String? modelName;
    String? serialNo;
    String? label;

    ResultArray({this.machineId, this.brandName, this.modelName, this.serialNo, this.label});

    ResultArray.fromJson(Map<String, dynamic> json) {
        machineId = json["machine_id"];
        brandName = json["brand_name"];
        modelName = json["model_name"];
        serialNo = json["serial_no"];
        label = json["label"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["machine_id"] = machineId;
        _data["brand_name"] = brandName;
        _data["model_name"] = modelName;
        _data["serial_no"] = serialNo;
        _data["label"] = label;
        return _data;
    }
}