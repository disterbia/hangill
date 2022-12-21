import 'package:hangil/model/product.dart';

class ProductUpdateDto {
  final Product? product;

  ProductUpdateDto({
    this.product});

  Map<String, dynamic> ProductToJson() =>
      {
        "name": product?.name,
        "comment": product?.comment,
        "price": product?.price,
        // "mainImageUrl": product?.mainImageUrl,
        "category": product?.category,
        "body" : product?.body
        // "detailImageUrl": product?.detailImageUrl,
      };
}