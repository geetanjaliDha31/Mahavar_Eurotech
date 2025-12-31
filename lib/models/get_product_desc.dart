import 'dart:convert';

ProductDescription ProductDescriptionFromJson(String str) =>
    ProductDescription.fromJson(json.decode(str));

String ProductDescriptionToJson(ProductDescription data) =>
    json.encode(data.toJson());

class ProductDescription {
  String? response;
  bool? error;
  String? message;
  List<ResultArray>? resultArray;

  ProductDescription(
      {this.response, this.error, this.message, this.resultArray});

  ProductDescription.fromJson(Map<String, dynamic> json) {
    response = json["response"];
    error = json["error"];
    message = json["message"];
    resultArray = json["result_array"] == null
        ? null
        : (json["result_array"] as List)
            .map((e) => ResultArray.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["response"] = response;
    data["error"] = error;
    data["message"] = message;
    if (resultArray != null) {
      data["result_array"] = resultArray?.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class ResultArray {
  List<ProductDetailsArray>? productDetailsArray;
  List<ProductImageArray>? productImageArray;
  List<FeatureDetailsArray>? featureDetailsArray;

  ResultArray(
      {this.productDetailsArray,
      this.productImageArray,
      this.featureDetailsArray});

  ResultArray.fromJson(Map<String, dynamic> json) {
    productDetailsArray = json["product_details_array"] == null
        ? null
        : (json["product_details_array"] as List)
            .map((e) => ProductDetailsArray.fromJson(e))
            .toList();
    productImageArray = json["product_image_array"] == null
        ? null
        : (json["product_image_array"] as List)
            .map((e) => ProductImageArray.fromJson(e))
            .toList();
    featureDetailsArray = json["feature_details_array"] == null
        ? null
        : (json["feature_details_array"] as List)
            .map((e) => FeatureDetailsArray.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (productDetailsArray != null) {
      data["product_details_array"] =
          productDetailsArray?.map((e) => e.toJson()).toList();
    }
    if (productImageArray != null) {
      data["product_image_array"] =
          productImageArray?.map((e) => e.toJson()).toList();
    }
    if (featureDetailsArray != null) {
      data["feature_details_array"] =
          featureDetailsArray?.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class FeatureDetailsArray {
  String? featureDetails;

  FeatureDetailsArray({this.featureDetails});

  FeatureDetailsArray.fromJson(Map<String, dynamic> json) {
    featureDetails = json["feature_details"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["feature_details"] = featureDetails;
    return data;
  }
}

class ProductImageArray {
  String? productPhotos;

  ProductImageArray({this.productPhotos});

  ProductImageArray.fromJson(Map<String, dynamic> json) {
    productPhotos = json["product_thumbnails"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["product_thumbnails"] = productPhotos;
    return data;
  }
}

class ProductDetailsArray {
  int? productId;
  String? brandId;
  String? modelId;
  String? productName;
  String? price;
  int? totalQty;
  String? discountedPrice;
  String? installationType;
  String? waterType;
  String? purificationType;
  String? purificationTechnology;
  String? brand;
  String? modelSeries;
  String? modelNumber;
  String? dimensionInCm;
  String? dimensionInInches;
  String? description;

  ProductDetailsArray(
      {this.productId,
      this.brandId,
      this.modelId,
      this.productName,
      this.price,
      this.totalQty,
      this.discountedPrice,
      this.installationType,
      this.waterType,
      this.purificationType,
      this.purificationTechnology,
      this.brand,
      this.modelSeries,
      this.modelNumber,
      this.dimensionInCm,
      this.dimensionInInches,
      this.description});

  ProductDetailsArray.fromJson(Map<String, dynamic> json) {
    productId = json["product_id"];
    brandId = json["brand_id"];
    modelId = json["model_id"];
    productName = json["product_name"];
    price = json["price"];
    totalQty = json["total_qty"];
    discountedPrice = json["discounted_price"];
    installationType = json["installation_type"];
    waterType = json["water_type"];
    purificationType = json["purification_type"];
    purificationTechnology = json["purification_technology"];
    brand = json["brand"];
    modelSeries = json["model_series"];
    modelNumber = json["model_number"];
    dimensionInCm = json["dimension_in_cm"];
    dimensionInInches = json["dimension_in_inches"];
    description = json["description"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["product_id"] = productId;
    data["brand_id"] = brandId;
    data["model_id"] = modelId;
    data["product_name"] = productName;
    data["price"] = price;
    data["total_qty"] = totalQty;
    data["discounted_price"] = discountedPrice;
    data["installation_type"] = installationType;
    data["water_type"] = waterType;
    data["purification_type"] = purificationType;
    data["purification_technology"] = purificationTechnology;
    data["brand"] = brand;
    data["model_series"] = modelSeries;
    data["model_number"] = modelNumber;
    data["dimension_in_cm"] = dimensionInCm;
    data["dimension_in_inches"] = dimensionInInches;
    data["description"] = description;
    return data;
  }
}
