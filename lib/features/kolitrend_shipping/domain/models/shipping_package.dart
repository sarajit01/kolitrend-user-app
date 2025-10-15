import 'package:uuid/uuid.dart';

class ShippingPackageModel {

  String? id;
  int? quantity;
  String? description;
  double? weight;
  double? length;
  double? width;
  double? height;
  double? vol_weight;
  double? shipment_invoice_amount;
  String? currency;
  double? price;

  ShippingPackageModel({
     this.id,
     this.quantity,
     this.description,
     this.weight,
     this.length,
     this.width,
     this.height,
     this.vol_weight,
     this.shipment_invoice_amount,
     this.currency,
     this.price
  });

}