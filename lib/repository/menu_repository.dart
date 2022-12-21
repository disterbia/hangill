import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hangil/model/menu.dart';
import 'package:hangil/provider/menu_provider.dart';

class MenuRepository{

  final MenuProvider _menuProvider = MenuProvider();

  Future<List<Menu>> findAll() async {
    QuerySnapshot querySnapshot = await _menuProvider.findAll();
    List<Menu> menus = querySnapshot.docs
        .map((e) => Menu.fromJson(e.data() as Map<String, dynamic>))
        .toList();
    return menus;
  }

  Future<void> save(Menu menu) async {
    DocumentSnapshot result = await _menuProvider.save(menu);
    // return Menu.fromJson(result.data() as Map<String, dynamic>);
  }

  Future<void> update(Menu menu) async {
    await _menuProvider.update(menu);
  }

  Future<void> delete(String id) async{
    await _menuProvider.delete(id);
  }
}