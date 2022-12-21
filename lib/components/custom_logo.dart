import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hangil/util/custom_screen_width.dart';

class CustomLogo extends StatelessWidget {
  CustomLogo(this.screenWidth);
  double screenWidth;
  bool isDeskTop=GetPlatform.isDesktop;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(cursor: SystemMouseCursors.click,
      child: GestureDetector(
          onTap: () => context.go("/"),
          child: Image.asset("assets/logo.png",height: !isDeskTop&&screenWidth <= CustomScreenWidth().smallSize?40:80,)),
    );
  }
}