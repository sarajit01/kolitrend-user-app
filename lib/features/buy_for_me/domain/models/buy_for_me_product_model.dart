import 'dart:ffi';

import 'package:flutter_sixvalley_ecommerce/features/buy_for_me/domain/models/category_model.dart';

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
  double? exchangeRate;
  String? itemPricePrimaryCurrency;
  double? serviceFeeUnitAmount;
  double? serviceFeeUnitPercent;
  double? inspectionFeeUnitAmount;
  double? inspectionFeeUnitPercent;
  double? vatAmount;
  double? vatPercent;
  double? customsFeePercent;
  double? customsFee;
  double? localDeliveryFee;
  double? localDeliveryFeePercent;
  double? internationalDeliveryFee;
  double? internationalDeliveryFeePercent;

  BuyForMeCategory? category;

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
    this.shipLocalPrice,
    this.exchangeRate,
    this.itemPricePrimaryCurrency,
    this.serviceFeeUnitAmount,
    this.serviceFeeUnitPercent,
    this.inspectionFeeUnitAmount,
    this.inspectionFeeUnitPercent,
    this.vatAmount,
    this.vatPercent,
    this.customsFeePercent,
    this.customsFee,
    this.localDeliveryFee,
    this.localDeliveryFeePercent,
    this.internationalDeliveryFee,
    this.internationalDeliveryFeePercent,
    this.category
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
    shipLocalCurrency = json['ship_local_currency'];
    shipLocalPrice = double.tryParse(json['ship_local_price'].toString());
    exchangeRate = double.tryParse(json['exchange_rate'].toString());
    itemPricePrimaryCurrency = json['item_price_primary_currency'];
    serviceFeeUnitAmount = double.tryParse(json['service_fee_unit_amount'].toString());
    serviceFeeUnitPercent = double.tryParse(json['service_fee_unit_percent'].toString());
    inspectionFeeUnitAmount = double.tryParse(json['inspection_fee_unit_amount'].toString());
    inspectionFeeUnitPercent = double.tryParse(json['inspection_fee_unit_percent'].toString());
    vatAmount = double.tryParse(json['vat_amount'].toString());
    vatPercent = double.tryParse(json['vat_percent'].toString());
    customsFeePercent = double.tryParse(json['customs_fee_percent'].toString());
    customsFee = double.tryParse(json['customs_fee'].toString());
    localDeliveryFee = double.tryParse(json['local_delivery_fee'].toString());
    localDeliveryFeePercent = double.tryParse(json['local_delivery_fee_percent'].toString());
    internationalDeliveryFee = double.tryParse(json['international_delivery_fee'].toString());
    internationalDeliveryFeePercent = double.tryParse(json['international_delivery_fee_percent'].toString());
    category = BuyForMeCategory.fromJson(json['category']);
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
    data['exchange_rate'] = exchangeRate;
    data['item_price_primary_currency'] = itemPricePrimaryCurrency;
    data['service_fee_unit_amount'] = serviceFeeUnitAmount;
    data['service_fee_unit_percent'] = serviceFeeUnitPercent;
    data['inspection_fee_unit_amount'] = inspectionFeeUnitAmount;
    data['inspection_fee_unit_percent'] = inspectionFeeUnitPercent;
    data['vat_amount'] = vatAmount;
    data['vat_percent'] = vatPercent;
    data['customs_fee_percent'] = customsFeePercent;
    data['customs_fee'] = customsFee;
    data['local_delivery_fee'] = localDeliveryFee;
    data['local_delivery_fee_percent'] = localDeliveryFeePercent;
    data['international_delivery_fee'] = internationalDeliveryFee;
    data['international_delivery_fee_percent'] = internationalDeliveryFeePercent;

    return data;
  }




}