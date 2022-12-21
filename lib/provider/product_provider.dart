import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hangil/dto/product_update_dto.dart';
import 'package:hangil/model/product.dart';

class ProductProvider{

  final _collection = "product";
  final _store = FirebaseFirestore.instance;

  Future<QuerySnapshot> findAll() =>
      _store.collection(_collection).orderBy("created", descending: true).get();

  Future<DocumentSnapshot> findById(String id) =>
      _store.doc("$_collection/$id").get();

  Future<QuerySnapshot> findByCategory(String category) => _store
      .collection(_collection)
      .where("category", isEqualTo: category)
      .orderBy("created", descending: true)
      .get();

  Future<DocumentSnapshot> save(Product product) =>
      _store.collection(_collection).add(product.toJson()).then((v) async {
        await v.update({"id": v.id});
        return v.get();
      });

  Future<void> update(Product product) {
    String? id = product.id;
    return _store
        .doc("$_collection/$id")
        .update(ProductUpdateDto(product: product).ProductToJson());
  }

  Future<void> delete(String id) => _store.doc("$_collection/$id").delete();


}