// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:mahavar_eurotech/constants.dart';
import 'package:mahavar_eurotech/http/http.dart';
import 'package:mahavar_eurotech/models/get_all_address.dart';
import 'package:mahavar_eurotech/screens/Address/add_new_address.dart';
import 'package:mahavar_eurotech/screens/Address/no_address_found.dart';
import 'package:mahavar_eurotech/screens/Service%20Request/service_request.dart';
import 'package:mahavar_eurotech/widgets/toast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChooseAddressPage extends StatefulWidget {
  final String? machineId;

  const ChooseAddressPage({
    super.key,
    this.machineId,
  });

  @override
  State<ChooseAddressPage> createState() => _ChooseAddressPageState();
}

class _ChooseAddressPageState extends State<ChooseAddressPage> {
  int selectedIndex = -1;
  String selectedAddressId = "";
  double? latitude;
  double? longitude;
  String? pinCode;
  String? house;
  String? building;
  String? street;
  String? subLocality;
  String? address;
  String googleApiKey = dotenv.env['GOOGLE_MAPS_API_KEY']!;

  Position? currentPosition;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                "ADDRESS",
                style: GoogleFonts.montserrat(
                    fontSize: 13, fontWeight: FontWeight.w500, color: color1),
              ),
            ],
          ),
          actions: [
            if (selectedIndex != -1)
              InkWell(
                onTap: () {
                  print("machine id");
                  print(widget.machineId!);

                  if (widget.machineId!.isEmpty) {
                    showToast(
                        context, 'Please select product from previous page', 3);
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ServiceRequestPage(
                          machineID: widget.machineId ?? '',
                          addressID: selectedAddressId,
                        ),
                      ),
                    );
                  }
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
              ),
          ],
          backgroundColor: Colors.white,
          shadowColor: color3,
          elevation: 1.5,
        ),
        body: FutureBuilder(
          future: HttpApiCall().getUserAddress(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              GetAllAddress addresses = snapshot.data!;
              return addresses.resultArray!.isEmpty
                  ? NoAddressFound(machineId: widget.machineId!)
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // const SizedBox(
                          //   height: 20,
                          // ),
                          ListView.builder(
                            itemCount: addresses.resultArray!.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final addData = addresses.resultArray![index];
                              String temp =
                                  "${addData.addressLine1!}, ${addData.landmark}, ${addData.area!}, Pincode: ${addData.pincode!}.";

                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    if (selectedIndex == index) {
                                      selectedIndex = -1;
                                      selectedAddressId = "";
                                    } else {
                                      selectedIndex = index;
                                      selectedAddressId =
                                          addData.addressId.toString();
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
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  addData.addressType!,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  temp,
                                                  style: TextStyle(
                                                    color: color5,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  // maxLines: 3,
                                                  // overflow:
                                                  //     TextOverflow.ellipsis,
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
                            onPressed: () async {
                              PermissionStatus locationStatus =
                                  await checkLocationPermission();

                              if (locationStatus == PermissionStatus.granted) {
                                await checkPermission();
                              } else {
                                showToast(context,
                                    'Location permission not granted', 3);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: color2,
                              minimumSize: const Size(120, 35),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: const Text(
                              "Add Address",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
            } else if (snapshot.hasError) {
              print("Error: ${snapshot.error}");
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

  Future<void> checkPermission() async {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then(
      (Position position) {
        setState(() {
          currentPosition = position;
        });
        if (currentPosition != null) {
          showToast(context, 'Move your screen to select location', 3);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Stack(
                children: [
                  PlacePicker(
                    apiKey: googleApiKey,
                    initialPosition: LatLng(37.77483, -122.41942),
                    resizeToAvoidBottomInset: true,
                    useCurrentLocation: true,
                    selectInitialPosition: true,
                    usePlaceDetailSearch: true,
                    selectedPlaceWidgetBuilder:
                        (context, place, details, animationController) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 40),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 20),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 6.0,
                                    spreadRadius: 0.0,
                                    offset: Offset(0.0, -3.0),
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    place?.formattedAddress ?? '',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  // Customize additional details as needed

                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        latitude =
                                            place?.geometry!.location.lat;
                                        longitude =
                                            place?.geometry!.location.lng;

                                        for (var component
                                            in place!.addressComponents!) {
                                          for (var type in component.types) {
                                            if (type == "postal_code") {
                                              pinCode = component.longName;
                                            } else if (type == "sublocality") {
                                              subLocality = component.longName;
                                            } else if (type ==
                                                    "street_number" ||
                                                type == 'premise' ||
                                                type == 'subpremise') {
                                              house = component.longName;
                                            } else if (type == 'neighborhood') {
                                              building = component.longName;
                                            } else if (type == 'route') {
                                              street = component.longName;
                                            }
                                          }
                                        }
                                        address = "$house"
                                            ','
                                            '$building'
                                            ","
                                            "$street";
                                      });
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddNewAddress(
                                            machineId: widget.machineId ?? '',
                                            area: subLocality ?? "",
                                            pinCode: pinCode ?? '',
                                            latitude: latitude ?? 0,
                                            longitude: longitude ?? 0,
                                            address: address ?? '',
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text('Select This Place'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    forceSearchOnZoomChanged: true,
                    automaticallyImplyAppBarLeading: false,
                    autocompleteLanguage: "en",
                    region: 'us',
                  ),
                  Positioned(
                    bottom: -1.5,
                    left: 0,
                    right: 0,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color2,
                        padding: const EdgeInsets.all(0),
                        minimumSize:
                            Size(MediaQuery.of(context).size.width * 0.38, 50),
                        maximumSize:
                            Size(MediaQuery.of(context).size.width * 0.38, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(2),
                            topRight: Radius.circular(2),
                          ),
                          side: BorderSide(
                            color: color2,
                          ),
                        ),
                      ),
                      child: const Text(
                        "Select Your Location",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    ).catchError((e) {
      showToast(context, 'Location permission not granted', 3);
      print(e);
    });
  }

  Future<PermissionStatus> checkLocationPermission() async {
    PermissionStatus status = await Permission.location.request();
    return status;
  }
}
