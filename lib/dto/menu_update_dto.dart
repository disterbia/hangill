import 'package:hangil/model/menu.dart';

class MenuUpdateDto {
  final Menu? menu;

  MenuUpdateDto({
    this.menu});

  Map<String, dynamic> MenuToJson() =>
      {
        "name": menu?.name,
      };
}