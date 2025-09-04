import 'dart:ffi';

class CompanyBranchesModel {

  List<CompanyBranch>? companyBranches;
  CompanyBranchesModel({this.companyBranches});

  CompanyBranchesModel.fromJson(Map<String, dynamic> json) {
    print("From this function");
    if (json['branches'] != null) {
      print("Branches json");

      companyBranches = <CompanyBranch>[];
      json['branches'].forEach((v) {
        print("Branch each");
        companyBranches!.add(CompanyBranch.fromJson(v));
      });
    }
  }
}

class CompanyBranch {
  String? id;
  String? firstName;
  String? lastName;
  String? companyName;
  String? branchType;
  String? branchName;
  String? phone;
  String? email;
  String? address;
  String? city;
  String? zip;
  String? country;
  String? timezone;
  Double? lat;
  Double? long;
  String? countryCode;


  CompanyBranch(
      {this.id,
      this.firstName,
      this.lastName,
      this.companyName,
      this.branchType,
      this.branchName,
      this.phone,
      this.email,
      this.address,
      this.city,
      this.zip,
      this.country,
      this.timezone,
      this.lat,
      this.long,
      this.countryCode});

  CompanyBranch.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString() ?? "";
    firstName = json['first_name'] ?? "";
    lastName = json['last_name'] ?? "";
    companyName = json['company_name'] ?? "";
    branchType = json['branch_type'] ?? "";
    branchName = json['branch_name'] ?? "";
    phone = json['phone'] ?? "";
    email = json['email'] ?? '';
    address = json['address'] ?? "";
    city = json['city'] ?? "";
    zip = json['zip'] ?? "";
    country = json['country'] ?? "";
  }
}
