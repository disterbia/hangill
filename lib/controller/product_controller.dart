
import 'package:get/get.dart';
import 'package:hangil/controller/menu_controller.dart';
import 'package:hangil/model/product.dart';
import 'package:hangil/repository/product_repository.dart';


class ProductController extends GetxController with StateMixin {
  final ProductRepository _productRepository = ProductRepository();
  MenuController m = Get.put(MenuController());
  final products = <Product>[].obs;
  final product = Product().obs;
  final productsList =<List<Product>>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    findAll();
  }

  Future<void> findAll() async{
    print("dd");
    productsList.clear();
    change(null,status: RxStatus.loading());
    await m.findAll();
    for(int i =0;i<m.menus.length;i++){
      await findByCategory(m.menus[i].id!);
    }
    // /changeCategory(0);
    isLoading.value=false;
    change(null, status: RxStatus.success());
  }

  Future<void> findById(String id) async {
   // change(null,status: RxStatus.loading());
    isLoading.value=true;
    Product product = await _productRepository.findById(id);
    this.product.value = product;
    isLoading.value=false;
    //change(null, status: RxStatus.success());
  }

  Future<void> findByCategory(String category) async {
    change(null,status: RxStatus.loading());
    isLoading.value=true;
    List<Product> products = await _productRepository.findByCategory(category);
    this.products.value=products;
    productsList.add(products);
    isLoading.value=false;
    change(null, status: RxStatus.success());
  }

  void changeCategory(int index){
    products.value=productsList[index];
  }


  Future<void> save(Product newProduct) async {
    change(null, status: RxStatus.loading());
    Product product = await _productRepository.save(newProduct);
    //this.product.value=product;
    change(null, status: RxStatus.success());
  }

  Future<void> delete(String id,String index) async {
    int temp = int.parse(index);
    change(null,status: RxStatus.loading());
    Product product = await _productRepository.findById(id);
    //findByCategory(product.category!);
    await _productRepository.delete(id);
    productsList[temp].removeWhere((element) => element.id==id);
    products.value = productsList[temp];

    change(null, status: RxStatus.success());
  }

  Future<void> updateProduct(Product newProduct) async {
    change(null,status: RxStatus.loading());
    await _productRepository.update(newProduct);
    for(int i =0;i<m.menus.length;i++){
      await findByCategory(m.menus[i].id!);
    }
    change(null, status: RxStatus.success());
  }
}
