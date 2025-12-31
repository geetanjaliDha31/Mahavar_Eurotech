// ignore_for_file: prefer_const_constructors, unused_local_variable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mahavar_eurotech/constants.dart';
import 'package:mahavar_eurotech/screens/Products%20page/product_details_page.dart';

class ProductSearch extends SearchDelegate {
  // ProductArray? productData;
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List matchQuery = [];
    for (var product in productsSearchList) {
      if (product['product_name'].toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add({
          'pname': product["product_name"],
          'pdesc': product['description'],
          'pprice': product['product_price'],
          'dprice': product['discounted_price'],
          "pid": product["product_id"],
          'pimage': product['product_image'],
        });
      }
    }
    if (matchQuery.isEmpty) {
      return const Center(
        child: Text(
          'No Data Found',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      );
    } else {
      return SingleChildScrollView(
        child: Container(
          height: 430,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          color: Colors.white,
          child: Column(
            children: [
              const SizedBox(
                height: 18,
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: matchQuery.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 13,
                    mainAxisSpacing: 13,
                    childAspectRatio: 155 / 180),
                itemBuilder: (context, index) {
                  final data = matchQuery[index];
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsPage(
                            productID: data['pid'],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 180,
                      width: 155,
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: color3, width: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 0,
                            offset: const Offset(0, 1),
                          ),
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 0,
                            offset: const Offset(1, 0),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Center(
                            child: Container(
                              height: 90,
                              width: 100,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    data['pimage'],
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            data['pname'],
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            data['pdesc'],
                            style: GoogleFonts.montserrat(
                              fontSize: 10,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                data['pprice'],
                                style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                data['dprice'],
                                style: GoogleFonts.montserrat(
                                  fontSize: 11,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ),
                          // Text(
                          //   "Save (₹${calculateSavings(productData!)})",
                          //   style: GoogleFonts.montserrat(
                          //     fontSize: 11,
                          //     color: Colors.green,
                          //     fontWeight: FontWeight.w500,
                          //   ),
                          //   textAlign: TextAlign.center,
                          // ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List matchQuery = [];
    for (var product in productsSearchList) {
      if (product['product_name'].toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add({
          'pname': product["product_name"],
          'pdesc': product['description'],
          'pprice': product['product_price'],
          'dprice': product['discounted_price'],
          "pid": product["product_id"],
          'pimage': product['product_image'],
        });
      }
    }
    if (matchQuery.isEmpty) {
      return const Center(
        child: Text(
          'No Data Found',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      );
    } else {
      return SingleChildScrollView(
        child: Container(
          height: 430,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          color: Colors.white,
          child: Column(
            children: [
              const SizedBox(
                height: 18,
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: matchQuery.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 13,
                    mainAxisSpacing: 13,
                    childAspectRatio: 155 / 180),
                itemBuilder: (context, index) {
                  final data = matchQuery[index];
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsPage(
                            productID: data['pid'],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 180,
                      width: 155,
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: color3, width: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 0,
                            offset: const Offset(0, 1),
                          ),
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 0,
                            offset: const Offset(1, 0),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Center(
                            child: Container(
                              height: 90,
                              width: 100,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    data['pimage'],
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            data['pname'],
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            data['pdesc'],
                            style: GoogleFonts.montserrat(
                              fontSize: 10,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                data['pprice'] ?? '',
                                style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                data['dprice'],
                                style: GoogleFonts.montserrat(
                                  fontSize: 11,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ),
                          // Text(
                          //   "Save (₹${calculateSavings(productData!)})",
                          //   style: GoogleFonts.montserrat(
                          //     fontSize: 11,
                          //     color: Colors.green,
                          //     fontWeight: FontWeight.w500,
                          //   ),
                          //   textAlign: TextAlign.center,
                          // ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      );
    }
  }

  // String calculateSavings(ProductArray productData) {
  //   String priceWithoutCurrency =
  //       productData.productPrice?.replaceAll('₹', '') ?? '0';
  //   String discountedPriceWithoutCurrency =
  //       productData.discountedPrice?.replaceAll('₹', '') ?? '0';

  //   int price = int.tryParse(priceWithoutCurrency.replaceAll(',', '')) ?? 0;
  //   int discountedPrice =
  //       int.tryParse(discountedPriceWithoutCurrency.replaceAll(',', '')) ?? 0;

  //   int savings = -price + discountedPrice;

  //   return savings.toString();
  // }
}
