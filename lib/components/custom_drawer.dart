import 'package:flutter/material.dart';
import 'package:hangil/components/custom_logo.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({this.screenWidth,this.createButton});
  double? screenWidth;
  List<Widget>? createButton;
  @override
  Widget build(BuildContext context) {
    return Drawer(width: screenWidth,
      child: SingleChildScrollView(
        child: Padding(
          padding:EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  CustomLogo(screenWidth!),
                  MouseRegion(cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                          onTap: ()=>Navigator.of(context).pop(),
                          child: Icon(Icons.close,size: 30))),
                ],),
              Container(width: screenWidth,child: Divider()),
              Column(
                children: createButton!)

            ],
          ),
        ),
      ),
    );
  }
}
