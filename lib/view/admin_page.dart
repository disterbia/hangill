import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as Quill;
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hangil/components/custom_text_form_field.dart';
import 'package:hangil/controller/menu_controller.dart';
import 'package:hangil/controller/product_controller.dart';
import 'package:hangil/model/menu.dart';
import 'package:hangil/model/product.dart';
import 'package:hangil/util/text_validate.dart';
import 'package:image_picker/image_picker.dart';

class AdminPage extends GetView<MenuController> {
  MenuController m = Get.put(MenuController());
  ProductController p = Get.put(ProductController());
  List<TextEditingController> _menuControllerList = [];
  TextEditingController t = TextEditingController();
  TextEditingController priceEditingController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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

  List<XFile>? pickedFile;
  Quill.QuillController _controller = Quill.QuillController.basic();

  Widget menuTextForm(int index) {
    return CustomTextFormField(
      controller: _menuControllerList[index],
      hint: "카테고리 이름",
      funValidator: validateContent(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return controller.obx((state) {
      if (m.isLoading.value) {
        return Center(
            child: Container(
                height: 50, width: 50, child: CircularProgressIndicator()));
      } else {
        _selections.value = [];
        for (int i = 0; i < m.menus.length; i++) {
          _selections.add(false);
        }
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
          textFormList.add(menuTextForm(i));
        }
      }
      return Obx(() {
        selectionChange.value;
        return SafeArea(
            child: Scaffold(
          body: SingleChildScrollView(
              primary: false,
              child: Column(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        visible.value = !visible.value;
                      },
                      child: Text(visible.value ? "취소" : "메뉴수정")),
                  menuForm(),
                  visible.value
                      ? Container()
                      : ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              for (int i = 0; i < textFormList.length; i++) {
                                await m.updateMenu(Menu(
                                    id: m.menus[i].id,
                                    name: _menuControllerList[i].text));
                              }
                              await m.findAll();
                            }
                          },
                          child: Text("적용")),
                  Divider(),
                  productScrollView(),
                  AbsorbPointer(
                    absorbing: disableButton.value,
                    child: ElevatedButton(
                        onPressed: () async {
                          bool temp = false;
                          for (var element in _selections) {
                            temp = element;
                            if (element) break;
                          }
                          if (!temp) {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text("카테고리 확인"),
                                      content: Text("카테고리를 선택하세요."),
                                      actions: [
                                        TextButton(
                                          child: Text("OK"),
                                          onPressed: () {
                                            return Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    ));
                            return;
                          }
                          if (_controller.document.isEmpty()) {
                            print("dd");
                          }
                          if (pickedFile != null) {
                            if (_productKey.currentState!.validate()) {
                              var json = jsonEncode(
                                  _controller.document.toDelta().toJson());
                              disableButton.value = !disableButton.value;
                              await m.uploadImageToStorage(
                                  pickedFile,
                                  Product(
                                      name: titleController.text,
                                      comment: commentController.text,
                                      price: priceController.text,
                                      category: category,
                                      body: json));
                              //p.changeCategory(categoryIndex!);
                              context.go("/home/$categoryIndex");
                              await p.findAll();
                            }
                          }
                        },
                        child: Text("상품 업로드")),
                  )
                ],
              )),
        ));
      });
    },
        onLoading: Center(
            child: Container(
                height: 50, width: 50, child: CircularProgressIndicator())));
  }

  Widget menuForm() {
    return Form(
      key: _formKey,
      child: Container(
          height: 100,
          child: Center(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: textFormList.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    visible.value ? textList[index] : textFormList[index],
                    visible.value
                        ? TextButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text("삭제 확인"),
                                        content:
                                            Text("해당 카테고리에 포함된 모든 상품들이 삭제됩니다."),
                                        actions: [
                                          TextButton(
                                            child: Text("OK"),
                                            onPressed: () async {
                                              await m
                                                  .delete(m.menus[index].id!);
                                              await m.findAll();
                                              visible.value = false;
                                              return Navigator.of(context)
                                                  .pop();
                                            },
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                return Navigator.of(context)
                                                    .pop();
                                              },
                                              child: Text("Cancel"))
                                        ],
                                      ));
                            },
                            child: Text("삭제"),
                          )
                        : Container(),
                    visible.value && index == textFormList.length - 1
                        ? TextButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text("메뉴 추가"),
                                        content: CustomTextFormField(
                                          hint: "카테고리 이름",
                                          controller: t,
                                          funSubmit: validateContent(),
                                        ),
                                        actions: [
                                          TextButton(
                                            child: Text("완료"),
                                            onPressed: () async {
                                              if (t.text.isNotEmpty) {
                                                Navigator.of(context).pop();
                                                await m.save(t.text);
                                                await m.findAll();
                                                visible.value = false;
                                                t.text = "";
                                                return;
                                              }
                                            },
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                return Navigator.of(context)
                                                    .pop();
                                              },
                                              child: Text("Cancel"))
                                        ],
                                      ));
                            },
                            child: Text("추가하기"))
                        : Container(),
                    VerticalDivider()
                  ],
                );
              },
            ),
          )),
    );
  }

  Widget productScrollView() {
    return SingleChildScrollView(
      primary: false,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          uploadComplete.value
              ? Form(
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
                      Container(
                          height: screenHeight / 2,
                          width: screenWidth / 2,
                          child: ListView.builder(
                            itemCount: pickedFile!.length,
                            itemBuilder: (context, index) {
                              return Text(pickedFile![index].name);
                            },
                          )),
                    ],
                  ),
                )
              : Container(
                  width: screenWidth / 2,
                  child: ElevatedButton(
                    onPressed: () async {
                      pickedFile = await ImagePicker().pickMultiImage();
                      uploadComplete.value = true;
                    },
                    child: Text("이미지 업로드"),
                  ),
                ),
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
                     fontSizeValues: {
                       '10': '10',
                       '20': '20',
                       '30': '30',
                       '40': '40',
                       '50':'50',
                       '60':'60',
                       'Clear':'0'
                     },
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
