import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as Quill;
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hangil/components/custom_text_form_field.dart';
import 'package:hangil/controller/menu_controller.dart';
import 'package:hangil/controller/product_controller.dart';
import 'package:hangil/model/product.dart';
import 'package:hangil/util/text_validate.dart';

class UpdatePage extends GetView<ProductController> {
  UpdatePage({this.param,this.index});
  String? param;
  String? index;
  MenuController m = Get.put(MenuController());
  ProductController p = Get.put(ProductController());
  List<TextEditingController> _menuControllerList = [];
  TextEditingController t = TextEditingController();
  TextEditingController priceEditingController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  final _productKey = GlobalKey<FormState>();
  final textFormList = <Widget>[].obs;
  final textList = <Widget>[].obs;
  final _selections = <bool>[].obs;
  RxBool visible = false.obs;
  RxBool uploadComplete = false.obs;
  RxBool selectionChange = false.obs;
  List<String> deleteList = [];
  String? category;
  int? categoryIndex;
  RxBool disableButton = false.obs;

  bool isDeskTop = GetPlatform.isDesktop;
  double screenHeight = Get.height;
  double screenWidth = Get.width;

  Quill.QuillController _controller = Quill.QuillController.basic();

  @override
  Widget build(BuildContext context) {
    if(p.product.value.id==null){
      p.findById(param!);
    }
    return controller.obx((state) {
      if (p.isLoading.value) {
        return Center(
            child: Container(
                height: 50, width: 50, child: CircularProgressIndicator()));
      } else {
        titleController.text=p.product.value.name!;
        commentController.text=p.product.value.comment!;
        priceController.text=p.product.value.price!;
        _controller = Quill.QuillController(
            document: Quill.Document.fromJson(jsonDecode(p.product.value.body!)),
            selection: TextSelection.collapsed(offset: 0));
        _selections.value = [];
        category=m.menus[int.parse(index!)].id;
        categoryIndex=int.parse(index!);
        for (int i = 0; i < m.menus.length; i++) {
          _selections.add(false);
        }
        _selections[int.parse(index!)]=true;
        print("======a=a=a=a==a=");
        _menuControllerList = [];
        textFormList.value = [];
        textList.value = [];
        visible.value = false;
        for (int i = 0; i < m.menus.length; i++) {
          //if(length<=_menuControllerList.length) break;
          _menuControllerList.add(TextEditingController());
          _menuControllerList[i].text = m.menus[i].name!;
          textList.add(Text(
            m.menus[i].name!,
            style: TextStyle(fontSize: 20),
          ));
        }
      }
      return Obx(() {
        selectionChange.value;
        return SafeArea(
            child: Scaffold(
              body: Center(
                child: SingleChildScrollView(
                    primary: false,
                    child: Column(
                      children: [
                        productScrollView(),
                        AbsorbPointer(
                          absorbing: disableButton.value,
                          child: ElevatedButton(
                              onPressed: () async {
                                if (_controller.document.isEmpty()) {
                                  print("dd");
                                }
                                  if (_productKey.currentState!.validate()) {
                                    var json = jsonEncode(
                                        _controller.document.toDelta().toJson());
                                    disableButton.value = !disableButton.value;
                                    await p.updateProduct(
                                        Product(
                                            id:p.product.value.id,
                                            name: titleController.text,
                                            comment: commentController.text,
                                            price: priceController.text,
                                            category: category,
                                            body: json));
                                    //p.changeCategory(categoryIndex!);
                                    context.go("/home/$categoryIndex");
                                    await p.findAll();
                                  }

                              },
                              child: Text("수정완료")),
                        )
                      ],
                    )
                ),
              ),
            ));
      });
    },
        onLoading: Center(
            child: Container(
                height: 50, width: 50, child: CircularProgressIndicator())));
  }

  Widget productScrollView() {
    return SingleChildScrollView(
      primary: false,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Form(
            key: _productKey,
            child: Column(
              children: [
                CustomTextFormField(
                  hint: "제목",
                  funValidator: validateContent(),
                  controller: titleController,
                ),
                CustomTextFormField(
                  hint: "코멘트",
                  funValidator: validateContent(),
                  controller: commentController,
                ),
                CustomTextFormField(
                  hint: "가격",
                  funValidator: validateContent(),
                  controller: priceController,
                ),
              ],
            ),
          )
          ,
          SizedBox(height: screenHeight / 2, child: VerticalDivider()),
          Column(
            children: [
              Container(
                  height: 50,
                  width: screenHeight / 2,
                  child: ToggleButtons(
                    children: textList,
                    isSelected: _selections,
                    onPressed: (index) {
                      for (int i = 0; i < _selections.length; i++) {
                        _selections[i] = i == index;
                        selectionChange.value = !selectionChange.value;
                      }
                      category = m.menus[index].id;
                      categoryIndex = index;
                    },
                    selectedColor: Colors.red,
                  )),
              Container(
                  height: 50,
                  width: screenWidth / 2,
                  child: Quill.QuillToolbar.basic(
                    controller: _controller,
                    showAlignmentButtons: false,
                    showBackgroundColorButton: true,
                    showBoldButton: true,
                    showCenterAlignment: false,
                    showClearFormat: false,
                    showCodeBlock: false,
                    showColorButton: true,
                    showDirection: false,
                    showDividers: false,
                    showFontFamily: true,
                    showFontSize: true,
                    showHeaderStyle: false,
                    showIndent: false,
                    showInlineCode: false,
                    showItalicButton: false,
                    showJustifyAlignment: false,
                    showLeftAlignment: false,
                    showLink: true,
                    showListBullets: false,
                    showListCheck: false,
                    showListNumbers: false,
                    showQuote: false,
                    showRedo: false,
                    showRightAlignment: false,
                    showSearchButton: false,
                    showSmallButton: false,
                    showStrikeThrough: false,
                    showUnderLineButton: true,
                    showUndo: false,
                    multiRowsDisplay: false,
                  )),
              Container(
                width: screenWidth / 2,
                height: screenHeight / 2,
                child: Quill.QuillEditor.basic(
                  controller: _controller,
                  readOnly: false, // true for view only mode
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
