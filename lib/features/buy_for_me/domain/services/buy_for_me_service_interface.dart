import 'package:flutter_sixvalley_ecommerce/features/buy_for_me/domain/models/buy_for_me_product_model.dart';

abstract class BuyForMeServiceInterface {
   Future<dynamic> getCategories();
   Future<dynamic> addProduct(BuyForMeProduct product);
   Future<dynamic> calculateProductFee(BuyForMeProduct product);

}