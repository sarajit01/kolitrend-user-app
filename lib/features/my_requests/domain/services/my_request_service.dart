import 'package:flutter_sixvalley_ecommerce/features/my_requests/domain/repositories/my_request_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/my_requests/domain/services/my_request_service_interface.dart';

class MyRequestService implements MyRequestServiceInterface {
  MyRequestRepositoryInterface myRequestRepositoryInterface;
  MyRequestService({required this.myRequestRepositoryInterface});

  @override
  Future cancelRequest(int? requestId) async {
    return await myRequestRepositoryInterface.cancelRequest(requestId);
  }

  @override
  Future<void> getMyRequestList(int offset, String status,
      {String? type}) async {
    return await myRequestRepositoryInterface.getMyRequestList(offset, status);
  }

  @override
  Future getTrackingInfo(String orderID) async {
    return await myRequestRepositoryInterface.getTrackingInfo(orderID);
  }
}
