// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mahavar_eurotech/constants.dart';
import 'package:mahavar_eurotech/http/http.dart';
import 'package:mahavar_eurotech/provider/mobileno_provider.dart';
import 'package:mahavar_eurotech/provider/panel_provider.dart';
import 'package:mahavar_eurotech/screens/Profile/Profile%20Sliding%20panel%20items/verify_otp.dart';
import 'package:mahavar_eurotech/widgets/textfield.dart';
import 'package:mahavar_eurotech/widgets/toast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

// ignore: must_be_immutable
class ChangeNumber extends StatefulWidget {
  PanelController controller;
  ChangeNumber({super.key, required this.controller});

  @override
  State<ChangeNumber> createState() => _ChangeNumberState();
}

class _ChangeNumberState extends State<ChangeNumber> {
  TextEditingController mobileno = TextEditingController();

  bool valueCheck = false;
  bool isLoading = false;

  // @override
  // void initState() {
  //  // TODO: implement initState
  //   super.initState();
  //   _updateData();
  // }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   mobileno.dispose();
  //   super.dispose();
  // }

  // Future<void> _updateData() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     mobileno.text = prefs.getString("mobileno") ?? '';
  //   });
  // }

  // Future<void> _saveData() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString('mobileno', mobileno.text);
  // }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 10, 28, 0),
        child: Form(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Change Mobile Number",
                    style: GoogleFonts.montserrat(
                        fontSize: 18,
                        color: color2,
                        fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                      onPressed: () {
                        widget.controller.close();
                      },
                      icon: Icon(
                        Icons.close_rounded,
                        size: 28,
                        color: color2,
                      ))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Enter your WhatsApp Number to continue.",
                style: TextStyle(
                  color: color5,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              TextBox(
                controller: mobileno,
                hinttext: "Mobile Number",
                label: "",
                obscureText: false,
                isNumber: true,
                icon: Icons.phone,
              ),
              const SizedBox(
                height: 8,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "A 4 digit OTP will be sent via WhatsApp to verify your phone number.",
                style: TextStyle(
                  color: color3,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 55,
              ),
              ElevatedButton(
                onPressed: () {
                  if (mobileno.text.length == 10) {
                    Provider.of<MobileNo>(context, listen: false)
                        .setMobileNumber(mobileno.text);
                    HttpApiCall().sendOTP(
                      context,
                      {
                        "mobile": mobileno.text,
                        "page_type": "update_no",
                      },
                    );
                    context.read<PanelProvider>().openPanel(
                        ChangeNumber(
                          controller: widget.controller,
                        ),
                        MediaQuery.of(context).size.height * 0.5);
                    widget.controller.close();
                    context.read<PanelProvider>().openPanel(
                        VerifyOtp(
                          controller: widget.controller,
                        ),
                        MediaQuery.of(context).size.height * 0.5);
                    widget.controller.open();
                  } else {
                    showToast(context, "Enter a Valid 10 Digit Number", 3);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: color2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  minimumSize: const Size(double.infinity, 55.0),
                ),
                child: Text('Continue',
                    style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
