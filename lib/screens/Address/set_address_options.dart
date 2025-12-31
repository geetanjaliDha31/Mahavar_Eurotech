import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mahavar_eurotech/constants.dart';

class SetAddressOptions extends StatefulWidget {
  const SetAddressOptions({super.key});

  @override
  State<SetAddressOptions> createState() => _SetAddressOptionsState();
}

class _SetAddressOptionsState extends State<SetAddressOptions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              "SET ADDRESS",
              style: GoogleFonts.montserrat(
                  fontSize: 13, fontWeight: FontWeight.w500, color: color1),
            ),
          ],
        ),
        backgroundColor: color4,
        shadowColor: color3,
        elevation: 1.5,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.white,
                height: 175,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      height: 40,
                      child: InkWell(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.my_location_rounded,
                              color: color2,
                              size: 22,
                            ),
                            const SizedBox(width: 20),
                            Text(
                              "Current Location",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: color2,
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: color3,
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      height: 40,
                      child: InkWell(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.map_pin,
                              color: color2,
                              size: 22,
                            ),
                            const SizedBox(width: 20),
                            Text(
                              "Locate on Map",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: color2,
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: color3,
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      height: 40,
                      child: InkWell(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_rounded,
                              color: color2,
                              size: 22,
                            ),
                            const SizedBox(width: 20),
                            Text(
                              "Add New Service Address",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: color2,
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      height: 8,
                      color: color3.withOpacity(0.6),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
