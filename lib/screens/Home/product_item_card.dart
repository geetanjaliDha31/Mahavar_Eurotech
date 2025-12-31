import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mahavar_eurotech/constants.dart';
import 'package:mahavar_eurotech/models/get_all_products.dart';
import 'package:mahavar_eurotech/screens/Products%20page/product_details_page.dart';
import 'package:html/parser.dart';

class ProductCardHome extends StatefulWidget {
  final ProductItem productData;

  const ProductCardHome({super.key, required this.productData});

  @override
  State<ProductCardHome> createState() => _ProductCardHomeState();
}

class _ProductCardHomeState extends State<ProductCardHome> {
 
  @override
  Widget build(BuildContext context) {

  // Function to remove HTML tags
  String removeHtmlTags(String htmlString) {
    final document = parse(htmlString);
    return parse(document.body!.text).documentElement!.text;
  }
  String description = removeHtmlTags(widget.productData.description ?? "");

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(
              productID: widget.productData.productId ?? "",
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
                    image: NetworkImage(widget.productData.productPhoto ?? ""),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.productData.productName ?? "",
              style: GoogleFonts.montserrat(
                fontSize: 12,
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              description,
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
                  widget.productData.productPrice ?? "",
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.productData.discountedPrice ?? "",
                  style: GoogleFonts.montserrat(
                    fontSize: 11,
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
            Text(
              "Save (₹${calculateSavings(widget.productData)})",
              style: GoogleFonts.montserrat(
                fontSize: 11,
                color: Colors.green,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String calculateSavings(ProductItem productData) {
    String priceWithoutCurrency =
        productData.productPrice?.replaceAll('₹', '') ?? '0';
    String discountedPriceWithoutCurrency =
        productData.discountedPrice?.replaceAll('₹', '') ?? '0';

    int price = int.tryParse(priceWithoutCurrency.replaceAll(',', '')) ?? 0;
    int discountedPrice =
        int.tryParse(discountedPriceWithoutCurrency.replaceAll(',', '')) ?? 0;

    int savings = -price + discountedPrice;

    return savings.toString();
  }
}
