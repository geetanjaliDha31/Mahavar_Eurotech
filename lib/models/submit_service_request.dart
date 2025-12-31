class ServiceRequest {
  String? fullName;
  // final String lastName;
  String? mobileNo;
  String? machineId;
  String? addressId;
  String? scheduleServiceDate;
  String? selectedIssueID;
  String? comments;
  String? imageBase64;
  String? time;

  ServiceRequest({
    this.fullName,
    // this.lastName,
    this.mobileNo,
    this.addressId,
    this.machineId,
    this.scheduleServiceDate,
    this.selectedIssueID,
    this.comments,
    this.imageBase64,
    this.time,
  });
}
