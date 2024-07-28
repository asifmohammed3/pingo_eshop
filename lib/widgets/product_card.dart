import 'package:eshop/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:eshop/models/product.dart';

class ProductCard extends StatelessWidget {
  final Products products;
  final bool isDiscounted;

  const ProductCard({
    super.key,
    required this.products,
    required this.isDiscounted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300]!,
            blurRadius: 5,
            spreadRadius: 1,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Center(
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Image.network(
                  products.images!.first,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              products.title!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              products.description!,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 5),
            isDiscounted ? showDiscountPrice() : showOriginalPrice(),
          ],
        ),
      ),
    );
  }

  Widget showOriginalPrice() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "\$${products.price!.toInt().toString()}",
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  Widget showDiscountPrice() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Text(
            "\$${products.price!.toStringAsFixed(1)}",
            style: TextStyle(
              fontSize: 14,
              decoration: TextDecoration.lineThrough,
              color: Colors.grey[600],
            ),
          ),
        ),
        Expanded(
          child: Text(
            "\$${products.priceAfterDiscount!.toStringAsFixed(1)}",
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic),
          ),
        ),
        Expanded(
          child: Text(
            "${products.discountPercentage.toString()}% off",
            style: const TextStyle(
              fontSize: 14,
              color: Colors.green,
            ),
          ),
        ),
      ],
    );
  }
}
