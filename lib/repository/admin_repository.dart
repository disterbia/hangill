import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hangil/provider/admin_provider.dart';

class AdminRepository{

  AdminProvider _adminProvider = AdminProvider();

Future<dynamic> findCompanyInfo() async {
  QuerySnapshot querySnapshot = await _adminProvider.findCompanyInfo();
  Map<String,dynamic>? json =  querySnapshot.docs[0].data() as Map<String,dynamic>;
  String info = json['info'];
  return info;
}

  Future<dynamic> findKakao() async {
    QuerySnapshot querySnapshot = await _adminProvider.findKakao();
    Map<String,dynamic>? json =  querySnapshot.docs[0].data() as Map<String,dynamic>;
    String info = json['kakao'];
    return info;
  }

  Future<dynamic> findByPassword(String password) async {
    QuerySnapshot querySnapshot = await _adminProvider.findByPassword(password);
    if(querySnapshot.docs.isEmpty) {
      return null;
    }
    Map<String,dynamic>? json =  querySnapshot.docs[0].data() as Map<String,dynamic>;
    String id= json["id"];
    return id;
  }

}