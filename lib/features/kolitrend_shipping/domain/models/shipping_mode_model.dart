
class ShippingModesModel {
  List<ShippingMode>? modes;

  ShippingModesModel({this.modes});

  ShippingModesModel.fromJson(Map<String, dynamic> json) {
    if (json["modes"] != null) {
      print("Modes json");

      modes = <ShippingMode>[];
      json['modes'].forEach((v) {
        modes!.add(ShippingMode.fromJson(v));
      });
    }
  }

}

class ShippingMode {
   int? id;
   String? shippingMode;
   String? details;
   String? countryOfOrigin;
   String? destinationCountry;
   String? status;

   ShippingMode({
     this.id,
     this.shippingMode,
     this.details,
     this.countryOfOrigin,
     this.destinationCountry,
     this.status
   });

   ShippingMode.fromJson(Map<String, dynamic> json) {
     id = json["id"] ;
     shippingMode = json["shipping_mode"];
     details = json["details"];
     countryOfOrigin = json["country_of_origin"];
     destinationCountry = json["destination_country"];
     status = json["status"];
   }

}