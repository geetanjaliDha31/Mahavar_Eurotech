// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mahavar_eurotech/constants.dart';
import 'package:mahavar_eurotech/provider/panel_provider.dart';
import 'package:mahavar_eurotech/screens/Bottom%20nav%20bar/bottom_nav_time.dart';
import 'package:mahavar_eurotech/screens/Home/home.dart';
import 'package:mahavar_eurotech/screens/Profile/profile.dart';
import 'package:mahavar_eurotech/screens/Products%20page/products_page.dart';
import 'package:mahavar_eurotech/screens/Service%20Request/my_request.dart';
import 'package:mahavar_eurotech/widgets/drawer.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:toastification/toastification.dart';

// ignore: must_be_immutable
class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PageController _pageController = PageController();
  final PanelController _controller = PanelController();
  bool isPanelOpen = false;

  int _pageIndex = 0;

  void _setPage(int pageIndex) {
    setState(() {
      _pageController.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }

  DateTime? currentBackPressTime;
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (!isPanelOpen) {
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
        if (_pageController.page == 0) {
          currentBackPressTime = now;
          toastification.show(
            context: context,
            title: const Text('Tap on back again to close'),
            alignment: const Alignment(0.5, 0.9),
            showProgressBar: false,
            autoCloseDuration: const Duration(seconds: 2),
          );
        } else {
          _setPage(0);
        }

        return Future.value(false);
      }
    } else {
      _controller.close();
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: SafeArea(
        child: Stack(
          children: [
            Scaffold(
              key: _scaffoldKey,
              drawer: const DrawerWidget(),
              backgroundColor: Colors.white,
              bottomNavigationBar: BottomAppBar(
                height: 60,
                elevation: 10,
                color: Colors.white,
                padding: EdgeInsets.zero,
                shadowColor: color3,
                clipBehavior: Clip.antiAlias,
                shape: const CircularNotchedRectangle(),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: grey1,
                    //     spreadRadius: 10,
                    //     blurRadius: 12,
                    //     // offset: const Offset(0, 1),
                    //   ),
                    // ],
                  ),
                  child: Row(
                    children: [
                      BottomNavItem(
                          name: "Home",
                          iconData: "assets/home_nav.png",
                          isSelected: _pageIndex == 0,
                          onTap: () => _setPage(0)),
                      BottomNavItem(
                          name: "All Products",
                          iconData: "assets/product_nav.png",
                          isSelected: _pageIndex == 1,
                          onTap: () => _setPage(1)),
                      BottomNavItem(
                          name: "Service Request",
                          iconData: "assets/service_nav.png",
                          isSelected: _pageIndex == 2,
                          onTap: () => _setPage(2)),
                      BottomNavItem(
                          name: "Profile",
                          iconData: "assets/profile_nav.png",
                          isSelected: _pageIndex == 3,
                          onTap: () => _setPage(3)),
                    ],
                  ),
                ),
              ),
              body: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                children: [
                  HomePage(
                    // scaffoldKey: _scaffoldKey,
                  ),
                  ProductPage(
                    // scaffoldKey: _scaffoldKey,
                  ),
                  MyRequest(),
                  ProfilePage(
                    controller: _controller,
                  ),
                ],
              ),
            ),
            SlidingUpPanel(
              controller: _controller,
              minHeight: 0.0,
              maxHeight: context.watch<PanelProvider>().height,
              panelBuilder: (sc) {
                return context.watch<PanelProvider>().widget;
              },
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              backdropTapClosesPanel: true,
              // isDraggable: false,
              backdropEnabled: true,
              backdropColor: Colors.black,
              backdropOpacity: 0.4,
              onPanelOpened: () {
                isPanelOpen = true;
              },
              onPanelClosed: () {
                context
                    .read<PanelProvider>()
                    .openPanel(const SizedBox.shrink(), 0);
                isPanelOpen = false;
              },
            )
          ],
        ),
      ),
    );
  }
}
