import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mahavar_eurotech/constants.dart';
import 'package:mahavar_eurotech/http/http.dart';
import 'package:mahavar_eurotech/models/get_product_desc.dart';
import 'package:html/parser.dart';
import 'package:mahavar_eurotech/widgets/toast.dart';

class ProductDetailsPage extends StatefulWidget {
  final String productID;
  const ProductDetailsPage({super.key, required this.productID});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int _carouselIndex = 0;
  bool isLoading = false;
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Product Details",
              style: GoogleFonts.montserrat(
                  fontSize: 13, fontWeight: FontWeight.w500, color: color1),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        shadowColor: color3,
        elevation: 1.5,
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: HttpApiCall().getProductDesc(widget.productID),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              ProductDescription productDescription = snapshot.data!;

              // Extracting data from the model
              String productName = productDescription
                      .resultArray![0].productDetailsArray![0].productName ??
                  '';
              // Function to remove HTML tags
              String removeHtmlTags(String htmlString) {
                final document = parse(htmlString);
                return parse(document.body!.text).documentElement!.text;
              }

              String description = removeHtmlTags(productDescription
                      .resultArray![0].productDetailsArray![0].description ??
                  '');

              String price = productDescription
                      .resultArray![0].productDetailsArray![0].price ??
                  '';
              String discountedPrice = productDescription.resultArray![0]
                      .productDetailsArray![0].discountedPrice ??
                  '';

              // Additional data
              Map<String, dynamic> specifications = {
                "Installation Type": productDescription.resultArray![0]
                        .productDetailsArray![0].installationType ??
                    '',
                "Water Type": productDescription
                        .resultArray![0].productDetailsArray![0].waterType ??
                    '',
                "Purification Type": productDescription.resultArray![0]
                        .productDetailsArray![0].purificationType ??
                    '',
                "Purification Technolgy": productDescription.resultArray![0]
                        .productDetailsArray![0].purificationTechnology ??
                    '',
                "Brand": productDescription
                        .resultArray![0].productDetailsArray![0].brand ??
                    '',
                "Model Series": productDescription
                        .resultArray![0].productDetailsArray![0].modelSeries ??
                    '',
                "Model Number": productDescription
                        .resultArray![0].productDetailsArray![0].modelNumber ??
                    '',
                'Dimension in cm': productDescription.resultArray![0]
                        .productDetailsArray![0].dimensionInCm ??
                    '',
                'Dimension in inches': productDescription.resultArray![0]
                        .productDetailsArray![0].dimensionInInches ??
                    '',
              };
              List<FeatureDetailsArray>? features =
                  productDescription.resultArray?[0].featureDetailsArray;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 240,
                      child: CarouselSlider(
                        items: productDescription
                            .resultArray![0].productImageArray!
                            .map((image) {
                          return Container(
                            height: 240,
                            width: 240,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: NetworkImage(image.productPhotos ?? ''),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          );
                        }).toList(),
                        options: CarouselOptions(
                          height: 240,
                          // aspectRatio: 16/9,
                          viewportFraction: 1,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          autoPlay: false,
                          autoPlayInterval: const Duration(seconds: 15),
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 900),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _carouselIndex = index;
                            });
                          },
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 10,
                      // width: 100,
                      alignment: Alignment.center,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: productDescription
                            .resultArray![0].productImageArray!.length,
                        itemBuilder: (BuildContext context, int index) {
                          // print(widget.productID);

                          return Container(
                            width: 8.0,
                            height: 8.0,
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _carouselIndex == index
                                  ? color1
                                  : Colors.white,
                              border: _carouselIndex == index
                                  ? Border.all(color: color1)
                                  : Border.all(color: color3, width: 1),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: color3,
                      height: 1.2,
                      thickness: 1,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            productName,
                            style: GoogleFonts.montserrat(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                            // maxLines: 1,
                            // overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Text(
                              description,
                              style: GoogleFonts.montserrat(
                                fontSize: 11,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          // const SizedBox(
                          //   height: 8,
                          // ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "₹$price",
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "₹$discountedPrice",
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  color: Colors.red,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: Colors.red,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                '(Save ₹${calculateSavings(price, discountedPrice)})',
                                style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 15,
                      color: color4,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Key Features',
                            style: GoogleFonts.montserrat(
                              fontSize: 13,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: features?.map((feature) {
                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        '\u2022',
                                        style:
                                            TextStyle(fontSize: 18, height: 1),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: Text(
                                          feature.featureDetails ?? '',
                                          textAlign: TextAlign.left,
                                          softWrap: true,
                                          style: GoogleFonts.montserrat(
                                            fontSize: 11,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList() ??
                                [],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 15,
                      color: color4,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Specifications',
                            style: GoogleFonts.montserrat(
                              fontSize: 13,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Water Purifier Technology',
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          GridView.count(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            childAspectRatio: 3,
                            crossAxisCount: 2,
                            children: specifications.entries
                                .where((entry) =>
                                    entry.value != null && entry.value != '')
                                .map((entry) => SizedBox(
                                      width: 300,
                                      height: 30,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            entry.key,
                                            style: GoogleFonts.montserrat(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            entry.value,
                                            style: GoogleFonts.montserrat(
                                              fontSize: 11,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )
                                        ],
                                      ),
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 15,
                      color: color4,
                    ),
                    SizedBox(
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 30,
                                width: 30,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        AssetImage('assets/original_logo.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Text(
                                "Genuine products",
                                style: GoogleFonts.montserrat(
                                    color: color1,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11),
                              )
                            ],
                          ),
                          Container(
                            width: 1,
                            height: 35,
                            color: color3,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 30,
                                width: 30,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        AssetImage('assets/quality_logo.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Text(
                                "Genuine products",
                                style: GoogleFonts.montserrat(
                                    color: color1,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 15,
                      color: color4,
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Easy 14 days returns and exchanges",
                            style: GoogleFonts.montserrat(
                                color: color1,
                                fontWeight: FontWeight.w700,
                                fontSize: 12),
                          ),
                          Text(
                            "Choose to return or exchange for a different size (if available) within 14 days.",
                            style: GoogleFonts.montserrat(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 10),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 15,
                      color: color4,
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
      ),
      bottomNavigationBar: Container(
        height: 60,
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: ElevatedButton(
          onPressed: () async {
            setState(() {
              isLoading = true;
            });

            try {
              await HttpApiCall().sendEnquiry(context, widget.productID);
            } catch (e) {
              showToast(context, "Error sending enquiry. Please try again.", 3);
            } finally {
              setState(() {
                isLoading = false;
              });
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: color2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            minimumSize: const Size(double.infinity, 50.0),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 3.0,
                  ),
                )
              : Text(
                  "ENQUIRY NOW",
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }

  String calculateSavings(String priceProdout, String discountProduct) {
    String priceWithoutCurrency = priceProdout.replaceAll('₹', '');
    String discountedPriceWithoutCurrency = discountProduct.replaceAll('₹', '');

    int price = int.tryParse(priceWithoutCurrency.replaceAll(',', '')) ?? 0;
    int discountedPrice =
        int.tryParse(discountedPriceWithoutCurrency.replaceAll(',', '')) ?? 0;

    int savings = -price + discountedPrice;

    return savings.toString();
  }
}
