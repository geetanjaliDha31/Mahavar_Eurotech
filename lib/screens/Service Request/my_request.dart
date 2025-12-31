// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mahavar_eurotech/constants.dart';
import 'package:mahavar_eurotech/http/http.dart';
import 'package:mahavar_eurotech/models/user_request.dart';
import 'package:mahavar_eurotech/screens/Bottom%20nav%20bar/bottom_nav_bar.dart';
import 'package:mahavar_eurotech/screens/Machine/machine_page.dart';
import 'package:mahavar_eurotech/screens/Service%20Request/no_cancel_request.dart';
import 'package:mahavar_eurotech/screens/Service%20Request/no_service_page.dart';
import 'package:mahavar_eurotech/screens/Service%20Request/service_card.dart';
import 'package:mahavar_eurotech/widgets/expanable_page_view.dart';

class MyRequest extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const MyRequest({
    super.key,
    this.scaffoldKey,
  });

  @override
  State<MyRequest> createState() => _MyRequestState();
}

class _MyRequestState extends State<MyRequest> {
  int selectedIndex = 0;
  PageController contr = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 28,
            color: color1,
          ),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const BottomNavBar(),
              ),
              (route) => false,
            );
          },
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MachinePage(),
                ),
              );
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
                "Book Service",
                style: TextStyle(
                  color: color1,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
        ],
        title: Column(
          children: [
            Text(
              "MY REQUESTS",
              style: GoogleFonts.montserrat(
                  fontSize: 13, fontWeight: FontWeight.w500, color: color1),
            ),
          ],
        ),
        // backgroundColor: Colors.white,
        shadowColor: color3,
        elevation: 1.5,
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: HttpApiCall().getUserRequest(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              UserRequest? temp = snapshot.data!;

              if (temp.resultArray != null && temp.resultArray!.isNotEmpty) {
                final pendingRequest =
                    temp.resultArray![0].pendingCallDetailsArray ?? [];
                final requestHistory =
                    temp.resultArray![0].completedCallDetailsArray ?? [];

                List<Map<String, dynamic>> pendingRequestList = [];

                for (int i = 0; i < pendingRequest.length; i++) {
                  pendingRequestList.add({
                    'service_id': pendingRequest[i].serviceId?.toString() ?? '',
                    "issue_name": pendingRequest[i].issueName ?? '',
                    "service_date": pendingRequest[i].serviceDate ?? '',
                    'label': pendingRequest[i].label ?? '',
                    'status': pendingRequest[i].status ?? '',
                    'service_time': pendingRequest[i].serviceTime ?? '',
                  });
                }

                List<Map<String, dynamic>> requestHistoryList = [];

                for (int i = 0; i < requestHistory.length; i++) {
                  requestHistoryList.add({
                    'service_id': requestHistory[i].serviceId?.toString() ?? '',
                    "issue_name": requestHistory[i].issueName ?? '',
                    "service_date": requestHistory[i].serviceDate ?? '',
                    'label': requestHistory[i].label ?? '',
                    'status': requestHistory[i].status ?? '',
                    'service_time': requestHistory[i].serviceTime ?? '',
                  });
                }

                return pendingRequest.isEmpty && requestHistory.isEmpty
                    ? const NoServicePage()
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 40,
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedIndex = 0;
                                        contr.jumpToPage(0);
                                      });
                                    },
                                    splashColor: Colors.white,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          "Pending Requests",
                                          style: TextStyle(
                                            color: selectedIndex == 0
                                                ? color1
                                                : color5,
                                            fontSize: 13,
                                            fontWeight: selectedIndex == 0
                                                ? FontWeight.w600
                                                : FontWeight.w500,
                                          ),
                                        ),
                                        Container(
                                          height: 5,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          decoration: BoxDecoration(
                                            color: selectedIndex == 0
                                                ? color1
                                                : Colors.white,
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(19),
                                              topRight: Radius.circular(19),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedIndex = 1;
                                        contr.jumpToPage(1);
                                      });
                                    },
                                    splashColor: Colors.white,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          "Request History",
                                          style: TextStyle(
                                            color: selectedIndex == 1
                                                ? color1
                                                : color5,
                                            fontSize: 13,
                                            fontWeight: selectedIndex == 1
                                                ? FontWeight.w600
                                                : FontWeight.w500,
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          height: 5,
                                          decoration: BoxDecoration(
                                            color: selectedIndex == 1
                                                ? color1
                                                : Colors.white,
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(19),
                                              topRight: Radius.circular(19),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            ExpandablePageView(
                              controller: contr,
                              onPageChanged: (value) {
                                setState(() {
                                  selectedIndex = value;
                                });
                              },
                              children: [
                                pendingRequestList.isEmpty
                                    ? Column(
                                        children: const [
                                          SizedBox(
                                            height: 85,
                                          ),
                                          NoServicePage(),
                                        ],
                                      )
                                    : ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: pendingRequestList.length,
                                        itemBuilder: (context, index) {
                                          return ServiceCard(
                                            data: pendingRequestList[index],
                                            isClosed: selectedIndex == 1,
                                          );
                                        },
                                      ),
                                requestHistoryList.isEmpty
                                    ? Column(
                                        children: const [
                                          SizedBox(
                                            height: 85,
                                          ),
                                          NoCancelRequest(),
                                        ],
                                      )
                                    : ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: requestHistoryList.length,
                                        itemBuilder: (context, index) {
                                          return ServiceCard(
                                            data: requestHistoryList[index],
                                            isClosed: selectedIndex == 1,
                                          );
                                        },
                                      ),
                                Divider(
                                  color: color3,
                                  height: 0,
                                )
                              ],
                            ),
                          ],
                        ),
                      );
              } else {
                return NoServicePage();
              }
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
}
