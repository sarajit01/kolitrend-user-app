import 'dart:ffi';

class BuyForMeCategoriesModel {
  List<BuyForMeCategory>? categories;

  BuyForMeCategoriesModel({this.categories});

  BuyForMeCategoriesModel.fromJson(Map<String, dynamic> json){
    if (json['categories'] != null) {
      print("categories json");

      categories = <BuyForMeCategory>[];
      json['categories'].forEach((v) {
        print("category each");
        categories!.add(BuyForMeCategory.fromJson(v));
      });
    }
  }

}

class BuyForMeCategory {
  int? id;
  String? name;

  BuyForMeCategory({this.id, this.name});

  BuyForMeCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] ;
  }
}