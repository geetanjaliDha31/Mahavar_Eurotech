// ignore_for_file: unused_import

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mahavar_eurotech/constants.dart';
import 'package:mahavar_eurotech/http/http.dart';
import 'package:mahavar_eurotech/provider/mobileno_provider.dart';
import 'package:mahavar_eurotech/provider/panel_provider.dart';
import 'package:mahavar_eurotech/widgets/textfield.dart';
import 'package:mahavar_eurotech/widgets/toast.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

// ignore: must_be_immutable
class VerifyOtp extends StatefulWidget {
  PanelController controller;
  VerifyOtp({super.key, required this.controller});

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  final TextEditingController _pinController = TextEditingController();

  bool valueCheck = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    String mobileNumber = Provider.of<MobileNo>(context).mobileNumber;
    return Material(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 10, 28, 0),
        child: Form(
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Text(
                "Enter 4 Digits Pin",
                style: GoogleFonts.montserrat(
                    fontSize: 24, fontWeight: FontWeight.w700, color: color2),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                'Enter four digit code that you have recieved',
                style: GoogleFonts.montserrat(
                    fontSize: 13, fontWeight: FontWeight.w400, color: color2),
              ),
              const SizedBox(
                height: 45,
              ),
              Pinput(
                length: 4,
                showCursor: true,
                defaultPinTheme: PinTheme(
                    width: 50,
                    height: 50,
                    textStyle: GoogleFonts.montserrat(
                        fontSize: 19, fontWeight: FontWeight.w600),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: color3, width: 1.5))),
                focusedPinTheme: PinTheme(
                    width: 50,
                    height: 50,
                    textStyle: GoogleFonts.montserrat(
                        fontSize: 19, fontWeight: FontWeight.w600),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: color2, width: 1.5))),
                onCompleted: (pin) {
                  setState(() {
                    print(pin);
                    _pinController.text = pin;
                  });
                },
                validator: (pin) {
                  if (pin!.length != 4) {
                    return "Enter a valid pin";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(
                height: 15,
              ),
              Text.rich(
                TextSpan(
                  text: "Didn't receive this code? ",
                  style: TextStyle(
                    color: color3,
                    fontWeight: FontWeight.w600,
                  ),
                  children: [
                    TextSpan(
                      text: 'RESEND',
                      style: TextStyle(
                        color: color2,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          HttpApiCall().resendOTP(
                            context,
                            {
                              "mobile": mobileNumber,
                            },
                          );
                        },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 45,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_pinController.text.isNotEmpty &&
                      _pinController.text.length == 4) {
                    setState(() {
                      isLoading = true;
                    });

                    await HttpApiCall().updateMobileNumber(
                      context,
                      {
                        "mobile": mobileNumber,
                        "otp": _pinController.text,
                      },
                    );

                    setState(() {
                      isLoading = false;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: color2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  minimumSize: const Size(200, 50.0),
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
                    : Text(
                        'Verify',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
