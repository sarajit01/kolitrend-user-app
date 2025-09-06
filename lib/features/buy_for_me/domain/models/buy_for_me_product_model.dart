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