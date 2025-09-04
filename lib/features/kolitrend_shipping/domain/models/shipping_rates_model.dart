

import 'dart:ffi';

class ClientShippingRate {

  Double? rate;
  Double? unitRate;

  ClientShippingRate({this.rate, this.unitRate});

  ClientShippingRate.fromJson(Map<String, dynamic> json) {
    rate = json["rate"];
    unitRate = json["unit_rate"];
  }

}

class ShippingRate {

  int? id;
  int? shippingModeId;
  int? shippingCompanyId;
  int? packageTypeId;
  int? deliveryTimeId;
  int? shippingServiceId;
  Double? startWeight;
  Double? endWeight;
  Double? rate;
   String? countryOfOrigin;
   String? destinationCountry;
   String? status;

   ShippingRate({
     this.id,
     this.shippingModeId,
     this.shippingCompanyId,
     this.packageTypeId,
     this.deliveryTimeId,
     this.shippingServiceId,
     this.startWeight,
     this.endWeight,
     this.rate,
     this.countryOfOrigin,
     this.destinationCountry,
     this.status
   });

   ShippingRate.fromJson(Map<String, dynamic> json) {
     id = json["id"] ;
     shippingModeId = json["shipping_mode_id"];
     shippingCompanyId = json["shipping_company_id"];
     packageTypeId = json["package_type_id"];
     deliveryTimeId = json["delivery_time_id"];
     shippingServiceId = json["shipping_service_id"];
     startWeight = json["start_weight"];
     endWeight = json["end_weight"];
     rate = json["rate"];
     countryOfOrigin = json["country_of_origin"];
     destinationCountry = json["destination_country"];
     status = json["status"];
   }

}