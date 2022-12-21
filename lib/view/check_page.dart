import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:hangil/components/custom_text_form_field.dart';
import 'package:hangil/controller/admin_controller.dart';
import 'package:hangil/util/text_validate.dart';

class CheckPage extends StatelessWidget {

  TextEditingController t= TextEditingController();
  AdminController a = Get.put(AdminController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(height: 100,
              child: Form(
                key: _formKey,
                child: CustomTextFormField(
                    hint: "Password", controller:t, funValidator:validateContent()),
              ),),
            ElevatedButton(onPressed: () async{
              if(_formKey.currentState!.validate()){
                bool result=await a.findByPassword(t.text);
                if(result) context.go("/mj");
              }
            }, child: Text("인증"))
          ],
        ),
      ),
    );
  }
}
