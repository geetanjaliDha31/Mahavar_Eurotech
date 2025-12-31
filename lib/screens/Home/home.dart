// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mahavar_eurotech/constants.dart';
import 'package:mahavar_eurotech/http/http.dart';
import 'package:mahavar_eurotech/models/get_brand.dart';
import 'package:mahavar_eurotech/screens/Home/product_item_card.dart';
import 'package:mahavar_eurotech/screens/Home/product_search.dart';
import 'package:mahavar_eurotech/screens/Notification/notification.dart';
import 'package:mahavar_eurotech/screens/Products%20page/products_page.dart';
import 'package:mahavar_eurotech/screens/Service%20Request/my_request.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mahavar_eurotech/models/get_all_products.dart';

class HomePage extends StatefulWidget {
  // final GlobalKey<ScaffoldState> scaffoldKey;
  const HomePage({
    super.key,
    // required this.scaffoldKey,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // int _carouselIndex = 0;
  @override
  void initState() {
    super.initState();
    loaddata().whenComplete(() => searchfilter());
    loadImage();
  }

  bool isLoading = true;
  AllProducts? products;
  Future loaddata() async {
    products = await HttpApiCall().getAllProducts();
    setState(() {
      isLoading = false;
    });
  }

  Future searchfilter() async {
    setState(() {
      for (int i = 0; i < products!.productArray!.length; i++) {
        productsSearchList.add({
          "product_name": products!.productArray![i].productName,
          "description": products!.productArray![i].description,
          "product_price": products!.productArray![i].productPrice,
          "discounted_price": products!.productArray![i].discountedPrice,
          "product_id": products!.productArray![i].productId.toString(),
          "product_image": products!.productArray![i].productPhoto,
        });
      }
    });
  }

  @override
  void dispose() {
    productsSearchList.clear();
    super.dispose();
  }

  // List<String> imageList = [
  //   'assets/home_carousel.jpg',
  //   'assets/home_carousel.jpg',
  //   'assets/home_carousel.jpg',
  //   'assets/home_carousel.jpg',
  //   'assets/home_carousel.jpg',
  // ];
  String imageUrl = '';

  loadImage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      imageUrl = prefs.getString("profile_image") ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color4,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: color2,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Home",
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 135,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: IconButton(
                              icon: Icon(
                                Icons.notifications_none_rounded,
                                size: 22,
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => NotificationPage(),
                                  ),
                                );
                              },
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(imageUrl),
                              radius: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 20, 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 45,
                            width: 320,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Search',
                                  border: InputBorder.none,
                                  prefixIcon: IconButton(
                                    icon: Icon(
                                      Icons.search,
                                      color: color1,
                                    ),
                                    onPressed: () {
                                      showSearch(
                                        context: context,
                                        delegate: ProductSearch(),
                                      );
                                    },
                                  ),
                                ),
                                onTap: () {
                                  showSearch(
                                    context: context,
                                    delegate: ProductSearch(),
                                  );
                                }),
                          ),
                          // InkWell(
                          //   onTap: () {},
                          //   child: Container(
                          //     height: 45,
                          //     width: 50,
                          //     decoration: BoxDecoration(
                          //       color: Colors.white,
                          //       borderRadius: BorderRadius.circular(8),
                          //     ),
                          //     child: Center(
                          //         child:
                          //             Icon(Icons.filter_list, color: color1)),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Container(
              //   height: 190,
              //   color: Colors.white,
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       const SizedBox(
              //         height: 8,
              //       ),
              //       SizedBox(
              //         height: 160,
              //         child: CarouselSlider(
              //           items: imageList.map((imagePath) {
              //             return Container(
              //               height: 130,
              //               width: 320,
              //               decoration: BoxDecoration(
              //                 borderRadius: BorderRadius.circular(12),
              //                 image: DecorationImage(
              //                   image: AssetImage(imagePath),
              //                   fit: BoxFit.fitWidth,
              //                 ),
              //               ),
              //             );
              //           }).toList(),
              //           options: CarouselOptions(
              //             height: 140,
              //             // aspectRatio: 16/9,
              //             viewportFraction: 1,
              //             initialPage: 0,
              //             enableInfiniteScroll: true,
              //             autoPlay: true,
              //             autoPlayInterval: const Duration(seconds: 15),
              //             autoPlayAnimationDuration:
              //                 const Duration(milliseconds: 900),
              //             autoPlayCurve: Curves.fastOutSlowIn,
              //             onPageChanged: (index, reason) {
              //               setState(() {
              //                 _carouselIndex = index;
              //               });
              //             },
              //             scrollDirection: Axis.horizontal,
              //           ),
              //         ),
              //       ),
              //       // const SizedBox(height: 5),
              //       SizedBox(
              //         height: 10,
              //         width: 100,
              //         child: ListView.builder(
              //           scrollDirection: Axis.horizontal,
              //           itemCount: imageList.length,
              //           itemBuilder: (BuildContext context, int index) {
              //             return Container(
              //               width: 9.0,
              //               height: 9.0,
              //               margin: const EdgeInsets.symmetric(horizontal: 4.0),
              //               decoration: BoxDecoration(
              //                 shape: BoxShape.circle,
              //                 color: _carouselIndex == index
              //                     ? color1
              //                     : Colors.white,
              //                 border: _carouselIndex == index
              //                     ? Border.all(color: color1)
              //                     : Border.all(color: color3, width: 1),
              //               ),
              //             );
              //           },
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // const SizedBox(
              //   height: 15,
              // ),
              Container(
                height: 138,
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Column(
                  children: [
                    // const SizedBox(
                    //   height: 8,
                    // ),
                    // Text(
                    //   'Brands',
                    //   style: GoogleFonts.montserrat(
                    //       fontSize: 15,
                    //       fontWeight: FontWeight.w600,
                    //       color: Colors.black),
                    //   textAlign: TextAlign.center,
                    // ),
                    const SizedBox(
                      height: 10,
                    ),
                    FutureBuilder(
                      future: HttpApiCall().getBrandData(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          GetBrand brandData = snapshot.data!;

                          return SizedBox(
                            height: 110,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: brandData
                                      .resultArray?[0].brandsArray?.length ??
                                  0,
                              itemBuilder: (context, index) {
                                // final data = brandList[index];
                                final brand = brandData
                                    .resultArray?[0].brandsArray?[index];
                                return Container(
                                  margin: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 90,
                                        width: 90,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                brand?.brandPhoto ?? ''),
                                            fit: BoxFit.contain,
                                          ),
                                          border: Border.all(
                                              color: color3, width: 0.2),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                      ),
                                      Text(
                                        brand?.brandName ?? '',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
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
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              FutureBuilder(
                future: HttpApiCall().getAllProducts(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var listdata = snapshot.data!.productArray!;
                    return listdata.isEmpty
                        ? SizedBox()
                        : Container(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            // padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            color: Colors.white,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 18,
                                ),
                                GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: listdata.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 13,
                                      mainAxisSpacing: 13,
                                      childAspectRatio: 155 / 180,
                                    ),
                                    itemBuilder: (context, index) {
                                      return ProductCardHome(
                                        productData: listdata[index],
                                      );
                                    }),
                                const SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                  height: 30,
                                  // color: Colors.pink,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProductPage(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "View More",
                                      style: GoogleFonts.montserrat(
                                          fontSize: 13,
                                          color: color2,
                                          fontWeight: FontWeight.w700,
                                          decoration: TextDecoration.underline,
                                          decorationColor: color2),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
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
              const SizedBox(
                height: 15,
              ),
              Container(
                height: 280,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Facing issues with your water purifier?",
                      style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    Text(
                      "Let us help you with your problems",
                      style: GoogleFonts.montserrat(
                          fontSize: 13,
                          // fontWeight: FontWeight.w500,

                          color: color3),
                    ),
                    Center(
                      child: Container(
                        height: 160,
                        width: 160,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/service_home.png"))),
                      ),
                    ),
                    Center(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyRequest(),
                            ),
                          );
                        },
                        child: Container(
                          height: 50,
                          width: 155,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: color1, width: 1.25),
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: 28,
                                width: 28,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: color1),
                                child: const Icon(
                                  CupertinoIcons.wrench,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              Text(
                                'Service Request',
                                style: GoogleFonts.montserrat(
                                    color: color1,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                height: 330,
                width: 330,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                      image: AssetImage('assets/banner_home.png'),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 35,
                    ),
                    Container(
                      // height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 90,
                            child: Text(
                              '90 Days Warranty',
                              style: GoogleFonts.montserrat(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                              maxLines: 2,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            height: 50,
                            width: 1.5,
                            color: Colors.black,
                          ),
                          Container(
                            width: 90,
                            margin: const EdgeInsets.all(8),
                            child: Text(
                              'High Quality Spare Parts',
                              style: GoogleFonts.montserrat(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                              maxLines: 2,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            height: 50,
                            width: 1.5,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 90,
                            child: Text(
                              '10 Years+ Experience',
                              style: GoogleFonts.montserrat(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                              maxLines: 2,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
