// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mahavar_eurotech/constants.dart';
import 'package:mahavar_eurotech/http/http.dart';
import 'package:mahavar_eurotech/screens/Bottom%20nav%20bar/bottom_nav_bar.dart';
import 'package:mahavar_eurotech/widgets/textfield.dart';
import 'package:mahavar_eurotech/widgets/toast.dart';

class AddNewAddress extends StatefulWidget {
  final String? machineId;
  final double latitude;
  final double longitude;
  final String pinCode;
  final String area;
  final String address;

  const AddNewAddress({
    super.key,
    this.machineId,
    required this.area,
    required this.pinCode,
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  @override
  State<AddNewAddress> createState() => _AddNewAddressState();
}

class _AddNewAddressState extends State<AddNewAddress> {
  @override
  void initState() {
    super.initState();
    getData();
    selectedType();
  }

  bool isLoading = false;
  TextEditingController pincode = TextEditingController();
  TextEditingController area = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController landmark = TextEditingController();
  TextEditingController addressType = TextEditingController();

  void getData() {
    pincode = TextEditingController(text: widget.pinCode);
    area = TextEditingController(text: widget.area);
    address = TextEditingController(text: widget.address);
  }

  int selectedAddressType = -1;
  List<String> addressTypeList = [
    "Home",
    "Office",
    "Other",
  ];
  void selectedType() {
    if (selectedAddressType == -1) {
      selectedAddressType = 0;
      addressType.text = addressTypeList[0]; // Set default address type
    }
  }

  bool validateAndSubmitDetails() {
    List<String> missingFields = [];
    String errorMessage = "";

    if (address.text.isEmpty) {
      missingFields.add("House No, Building Name, Street Name");
    }

    if (pincode.text.isEmpty) {
      missingFields.add("Pincode");
    }

    if (area.text.isEmpty) {
      missingFields.add("Area");
    }
    if (missingFields.length > 1) {
      errorMessage = "All Fields are required";
    } else if (missingFields.length == 1) {
      errorMessage = "Please Enter ${missingFields[0]}";
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
    return Scaffold(
      backgroundColor: color4,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 28,
            color: color1,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BottomNavBar(),
              ),
            );
          },
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            "Add Service Address",
            style: GoogleFonts.montserrat(
                fontSize: 13, fontWeight: FontWeight.w500, color: color1),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "House No, Building Name, Street Name",
                      style: GoogleFonts.montserrat(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "*",
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: red,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                TextBox(
                  controller: address,
                  hinttext: "House No, Building Name, Street Name",
                  labelSize: 13,
                  label: "",
                  inputType: true,
                  textInputType: TextInputType.multiline,
                  maxLines: 4,
                  obscureText: false,
                  height: 65,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            TextBox(
              controller: landmark,
              hinttext: "Landmark",
              labelSize: 13,
              label: "Landmark",
              obscureText: false,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Pincode",
                          style: GoogleFonts.montserrat(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "*",
                          style: GoogleFonts.montserrat(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: red,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    TextBox(
                      controller: pincode,
                      hinttext: "Pincode",
                      labelSize: 13,
                      label: "",
                      obscureText: false,
                      isNumber: true,
                      width: MediaQuery.of(context).size.width * 0.43,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Area",
                          style: GoogleFonts.montserrat(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "*",
                          style: GoogleFonts.montserrat(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: red,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    TextBox(
                      controller: area,
                      hinttext: "Area",
                      labelSize: 13,
                      label: "",
                      obscureText: false,
                      isNumber: false,
                      width: MediaQuery.of(context).size.width * 0.44,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "Set address as:    ",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                for (int i = 0; i < addressTypeList.length; i++)
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedAddressType = i;
                        addressType.text = addressTypeList[i];
                      });
                    },
                    child: Container(
                      height: 30,
                      width: 60,
                      margin: const EdgeInsets.only(right: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selectedAddressType == i ? color2 : Colors.white,
                        border: Border.all(
                          color: color2,
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        addressTypeList[i],
                        style: TextStyle(
                          color:
                              selectedAddressType == i ? Colors.white : color2,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    pincode.clear();
                    area.clear();
                    address.clear();
                    landmark.clear();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.all(0),
                    minimumSize:
                        Size(MediaQuery.of(context).size.width * 0.38, 45),
                    maximumSize:
                        Size(MediaQuery.of(context).size.width * 0.38, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: color2,
                      ),
                    ),
                  ),
                  child: Text(
                    "DISCARD",
                    style: TextStyle(
                      color: color1,
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (validateAndSubmitDetails()) {
                      setState(() {
                        isLoading = true;
                      });

                      await HttpApiCall().addServiceAddress(
                        context,
                        {
                          'pincode': pincode.text,
                          'area': area.text,
                          'address_line_1': address.text,
                          'address_type': addressType.text,
                          'landmark': landmark.text,
                          'latitude': widget.latitude.toString(),
                          'longitude': widget.longitude.toString(),
                        },
                        widget.machineId ?? '',
                      );

                      setState(() {
                        isLoading = false;
                      });
                    }
                    print(addressType.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color2,
                    padding: const EdgeInsets.all(0),
                    minimumSize:
                        Size(MediaQuery.of(context).size.width * 0.38, 45),
                    maximumSize:
                        Size(MediaQuery.of(context).size.width * 0.38, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: color2,
                      ),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 3.0,
                          ),
                        )
                      : const Text(
                          "SAVE",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                          ),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
