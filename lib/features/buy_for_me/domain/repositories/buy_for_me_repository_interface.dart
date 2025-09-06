
import 'package:flutter_sixvalley_ecommerce/features/buy_for_me/domain/models/buy_for_me_product_model.dart';

abstract class BuyForMeRepositoryInterface<T> {
   Future<void> getCategories();
   Future<void> addNewProduct(BuyForMeProduct product);
   Future<void> calculateProductFee(BuyForMeProduct product);

}