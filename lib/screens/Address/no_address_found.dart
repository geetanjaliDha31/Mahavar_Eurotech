// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mahavar_eurotech/constants.dart';
import 'package:mahavar_eurotech/widgets/toast.dart';
import 'package:mahavar_eurotech/screens/Address/add_new_address.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class NoAddressFound extends StatefulWidget {
  final String machineId;
  const NoAddressFound({
    super.key,
    required this.machineId,
  });

  @override
  State<NoAddressFound> createState() => _NoAddressFoundState();
}

class _NoAddressFoundState extends State<NoAddressFound> {
  double? latitude;
  double? longitude;
  String? pinCode;
  String? house;
  String? building;
  String? street;
  String? subLocality;
  String? address;
  Position? currentPosition;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Container(
            height: 250,
            width: 250,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/add_address.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        // SizedBox(
        //   height: 15,
        // ),
        Text(
          "No service address added yet",
          style: TextStyle(
              color: color2, fontWeight: FontWeight.w600, fontSize: 15),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          "Add Service Address for further service requests",
          style: TextStyle(
              color: color2, fontWeight: FontWeight.w400, fontSize: 13),
        ),
        const SizedBox(
          height: 25,
        ),
        ElevatedButton(
          onPressed: () async {
            PermissionStatus locationStatus = await checkLocationPermission();

            if (locationStatus == PermissionStatus.granted) {
              await checkPermission();
            } else {
              showToast(context, 'Location permission not granted', 3);
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
    );
  }

 Future<void> checkPermission() async{
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
                    apiKey: 'AIzaSyCWqJ7cq8ZoVTokiyTOVP8ndGF-umo6np4',
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
                                            machineId: widget.machineId,
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
