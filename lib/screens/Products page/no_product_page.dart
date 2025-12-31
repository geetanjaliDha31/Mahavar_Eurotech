// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mahavar_eurotech/constants.dart';

class NoProductPage extends StatefulWidget {
  const NoProductPage({super.key});

  @override
  State<NoProductPage> createState() => _NoServicePageState();
}

class _NoServicePageState extends State<NoProductPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 120,
        ),
        Center(
          child: Container(
            height: 250,
            width: 250,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/No data.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),

        Text(
          "No products to show",
          style: TextStyle(
              color: color2, fontWeight: FontWeight.w600, fontSize: 16),
        ),
        // const SizedBox(
        //   height: 5,
        // ),
        // Text(
        //   "Book service to solve your issue",
        //   style: TextStyle(
        //       color: color2, fontWeight: FontWeight.w400, fontSize: 13),
        // ),
        // const SizedBox(
        //   height: 25,
        // ),
      ],
    );
  }
}
