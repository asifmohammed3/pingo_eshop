import 'package:eshop/providers/product_provider.dart';
import 'package:eshop/services/remote_config_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/product_card.dart';
import '../utils/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<ProductProvider>(context, listen: false)
        .fetchProducts(isInitialLoad: true);
    Provider.of<RemoteConfigProvider>(context, listen: false).fetchConfig();

    return Consumer2<ProductProvider, RemoteConfigProvider>(
      builder: (context, productProvider, remConfigProvider, child) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                color: lightColor,
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/signin');
                },
              ),
            ],
            title: const Text(
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
              ? const Center(child: CircularProgressIndicator())
              : productProvider.products.isEmpty
                  ? const Center(child: Text('No products found'))
                  : NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (!productProvider.isLoading &&
                            scrollInfo.metrics.pixels ==
                                scrollInfo.metrics.maxScrollExtent) {
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
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            final product = productProvider.products[index];
                            return ProductCard(
                              products: product,
                              isDiscounted: remConfigProvider.isDiscounted,
                            );
                          },
                        ),
                      ),
                    ),
        );
      },
    );
  }
}
