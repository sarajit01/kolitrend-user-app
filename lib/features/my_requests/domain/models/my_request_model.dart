import 'dart:ffi';

import 'package:flutter_sixvalley_ecommerce/data/model/image_full_url.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/domain/models/seller_model.dart';

class MyRequestModel {
  int? totalSize;
  String? limit;
  String? offset;
  List<MyRequests>? myRequests;

  MyRequestModel({this.totalSize, this.limit, this.offset, this.myRequests});

  MyRequestModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    if (json['my_requests'] != null) {
      myRequests = <MyRequests>[];
      json['my_requests'].forEach((v) {
        myRequests!.add(MyRequests.fromJson(v));
      });
    }
  }
}

class MyRequests {
  int? id;
  int? customerId;
  int? requestId;
  String? requestType;
  String? createdAt;
  String? updatedAt;
  String? status;
  double? totalAmount;

  MyRequests(
      {this.id,
      this.customerId,
      this.requestId,
      this.requestType,
      this.createdAt,
      this.updatedAt,
      this.status,
      this.totalAmount});

  MyRequests.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    requestId = json['request_id'];
    requestType = json['request_type'];

    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    try {
      totalAmount = double.tryParse(json['total_amount'] ?? 0.0);
    } catch(e) {
      totalAmount = 0.00 ;
    }
    status = json['status'] ?? '';
  }
}
