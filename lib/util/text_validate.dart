import 'package:get/get.dart';

Function validateContent() {
  return (String? value) {
    if (value!.isEmpty) {
      return "내용은 공백이 들어갈 수 없습니다.";
    }
    if(value.isBlank!){
      return "내용은 공백이 들어갈 수 없습니다.";
    }
    return null;
  };
}