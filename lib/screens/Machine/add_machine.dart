// ignore_for_file: unused_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mahavar_eurotech/constants.dart';
import 'package:mahavar_eurotech/http/http.dart';
import 'package:mahavar_eurotech/models/add_machine.dart';
import 'package:mahavar_eurotech/models/get_brand.dart';
import 'package:mahavar_eurotech/widgets/textfield.dart';
import 'package:mahavar_eurotech/widgets/toast.dart';

class AddMachinePage extends StatefulWidget {
  const AddMachinePage({super.key});

  @override
  State<AddMachinePage> createState() => _AddMachinePageState();
}

class _AddMachinePageState extends State<AddMachinePage> {
  TextEditingController modelId = TextEditingController();
  TextEditingController serialNumber = TextEditingController();
  TextEditingController label = TextEditingController();
  TextEditingController warrantyPeriod = TextEditingController();
  TextEditingController brandId = TextEditingController();
  TextEditingController deviceCondition = TextEditingController();
  TextEditingController terms1 = TextEditingController();
  TextEditingController terms2 = TextEditingController();

  bool isLoading = false;

  List<String> warrantyPeriodList = [
    "6 Months",
    "12 Months",
    "36 Months",
    "48 Months"
  ];

  bool terms1value = false;
  bool terms2value = false;

  List<String> deviceCondnList = [
    "Working",
    "Not Working",
    "Not Purifying",
    "Making Noise",
    "Change Filter Indication"
  ];

  List<dynamic> brandList = [];
  List<dynamic> modelList = [];

  String selectedBrandID = "";
  String selectedModelID = "";

  bool isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    final response = await HttpApiCall().getDropdownData();

