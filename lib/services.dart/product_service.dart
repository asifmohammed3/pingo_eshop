import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  final String apiUrl = "https://dummyjson.com/products";

  Future<Product> fetchProducts({required int skip, required int limit}) async {
    final response =
        await http.get(Uri.parse('$apiUrl?skip=$skip&limit=$limit'));
    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load products');
    }
  }
}
