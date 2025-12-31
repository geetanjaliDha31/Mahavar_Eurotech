// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:mahavar_eurotech/constants.dart';
import 'package:mahavar_eurotech/http/http.dart';
import 'package:mahavar_eurotech/img_helper.dart';
import 'package:mahavar_eurotech/models/submit_service_request.dart';
import 'package:mahavar_eurotech/widgets/textfield.dart';
import 'package:mahavar_eurotech/widgets/toast.dart';

class ServiceRequestPage extends StatefulWidget {
  final String machineID;
  final String addressID;
  const ServiceRequestPage(
      {super.key, required this.machineID, required this.addressID});

  @override
  State<ServiceRequestPage> createState() => _ServiceRequestPageState();
}

class _ServiceRequestPageState extends State<ServiceRequestPage> {
  TextEditingController fullName = TextEditingController();
  TextEditingController mobileNo = TextEditingController();
  TextEditingController issue = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController comment = TextEditingController();

  List<dynamic> issueList = [];
  bool isDataLoaded = false;
  String selectedIssueID = "";
  bool isLoading = false;

  @override
  void initState() {
    getData();

    super.initState();
  }

  Future<void> getData() async {
    final response = await HttpApiCall().getDropdownData();

    if (response.isNotEmpty && response["result_array"].isNotEmpty) {
      print(response['result_array'][0]["issue_array"]);
      issueList = response['result_array'][0]["issue_array"];
      print("No error");
      setState(() {
        isDataLoaded = true;
      });
    }
  }

  final ImageHelper _imageHelper = ImageHelper();
  File? _image;

  String? imageBase64;
  void convertImage() {
    List<int> imageBytes = File(_image!.path).readAsBytesSync();
    imageBase64 = base64Encode(imageBytes);
  }

