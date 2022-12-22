import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hangil/repository/admin_repository.dart';

class AdminController extends GetxController{

  AdminRepository _adminRepository = AdminRepository();
  RxString info = "".obs;
  RxString kakao = "".obs;

  @override
  void onInit() {
    super.onInit();
    findCompanyInfo();
    findKakao();
  }

  Future<void> findCompanyInfo() async{
    dynamic result = await _adminRepository.findCompanyInfo();
    info.value=result;
  }
  Future<void> findKakao() async{
    dynamic result = await _adminRepository.findKakao();
    kakao.value=result;
  }

  Future<bool> findByPassword(String password) async {
    dynamic result=await _adminRepository.findByPassword(password);
    print("==========$result");
    if(result!=null){
      await GetStorage().write("id", result);
      return true;
      }
    return false;
  }
}