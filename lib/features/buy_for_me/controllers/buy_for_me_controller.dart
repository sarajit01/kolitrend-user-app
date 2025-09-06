
import 'dart:convert';
import 'dart:ffi';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/address/domain/models/address_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/buy_for_me/domain/models/buy_for_me_product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/buy_for_me/domain/models/buy_for_me_product_order_summary.dart';
import 'package:flutter_sixvalley_ecommerce/features/buy_for_me/domain/models/category_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/buy_for_me/domain/services/buy_for_me_service_interface.dart';

import '../../../data/local/cache_response.dart';
import '../../../helper/api_checker.dart';
import '../../../main.dart';
import '../../../utill/app_constants.dart';

class BuyForMeController with ChangeNotifier {
   final BuyForMeServiceInterface buyForMeServiceInterface;

   bool isLoading = false;
   BuyForMeCategory? selectedCategory;
   BuyForMeProduct? productInAction;
   BuyForMeProductOrderSummary? buyForMeProductOrderSummary;


   BuyForMeController({required this.buyForMeServiceInterface});

   BuyForMeCategoriesModel? buyForMeCategoriesModel;
   List<BuyForMeCategory>? _categories = [];
   List<BuyForMeCategory>? get categories => _categories;

   Future<void> getCategories() async{
     _categories = [];

     var localData = await database.getCacheResponseById(AppConstants.buyForMeCategoriesUri);
     if (localData != null) {
       buyForMeCategoriesModel =
           BuyForMeCategoriesModel.fromJson(jsonDecode(localData.response));
       buyForMeCategoriesModel?.categories
           ?.forEach((category) => _categories!.add(category));

       notifyListeners();

     }

     ApiResponseModel apiResponse = await buyForMeServiceInterface.getCategories();
     if (apiResponse.response != null &&
         apiResponse.response!.statusCode == 200) {
       print("List of categories from API:");
       buyForMeCategoriesModel = BuyForMeCategoriesModel.fromJson(apiResponse.response?.data);
       buyForMeCategoriesModel?.categories
           ?.forEach((category) => _categories!.add(category));

       if (localData != null) {
         await database.updateCacheResponse(
             AppConstants.orderUri,
             CacheResponseCompanion(
               endPoint: const Value(AppConstants.buyForMeCategoriesUri),
               header: Value(jsonEncode(apiResponse.response!.headers.map)),
               response: Value(jsonEncode(apiResponse.response!.data)),
             ));
       } else {
         await database.insertCacheResponse(
           CacheResponseCompanion(
             endPoint: const Value(AppConstants.buyForMeCategoriesUri),
             header: Value(jsonEncode(apiResponse.response!.headers.map)),
             response: Value(jsonEncode(apiResponse.response!.data)),
           ),
         );
       }

     } else {
       ApiChecker.checkApi(apiResponse);
     }
     notifyListeners();
   }

   Future<void> addProduct(BuyForMeProduct product) async{
     showCustomSnackBar("Failed to add product", Get.context!);
     ApiResponseModel apiResponse = await buyForMeServiceInterface.addProduct(product);
     if (apiResponse.response != null &&
         apiResponse.response!.statusCode == 200) {
        print(apiResponse.response.data);
     } else {
       ApiChecker.checkApi(apiResponse);
     }
     notifyListeners();
   }


   Future<void> calculateProductFee() async{
     if (productInAction == null){
       showCustomSnackBar("Product was not set in context to calculate", Get.context!);
       return;
     }
     ApiResponseModel apiResponse = await buyForMeServiceInterface.calculateProductFee(productInAction!);
     if (apiResponse.response != null &&
         apiResponse.response!.statusCode == 200) {
       print(apiResponse.response.data);
       buyForMeProductOrderSummary = BuyForMeProductOrderSummary.fromJson(apiResponse.response.data);
     } else {
       ApiChecker.checkApi(apiResponse);
     }
     notifyListeners();
   }




}