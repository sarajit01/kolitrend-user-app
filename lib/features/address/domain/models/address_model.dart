
import 'package:flutter_sixvalley_ecommerce/features/kolitrend_shipping/domain/models/branch_model.dart';

class CountryModel {
   String? name;
   String? code;

   CountryModel({
       this.name,
       this.code
   });

   CountryModel.fromJson(Map<String, dynamic> json) {
     name = json['name'];
     code = json['code'];
   }
}

class AddressListModel {
   List<CompanyBranch>? companyBranches;
   List<AddressModel>? shippingAddresses;
   List<AddressModel>? billingAddresses;

   AddressListModel({
     this.companyBranches,
     this.shippingAddresses,
     this.billingAddresses
   });

   AddressListModel.fromJson(Map<String, dynamic> json) {

     if (json['company_branches'] != null) {
       companyBranches = <CompanyBranch>[];
       json['company_branches'].forEach((v) {
         companyBranches!.add(CompanyBranch.fromJson(v));
       });
     }

     if (json['shipping_addresses'] != null) {
       shippingAddresses = <AddressModel>[];
       json['shipping_addresses'].forEach((v) {
         shippingAddresses!.add(AddressModel.fromJson(v));
       });
     }

     if (json['billing_addresses'] != null) {
       billingAddresses = <AddressModel>[];
       json['billing_addresses'].forEach((v) {
         billingAddresses!.add(AddressModel.fromJson(v));
       });
     }

   }

}

class AddressModel {
  int? id;
  String? firstName;
  String? lastName;
  String? contactPersonName;
  String? company;
  String? addressType;
  String? address;
  String? city;
  String? zip;
  String? phone;
  String? createdAt;
  String? updatedAt;
  String? state;
  String? country;
  String? countryCode;
  String? countryFlag;
  String? latitude;
  String? longitude;
  bool? isBilling;
  String? guestId;
  String? email;
  AddressModel({
    this.id,
    this.firstName,
    this.lastName,
    this.contactPersonName,
    this.company,
    this.addressType,
    this.address,
    this.city,
    this.zip,
    this.phone,
    this.createdAt,
    this.updatedAt,
    this.state,
    this.country,
    this.countryCode,
    this.countryFlag,
    this.latitude,
    this.longitude,
    this.isBilling,
    this.guestId,
    this.email,
  });

  AddressModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    contactPersonName = json['contact_person_name'];
    company = json['company'];
    addressType = json['address_type'];
    address = json['address'];
    city = json['city'];
    zip = json['zip'];
    phone = json['phone'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    state = json['state'];
    country = json['country'];
    countryCode = json['country_code'];
    countryFlag = json['country_flag'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    isBilling = json['is_billing'] ?? false;
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['contact_person_name'] = contactPersonName;
    data['company'] = company;
    data['address_type'] = addressType;
    data['address'] = address;
    data['city'] = city;
    data['zip'] = zip;
    data['phone'] = phone;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['state'] = state;
    data['country'] = country;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['is_billing'] = isBilling;
    data['guest_id'] = guestId;
    data['email'] = email;
    return data;
  }
}
