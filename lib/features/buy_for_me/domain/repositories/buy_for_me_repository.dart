import 'package:dio/dio.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/buy_for_me/domain/models/buy_for_me_product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/buy_for_me/domain/repositories/buy_for_me_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';

class BuyForMeRepository implements BuyForMeRepositoryInterface {
  
  final DioClient? dioClient;
  
  BuyForMeRepository({required this.dioClient});
  
  @override
  Future<ApiResponseModel> getCategories() async {
     try {
       final response = await dioClient!.get('${AppConstants.buyForMeCategoriesUri}');
       print(response);
       return ApiResponseModel.withSuccess(response);
     } catch(e) {
       return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
     }
  }

  @override
  Future<ApiResponseModel> addNewProduct(BuyForMeProduct product) async {
    try {
      Response response = await dioClient!
          .post(AppConstants.buyForMeAddProductUri, data: product.toJson());
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> calculateProductFee(BuyForMeProduct product) async {
    try {
      Response response = await dioClient!
          .post(AppConstants.buyForMeCalculateFees, data: product.toJson());
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }
  
}