  bool validateAndSubmitDetails() {
    List<String> missingFields = [];
    String errorMessage = "";

    if (fullName.text.isEmpty) {
      missingFields.add(" Full Name");
    }

    if (mobileNo.text.isEmpty) {
      missingFields.add("Mobile Number");
    }

    if (date.text.isEmpty) {
      missingFields.add("Service Date");
    }

    if (timeController.text.isEmpty) {
      missingFields.add("Service Time");
    }

    if (issue.text.isEmpty) {
      missingFields.add("Select Issue");
    }

    if (imageBase64 == null) {
      missingFields.add("Please Choose Different Image");
    }

    if (missingFields.length > 2) {
      if (imageBase64 == null) {
        errorMessage =
            "All Fields are required & Please Choose Different Image";
      } else {
        errorMessage = "All Fields are required";
      }
    } else if (missingFields.length == 1) {
      errorMessage = "Please ${missingFields[0]}";
    }
    if (missingFields.isNotEmpty) {
      showToast(context, errorMessage, 5);
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 28,
              color: color1,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Column(
            children: [
              Text(
                "SERVICE REQUEST",
                style: GoogleFonts.montserrat(
                    fontSize: 13, fontWeight: FontWeight.w500, color: color1),
              ),
            ],
          ),
          // backgroundColor: Colors.white,
          shadowColor: color3,
          elevation: 1.5,
        ),
        body: !isDataLoaded
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Contact Details",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(
                            "Please fill the following form to address yourself",
                            style: TextStyle(
                              color: color5,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextBox(
                            controller: fullName,
                            hinttext: "Full Name",
                            label: "Full Name",
                            obscureText: false,
                            isNumber: false,
                            icon: Icons.person,
                            labelSize: 14,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextBox(
                            controller: mobileNo,
                            hinttext: "Mobile Number",
                            label: "Mobile Number",
                            obscureText: false,
                            isNumber: true,
                            icon: Icons.phone,
                            labelSize: 14,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextBox(
                                controller: date,
                                hinttext: "Service Date",
                                readOnly: true,
                                icon: Icons.calendar_month_outlined,
                                label: "Service Date",
                                obscureText: false,
                                labelSize: 14,
                                width: 162,
                                onTap: () {
                                  print(date.text);
                                  showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1999),
                                      lastDate:
                                          DateTime(DateTime.now().year + 5),
                                      selectableDayPredicate: (DateTime date) {
                                        // Disable previous dates (highlighting)
                                        return date.isAfter(DateTime.now()
                                            .subtract(const Duration(days: 1)));
                                      }).then(
                                    (value) {
                                      if (value != null) {
                                        setState(() {
                                          // Format the selected date to "day month year" format
                                          final formattedDate =
                                              DateFormat('dd-MM-yyyy')
                                                  .format(value);
                                          date.text = formattedDate;
                                        });
                                      }
                                    },
                                  );
                                },
                              ),
                              TextBox(
                                controller: timeController,
                                hinttext: "Service Time",
                                readOnly: true,
                                icon: Icons.watch_later_outlined,
                                label: "Service Time",
                                obscureText: false,
                                labelSize: 14,
                                width: 162,
                                onTap: () async {
                                  print(timeController.text);

                                  final TimeOfDay? newTime =
                                      await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                    useRootNavigator: false,
                                    builder:
                                        (BuildContext context, Widget? child) {
                                      return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                          alwaysUse24HourFormat: false,
                                        ),
                                        child: child ?? Container(),
                                      );
                                    },
                                  );
                                  if (newTime != null) {
                                    setState(() {
                                      final String formattedTime =
                                          '${newTime.hour.toString().padLeft(2, '0')}:${newTime.minute.toString().padLeft(2, '0')}';
                                      timeController.text = formattedTime;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 15,
                      color: color4,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "How can we help you?",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(
                            "Please fill the following form to address your issues",
                            style: TextStyle(
                              color: color5,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          DropdownMenu<dynamic>(
                            width: MediaQuery.of(context).size.width * 0.89,

                            initialSelection: issueList[0]['issue_name'],
                            textStyle: const TextStyle(
                              fontSize: 14,
                              // overflow: TextOverflow.clip,
                            ),

                            label: Text(
                              "Select Issue",
                              style: TextStyle(color: color3),
                            ),
                            trailingIcon: Icon(
                              CupertinoIcons.chevron_down,
                              color: color3,
                            ),
                            selectedTrailingIcon: Icon(
                              CupertinoIcons.chevron_up,
                              color: color3,
                            ),
                            menuStyle: const MenuStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.white)),
                            inputDecorationTheme: InputDecorationTheme(
                              constraints: const BoxConstraints(maxHeight: 55),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: color3),
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: color3),
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                              ),
                            ),
                            onSelected: (dynamic value) {
                              setState(() {
                                issue.text = value!['issue_name'];
                                selectedIssueID = value!['issue_id'].toString();
                              });
                            },
                            // controller: modelId,
                            // underline: SizedBox.shrink(),
                            dropdownMenuEntries: issueList
                                .map<DropdownMenuEntry<dynamic>>(
                                    (dynamic value) {
                              return DropdownMenuEntry<dynamic>(
                                value: value,
                                label: value['issue_name'],
                              );
                            }).toList(),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextBox(
                            controller: comment,
                            hinttext: "Your Comments (Optional)",
                            label: "Your Comments",
                            obscureText: false,
                            maxLines: 3,
                            height: 120,
                            labelSize: 14,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 5,
                              ),
                              const Icon(
                                Icons.cloud_upload_rounded,
                                color: Color(0xFFE8A22E),
                                size: 30,
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Please upload image File",
                                      style: TextStyle(
                                        color: color5,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "Choose file .jpg, .jpeg, .png not more than 10MB",
                                      style: TextStyle(
                                        color: color5,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () async {
                                  final file = await _imageHelper.getImage();
                                  if (file != null) {
                                    final cropped =
                                        await _imageHelper.crop(file);
                                    if (cropped != null) {
                                      setState(() {
                                        _image = cropped;
                                      });
                                      convertImage();
                                    }
                                  }
                                },
                                child: DottedBorder(
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(12),
                                  color: color5,
                                  dashPattern: const [6, 6],
                                  // padding: const EdgeInsets.all(5),
                                  child: _image == null
                                      ? Container(
                                          height: 115,
                                          width: 115,
                                          alignment: Alignment.center,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.cloud_upload_rounded,
                                                color: color5,
                                                size: 28,
                                              ),
                                              Text(
                                                "Upload",
                                                style: TextStyle(
                                                  color: color5,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(
                                          height: 115,
                                          width: 115,
                                          margin: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: FileImage(_image!),
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () async {
                              if (validateAndSubmitDetails()) {
                                setState(() {
                                  isLoading = true;
                                });

                                ServiceRequest serviceRequest = ServiceRequest(
                                  fullName: fullName.text,
                                  mobileNo: mobileNo.text,
                                  addressId: widget.addressID,
                                  machineId: widget.machineID,
                                  scheduleServiceDate: date.text,
                                  selectedIssueID: selectedIssueID,
                                  comments: comment.text,
                                  imageBase64: imageBase64,
                                  time: timeController.text,
                                );

                                try {
                                  await HttpApiCall().addServiceRequest(
                                      context, serviceRequest);
                                } catch (e) {
                                  print('Error: $e');
                                } finally {
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: color1,
                              padding: const EdgeInsets.all(0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              minimumSize: const Size(double.infinity, 45),
                              maximumSize: const Size(double.infinity, 45),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                      strokeWidth: 3.0,
                                    ),
                                  )
                                : const Text(
                                    "Submit Details",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
