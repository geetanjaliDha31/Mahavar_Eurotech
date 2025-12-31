class MachineData {
  String? brandId;
  String? modelId;
  String? serialNumber;
  String? warrantyPeriod;
  String? deviceCondition;
  String? label;

  MachineData({
    this.brandId,
    this.modelId,
    this.serialNumber,
    this.warrantyPeriod,
    this.deviceCondition,
    this.label
  });

  Map<String, dynamic> toJson() {
    return {
      'brandId': brandId,
      'modelId': modelId,
      'serialNumber': serialNumber,
      'warrantyPeriod': warrantyPeriod,
      'deviceCondition': deviceCondition,
    };
  }
}
