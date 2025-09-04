abstract class MyRequestServiceInterface {
  Future<dynamic> getMyRequestList(int offset, String status, {String? type});

  Future<dynamic> getTrackingInfo(String orderID);

  Future<dynamic> cancelRequest(int? orderId);
}
