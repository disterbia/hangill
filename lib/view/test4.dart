import 'dart:html' as HTML;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hangil/controller/admin_controller.dart';

class Test4 extends StatelessWidget {
  AdminController a = Get.put(AdminController());
  @override
  Widget build(BuildContext context) {
    return Obx(()=>
         ElevatedButton(onPressed: ()async{
        HTML.window.location.href='http://pf.kakao.com/_qASxjxj';
      }, child: Text("dd")),
    );
  }
}
