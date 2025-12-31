// ignore_for_file: prefer_const_constructors, avoid_print, await_only_futures

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mahavar_eurotech/constants.dart';
import 'package:mahavar_eurotech/http/http.dart';
import 'package:mahavar_eurotech/provider/mobileno_provider.dart';
import 'package:mahavar_eurotech/screens/Login/login.dart';
import 'package:mahavar_eurotech/widgets/textfield.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({
    super.key,
  });

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  // final TextEditingController _lastnameController = TextEditingController();
  // final TextEditingController _phoneNoController = TextEditingController();y
  bool isLoading = false;

  final FocusNode _emailNode = FocusNode();
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

  bool valueCheck = false;

  @override
  Widget build(BuildContext context) {
    String mobileNumber = Provider.of<MobileNo>(context).mobileNumber;
    return Scaffold(
      body: FutureBuilder(
        future: checkPlayerId(),
        builder: (context, snapshot) {
          if (playerId != null) {
            print(playerId);
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                            color: color1,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8))),
                        child: InkWell(
                          child: const Center(
                            child: Icon(
                              Icons.arrow_back_rounded,
                              size: 25,
                              color: Colors.white,
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                                (route) => false);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Text(
                        "Let's Get Started",
                        style: GoogleFonts.montserrat(
                            fontSize: 23, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Create your own account",
                        style: GoogleFonts.montserrat(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 3.0, right: 3),
                        child: TextBox(
                          controller: _fullnameController,
                          label: "Full Name",
                          obscureText: false,
                          hinttext: "Full Name",
                          icon: Icons.person,
                          height: 55,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter full name';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 6,
                        ),
                        child: Text(
                          'Mobile Number',
                          style: GoogleFonts.montserrat(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 3.0, right: 3),
                        child: TextBox(
                          label: '',
                          hinttext: mobileNumber,
                          style: GoogleFonts.montserrat(
                              color: color3,
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                          readOnly: true,
                          icon: Icons.phone,
                          validator: (value) {
                            if (value?.length != 10) {
                              return 'Please enter a valid 10-digit phone number';
                            }

                            return null;
                          },
                          obscureText: false,
                          isNumber: true,
                        ),
                      ),
                      // ),
                      const SizedBox(height: 8.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 3, right: 3),
                        child: TextBox(
                          controller: _emailController,
                          hinttext: "Email address",
                          validator: (value) {
                            if (!RegExp(
                                    r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                                .hasMatch(value!)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                          obscureText: false,
                          label: 'Email Address',
                          node: _emailNode,
                          icon: Icons.mail_outline_rounded,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate() &&
                              playerId != null) {
                            setState(() {
                              isLoading = true;
                            });

                            print('Email: ${_emailController.text}');
                            await HttpApiCall().registerUser(context, {
                              'full_name': _fullnameController.text,
                              'player_id': playerId,
                              'mobile_no': mobileNumber,
                              'user_email': _emailController.text,
                            });

                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          minimumSize: const Size(double.infinity, 50.0),
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
                            : Text('SIGN UP',
                                style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                ),
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
