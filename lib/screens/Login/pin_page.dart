// ignore_for_file: await_only_futures, avoid_print

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mahavar_eurotech/constants.dart';
import 'package:mahavar_eurotech/http/http.dart';
import 'package:mahavar_eurotech/widgets/toast.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:pinput/pinput.dart';

class PinPage extends StatefulWidget {
  final Map<String, dynamic> data;
  const PinPage({super.key, required this.data});

  @override
  State<PinPage> createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  final TextEditingController _pinController = TextEditingController();
  bool isLoading = false;
  Future<void> checkPlayerId() async {
    while (playerId == null) {
      playerId = await OneSignal.User.pushSubscription.id;

      print("playerid: $playerId");

      if (playerId != null) {
        return; // Exit the future once playerid is available
      }

      await Future.delayed(
        const Duration(seconds: 1),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1,
      body: FutureBuilder(
        future: checkPlayerId(),
        builder: (context, snapshot) {
          if (playerId != null) {
            print(playerId);
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Container(
                      alignment: Alignment.topLeft,
                      height: 35,
                      width: 35,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: InkWell(
                        child: Center(
                          child: Icon(
                            Icons.arrow_back_rounded,
                            size: 25,
                            color: color1,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      // alignment: Alignment.center,
                      height: 205,
                      width: 180,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/login_pic.png"),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  // SizedBox(height: 15,),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.60,
                    padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        color: Colors.white),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 5,
                          width: 120,
                          decoration: BoxDecoration(
                            color: color3,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Text(
                          "Enter 4 Digits Pin",
                          style: GoogleFonts.montserrat(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: color2),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Enter four digit code that you have recieved',
                          style: GoogleFonts.montserrat(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: color2),
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
                                  border:
                                      Border.all(color: color3, width: 1.5))),
                          focusedPinTheme: PinTheme(
                              width: 50,
                              height: 50,
                              textStyle: GoogleFonts.montserrat(
                                  fontSize: 19, fontWeight: FontWeight.w600),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border:
                                      Border.all(color: color2, width: 1.5))),
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
                                        "mobile": widget.data['mobile'],
                                      },
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 65,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            print('pid');
                            print(playerId);
                            if (_pinController.text.isNotEmpty &&
                                _pinController.text.length == 4 &&
                                playerId != null) {
                              setState(() {
                                isLoading = true;
                              });

                              try {
                                await HttpApiCall().verifyOTP(
                                  context,
                                  {
                                    "mobile": widget.data['mobile'],
                                    'player_id': playerId,
                                    "otp": _pinController.text,
                                  },
                                );
                              } catch (e) {
                                showToast(
                                    context,
                                    "Error verifying OTP. Please try again.",
                                    3);
                              } finally {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            } else {
                              showToast(context, "Please enter a valid OTP", 3);
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
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
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
      ),
    );
  }
}
