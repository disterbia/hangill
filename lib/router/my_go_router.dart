import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:hangil/view/admin_page.dart';
import 'package:hangil/view/check_page.dart';
import 'package:hangil/view/detail_page.dart';
import 'package:hangil/view/home_page.dart';
import 'package:hangil/view/test4.dart';
import 'package:hangil/view/update_page.dart';

class MyRoutes {
  static const HOME = '/';
  static const HOME2 = '/home/:index';
  static const ADMIN = '/mj';
  static const CHECK = '/check';
  static const DETAIL = '/detail/:index/:id';
  static const UPDATE = '/update/:index/:id';
  static const TEST4 = '/test4';

}

class MyPages {
  static late final  router = GoRouter(
    redirect: (state){
      String? uid=GetStorage().read("id");
      if(state.subloc=="/") return '/home/0';
      if(state.subloc=="/mj"&&uid!="fn34nfnv8avf9ni30an"){

        return "/check";
      }
      return null;
    },
    errorBuilder: (context, state) => Container(child: Text("dd"),),
    routes: [
      GoRoute(
        path: MyRoutes.HOME,
        builder: (context, state) => HomePage()
      ),
      GoRoute(
          path: MyRoutes.HOME2,
          builder: (context, state) => HomePage(param:state.params['index'])
      ),
      GoRoute(
          path: MyRoutes.ADMIN,
          builder: (context, state) => AdminPage()
      ),
      GoRoute(
          path: MyRoutes.CHECK,
          builder: (context, state) => CheckPage()
      ),
      GoRoute(
        path: MyRoutes.DETAIL,
        name: "/detail",
        builder: (context, state) {
          return DetailPage(param: state.params['id'],index: state.params["index"],);},
      ),
      GoRoute(
        path: MyRoutes.UPDATE,
          name: "/update",
        builder: (context, state) => UpdatePage(param:state.params['id'],index: state.params['index'],)
      ),
      GoRoute(
          path: MyRoutes.TEST4,
          builder: (context, state) => Test4()
      ),
    ],
  );
}