import 'package:flutter_sixvalley_ecommerce/features/buy_for_me/domain/repositories/buy_for_me_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/buy_for_me/domain/services/buy_for_me_service_interface.dart';

class BuyForMeService implements BuyForMeServiceInterface {

  BuyForMeRepositoryInterface buyForMeRepositoryInterface;

  BuyForMeService({required this.buyForMeRepositoryInterface});

  @override
  Future<void> getCategories() async {
    return await buyForMeRepositoryInterface.getCategories();
  }



}