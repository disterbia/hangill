import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hangil/dto/menu_update_dto.dart';
import 'package:hangil/model/menu.dart';
class MenuProvider{

  final _collection = "menu";
  final _store = FirebaseFirestore.instance;

  Future<QuerySnapshot> findAll() =>
      _store.collection(_collection).orderBy("created", descending: false).get();

  Future<DocumentSnapshot> save(Menu menu) =>
      _store.collection(_collection).add(menu.toJson()).then((v) async {
        await v.update({"id": v.id});
        return v.get();
      });

  Future<void> update(Menu menu) {
    String? id = menu.id;
    return _store
        .doc("$_collection/$id")
        .update(MenuUpdateDto(menu: menu).MenuToJson());
  }

  Future<void> delete(String id) => _store.doc("$_collection/$id").delete();
}