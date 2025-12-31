// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:mahavar_eurotech/constants.dart';
import 'package:mahavar_eurotech/http/http.dart';
import 'package:mahavar_eurotech/models/get_all_address.dart';
import 'package:mahavar_eurotech/provider/panel_provider.dart';
import 'package:mahavar_eurotech/screens/Address/edit_address.dart';
import 'package:mahavar_eurotech/widgets/toast.dart';
import 'package:mahavar_eurotech/screens/Address/add_new_address.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ManageAddress extends StatefulWidget {
  const ManageAddress({super.key});

  @override
  State<ManageAddress> createState() => _ManageAddressState();
}

class _ManageAddressState extends State<ManageAddress> {
  @override
  void initState() {
    super.initState();
    // getData();
  }

  String googleApiKey = dotenv.env['GOOGLE_MAPS_API_KEY']!;
  double? latitude;
  double? longitude;
  String? pinCode;
  String? house;
  String? building;
  String? street;
  String? subLocality;
  String? address;
  double? lat;
  double? lng;
  String? addressId;
  Position? currentPosition;
  Future<void>? deletePopup(String addressId) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Delete Address",
              style: GoogleFonts.montserrat(
                  fontSize: 14, fontWeight: FontWeight.w500, color: color1),
            ),
            content: Text(
              'Are you sure you want to delete this address?',
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color5,
              ),
            ),
            actions: [
              TextButton(
                child: Text(
                  'Cancel',
                  style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: color5.withOpacity(0.8)),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  'Delete',
                  style: GoogleFonts.montserrat(
                      fontSize: 12, fontWeight: FontWeight.w500, color: color1),
                ),
                onPressed: () {
                  HttpApiCall()
                      .deleteAddress(context, {'address_id': addressId});
                  context.read<PanelProvider>().openPanel(const ManageAddress(),
                      MediaQuery.of(context).size.height * 0.6);
                },
              ),
            ],
            contentPadding: EdgeInsets.fromLTRB(16, 10, 16, 6),
            actionsPadding: EdgeInsets.only(bottom: 10, right: 10),
          );
        });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Manage Address",
                  style: GoogleFonts.montserrat(
                      fontSize: 13, fontWeight: FontWeight.w600, color: color2),
                ),
                SizedBox(width: 32),
                InkWell(
                  onTap: () async {
                    PermissionStatus locationStatus =
                        await checkLocationPermission();

                    if (locationStatus == PermissionStatus.granted) {
                      await checkPermission();
                    } else {
                      showToast(context, 'Location permission not granted', 3);
                    }
                  },
                  child: Container(
                    height: 40,
                    width: 150,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: color2,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "+ Add New Address",
                      style: TextStyle(
                        color: color1,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            FutureBuilder(
              future: HttpApiCall().getUserAddress(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  GetAllAddress addresses = snapshot.data!;
                  return addresses.resultArray!.isEmpty
                      ? const Text('No Address  Found',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold))
                      : SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ListView.builder(
                                itemCount: addresses.resultArray!.length,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final addData = addresses.resultArray![index];
                                  String temp =
                                      "${addData.addressLine1!}, ${addData.landmark}, ${addData.area!}, Pincode: ${addData.pincode!}.";
                                  double? lat = (addData.latitude != null)
                                      ? addData.latitude!.toDouble()
                                      : null;
                                  double? lng = (addData.longitude != null)
                                      ? addData.longitude!.toDouble()
                                      : null;

                                  addressId = addData.addressId.toString();
                                  return InkWell(
                                    onTap: () {
                                      print(lat);
                                      print(lng);
                                      print(addData.addressId);
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(15),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
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
                                                        fontWeight:
                                                            FontWeight.w600,
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
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                      // maxLines: 3,
                                                      // overflow:
                                                      //     TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              PopupMenuButton<int>(
                                                iconSize: 20,
                                                padding:
                                                    const EdgeInsets.all(0),
                                                onSelected: (item) {
                                                  if (item == 0) {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            EditAddress(
                                                          addressId: addData
                                                              .addressId
                                                              .toString(),
                                                        ),
                                                      ),
                                                    );
                                                  } else if (item == 1) {
                                                    updateLoc(addressId ?? "",
                                                        lat, lng);
                                                  } else if (item == 2) {
                                                    deletePopup(
                                                      addData.addressId
                                                          .toString(),
                                                    );
                                                  }
                                                },
                                                itemBuilder: (context) => [
                                                  const PopupMenuItem<int>(
                                                    value: 0,
                                                    child: Text('Edit Address'),
                                                  ),
                                                  const PopupMenuItem<int>(
                                                    value: 1,
                                                    child: Text(
                                                        'Change Map Location'),
                                                  ),
                                                  const PopupMenuItem<int>(
                                                    value: 2,
                                                    child:
                                                        Text('Delete Address'),
                                                  ),
                                                ],
                                              ),
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
          ],
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

  Future<void> checkUpdatePermission(
      double? lat, double? lng, String addressId) async {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then(
      (Position position) {
        setState(() {
          currentPosition = position;
        });

        if (lat != null && lng != null) {
          if (currentPosition != null) {
            showToast(context, 'Move your screen to select location', 3);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Stack(
                  children: [
                    PlacePicker(
                      apiKey: 'Your_API_Key_Here',
                      initialPosition: LatLng(lat, lng),
                      resizeToAvoidBottomInset: true,
                      useCurrentLocation: false,
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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      place?.formattedAddress ?? '',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(height: 8),
                                    ElevatedButton(
                                      onPressed: () {
                                        double? latitude =
                                            place?.geometry?.location.lat;
                                        double? longitude =
                                            place?.geometry?.location.lng;

                                        setState(() {
                                          HttpApiCall()
                                              .updateMapLocation(context, {
                                            'address_id': addressId,
                                            'latitude': latitude.toString(),
                                            'longitude': longitude.toString(),
                                          });
                                        });
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
                          minimumSize: Size(
                              MediaQuery.of(context).size.width * 0.38, 50),
                          maximumSize: Size(
                              MediaQuery.of(context).size.width * 0.38, 50),
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
                              fontSize: 13),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        } else {
          showToast(context, 'Latitude & Longitude are null', 3);
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

  void updateLoc(String addressId, double? lat, double? lng) async {
    PermissionStatus locationStatus = await checkLocationPermission();

    if (locationStatus == PermissionStatus.granted) {
      checkUpdatePermission(lat, lng, addressId);
    } else {
      showToast(context, 'Location permission not granted', 3);
    }
  }
}
