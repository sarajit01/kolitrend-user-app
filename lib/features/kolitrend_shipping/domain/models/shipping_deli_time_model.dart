
class ShippingDeliveryTimesModel {

  List<ShippingDeliveryTime>? deliveryTimes;

  ShippingDeliveryTimesModel({this.deliveryTimes});

  ShippingDeliveryTimesModel.fromJson(Map<String, dynamic> json) {
    if (json["delivery_times"] != null) {
      deliveryTimes = <ShippingDeliveryTime>[];
      json['delivery_times'].forEach((v) {
        deliveryTimes!.add(ShippingDeliveryTime.fromJson(v));
      });
    }
  }

}

class ShippingDeliveryTime {

   int? id;
   String? deliveryTime;
   String? details;
   String? countryOfOrigin;
   String? destinationCountry;
   String? status;
   int? shippingModeId;
   int? shippingCompanyId;
   int? packageTypeId;
   int? shippingServiceId;

   ShippingDeliveryTime({
     this.id,
     this.deliveryTime,
     this.details,
     this.countryOfOrigin,
     this.destinationCountry,
     this.status,
     this.shippingModeId,
     this.shippingCompanyId,
     this.packageTypeId,
     this.shippingServiceId
   });

   ShippingDeliveryTime.fromJson(Map<String, dynamic> json) {
     id = json["id"] ;
     deliveryTime = json["delivery_time"];
     details = json["details"];
     countryOfOrigin = json["country_of_origin"];
     destinationCountry = json["destination_country"];
     status = json["status"];
     shippingModeId = json["shipping_mode_id"];
     shippingCompanyId = json["shipping_company_id"];
     packageTypeId = json["package_type_id"];
     shippingServiceId = json["shipping_service_id"];
   }

}