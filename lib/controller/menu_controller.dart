
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:hangil/controller/product_controller.dart';
import 'package:hangil/model/menu.dart';
import 'package:hangil/model/product.dart';
import 'package:hangil/repository/menu_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

class MenuController extends GetxController with StateMixin{

  final MenuRepository _menuRepository = MenuRepository();
  final menus = <Menu>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    change(null,status: RxStatus.loading());
    findAll();
    change(null, status: RxStatus.success());
  }

  Future<void> findAll() async{
    change(null,status: RxStatus.loading());
    isLoading.value=true;
    List<Menu> menus = await _menuRepository.findAll();
    this.menus.value=menus;
    isLoading.value=false;
    change(null, status: RxStatus.success());
  }

  Future<void> save(String name) async {
    change(null,status: RxStatus.loading());
    await _menuRepository.save(Menu(name: name));
    isLoading.value=false;
    change(null, status: RxStatus.success());
  }

  Future<void> updateMenu(Menu menu) async {
    change(null,status: RxStatus.loading());

    await _menuRepository.update(menu);
    isLoading.value=false;

    change(null, status: RxStatus.success());
  }

  Future<void> delete(String id) async {
    change(null,status: RxStatus.loading());
    await _menuRepository.delete(id);
    isLoading.value=false;
    change(null, status: RxStatus.success());
  }

  Future<void> uploadImageToStorage(
      List<XFile>? pickedFile, Product product) async {
    if (pickedFile == null) return;
    List<String> urlList = [];
    change(null, status: RxStatus.loading());
    for (int i = 0; i < pickedFile.length; i++) {
      Reference _reference = FirebaseStorage.instance.ref().child(
          'product/${product.category}/${Path.basename(pickedFile[i].path)}');
      await _reference
          .putData(
        await pickedFile[i].readAsBytes(),
        SettableMetadata(contentType: 'image/jpeg'),
      )
          .whenComplete(() async {
        await _reference.getDownloadURL().then((value) {
          urlList.add(value);
          print(value);
        });
      });
    }
    Product newProduct = Product(
        name: product.name,
        comment: product.comment,
        price: product.price,
        category: product.category,
        body: product.body,
        imageUrls: urlList
    );
    await Get.find<ProductController>().save(newProduct);

    change(null, status: RxStatus.success());
  }


}