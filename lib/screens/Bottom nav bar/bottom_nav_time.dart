// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mahavar_eurotech/constants.dart';

class BottomNavItem extends StatelessWidget {
  final String? iconData;
  final VoidCallback? onTap;
  final bool? isSelected;
  final String name;
  const BottomNavItem(
      {super.key,
      @required this.iconData,
      this.onTap,
      this.isSelected = false,
      required this.name});

  String getImagePath() {
    if (isSelected!) {
      return iconData!.replaceAll('.png', '_sel.png');
    } else {
      return iconData!;
    }
  }

  @override
  Widget build(BuildContext context) {
    double widthData() {
      if (name == "Home" || name == "Profile") {
        return MediaQuery.of(context).size.width * 0.22;
      } else {
        return MediaQuery.of(context).size.width * 0.28;
      }
    }

    return SizedBox(
      width: widthData(),
      child: IconButton(
        padding: EdgeInsets.zero,
        splashColor: Colors.white,
        color: Colors.white,
        icon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 2,
            ),
            Image.asset(
              getImagePath(),
              width: 20,
              height: 20,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              name,
              style: TextStyle(
                color: isSelected! ? color1 : Colors.black,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
        onPressed: onTap!,
      ),
    );
  }
}
