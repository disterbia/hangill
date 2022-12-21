import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_quill/flutter_quill.dart' as Quill hide Text;
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:hangil/components/create_button.dart';
import 'package:hangil/components/custom_drawer.dart';
import 'package:hangil/components/custom_header.dart';
import 'package:hangil/components/custom_logo.dart';
import 'package:hangil/controller/admin_controller.dart';
import 'package:hangil/controller/menu_controller.dart';
import 'package:hangil/controller/product_controller.dart';
import 'package:hangil/model/menu.dart';
import 'package:hangil/util/custom_screen_width.dart';
import 'package:intl/intl.dart';

class DetailPage extends GetView<ProductController> {
  DetailPage({this.param,this.index});
  String? param;
  String? index;

  final _selections = <bool>[].obs;
  final screenHeight = Get.height.obs;
  final screenWidth = Get.width.obs;
  AdminController a = Get.put(AdminController());
  ProductController p = Get.put(ProductController());
  MenuController m = Get.put(MenuController());
  bool isDesktop = GetPlatform.isDesktop;
  final isReverse = false.obs;
  Quill.QuillController _controller = Quill.QuillController.basic();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<bool> priceList = [];
  bool priceIsNumber = true;
  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.width);
    // if(screenWidth.value<MediaQuery.of(context).size.width) {
    screenWidth.value = MediaQuery.of(context).size.width;
    screenHeight.value = MediaQuery.of(context).size.height;
    //  }
    return controller.obx((state) {
      if(p.product.value.id==null){
        p.findById(param!);
      }
        return Obx(() {
          if (p.isLoading.value) {
            return Center(
                child: Container(
                    height: 50, width: 50, child: CircularProgressIndicator()));
          }else {
            priceList.clear();
             int length = m.menus.length;
            // _selections.value = List.generate(length, (index) => false);
            // param = param ?? "0";
            // _selections.length != 0 ? _selections[int.parse(param!)] = true : null;
            //nowCategory =_selections.length!=0? m.menus[int.parse(param!)].id:null;
            //p.changeCategory(int.parse(param!));

              try {
                int.parse(p.product.value.price!);
               priceIsNumber=true;
              } catch (e) {
                priceIsNumber=false;
              }

            _controller = Quill.QuillController(
                document: Quill.Document.fromJson(jsonDecode(p.product.value.body!)),
                selection: TextSelection.collapsed(offset: 0));
            return SafeArea(
            child: Scaffold(
              key: _scaffoldKey,
              drawer:CustomDrawer(screenWidth: screenWidth.value,createButton: CreateButton.createButton( m.menus.length,m.menus, context),) ,
              body: SingleChildScrollView(
                reverse: isReverse.value,
                child: Column(
                    children: [
                  Container(
                    height: 25,
                    color: Colors.black,
                    width: screenWidth.value,
                    child: Center(
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                              onTap: () =>
                              isReverse.value = !isReverse.value,
                              child: Text(
                                "회사 정보 안내",
                                style: TextStyle(color: Colors.white,fontSize: 10),
                              )),
                        )),
                  ),
                  CustomHeader(screenWidth.value, _scaffoldKey,  CreateButton.createButton( m.menus.length,m.menus, context)),
                  GetStorage().read("id") ==
                      "fn34nfnv8avf9ni30an"
                      ? Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            context.goNamed("/update",params: {"id":param!,"index":index!});
                            //Get.rootDelegate.toNamed("/update");
                          },
                          child: Text("수정")),
                      TextButton(
                          onPressed: () async {
                            await p.delete(p.product.value.id!,index!);
                            p.changeCategory(int.parse(index!));
                            context.go("/");
                            //Get.rootDelegate.toNamed("/");
                          },
                          child: Text("삭제")),
                    ],
                  )
                      : Container(),
                  screenWidth.value<=CustomScreenWidth().middleSize?Container():Container(
                      width: screenWidth.value,
                      child: Divider(height: 1,

                      )),
                  screenWidth.value<=CustomScreenWidth().menuSize?
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20,),
                    Row(
                      children: [
                        SizedBox(width: 20,),
                        Text(p.product.value.name!,style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        SizedBox(width: 25,),
                        Text(priceIsNumber ? NumberFormat("###,###,### 원").format(int.parse(
                            p.product.value.price!))
                            : p.product.value.price!,
                          style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                      SizedBox(height: 20,),
                      products(),
                      SizedBox(height: 20,),
                      Text(p.product.value.comment!,style: TextStyle(fontSize: 15),),
                      SizedBox(height: 20,),
                      Container(
                         width: screenWidth.value ,
                        //height: screenHeight / 17,
                        child: Quill.QuillEditor(
                          scrollController: ScrollController(),
                          scrollable: true,
                          focusNode: FocusNode(),
                          autoFocus: false,
                          expands: false,
                          padding: EdgeInsets.zero,
                          controller: _controller,
                          readOnly: true, // true for view only mode
                        ),
                      )

                  ],  ):
                  Row(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex:2,child: ConstrainedBox(constraints: BoxConstraints.tightFor(height: screenHeight.value),child: products())),
                      SizedBox(width: 30,),
                      Expanded(flex: 1,
                        child: Container(
                          height: screenHeight.value,
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p.product.value.name!,style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),
                              SizedBox(height: 10,),
                              Text(priceIsNumber ? NumberFormat("###,###,### 원").format(int.parse(
                                    p.product.value.price!))
                                    : p.product.value.price!,
                                  style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10,),
                              Text(p.product.value.comment!,style: TextStyle(fontSize: 15),),
                              SizedBox(height: 40,),
                              Container(
                               // width: screenWidth / 1,
                                height: screenHeight / 1.7,
                                child: Quill.QuillEditor(
                                  scrollController: ScrollController(),
                                  scrollable: true,
                                  focusNode: FocusNode(),
                                  autoFocus: false,
                                  expands: false,
                                  padding: EdgeInsets.zero,
                                  controller: _controller,
                                  readOnly: true, // true for view only mode
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 100,),
                  Container(
                      // height: screenWidth.value<=CustomScreenWidth().smallSize ?
                      // 200 : 130,
                      width: screenWidth.value,
                      color: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SelectableText(a.info.value.replaceAll('뷁', "\n"),style: TextStyle(color: Colors.white),),
                            SelectableText("Copyright © www.dmonster.co.kr All rights reserved.Since 2022",style: TextStyle(color: Colors.white))
                          ],
                        ),
                      )
                  )
                ]),
              ),
            ),
          );
          }
        });

    });


  }
  Widget products(){
    return Container(
      child: GridView.builder(
        padding: const EdgeInsets.all(0),
        //physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: p.product.value.imageUrls!.length,
        gridDelegate:
        SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: screenWidth.value <=
              CustomScreenWidth().smallSize
              ? 1 : 2 ,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (context, index) {
          return CachedNetworkImage(
            imageUrl:
            p.product.value.imageUrls![index],
            imageBuilder:
                (context, imageProvider) =>
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                      // colorFilter:
                      // ColorFilter.mode(Colors.red, BlendMode.colorBurn)
                    ),
                  ),
                ),
            //placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) =>
                Icon(Icons.error),
          );
        },
      ),
    );
  }
}
