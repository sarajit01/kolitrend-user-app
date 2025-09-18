class OrderStatusModel {

  //'status_name', 'value',  'img', 'enabled'

  int? id;
  String? statusName;
  String? value;
  String? img;

  OrderStatusModel({
    this.id,
    this.statusName,
    this.value,
    this.img
  });

  OrderStatusModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    statusName = json['status_name'];
    value = json['value'];
    img = json['img'];
  }

}
