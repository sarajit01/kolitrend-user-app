abstract class SplashServiceInterface {
  Future<dynamic> getConfig();
  Future<dynamic> getBusinessPages(String type);
  void initSharedData();
  String getCurrency();
  void setCurrency(String currencyCode);
  void setShoppingCountry(String shoppingCountry);
  String getShoppingCountry();
  void disableIntro();
  bool? showIntro();
}
