import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hangil/model/menu.dart';

class CreateButton{
  static List<Widget> createButton(int length,List<Menu> menus, BuildContext context,{List<bool>? selection}) {
    List<Widget> list = [];
    for (int i = 0; i < length; i++) {
      list.add(ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: selection!=null? selection[i] ? Colors.grey : Colors.transparent : Colors.transparent,
            shadowColor: Colors.transparent,
            onPrimary: Colors.black),
        onPressed: () {
          if(selection!=null)
          for (int j = 0; j < selection.length; j++) {
            selection[j] = i == j;
          }
          //nowCategory = menus[i].id;
          // p.changeCategory(i);
          //_search.clear();
          // WidgetsBinding.instance!.addPersistentFrameCallback((_) {
          context.go("/home/$i");
          // });
        },
        child: Text(menus[i].name!,
            style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
      ));
    }
    return list;
  }
}