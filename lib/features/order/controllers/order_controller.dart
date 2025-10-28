import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/data/local/cache_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/domain/models/order_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/domain/models/order_status_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/domain/services/order_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';

class OrderController with ChangeNotifier {
  final OrderServiceInterface orderServiceInterface;
  OrderController({required this.orderServiceInterface});

  bool isLoading = false;

  OrderModel? orderModel;
  OrderModel? deliveredOrderModel;

  List<OrderStatusModel> orderStatusList = [];
  OrderStatusModel? selectedStatus;



  Future<void> getOrderStatuses() async {
    orderStatusList = [];
    var localData = await database.getCacheResponseById(AppConstants.orderStatusesUri);

    notifyListeners();

    ApiResponseModel apiResponse = await orderServiceInterface.getOrderStatuses();
    print("API response for orders");
    print(apiResponse);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        apiResponse.response!.data!.forEach((element) {
          orderStatusList.add(OrderStatusModel.fromJson(element));
        });
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    print("Order statuses");
    print(orderStatusList.length);
    notifyListeners();
  }

  Future<void> getOrderList(int offset, String status, {String? type}) async {
    var localData = await database.getCacheResponseById(AppConstants.orderUri);

    if (type == 'reorder') {
      if (localData != null) {
        deliveredOrderModel =
            OrderModel.fromJson(jsonDecode(localData.response));
        notifyListeners();
      }
    }

    if (offset == 1) {
      orderModel?.orders = [];
    }


    ApiResponseModel apiResponse =
        await orderServiceInterface.getOrderList(offset, status, type: type);
    print("API response for orders");
    print(apiResponse);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      if (offset == 1) {
        orderModel = OrderModel.fromJson(apiResponse.response?.data);
        if (type == 'reorder') {
          deliveredOrderModel = OrderModel.fromJson(apiResponse.response?.data);

          if (localData != null) {
            showCustomSnackBar("Loaded from cache", Get.context!);
            await database.updateCacheResponse(
                AppConstants.orderUri,
                CacheResponseCompanion(
                  endPoint: const Value(AppConstants.orderUri),
                  header: Value(jsonEncode(apiResponse.response!.headers.map)),
                  response: Value(jsonEncode(apiResponse.response!.data)),
                ));
          } else {
            await database.insertCacheResponse(
              CacheResponseCompanion(
                endPoint: const Value(AppConstants.orderUri),
                header: Value(jsonEncode(apiResponse.response!.headers.map)),
                response: Value(jsonEncode(apiResponse.response!.data)),
              ),
            );
          }
        }
      } else {
        orderModel!.orders!
            .addAll(OrderModel.fromJson(apiResponse.response?.data).orders!);
        orderModel!.offset =
            OrderModel.fromJson(apiResponse.response?.data).offset;
        orderModel!.totalSize =
            OrderModel.fromJson(apiResponse.response?.data).totalSize;
      }
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  int _orderTypeIndex = 0;
  int get orderTypeIndex => _orderTypeIndex;

  String selectedType = 'pending';
  void setIndex(int index, {bool notify = true}) {
    _orderTypeIndex = index;
    if (_orderTypeIndex == 0) {
      selectedType = 'pending';
      getOrderList(1, 'pending');
    } else if (_orderTypeIndex == 1) {
      selectedType = 'delivered';
      getOrderList(1, 'delivered');
    } else if (_orderTypeIndex == 2) {
      selectedType = 'canceled';
      getOrderList(1, 'canceled');
    }
    if (notify) {
      notifyListeners();
    }
  }

  void setSelectedStatus(OrderStatusModel status) {
    if (selectedStatus?.value != status.value){
      showCustomSnackBar("Loading ${status.statusName} orders", Get.context! , isError: false);
      orderModel = null ;
    }
    selectedStatus = status;
    isLoading = true;
    getOrderList(1, status.value!);
    isLoading = false;
  }

  Orders? trackingModel;
  Future<void> initTrackingInfo(String orderID) async {
    ApiResponseModel apiResponse =
        await orderServiceInterface.getTrackingInfo(orderID);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      trackingModel = Orders.fromJson(apiResponse.response!.data);
    }
    notifyListeners();
  }

  Future<ApiResponseModel> cancelOrder(
      BuildContext context, int? orderId) async {
    isLoading = true;
    ApiResponseModel apiResponse =
        await orderServiceInterface.cancelOrder(orderId);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      isLoading = false;
    } else {
      isLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }
}
