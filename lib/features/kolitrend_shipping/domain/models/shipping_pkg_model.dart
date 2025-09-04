
class ShippingPackageTypesModel {
  List<ShippingPackageType>? packageTypes;

  ShippingPackageTypesModel({this.packageTypes});

  ShippingPackageTypesModel.fromJson(Map<String, dynamic> json) {
    if (json["package_types"] != null) {
      print("Package types json");

      packageTypes = <ShippingPackageType>[];
      json['package_types'].forEach((v) {
        packageTypes!.add(ShippingPackageType.fromJson(v));
      });
    }
  }

}

class ShippingPackageType {

  int? id;
  String? packagingTypeName;
  String? newPackageDetails;
  String? status;

   int? shippingModeId;
   int? shippingCompanyId;
   String? countryOfOrigin;
   String? destinationCountry;

   ShippingPackageType({
     this.id,
     this.packagingTypeName,
     this.newPackageDetails,
     this.status,
     this.countryOfOrigin,
     this.destinationCountry,
   });

   ShippingPackageType.fromJson(Map<String, dynamic> json) {
     id = json["id"] ;
     packagingTypeName = json["packaging_type_name"];
     newPackageDetails = json["new_package_details"];
     status = json["status"];
     countryOfOrigin = json["country_of_origin"];
     destinationCountry = json["destination_country"];
   }

}