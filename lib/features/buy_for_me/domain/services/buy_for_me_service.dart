import 'package:flutter_sixvalley_ecommerce/features/buy_for_me/domain/models/buy_for_me_product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/buy_for_me/domain/repositories/buy_for_me_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/buy_for_me/domain/services/buy_for_me_service_interface.dart';

class BuyForMeService implements BuyForMeServiceInterface {

  BuyForMeRepositoryInterface buyForMeRepositoryInterface;

  BuyForMeService({required this.buyForMeRepositoryInterface});

  @override
  Future<void> getCategories() async {
    return await buyForMeRepositoryInterface.getCategories();
  }

  @override
  Future<void> addProduct(BuyForMeProduct product) async {
    return await buyForMeRepositoryInterface.addNewProduct(product);
  }

  @override
  Future<void> calculateProductFee(BuyForMeProduct product) async {
    return await buyForMeRepositoryInterface.calculateProductFee(product);
  }


}