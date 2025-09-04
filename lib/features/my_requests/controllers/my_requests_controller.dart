import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_sixvalley_ecommerce/data/local/cache_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/my_requests/domain/models/my_request_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/my_requests/domain/services/my_request_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/domain/models/order_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/domain/services/order_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';

class MyRequestsController with ChangeNotifier {
  final MyRequestServiceInterface myRequestServiceInterface;
  MyRequestsController({required this.myRequestServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  MyRequestModel? myRequestModel;
  OrderModel? deliveredOrderModel;
  Future<void> getMyRequestsList(
      int offset, String status, String? type) async {
    var localData = await database.getCacheResponseById(AppConstants.orderUri);

    if (type == 'reorder') {
      if (localData != null) {
        deliveredOrderModel =
            OrderModel.fromJson(jsonDecode(localData.response));
        notifyListeners();
      }
    }

    if (offset == 1) {
      myRequestModel = null;
    }
    ApiResponseModel apiResponse = await myRequestServiceInterface
        .getMyRequestList(offset, status, type: type);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      if (offset == 1) {
        myRequestModel = MyRequestModel.fromJson(apiResponse.response?.data);
        if (type == 'reorder') {
          deliveredOrderModel = OrderModel.fromJson(apiResponse.response?.data);

          if (localData != null) {
            await database.updateCacheResponse(
                AppConstants.myRequestsUri,
                CacheResponseCompanion(
                  endPoint: const Value(AppConstants.myRequestsUri),
                  header: Value(jsonEncode(apiResponse.response!.headers.map)),
                  response: Value(jsonEncode(apiResponse.response!.data)),
                ));
          } else {
            await database.insertCacheResponse(
              CacheResponseCompanion(
                endPoint: const Value(AppConstants.myRequestsUri),
                header: Value(jsonEncode(apiResponse.response!.headers.map)),
                response: Value(jsonEncode(apiResponse.response!.data)),
              ),
            );
          }
        }
      } else {
        myRequestModel!.myRequests!.addAll(
            MyRequestModel.fromJson(apiResponse.response?.data).myRequests!);
        myRequestModel!.offset =
            OrderModel.fromJson(apiResponse.response?.data).offset;
        myRequestModel!.totalSize =
            OrderModel.fromJson(apiResponse.response?.data).totalSize;
      }
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  int _orderTypeIndex = 0;
  int get orderTypeIndex => _orderTypeIndex;

  String selectedType = '';
  void setIndex(int index, {bool notify = true}) {
    _orderTypeIndex = index;
    if (_orderTypeIndex == 0) {
      selectedType = 'buy_for_me';
      getMyRequestsList(1, '', 'buy_for_me');
    } else if (_orderTypeIndex == 1) {
      selectedType = 'kolitrend_shipping';
      getMyRequestsList(1, '', 'kolitrend_shipping');
    } else if (_orderTypeIndex == 2) {
      selectedType = 'combine_ship';
      getMyRequestsList(1, '', 'combine_ship');
    }
    if (notify) {
      notifyListeners();
    }
  }

  Orders? trackingModel;
  Future<void> initTrackingInfo(String orderID) async {
    ApiResponseModel apiResponse =
        await myRequestServiceInterface.getTrackingInfo(orderID);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      trackingModel = Orders.fromJson(apiResponse.response!.data);
    }
    notifyListeners();
  }

  Future<ApiResponseModel> cancelOrder(
      BuildContext context, int? orderId) async {
    _isLoading = true;
    ApiResponseModel apiResponse =
        await myRequestServiceInterface.cancelRequest(orderId);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _isLoading = false;
    } else {
      _isLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }
}