    if (response.isNotEmpty && response["result_array"].isNotEmpty) {
      brandList = response['result_array'][0]['brands_array'];
      brandList.removeAt(0);
      setState(() {
        isDataLoaded = true;
      });
    }
  }

  Future<void> getModelData() async {
    final response =
        await HttpApiCall().getModelsById({'brand_id': selectedBrandID});

    if (response.isNotEmpty && response["result_array"].isNotEmpty) {
      modelList = response['result_array'];
      print(modelList);
      setState(() {
        isDataLoaded = true;
      });
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
            Navigator.pop(context);
          },
        ),
        title: Column(
          children: [
            Text(
              "ADD MACHINE",
              style: GoogleFonts.montserrat(
                  fontSize: 13, fontWeight: FontWeight.w500, color: color1),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        shadowColor: color3,
        elevation: 1.5,
      ),
      body: SafeArea(
        child: !isDataLoaded
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Enter Device Details",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      DropdownMenu<dynamic>(
                        width: MediaQuery.of(context).size.width * 0.89,

                        initialSelection: brandList[0]['brand_name'],
                        textStyle: const TextStyle(
                            fontSize: 14, overflow: TextOverflow.clip),
                        label: Text(
                          "Brand",
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
                          constraints: const BoxConstraints(maxHeight: 60),
                          // contentPadding: EdgeInsets.all(0),
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
                        onSelected: (dynamic value) async {
                          setState(() {
                            brandId.text = value!['brand_name'];
                            selectedBrandID = value!['brand_id'].toString();
                            // int index = 0;

                            // for (int i = 0; i < brandList.length; i++) {
                            //   if (value['brand_id'] ==
                            //       brandList[i]['brand_id']) {
                            //     index = i;
                            //     break;
                            //   }
                            // }
                            // modelList = brandList[index]['models_array'];
                          });
                          await getModelData();
                        },
                        controller: brandId,
                        // underline: SizedBox.shrink(),
                        dropdownMenuEntries: brandList
                            .map<DropdownMenuEntry<dynamic>>((dynamic value) {
                          return DropdownMenuEntry<dynamic>(
                            value: value,
                            label: value['brand_name'] ?? "",
                          );
                        }).toList(),
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      DropdownMenu<dynamic>(
                        width: MediaQuery.of(context).size.width * 0.89,

                        initialSelection: modelList.isNotEmpty
                            ? modelList[0]['model_name']
                            : null,
                        textStyle: const TextStyle(
                          fontSize: 14,
                          // overflow: TextOverflow.clip,
                        ),

                        label: Text(
                          "Model",
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
                          constraints: const BoxConstraints(maxHeight: 60),
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
                            modelId.text = value!['model_name'];
                            selectedModelID = value!['model_id'].toString();
                            print(selectedModelID);
                          });
                        },
                        // controller: modelId,
                        // underline: SizedBox.shrink(),
                        dropdownMenuEntries: modelList
                            .map<DropdownMenuEntry<dynamic>>((dynamic value) {
                          return DropdownMenuEntry<dynamic>(
                            value: value,
                            label: value['model_name'],
                          );
                        }).toList(),
                      ),
                      const SizedBox(
                        height: 15,
                      ),

                      TextBox(
                        controller: serialNumber,
                        hinttext: "Serial Number",
                        label: "",
                        height: 63,
                        obscureText: false,
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      TextBox(
                        controller: label,
                        hinttext: "Label",
                        label: "",
                        height: 63,
                        obscureText: false,
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      DropdownMenu<String>(
                        width: MediaQuery.of(context).size.width * 0.89,

                        initialSelection: warrantyPeriodList.first,
                        textStyle: const TextStyle(fontSize: 14),
                        label: Text(
                          "Warranty Period",
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
                          constraints: const BoxConstraints(maxHeight: 60),
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
                        onSelected: (String? value) {
                          setState(() {
                            warrantyPeriod.text = value!;
                          });
                        },
                        controller: warrantyPeriod,
                        // underline: SizedBox.shrink(),
                        dropdownMenuEntries: warrantyPeriodList
                            .map<DropdownMenuEntry<String>>((String value) {
                          return DropdownMenuEntry<String>(
                            value: value,
                            label: value,
                          );
                        }).toList(),
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                      DropdownMenu<String>(
                        width: MediaQuery.of(context).size.width * 0.89,

                        initialSelection: deviceCondnList.first,
                        textStyle: const TextStyle(fontSize: 14),
                        label: Text(
                          "Device Confition",
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
                          constraints: const BoxConstraints(maxHeight: 60),
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
                        onSelected: (String? value) {
                          setState(() {
                            deviceCondition.text = value!;
                          });
                        },
                        controller: deviceCondition,
                        // underline: SizedBox.shrink(),
                        dropdownMenuEntries: deviceCondnList
                            .map<DropdownMenuEntry<String>>((String value) {
                          return DropdownMenuEntry<String>(
                            value: value,
                            label: value,
                          );
                        }).toList(),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "By continuing, you agree to our Terms and Services",
                          style: GoogleFonts.montserrat(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: terms1value,
                            onChanged: (value) {
                              setState(() {
                                terms1value = !terms1value;
                                terms1.text = terms1.toString();
                              });
                            },
                            activeColor: color2,
                            checkColor: Colors.white,
                          ),
                          Expanded(
                            child: Text(
                              'The device has been purchased in India and its warranty is valid and serviceable in India',
                              style: GoogleFonts.montserrat(
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // SizedBox(
                      //   height: ,
                      // ),
                      Row(
                        children: [
                          Checkbox(
                            value: terms2value,
                            onChanged: (value) {
                              setState(() {
                                terms2value = !terms2value;
                                terms2.text = terms2.toString();
                              });
                            },
                            activeColor: color2,
                            checkColor: Colors.white,
                          ),
                          Expanded(
                            child: Text(
                              'All information provided above is true to the best of your knowledge',
                              style: GoogleFonts.montserrat(
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),

                      ElevatedButton(
                        onPressed: () async {
                          MachineData machineData = MachineData(
                            brandId: selectedBrandID,
                            modelId: selectedModelID,
                            serialNumber: serialNumber.text,
                            warrantyPeriod: warrantyPeriod.text,
                            deviceCondition: deviceCondition.text,
                            label: label.text,
                          );

                          setState(() {
                            isLoading = true;
                          });

                          try {
                            await HttpApiCall()
                                .addUserMachine(context, machineData);
                          } catch (e) {
                            showToast(context,
                                "Error adding machine. Please try again.", 3);
                          } finally {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color2,
                          fixedSize:
                              Size(MediaQuery.of(context).size.width, 45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
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
                            : Text(
                                'Add Machine',
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
