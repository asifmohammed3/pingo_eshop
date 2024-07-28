import 'package:eshop/services.dart/product_service.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  final ProductService _productService = ProductService();

  List<Products> _products = [];
  List<Products> get products => _products;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _skip = 0;
  final int _limit = 10; // Number of products to fetch per page

  Future<void> fetchProducts({bool isInitialLoad = false}) async {
    if (isInitialLoad) {
      _products = []; // Reset products list for initial load
      _skip = 0; // Reset skip count for initial load
    }

    _isLoading = true;
    notifyListeners();

    try {
      print('Fetching products: skip=$_skip, limit=$_limit');
      final product =
          await _productService.fetchProducts(skip: _skip, limit: _limit);
      if (isInitialLoad) {
        _products = product.products!;
      } else {
        _products.addAll(product.products!);
      }
      _skip += _limit;
      print('Fetched ${product.products!.length} products');
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void loadMoreProducts() {
    if (!_isLoading) {
      fetchProducts();
    }
  }
}
