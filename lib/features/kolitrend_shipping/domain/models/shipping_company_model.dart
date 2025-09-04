
class ShippingCompaniesModel {
  List<ShippingCompany>? companies;

  ShippingCompaniesModel({this.companies});

  ShippingCompaniesModel.fromJson(Map<String, dynamic> json) {
    if (json["companies"] != null) {
      print("Companies json");

      companies = <ShippingCompany>[];
      json['companies'].forEach((v) {
        companies!.add(ShippingCompany.fromJson(v));
      });
    }
  }
}


class ShippingCompany {
   int? id;
   String? company;
   String? city;
   String? address;
   String? postcode;
   String? country;
   String? phone;
   int? shipping_mode_id;
   String? countryOfOrigin;
   String? destinationCountry;
   String? status;

   ShippingCompany({
     this.id,
     this.company,
     this.city,
     this.address,
     this.postcode,
     this.country,
     this.phone,
     this.shipping_mode_id,
     this.countryOfOrigin,
     this.destinationCountry,
     this.status
   });

   ShippingCompany.fromJson(Map<String, dynamic> json) {
     id = json["id"] ;
     company = json["company"];
     city = json["city"];
     address = json["address"];
     postcode = json["postcode"];
     country = json["country"];
     phone = json["phone"];
     shipping_mode_id = json["shipping_mode_id"];
     countryOfOrigin = json["country_of_origin"];
     destinationCountry = json["destination_country"];
     status = json["status"];
   }

}