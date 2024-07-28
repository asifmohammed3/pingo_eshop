import 'dart:developer';

class Product {
  List<Products>? products;
  int? total;
  int? skip;
  int? limit;

  Product({this.products, this.total, this.skip, this.limit});

  Product.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
    total = json['total'];
    skip = json['skip'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    data['total'] = total;
    data['skip'] = skip;
    data['limit'] = limit;
    return data;
  }
}

class Products {
  int? id;
  String? title;
  String? description;
  double? price;
  double? discountPercentage;
  double? priceAfterDiscount;
  List<String>? images;

  Products({
    this.id,
    this.title,
    this.description,
    this.price,
    this.discountPercentage,
    this.priceAfterDiscount,
    this.images,
  });

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    price = (json['price'] as num?)?.toDouble();
    discountPercentage = (json['discountPercentage'] as num?)?.toDouble();
    images = List<String>.from(json['images']);
    priceAfterDiscount = calculatePriceAfterDiscount();
    log("id: $id, title: $title, description: $description, price: $price, discountPercentage: $discountPercentage, images: $images, priceAfterDiscount: $priceAfterDiscount");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['price'] = price;
    data['discountPercentage'] = discountPercentage;
    data['images'] = images;
    data['priceAfterDiscount'] = priceAfterDiscount;
    return data;
  }

  double calculatePriceAfterDiscount() {
    if (price != null && discountPercentage != null) {
      return price! - (price! * (discountPercentage! / 100));
    } else {
      return 0.0;
    }
  }
}
