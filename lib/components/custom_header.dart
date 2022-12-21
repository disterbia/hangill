import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:html' as HTML;
import 'package:hangil/components/custom_logo.dart';
import 'package:hangil/util/custom_screen_width.dart';

class CustomHeader extends StatelessWidget {
  CustomHeader(this.screenWidth,this.scaffoldKey,this.createButton);
  double screenWidth;
  GlobalKey<ScaffoldState> scaffoldKey;
  List<Widget> createButton;
  bool isDeskTop=GetPlatform.isDesktop;
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: screenWidth,
      ),
      child: Padding(
        padding: !isDeskTop&&screenWidth <= CustomScreenWidth().smallSize? EdgeInsets.all(10):EdgeInsets.only(
            right: 30, top: 20, bottom: 10, left: 20),
        child: Row(
          mainAxisAlignment: screenWidth <= CustomScreenWidth().menuSize
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.start,
          children: [
            if (screenWidth < CustomScreenWidth().menuSize)
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                    onTap: () => scaffoldKey.currentState!.openDrawer(),
                    child: Icon(Icons.menu,size: !isDeskTop&&screenWidth <= CustomScreenWidth().smallSize?20:30,)),
              ),
            CustomLogo(screenWidth),
            if (screenWidth >= CustomScreenWidth().menuSize)
              Expanded(
                  flex: 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: createButton,
                  )),
            if (screenWidth >= CustomScreenWidth().middleSize)
              Text("상담/문의->",
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
            if (screenWidth >=
                CustomScreenWidth().menuSize)
              SizedBox(width: 10,),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                  onTap: () =>  HTML.window.location.href='http://pf.kakao.com/_qASxjxj',
                  child: Image.asset(
                    "assets/kakao.png",
                    height: !isDeskTop&&screenWidth<=CustomScreenWidth().smallSize?30:60,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
