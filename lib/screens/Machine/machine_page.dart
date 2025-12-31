import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mahavar_eurotech/constants.dart';
import 'package:mahavar_eurotech/http/http.dart';
import 'package:mahavar_eurotech/models/get_all_machines.dart';
import 'package:mahavar_eurotech/screens/Address/choose_address.dart';
import 'package:mahavar_eurotech/screens/Machine/add_machine.dart';
import 'package:mahavar_eurotech/screens/Machine/no_machines_service_page.dart';

class MachinePage extends StatefulWidget {
  const MachinePage({
    super.key,
  });

  @override
  State<MachinePage> createState() => _MachinePageState();
}

class _MachinePageState extends State<MachinePage> {
  List<Map<String, dynamic>> data = [
    {
      "name": "Aquaguard Eden (6L)",
      "desc":
          "RO + UV + MTDS + SS Smart Water Purifier with Active Copper Zinc Booster Tech and 7 Stage Purification (Deep Black)",
      "image": "assets/ro.png"
    },
    {
      "name": "Pure-it Classic",
      "desc":
          "UV Electrical Water Purifier with Sleek And Covered Design (White)",
      "image": "assets/ro.png"
    },
  ];

  int selectedIndex = -1;
  String machineID = "";

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
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Column(
            children: [
              Text(
                "SERVICES",
                style: GoogleFonts.montserrat(
                    fontSize: 13, fontWeight: FontWeight.w500, color: color1),
              ),
            ],
          ),
        ),
        actions: [
          if (selectedIndex != -1)
            InkWell(
              onTap: () {
                print("machineId");
                print(machineID);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChooseAddressPage(
                      machineId: machineID,
                    ),
                  ),
                );
              },
              child: Container(
                height: 40,
                width: 100,
                margin: const EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: color2,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Proceed",
                  style: TextStyle(
                    color: color1,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
        ],
        backgroundColor: Colors.white,
        shadowColor: color3,
        elevation: 1.5,
      ),
      body: SafeArea(
          child: FutureBuilder(
        future: HttpApiCall().getUserMachines(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserMachines machineData = snapshot.data!;

            return machineData.resultArray!.isEmpty
                ? const NoMachineServicePage()
                : SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // const SizedBox(
                        //   height: 20,
                        // ),
                        ListView.builder(
                          itemCount: machineData.resultArray!.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final machine = machineData.resultArray![index];
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  if (selectedIndex == index) {
                                    selectedIndex = -1;
                                    machineID = "";
                                  } else {
                                    selectedIndex = index;
                                    machineID = machine.machineId.toString();
                                  }
                                });
                              },
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 16,
                                          width: 16,
                                          padding: const EdgeInsets.all(1.5),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: selectedIndex == index
                                                    ? color2
                                                    : color5,
                                                width: selectedIndex == index
                                                    ? 1.5
                                                    : 1,
                                              ),
                                              shape: BoxShape.circle),
                                          child: Container(
                                            height: 16,
                                            width: 16,
                                            decoration: BoxDecoration(
                                              color: selectedIndex == index
                                                  ? color2
                                                  : color4,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        Container(
                                          height: 90,
                                          width: 70,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image:
                                                  AssetImage(data[0]['image']),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                machine.label ?? "",
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                machine.brandName ?? "",
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                machine.modelName ?? "",
                                                style: TextStyle(
                                                  color: color5,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    color: color3,
                                    height: 1,
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 1.5,
                              width: 100,
                              color: color3,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              "or",
                              style: TextStyle(
                                fontSize: 13,
                                color: color5,
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Container(
                              height: 1.5,
                              width: 100,
                              color: color3,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddMachinePage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: color2,
                            minimumSize: const Size(120, 35),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: const Text(
                            "Add Device",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        )
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
      )),
    );
  }
}
