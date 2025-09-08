import 'dart:ffi';

class BuyForMeProduct {

  int? id;
  String? tempSessionToken;
  String? url ;
  String? product;
  int? categoryId;
  String? size;
  String? color;
  String? description;
  int? quantity;
  double? itemPrice;
  String? storeName;
  String? buyingCountry;
  String? deliveryCountry;
  double? subTotal;
  double? localShip;
  double? serviceFee;
  double? inspectionFee;
  double? total;
  String? itemPriceLocalCurrency;
  double? itemLocalPrice;
  String? shipLocalCurrency;
  double? shipLocalPrice;

  BuyForMeProduct({
    this.id,
    this.tempSessionToken,
    this.url,
    this.product,
    this.categoryId,
    this.size,
    this.color,
    this.description,
    this.quantity,
    this.itemPrice,
    this.storeName,
    this.buyingCountry,
    this.deliveryCountry,
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


  BuyForMeProduct.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id'].toString());
    tempSessionToken = json['session_token'];
    url = json['url'];
    product = json['product'];
    categoryId = int.tryParse(json['category_id']);
    size = json['size'];
    color = json['color'];
    description = json['description'];
    quantity = int.tryParse(json['quantity'].toString());
    itemPrice = double.tryParse(json['item_price']);
    storeName = json["store_name"];
    buyingCountry = json['buying_country'];
    deliveryCountry = json['delivery_country'];
    subTotal = double.tryParse(json['sub_total'].toString());
    localShip = double.tryParse(json['local_ship'].toString());
    serviceFee = double.tryParse(json['service_fee'].toString());
    inspectionFee = double.tryParse(json['inspection_fee'].toString());
    total = double.tryParse(json['total'].toString());
    itemPriceLocalCurrency = json['item_price_local_currency'];
    itemLocalPrice = double.tryParse(json['item_local_price'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['session_token'] = tempSessionToken;
    data['url'] = url;
    data['product'] = product;
    data['category_id'] = categoryId;
    data['size'] = size;
    data['color'] = color;
    data['description'] = description;
    data['quantity'] = quantity;
    data['item_price'] = itemPrice;
    data['store_name'] = storeName;
    data['buying_country'] = buyingCountry;
    data['delivery_country'] = deliveryCountry;
    data['sub_total'] = subTotal;
    data['local_ship'] = localShip;
    data['service_fee'] = serviceFee;
    data['inspection_fee'] = inspectionFee;
    data['total'] = total;
    data['item_price_local_currency'] = itemPriceLocalCurrency;
    data['item_local_price'] = itemLocalPrice;
    data['ship_local_currency'] = shipLocalCurrency;
    data['ship_local_price'] = shipLocalPrice;
    return data;
  }




}