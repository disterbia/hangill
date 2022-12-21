import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hangil/model/product.dart';
import 'package:hangil/provider/product_provider.dart';

class ProductRepository{
  final ProductProvider _productProvider = ProductProvider();


  Future<List<Product>> findAll() async {
    QuerySnapshot querySnapshot = await _productProvider.findAll();
    List<Product> products = querySnapshot.docs
        .map((e) => Product.fromJson(e.data() as Map<String, dynamic>))
        .toList();
    return products;
  }

  Future<Product> findById(String id) async {
    DocumentSnapshot result = await _productProvider.findById(id);
    return Product.fromJson(result.data() as Map<String, dynamic>);
  }

  Future<Product> save(Product product) async {
    DocumentSnapshot result = await _productProvider.save(product);
    return Product.fromJson(result.data() as Map<String, dynamic>);
  }

  Future<List<Product>> findByCategory(String category) async {
    QuerySnapshot querySnapshot =
    await _productProvider.findByCategory(category);
    List<Product> products = querySnapshot.docs
        .map((e) => Product.fromJson(e.data() as Map<String, dynamic>))
        .toList();
    return products;
  }

  Future<void> update(Product product) async {
    await _productProvider.update(product);
  }

  Future<void> delete(String id) async{
    await _productProvider.delete(id);
  }

}