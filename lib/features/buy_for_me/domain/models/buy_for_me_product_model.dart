import 'dart:ffi';

class BuyForMeProduct {

  int? id;
  String? tempSessionToken;
  String? url ;
  String? product;
  String? size;
  String? color;
  String? description;
  int? quantity;
  Double? itemPrice;
  String? storeName;
  String? country;
  Double? subTotal;
  Double? localShip;
  Double? serviceFee;
  Double? inspectionFee;
  Double? total;
  String? itemPriceLocalCurrency;
  Double? itemLocalPrice;
  String? shipLocalCurrency;
  Double? shipLocalPrice;

  BuyForMeProduct({
    this.id,
    this.tempSessionToken,
    this.url,
    this.product,
    this.size,
    this.color,
    this.description,
    this.quantity,
    this.itemPrice,
    this.storeName,
    this.country,
    this.subTotal,
    this.localShip,
    this.serviceFee,
    this.inspectionFee,
    this.total,
    this.itemPriceLocalCurrency,
    this.itemLocalPrice,
    this.shipLocalCurrency,
    this.shipLocalPrice
  });
  //
  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   data['id'] = id;
  //   data['name'] = name;
  //   data['_method'] = method;
  //   data['f_name'] = fName;
  //   data['l_name'] = lName;
  //   data['phone'] = phone;
  //   data['image'] = image;
  //   data['email'] = email;
  //   data['email_verified_at'] = emailVerifiedAt;
  //   data['created_at'] = createdAt;
  //   data['updated_at'] = updatedAt;
  //   data['wallet_balance'] = walletBalance;
  //   data['loyalty_point'] = loyaltyPoint;
  //   return data;
  // }
  //
  //
  //

}