import 'package:flutter_sixvalley_ecommerce/interface/repo_interface.dart';

abstract class MyRequestRepositoryInterface<T> extends RepositoryInterface {
  Future<void> getMyRequestList(int offset, String status, {String? type});

  Future<dynamic> getTrackingInfo(String orderID);

  Future<dynamic> cancelRequest(int? orderId);
}
