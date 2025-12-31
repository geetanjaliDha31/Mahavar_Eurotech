import 'dart:convert';

AllProducts AllProductsFromJson(String str) =>
    AllProducts.fromJson(json.decode(str));

String AllProductsToJson(AllProducts data) => json.encode(data.toJson());

class AllProducts {
  AllProducts({
    this.response,
    this.error,
    this.message,
    this.productArray,
  });

  String? response;
  bool? error;
  String? message;
  List<ProductItem>? productArray;

  factory AllProducts.fromJson(Map<String, dynamic> json) => AllProducts(
        response: json["response"],
        error: json["error"],
        message: json["message"],
        productArray: json["product_array"] == null
            ? []
            : List<ProductItem>.from(
                json["product_array"].map((x) => ProductItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "response": response,
        "error": error,
        "message": message,
        "product_array": productArray == null
            ? []
            : List<dynamic>.from(productArray!.map((x) => x.toJson())),
      };
}

class ProductItem {
  ProductItem({
    this.productId,
    this.brandName,
    this.modelName,
    this.productName,
    this.productPhoto,
    this.productPrice,
    this.discountedPrice,
    this.description,
  });

  String? productId;
  String? brandName;
  String? modelName;
  String? productName;
  String? productPhoto;
  String? productPrice;
  String? discountedPrice;
  String? description;

  factory ProductItem.fromJson(Map<String, dynamic> json) => ProductItem(
        productId: json["product_id"],
        brandName: json["brand_name"],
        modelName: json["model_name"],
        productName: json["product_name"],
        productPhoto: json["product_photo"],
        productPrice: json["product_price"],
        discountedPrice: json["discounted_price"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "brand_name": brandName,
        "model_name": modelName,
        "product_name": productName,
        "product_photo": productPhoto,
        "product_price": productPrice,
        "discounted_price": discountedPrice,
        "description": description,
      };
}
