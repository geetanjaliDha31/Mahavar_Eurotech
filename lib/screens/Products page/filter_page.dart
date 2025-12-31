import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mahavar_eurotech/constants.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  double _minRange = 0;
  double _maxRange = 30000;

  List<int> selectedTechnology = [];
  List<String> technologyList = [
    'All',
    'RO',
    'UV',
    'RO',
    'RO',
    'UV',
    'RO',
    'RO',
    'UV',
    'RO',
  ];

  List<int> selectedBrands = [];
  List<String> brandList = [
    'LG (7)',
    'HAVELLS (20)',
    'Aquaguard (2)',
    'KENT (29)',
    'SAMSUNG (1)',
    'Huwaei (4)',
    'LG (7)',
    'HAVELLS (20)',
    'Aquaguard (2)',
    'KENT (29)',
    'SAMSUNG (1)',
    'Huwaei (4)',
  ];

  List<int> selectedDiscount = [];
  List<String> discountList = [
    'Below 20% (7)',
    '20% to 40% (20)',
    '40% to 60% (2)',
    '60% to 80% (29)',
  ];

  List<int> selectedpurifierType = [];
  List<String> purifierTypeList = [
    'Electrical (7)',
    'Non-Electrical (20)',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 28,
            color: color1,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "PRODUCTS",
          style: GoogleFonts.montserrat(
              fontSize: 13, fontWeight: FontWeight.w500, color: color1),
        ),
        backgroundColor: Colors.white,
        shadowColor: color3,
        elevation: 1.5,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "Purification Technology",
                  style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    itemCount: technologyList.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (selectedTechnology.contains(index)) {
                                selectedTechnology.remove(index);
                              } else {
                                selectedTechnology.add(index);
                              }
                            });
                          },
                          child: Container(
                            height: 20,
                            width: 60,
                            decoration: BoxDecoration(
                              color: selectedTechnology.contains(index)
                                  ? color1
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              border: selectedTechnology.contains(index)
                                  ? Border.all(color: color1, width: 1)
                                  : Border.all(color: Colors.black, width: 1),
                            ),
                            child: Center(
                              child: Text(
                                technologyList[index],
                                style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  color: selectedTechnology.contains(index)
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
          Container(
            height: 15,
            color: color4,
            width: MediaQuery.of(context).size.width,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "Price Range",
                  style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black),
                ),
                // const SizedBox(
                //   height: 10,
                // ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "₹${_minRange.toInt()}",
                        style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                      Text(
                        "₹${_maxRange.toInt()}",
                        style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ),
                RangeSlider(
                  values: RangeValues(_minRange, _maxRange),
                  min: 0,
                  max: 30000,
                  divisions: 100,
                  onChanged: (value) {
                    setState(() {
                      _minRange = value.start;
                      _maxRange = value.end;
                    });
                  },
                  activeColor: color1,
                  labels: RangeLabels(_minRange.toInt().toString(),
                      _maxRange.toInt().toString()),
                ),
                // const SizedBox(
                //   height: 15,
                // ),
              ],
            ),
          ),
          Container(
            height: 15,
            color: color4,
            width: MediaQuery.of(context).size.width,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "Choose Brand",
                  style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    itemCount: brandList.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (selectedBrands.contains(index)) {
                                selectedBrands.remove(index);
                              } else {
                                selectedBrands.add(index);
                              }
                            });
                          },
                          child: Container(
                            height: 20,
                            // width: 60,
                            decoration: BoxDecoration(
                              color: selectedBrands.contains(index)
                                  ? color1
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              border: selectedBrands.contains(index)
                                  ? Border.all(color: color1, width: 1)
                                  : Border.all(color: Colors.black, width: 1),
                            ),
                            child: Center(
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                child: Text(
                                  brandList[index],
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    color: selectedBrands.contains(index)
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
          Container(
            height: 15,
            color: color4,
            width: MediaQuery.of(context).size.width,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "Discount",
                  style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    itemCount: discountList.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (selectedDiscount.contains(index)) {
                                selectedDiscount.remove(index);
                              } else {
                                selectedDiscount.add(index);
                              }
                            });
                          },
                          child: Container(
                            height: 20,
                            // width: 60,
                            decoration: BoxDecoration(
                              color: selectedDiscount.contains(index)
                                  ? color1
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              border: selectedDiscount.contains(index)
                                  ? Border.all(color: color1, width: 1)
                                  : Border.all(color: Colors.black, width: 1),
                            ),
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              child: Center(
                                child: Text(
                                  discountList[index],
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    color: selectedDiscount.contains(index)
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
          Container(
            height: 15,
            color: color4,
            width: MediaQuery.of(context).size.width,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "Purifier Type",
                  style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    itemCount: purifierTypeList.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (selectedpurifierType.contains(index)) {
                                selectedpurifierType.remove(index);
                              } else {
                                selectedpurifierType.add(index);
                              }
                            });
                          },
                          child: Container(
                            height: 20,
                            // width: 60,
                            decoration: BoxDecoration(
                              color: selectedpurifierType.contains(index)
                                  ? color1
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              border: selectedpurifierType.contains(index)
                                  ? Border.all(color: color1, width: 1)
                                  : Border.all(color: Colors.black, width: 1),
                            ),
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              child: Center(
                                child: Text(
                                  purifierTypeList[index],
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    color: selectedpurifierType.contains(index)
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
          Container(
            height: 15,
            color: color4,
            width: MediaQuery.of(context).size.width,
          ),
          const SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 50,
                    width: 155,
                    padding: const EdgeInsets.all(5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: color1, width: 1.25),
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      'DISCARD',
                      style: GoogleFonts.montserrat(
                          color: color1,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const FilterPage(),
                    //   ),
                    // );
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 50,
                    width: 155,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: color1,
                        border: Border.all(color: color1, width: 1.25),
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      'APPLY',
                      style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
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
}
