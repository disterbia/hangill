import 'package:cloud_firestore/cloud_firestore.dart';

class Menu{
  final String? id;
  final String? name;
  final DateTime? created;
  Menu({
   this.id,this.name,this.created
});


  Menu.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name=json["name"],
        created=json["created"].toDate();

  Map<String, dynamic> toJson() =>{
    "name":name,
    "created": FieldValue.serverTimestamp(),
  };
}
