import 'package:eshop/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/product_card.dart';
import '../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isFirstLoad = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirstLoad) {
      Provider.of<ProductProvider>(context, listen: false)
          .fetchProducts(isInitialLoad: true);
      _isFirstLoad = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: Icon(Icons.logout),
                color: lightColor,
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/signin');
                },
              ),
            ],
            title: Text(
              '  e-Shop',
              style: TextStyle(
                fontFamily: fontPoppins,
                fontWeight: fontWeightBold,
                color: lightColor,
              ),
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          body: productProvider.isLoading && productProvider.products.isEmpty
              ? Center(child: CircularProgressIndicator())
              : productProvider.products.isEmpty
                  ? Center(child: Text('No products found'))
                  : NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (!productProvider.isLoading &&
                            scrollInfo.metrics.pixels ==
                                scrollInfo.metrics.maxScrollExtent) {
                          print(
                              'End of list reached, loading more products...');
                          productProvider.loadMoreProducts();
                          return true;
                        }
                        return false;
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.66,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            mainAxisExtent: 300,
                          ),
                          itemCount: productProvider.products.length +
                              (productProvider.isLoading ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == productProvider.products.length) {
                              return Center(child: CircularProgressIndicator());
                            }
                            final product = productProvider.products[index];
                            return ProductCard(products: product);
                          },
                        ),
                      ),
                    ),
        );
      },
    );
  }
}
