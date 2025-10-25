import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/kolitrend_shipping/domain/repositories/kolitrend_shipping_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'dart:async';

class KolitrendShippingRepository implements KolitrendShippingRepositoryInterface {
  final DioClient? dioClient;
  KolitrendShippingRepository({required this.dioClient});

  @override
  Future<ApiResponseModel> getBranches(String countryOfOrigin) async {
    try {
      final response = await dioClient!.get(
          '${AppConstants.shippingBranchesUri}$countryOfOrigin');
      print(response);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getCombineShipRelatedOrders() async {
    try {
      final response = await dioClient!.get(
          AppConstants.combineShipRelatedOrdersUri);
      print(response);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getShippingModes(String countryOfOrigin, String destinationCountry) async {
    try {
      final response = await dioClient!.get('${AppConstants.shippingModes}?country_of_origin=${countryOfOrigin}&destination_country=${destinationCountry}');
      print(response);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getShippingCompanies(String countryOfOrigin, String destinationCountry, int shippingModeId) async {
    try {
      final response = await dioClient!.get('${AppConstants.shippingCompanies}?country_of_origin=${countryOfOrigin}&destination_country=${destinationCountry}&shipping_mode_id=${shippingModeId}');
      print(response);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getShippingPackageTypes(String countryOfOrigin, String destinationCountry, int shippingModeId, int shippingCompanyId) async {
    try {
      final response = await dioClient!.get('${AppConstants.shippingPackageTypes}?country_of_origin=$countryOfOrigin&destination_country=$destinationCountry&shipping_mode_id=$shippingModeId&shipping_company_id=$shippingCompanyId');
      print(response);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getShippingServices(String countryOfOrigin, String destinationCountry, int shippingModeId, int shippingCompanyId, int shippingPackageTypeId) async {
    try {
      final response = await dioClient!.get('${AppConstants.shippingServices}?country_of_origin=$countryOfOrigin&destination_country=$destinationCountry&shipping_mode_id=$shippingModeId&shipping_company_id=$shippingCompanyId&package_type_id=$shippingPackageTypeId');
      print(response);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getShippingDeliveryTimes(
      String countryOfOrigin,
      String destinationCountry,
      int shippingModeId,
      int shippingCompanyId,
      int shippingPackageTypeId,
      int shippingServiceId
      ) async {
    try {
      final response = await dioClient!.get('${AppConstants.shippingDeliveryTimes}?country_of_origin=$countryOfOrigin&destination_country=$destinationCountry&shipping_mode_id=$shippingModeId&shipping_company_id=$shippingCompanyId&package_type_id=$shippingPackageTypeId&shipping_service_id=$shippingServiceId');
      print(response);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getClientShippingRate(
      String countryOfOrigin,
      String destinationCountry,
      int shippingModeId,
      int shippingCompanyId,
      int shippingPackageTypeId,
      int shippingServiceId,
      int deliveryTimeId,
      double weight
      ) async {
    try {
      final response = await dioClient!.get('${AppConstants.shippingRates}?country_of_origin=$countryOfOrigin&destination_country=$destinationCountry&shipping_mode_id=$shippingModeId&shipping_company_id=$shippingCompanyId&package_type_id=$shippingPackageTypeId&shipping_service_id=$shippingServiceId&delivery_time_id=$deliveryTimeId&weight=$weight');
      print(response);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }


}
