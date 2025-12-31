import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mahavar_eurotech/constants.dart';
import 'package:mahavar_eurotech/http/http.dart';
import 'package:mahavar_eurotech/screens/Bottom%20nav%20bar/bottom_nav_bar.dart';
import 'package:mahavar_eurotech/screens/Home/product_item_card.dart';
import 'package:mahavar_eurotech/screens/Products%20page/no_product_page.dart';
import 'package:mahavar_eurotech/widgets/hydration_vector.dart';

class ProductPage extends StatefulWidget {
  // final GlobalKey<ScaffoldState> scaffoldKey;

  const ProductPage({
    super.key,
    // required this.scaffoldKey,
  });

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const BottomNavBar(),
              ),
            );
          },
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Column(
            children: [
              Text(
                "PRODUCTS",
                style: GoogleFonts.montserrat(
                    fontSize: 13, fontWeight: FontWeight.w500, color: color1),
              ),
              Text(
                "Water Purifiers",
                style: GoogleFonts.montserrat(
                    fontSize: 11,
                    // fontWeight: FontWeight.w500,
                    color: color3),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        shadowColor: color3,
        elevation: 1.5,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: FutureBuilder(
          future: HttpApiCall().getAllProducts(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var listdata = snapshot.data!.productArray!;

              return listdata.isEmpty
                  ? const NoProductPage()
                  : Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       InkWell(
                        //         onTap: () {},
                        //         child: Container(
                        //           height: 50,
                        //           width: 155,
                        //           padding: const EdgeInsets.all(5),
                        //           decoration: BoxDecoration(
                        //               color: Colors.white,
                        //               border: Border.all(color: color1, width: 1.25),
                        //               borderRadius: BorderRadius.circular(5)),
                        //           child: Row(
                        //             mainAxisAlignment: MainAxisAlignment.center,
                        //             children: [
                        //               SizedBox(
                        //                 height: 18,
                        //                 width: 18,
                        //                 child: SvgPicture.asset(
                        //                   "assets/Sort Vector.svg",
                        //                   colorFilter: ColorFilter.mode(
                        //                       color1, BlendMode.srcIn),
                        //                 ),
                        //               ),
                        //               const SizedBox(
                        //                 width: 5,
                        //               ),
                        //               Text(
                        //                 'Sort',
                        //                 style: GoogleFonts.montserrat(
                        //                     color: color1,
                        //                     fontSize: 14,
                        //                     fontWeight: FontWeight.w600),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //       InkWell(
                        //         onTap: () {
                        //           Navigator.of(context).push(
                        //             MaterialPageRoute(
                        //               builder: (context) => const FilterPage(),
                        //             ),
                        //           );
                        //         },
                        //         child: Container(
                        //           height: 50,
                        //           width: 155,
                        //           padding: const EdgeInsets.all(5),
                        //           decoration: BoxDecoration(
                        //               color: Colors.white,
                        //               border: Border.all(color: color1, width: 1.25),
                        //               borderRadius: BorderRadius.circular(5)),
                        //           child: Row(
                        //             mainAxisAlignment: MainAxisAlignment.center,
                        //             children: [
                        //               SizedBox(
                        //                 height: 18,
                        //                 width: 18,
                        //                 child: SvgPicture.asset(
                        //                   "assets/Filter Vector.svg",
                        //                   colorFilter: ColorFilter.mode(
                        //                       color1, BlendMode.srcIn),
                        //                 ),
                        //               ),
                        //               const SizedBox(
                        //                 width: 5,
                        //               ),
                        //               Text(
                        //                 'Filter',
                        //                 style: GoogleFonts.montserrat(
                        //                     color: color1,
                        //                     fontSize: 14,
                        //                     fontWeight: FontWeight.w600),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       )
                        //     ],
                        //   ),
                        // ),
                        // const SizedBox(
                        //   height: 15,
                        // ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10.0,
                                    mainAxisSpacing: 10.0,
                                    childAspectRatio: 155 / 180),
                            itemCount: listdata.length,
                            itemBuilder: (context, index) {
                              return ProductCardHome(
                                productData: listdata[index],
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const HydrationMotivation(),
                        // const SizedBox(
                        //   height: 30,
                        // )
                      ],
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
      )),
    );
  }
}
