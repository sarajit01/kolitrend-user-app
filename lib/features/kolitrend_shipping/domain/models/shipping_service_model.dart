
class ShippingServicesModel {
  List<ShippingService>? shippingServices;
  ShippingServicesModel({this.shippingServices});

  ShippingServicesModel.fromJson(Map<String, dynamic> json) {
    if (json["services"] != null) {
      shippingServices = <ShippingService>[];
      json['services'].forEach((v) {
        shippingServices!.add(ShippingService.fromJson(v));
      });
    }
  }
}

class ShippingService {
   int? id;
   String? shippingService;
   String? details;
   String? countryOfOrigin;
   String? destinationCountry;
   String? status;
   int? shippingModeId;
   int? shippingCompanyId;
   int? packageTypeId;

   ShippingService({
     this.id,
     this.shippingService,
     this.details,
     this.countryOfOrigin,
     this.destinationCountry,
     this.status,
     this.shippingModeId,
     this.shippingCompanyId,
     this.packageTypeId
   });

   ShippingService.fromJson(Map<String, dynamic> json) {
     id = json["id"] ;
     shippingService = json["shipping_service"];
     details = json["details"];
     countryOfOrigin = json["country_of_origin"];
     destinationCountry = json["destination_country"];
     status = json["status"];
     shippingModeId = json["shipping_mode_id"];
     shippingCompanyId = json["shipping_company_id"];
     packageTypeId = json["package_type_id"];
   }

}