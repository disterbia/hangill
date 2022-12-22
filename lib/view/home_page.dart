import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
import 'package:responsive_framework/responsive_framework.dart';

class HomePage extends GetView<ProductController> {
  HomePage({this.param});

  //final _search = TextEditingController();
  AdminController a = Get.put(AdminController());
  MenuController m = Get.put(MenuController());
  ProductController p = Get.put(ProductController());


  final _selections = <bool>[].obs;
  String? param;
  final screenHeight = Get.height.obs;
  final screenWidth = Get.width.obs;
  bool priceIsNumber = true;
  final isReverse = false.obs;
  List<bool> priceList = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isDeskTop=GetPlatform.isDesktop;

  @override
  Widget build(BuildContext context) {
    screenWidth.value = MediaQuery.of(context).size.width;
    screenHeight.value = MediaQuery.of(context).size.height;

    return controller.obx((state) {
      if (p.isLoading.value) {
        return Center(
            child: Container(
                height: 50, width: 50, child: CircularProgressIndicator()));
      } else {
        priceList.clear();
        int length = m.menus.length;
        _selections.value = List.generate(length, (index) => false);
        param = param ?? "0";
        _selections.length != 0 ? _selections[int.parse(param!)] = true : null;
        //nowCategory =_selections.length!=0? m.menus[int.parse(param!)].id:null;
        p.changeCategory(int.parse(param!));
        for (int i = 0; i < p.products.length; i++) {
          try {
            int.parse(p.products[i].price!);
            priceList.add(true);
          } catch (e) {
            priceList.add(false);
          }
        }
      }
      return Obx(
        () {
          return SafeArea(
            child: Scaffold(
                key: _scaffoldKey,
                drawer: CustomDrawer(screenWidth: screenWidth.value,createButton: CreateButton.createButton(m.menus.length, m.menus, context,selection: _selections),),
                body: SingleChildScrollView(
                    reverse: isReverse.value,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        CustomHeader(screenWidth.value, _scaffoldKey, CreateButton.createButton(m.menus.length, m.menus, context,selection: _selections),a.kakao.value),
                        screenWidth.value<=CustomScreenWidth().middleSize?Container():Container(
                            width: screenWidth.value,
                            child: Divider(
                            )),
                        Padding(
                          padding: EdgeInsets.only(
                              left: screenWidth.value <=
                                      CustomScreenWidth().bigSize
                                  ? 10.0
                                  : 10 + (screenWidth.value / 50),
                              right: screenWidth.value <=
                                      CustomScreenWidth().bigSize
                                  ? 10.0
                                  : 10 + (screenWidth.value / 50),
                              bottom: 0,
                              top: 0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                m.menus[int.parse(param!)].name!,
                                style: TextStyle(
                                  fontSize: !isDeskTop&&screenWidth <= CustomScreenWidth().smallSize?15:30,fontStyle: FontStyle.italic
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    height: !isDeskTop&&screenWidth <= CustomScreenWidth().smallSize?1:10,
                                  ),
                                  Text(
                                    "[${p.products.length}]",
                                    style: TextStyle(color: Colors.grey,fontSize: !isDeskTop&&screenWidth <= CustomScreenWidth().smallSize?8:16),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        // isDeskTop
                        //     ? Row(children: createButton(0, 6,context))
                        //     : Column(
                        //   children: [
                        //     Row(children: createButton(0, 3,context)),
                        //     Row(children: createButton(3, 6,context))
                        //   ],
                        // ),
                        Container(
                          width: screenWidth.value ,
                          child: GridView.builder(
                            padding: screenWidth.value<=CustomScreenWidth().smallSize
                                ? EdgeInsets.symmetric(vertical: 10,horizontal: 0):
                            EdgeInsets.only(
                                left: screenWidth.value <=
                                        CustomScreenWidth().bigSize
                                    ? 10.0
                                    : 10 + (screenWidth.value / 20),
                                right: screenWidth.value <=
                                        CustomScreenWidth().bigSize
                                    ? 10.0
                                    : 10 + (screenWidth.value / 20),
                                bottom: 10,
                                top: 10),
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: p.products.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: screenWidth.value <=
                                      CustomScreenWidth().smallSize
                                  ? 2
                                  : screenWidth.value <=
                                          CustomScreenWidth().middleSize
                                      ? 3
                                      : 4,
                              crossAxisSpacing: screenWidth.value <=
                                  CustomScreenWidth().smallSize?1:10,
                              mainAxisSpacing: 0,
                              childAspectRatio: screenWidth.value<=CustomScreenWidth().bigSize?0.7:0.8,
                            ),
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          p.products[index].imageUrls![0]!,
                                      imageBuilder:
                                          (context, imageProvider) =>
                                              GestureDetector(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.fill,
                                              // colorFilter:
                                              // ColorFilter.mode(Colors.red, BlendMode.colorBurn)
                                            ),
                                          ),
                                        ),
                                        onTap: () async {
                                          String param =
                                              p.products[index].id!;
                                          await p.findById(param);
                                          //context.go("/detail/$param");
                                          context.goNamed("/detail",params:{"index":this.param!,"id":param} );
                                          // Get.to(() => DetailPage(),
                                          //     transition: Transition.size);
                                        },
                                      ),
                                      //placeholder: (context, url) => CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                  ),
                                  //SizedBox(height: 10,),
                                  ConstrainedBox(constraints: BoxConstraints.tightFor(height: !isDeskTop&&screenWidth <= CustomScreenWidth().smallSize?60:75),
                                    child: Container(
                                      child: Column(
                                      children: [
                                      Text(
                                        p.products[index].name!,
                                        style: TextStyle(
                                            fontSize: !isDeskTop&&screenWidth <= CustomScreenWidth().smallSize?12:16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(p.products[index].comment!, style: TextStyle(fontSize: !isDeskTop&&screenWidth <= CustomScreenWidth().smallSize?10:14)),
                                      Text(
                                        priceList[index]
                                            ? NumberFormat("###,###,### 원")
                                            .format(int.parse(
                                            p.products[index].price!))
                                            : p.products[index].price!,
                                        style: TextStyle(color: Colors.grey, fontSize: !isDeskTop&&screenWidth <= CustomScreenWidth().smallSize?9:14),
                                      ),
                                    ],),),
                                  ),

                                ],
                              );
                            },
                          ),
                        ),SizedBox(height: 100,),
                        if(p.products.length<5)
                        SizedBox(height: 200,),
                        Container(
                          // height: screenWidth.value<=CustomScreenWidth().smallSize ?
                          // 200 : 130,
                            width: screenWidth.value,
                            color: Colors.black,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SelectableText(a.info.value.replaceAll('뷁', "\n"),style:
                                  TextStyle(color: Colors.white,fontSize: !isDeskTop&&screenWidth <= CustomScreenWidth().smallSize?10:16),),
                                  SelectableText("Copyright © www.dmonster.co.kr All rights reserved.Since 2022",style:
                                  TextStyle(color: Colors.white,fontSize: !isDeskTop&&screenWidth <= CustomScreenWidth().smallSize?10:16))
                                ],
                              ),
                            )
                        )
                      ],
                    ))),
          );
        },
      );
    },
        onLoading: Center(
            child: Container(
                height: 50, width: 50, child: CircularProgressIndicator()))
    );
  }
}
