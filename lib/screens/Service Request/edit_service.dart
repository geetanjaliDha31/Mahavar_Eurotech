// ignore_for_file: prefer_const_constructors, unused_local_variable, unnecessary_null_comparison, avoid_print

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
import 'package:mahavar_eurotech/models/request_details.dart';
import 'package:mahavar_eurotech/screens/Service%20Request/my_request.dart';
import 'package:mahavar_eurotech/widgets/textfield.dart';
import 'package:mahavar_eurotech/widgets/toast.dart';
// import 'package:http/http.dart' as http;

class EditServiceRequest extends StatefulWidget {
  final Map<String, dynamic> data;

  const EditServiceRequest({
    super.key,
    required this.data,
  });

  @override
  State<EditServiceRequest> createState() => _EditServiceRequestState();
}

class _EditServiceRequestState extends State<EditServiceRequest> {
  TextEditingController fullName = TextEditingController();
  TextEditingController mobileNo = TextEditingController();
  TextEditingController issue = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController comment = TextEditingController();
  List<dynamic> issueList = [];
  String imageUrl = '';
  bool isDataLoaded = false;
  String selectedIssueID = "";
  RequestDetails? requestDetails;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    fullName.dispose();
    mobileNo.dispose();
    issue.dispose();
    date.dispose();
    timeController.dispose();
    comment.dispose();
    super.dispose();
  }

  String _formatTime(String time) {
    List<String> parts = time.split(':');
    if (parts.length >= 2) {
      return '${parts[0]}:${parts[1]}';
    } else {
      return time;
    }
  }

  Future<void> getData() async {
    final response = await HttpApiCall().getDropdownData();

    if (response.isNotEmpty && response["result_array"].isNotEmpty) {
      issueList = response['result_array'][0]["issue_array"];
      loadData().whenComplete(() => getPrefilledData());
      setState(() {
        isDataLoaded = true;
      });
    }
  }

  void setDropDown(String issueId) {
    for (int i = 0; i < issueList.length; i++) {
      if (issueList[i]['issue_id'] == issueId) {
        setState(() {
          issue.text = issueList[i]['issue_name'];
          selectedIssueID = issueId;
        });
      }
    }
  }

  Future loadData() async {
    requestDetails = await HttpApiCall()
        .getRequestDetails({'service_id': widget.data['service_id']});
  }

  Future<void> getPrefilledData() async {
    setState(() {
      fullName.text = requestDetails!.resultArray![0].fullName ?? '';
      mobileNo.text = requestDetails!.resultArray![0].customerMobileNo ?? '';
      date.text = requestDetails!.resultArray![0].serviceDate ?? '';
      String time = requestDetails!.resultArray![0].serviceTime ?? '';
      timeController.text = _formatTime(time);
      comment.text = requestDetails!.resultArray![0].comments ?? '';
      setDropDown(requestDetails!.resultArray![0].issueId.toString());
      imageUrl = requestDetails!.resultArray![0].serviceImage ?? '';
      // convertImage();
      // print(imageUrl);
    });
  }

  final ImageHelper _imageHelper = ImageHelper();
  File? _image;

  String? imageBase64;

  void convertImage() {
    if (_image != null) {
      List<int> imageBytes = _image!.readAsBytesSync();
      imageBase64 = base64Encode(imageBytes);
    }
    // else if (imageUrl.isNotEmpty) {
    //   // Load image from URL and convert it to base64
    //   http.get(Uri.parse(imageUrl)).then((response) {
    //     if (response.statusCode == 200) {
    //       List<int> imageBytes = response.bodyBytes;
    //       imageBase64 = base64Encode(imageBytes);
    //     } else {
    //       print(
    //           'Failed to load image from URL. Status code: ${response.statusCode}');
    //       imageBase64 = null; // Set imageBase64 to null if loading fails
    //     }
    //   }).catchError((error) {
    //     print('Error loading image from URL: $error');
    //     imageBase64 = null; // Set imageBase64 to null if loading fails
    //   });
    // }
    else {
      imageBase64 =
          null; // Set imageBase64 to null if _image is null and imageUrl is empty
    }
  }

  bool validateAndSubmitDetails() {
    List<String> missingFields = [];
    String errorMessage = "";

    if (fullName.text.isEmpty) {
      missingFields.add("Full Name");
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

    if (missingFields.length > 2) {
      errorMessage = "All Fields are required";
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
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => MyRequest()),
                  (route) => false);
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
            : FutureBuilder(
                future: HttpApiCall().getRequestDetails(
                  {
                    'service_id': widget.data['service_id'],
                  },
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    RequestDetails req = snapshot.data!;
                    final temp = req.resultArray![0];
                    return SingleChildScrollView(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                            lastDate: DateTime(
                                                DateTime.now().year + 5),
                                            selectableDayPredicate:
                                                (DateTime date) {
                                              // Disable previous dates (highlighting)
                                              return date.isAfter(DateTime.now()
                                                  .subtract(
                                                      const Duration(days: 1)));
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
                                          builder: (BuildContext context,
                                              Widget? child) {
                                            return MediaQuery(
                                              data: MediaQuery.of(context)
                                                  .copyWith(
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.89,
                                  // initialSelection: issueList[0]['issue_name'],
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
                                      backgroundColor: MaterialStatePropertyAll(
                                          Colors.white)),
                                  inputDecorationTheme: InputDecorationTheme(
                                    constraints:
                                        const BoxConstraints(maxHeight: 55),
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
                                  controller: issue,
                                  onSelected: (dynamic value) {
                                    setState(() {
                                      issue.text = value!['issue_name'];
                                      selectedIssueID =
                                          value!['issue_id'].toString();
                                    });
                                  },
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
                                  label: 'Comments',
                                  hinttext: "Your Comments(Optional)",
                                  obscureText: false,
                                  maxLines: 3,
                                  height: 120,
                                  labelSize: 14,
                                ),
                                imageUrl.length >
                                        45 // Check if imageUrl is not empty
                                    ? DottedBorder(
                                        borderType: BorderType.RRect,
                                        radius: const Radius.circular(12),
                                        color: color5,
                                        dashPattern: const [6, 6],
                                        // padding: const EdgeInsets.all(5),
                                        child: Container(
                                          height: 115,
                                          width: 115,
                                          margin: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: color5),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Image.network(
                                              imageUrl, // Show the image from URL
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                                SizedBox(
                                  height: 20,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Please upload image file",
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
                                Stack(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        // SizedBox(width: 50),
                                        InkWell(
                                          onTap: () async {
                                            final file =
                                                await _imageHelper.getImage();
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
                                            child: _image != null
                                                ? Container(
                                                    height: 115,
                                                    width: 115,
                                                    margin:
                                                        const EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: color5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3.0),
                                                      child: Image.file(
                                                        _image!, // Show the selected image
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  )
                                                : Container(
                                                    height: 115,
                                                    width: 115,
                                                    alignment: Alignment.center,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .cloud_upload_rounded,
                                                          color: color5,
                                                          size: 28,
                                                        ),
                                                        Text(
                                                          "Upload",
                                                          style: TextStyle(
                                                            color: color5,
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15, bottom: 20, right: 15),
                            child: SizedBox(
                              height: 45,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (validateAndSubmitDetails()) {
                                    setState(() {
                                      isLoading = true;
                                    });

                                    try {
                                      await HttpApiCall()
                                          .editServiceRequest(context, {
                                        'service_id': widget.data['service_id'],
                                        'issue_id': selectedIssueID,
                                        'comments': comment.text,
                                        'service_date': date.text,
                                        'service_image': imageBase64 ?? "",
                                        'full_name': fullName.text,
                                        'mobile_no': mobileNo.text,
                                        'service_time': timeController.text,
                                      });

                                      print(selectedIssueID);
                                      print(comment.text);
                                      print(date.text);
                                      print(imageBase64);
                                      print(fullName.text);
                                      print(mobileNo.text);
                                    } catch (e) {
                                      print('Error: $e');
                                    } finally {
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                  } else {
                                    print('error');
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: color1,
                                  padding: const EdgeInsets.all(0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                          strokeWidth: 3.0,
                                        ),
                                      )
                                    : const Text(
                                        "UPDATE",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text('No Internet Connection'),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
      ),
    );
  }
}
