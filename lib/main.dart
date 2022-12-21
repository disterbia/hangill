import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hangil/components/custom_scroll.dart';
import 'package:hangil/router/my_go_router.dart';
import 'package:url_strategy/url_strategy.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDvismzFA0-WvMnuBMozVXQPwmZYbd02t4",
          authDomain: "hangil-ee9c5.firebaseapp.com",
          projectId: "hangil-ee9c5",
          storageBucket: "hangil-ee9c5.appspot.com",
          messagingSenderId: "1061346092985",
          appId: "1:1061346092985:web:c15be64a94c2f806453868",
          measurementId: "G-0SHV67H1DV")
  );
  await GetStorage.init();
  setPathUrlStrategy(); //샵없애기
  runApp(GetMaterialApp.router(theme: ThemeData(fontFamily: "MyFont"),
    scrollBehavior: CustomScroll(),
    title: "Hangil",
    debugShowCheckedModeBanner: false,
    routeInformationParser: MyPages.router.routeInformationParser,
    routerDelegate: MyPages.router.routerDelegate,
    routeInformationProvider: MyPages.router.routeInformationProvider,
    // getPages: AppPages.pages,
    // routerDelegate: AppRouterDelegate(),
  )
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Container(child: Text("dd"),);
  }
}