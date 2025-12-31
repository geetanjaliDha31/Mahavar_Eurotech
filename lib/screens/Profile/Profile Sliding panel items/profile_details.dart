import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mahavar_eurotech/constants.dart';
import 'package:mahavar_eurotech/http/http.dart';
import 'package:mahavar_eurotech/widgets/textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

// ignore: must_be_immutable
class ProfiledetailsPage extends StatefulWidget {
  PanelController controller;
  ProfiledetailsPage({super.key, required this.controller});

  @override
  State<ProfiledetailsPage> createState() => _ProfiledetailsPageState();
}

class _ProfiledetailsPageState extends State<ProfiledetailsPage> {
  TextEditingController fullName = TextEditingController();
  // TextEditingController lastname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mobileno = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool valueCheck = false;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _updateData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    fullName.dispose();
    // lastname.dispose();
    email.dispose();
    mobileno.dispose();
    super.dispose();
  }

  Future<void> _updateData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fullName.text = prefs.getString('full_name') ?? '';
      // lastname.text = prefs.getString('last_name') ?? '';
      email.text = prefs.getString('email') ?? '';
      mobileno.text = prefs.getString("mobile_no") ?? '';
    });
  }

  Future<void> _saveData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('first_name', fullName.text);
    // prefs.setString('last_name', lastname.text);
    prefs.setString('email', email.text);
    // prefs.setString('mobile', mobileno.text);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 10, 28, 0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Profile Details",
                    style: GoogleFonts.montserrat(
                        fontSize: 18,
                        color: color2,
                        fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                      onPressed: () {
                        widget.controller.close();

                        // dispose();
                      },
                      icon: Icon(
                        Icons.close_rounded,
                        size: 28,
                        color: color2,
                      ))
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     TextBox(
              //       controller: fullName,
              //       label: "First Name",
              //       obscureText: false,
              //       hinttext: "First Name",
              //       width: 145,
              //       height: 55,
              //     ),
              //     TextBox(
              //       controller: lastname,
              //       label: "Last Name",
              //       hinttext: "Last Name",
              //       obscureText: false,
              //       width: 145,
              //       height: 55,
              //     ),
              //   ],
              // ),
              TextBox(
                controller: fullName,
                label: "Full Name",
                obscureText: false,
                hinttext: "Full Name",
                height: 55,
                icon: Icons.person,
              ),
              const SizedBox(
                height: 8,
              ),
              TextBox(
                controller: mobileno,
                label: "Mobile number",
                hinttext: "Mobile number",
                obscureText: false,
                height: 55,
                isNumber: true,
                icon: Icons.phone_android_rounded,
              ),
              const SizedBox(
                height: 8,
              ),
              TextBox(
                controller: email,
                label: "Email Address",
                hinttext: "Email Address",
                obscureText: false,
                height: 55,
                validator: (value) {
                  if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                      .hasMatch(value!)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                icon: Icons.mail_rounded,
              ),
              // const SizedBox(height: 5),
              const SizedBox(
                height: 20,
              ),

              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      isLoading = true;
                    });

                    try {
                      await HttpApiCall().updateProfileDetails(
                          context, fullName.text, email.text);
                      _saveData();
                    } catch (e) {
                      print('Error in updating profile: $e');
                    } finally {
                      setState(() {
                        isLoading = false;
                      });
                    }
                  } else {
                    print('Error in updating profile');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: color2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  minimumSize: const Size(double.infinity, 55.0),
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
                        'UPDATE DETAILS',
                        style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
