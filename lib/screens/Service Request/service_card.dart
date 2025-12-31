// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mahavar_eurotech/constants.dart';
import 'package:mahavar_eurotech/http/http.dart';
import 'package:mahavar_eurotech/screens/Service%20Request/edit_service.dart';
import 'package:mahavar_eurotech/screens/Service%20Request/my_request.dart';
import 'package:mahavar_eurotech/widgets/textfield.dart';

class ServiceCard extends StatefulWidget {
  final Map<String, dynamic> data;
  final bool isClosed;

  const ServiceCard({
    super.key,
    required this.data,
    required this.isClosed,
  });

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  TextEditingController date = TextEditingController();
  @override
  void initState() {
    super.initState();
    date.text = widget.data['service_date'];
    // _updateData();
  }

  // Future<void> _updateData() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     date.text = prefs.getString('service_date') ?? '';
  //   });
  // }

  // Future<void> _saveData() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString('service_date', date.text);
  // }

  Future<void>? datePopup() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Update Date",
              style: GoogleFonts.montserrat(
                  fontSize: 14, fontWeight: FontWeight.w500, color: color1),
            ),
            content: SizedBox(
              height: 90,
              child: Column(
                children: [
                  Text(
                    'Select service date to Update ',
                    style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: color3),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextBox(
                    controller: date,
                    hinttext: " Service Date",
                    readOnly: true,
                    icon: Icons.calendar_month_outlined,
                    label: "",
                    obscureText: false,
                    // hintStyle: GoogleFonts.montserrat(
                    //     fontSize: 12,
                    //     fontWeight: FontWeight.w500,
                    //     color: color5),
                    // labelSize: 10,
                    onTap: () {
                      showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1999),
                          lastDate: DateTime(DateTime.now().year + 5),
                          selectableDayPredicate: (DateTime date) {
                            // Disable previous dates (highlighting)
                            return date.isAfter(
                                DateTime.now().subtract(Duration(days: 1)));
                          }).then((value) {
                        if (value != null) {
                          setState(() {
                            // Format the selected date to "day month year" format
                            final formattedDate =
                                DateFormat('dd-MM-yyyy').format(value);
                            date.text = formattedDate;
                          });
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text(
                  'Cancel',
                  style: GoogleFonts.montserrat(
                      fontSize: 12, fontWeight: FontWeight.w500, color: color5),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  'Submit',
                  style: GoogleFonts.montserrat(
                      fontSize: 12, fontWeight: FontWeight.w500, color: color1),
                ),
                onPressed: () {
                  HttpApiCall().changeServiceDate(context, {
                    'service_id': widget.data["service_id"],
                    'service_date': date.text,
                  }).then(
                    (value) => Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => MyRequest()),
                        (route) => false),
                  );
                },
              ),
            ],
            contentPadding: EdgeInsets.fromLTRB(14, 10, 14, 2),
            actionsPadding: EdgeInsets.only(bottom: 10, right: 10),
          );
        });
    return null;
  }

  Color mainColor = green;

  assignColor() {
    if (widget.data['status'] == "pending") {
      mainColor = orange;
    } else if (widget.data['status'] == "cancelled") {
      mainColor = red;
    } else if (widget.data['status'] == "completed") {
      mainColor = green;
    } else {
      mainColor = green;
    }
  }

  @override
  Widget build(BuildContext context) {
    assignColor();
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          Divider(
            color: color3,
            height: 1,
          ),
          SizedBox(
            height: 120,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 110,
                    padding: const EdgeInsets.fromLTRB(16, 8, 10, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 4,
                        ),
                        SizedBox(
                          height: 20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.data['label'],
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              if (!widget.isClosed)
                                PopupMenuButton<int>(
                                  iconSize: 20,
                                  padding: const EdgeInsets.all(0),
                                  onSelected: (item) {
                                    if (item == 0) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditServiceRequest(
                                            data: widget.data,
                                          ),
                                        ),
                                      );
                                    } else if (item == 1) {
                                      // _saveData();
                                      datePopup();
                                    } else if (item == 2) {
                                      HttpApiCall().cancelServiceRequest(
                                        context,
                                        {
                                          'service_id':
                                              widget.data['service_id'],
                                        },
                                      );

                                      print('cancel request');
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    const PopupMenuItem<int>(
                                      value: 0,
                                      child: Text('Edit Request'),
                                    ),
                                    const PopupMenuItem<int>(
                                      value: 1,
                                      child: Text('Change Service Date'),
                                    ),
                                    const PopupMenuItem<int>(
                                      value: 2,
                                      child: Text('Cancel Request'),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              const TextSpan(
                                text: 'Issue: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                              TextSpan(
                                text: widget.data['issue_name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              const TextSpan(
                                text: 'Service Date & Time : ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                              TextSpan(
                                text: "${widget.data['service_date']}"
                                    " "
                                    "${widget.data['service_time']}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Status: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: mainColor),
                              ),
                              TextSpan(
                                text: widget.data['status'],
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: mainColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    date.dispose();
    super.dispose();
  }
}
