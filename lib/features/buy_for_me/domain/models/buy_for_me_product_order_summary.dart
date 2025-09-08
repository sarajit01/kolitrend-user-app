import 'dart:ffi';

class BuyForMeProductOrderSummary {

  double? subtotal = 0;
  String? subtotalHint;
  double? serviceFee = 0 ;
  String? serviceFeeHint;
  double? inspectionFee = 0;
  String? inspectionFeeHint;
  double? vat = 0;
  String? vatHint;
  double? customsFee = 0;
  String? customsFeeHint;
  double? localDeliveryFee = 0;
  String? localDeliveryFeeHint;
  double? internationalDeliveryFee = 0;
  String? internationalDeliveryFeeHint;
  double? total = 0;

  BuyForMeProductOrderSummary({
    this.subtotal,
    this.subtotalHint,
    this.serviceFee,
    this.serviceFeeHint,
    this.inspectionFee,
    this.inspectionFeeHint,
    this.vat,
    this.vatHint,
    this.customsFee,
    this.customsFeeHint,
    this.localDeliveryFee,
    this.localDeliveryFeeHint,
    this.internationalDeliveryFee,
    this.internationalDeliveryFeeHint,
    this.total
  });

  BuyForMeProductOrderSummary.fromJson(Map<String, dynamic> json) {
    subtotal = double.tryParse(json['subtotal'].toString());
    serviceFee = double.tryParse(json['service_fee'].toString()) ;
    serviceFeeHint = json['service_fee_tooltip'];
    inspectionFee = double.tryParse(json['inspection_fee'].toString());
    inspectionFeeHint = json['inspection_fee_tooltip'];
    vat = double.tryParse(json['vat'].toString());
    vatHint = json['vat_tooltip'];
    customsFee = double.tryParse(json['customs_fee'].toString());
    customsFeeHint = json['customs_fee_tooltip'];
    localDeliveryFee = double.tryParse(json['local_delivery_fee'].toString());
    localDeliveryFeeHint = json['local_delivery_fee_tooltip'];
    internationalDeliveryFee = double.tryParse(json['international_delivery_fee'].toString());
    internationalDeliveryFeeHint = json['international_delivery_fee_tooltip'];
    total = double.tryParse(json['total_payable'].toString());
  }


}