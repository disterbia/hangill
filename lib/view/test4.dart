import 'dart:html' as HTML;

import 'package:flutter/material.dart';

class Test4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: ()async{
      HTML.window.location.href='http://pf.kakao.com/_qASxjxj';
    }, child: Text("dd"));
  }
}
