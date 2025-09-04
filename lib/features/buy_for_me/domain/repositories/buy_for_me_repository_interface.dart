import 'package:flutter_sixvalley_ecommerce/interface/repo_interface.dart';

abstract class BuyForMeRepositoryInterface<T> {
   Future<void> getCategories();

}