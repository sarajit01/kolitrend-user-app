abstract class KolitrendShippingServiceInterface {
  Future<dynamic> getBranches(String countryOfOrigin);
  Future<dynamic> getCombineShipRelatedOrders();
  Future<dynamic> getShippingModes(
      String countryOfOrigin, String destinationCountry);
  Future<dynamic> getShippingCompanies(
      String countryOfOrigin, String destinationCountry, int shippingModeId);
  Future<dynamic> getShippingPackageTypes(String countryOfOrigin,
      String destinationCountry, int shippingModeId, int shippingCompanyId);
  Future<dynamic> getShippingServices(
      String countryOfOrigin,
      String destinationCountry,
      int shippingModeId,
      int shippingCompanyId,
      int shippingPackageTypeId);
  Future<dynamic> getShippingDeliveryTimes(
      String countryOfOrigin,
      String destinationCountry,
      int shippingModeId,
      int shippingCompanyId,
      int shippingPackageTypeId,
      int shippingServiceId
      );

// Future<dynamic> add(AddressModel addressModel);
  //
  // Future<dynamic> update(Map<String, dynamic> body, int addressId);
  //
  // Future<dynamic> delete(int id);
  //
  // List<LabelAsModel> getAddressType();
  //
  // Future<dynamic> getDeliveryRestrictedCountryList();
  //
  // Future<dynamic> getDeliveryRestrictedZipList();
  //
  // Future<dynamic> getDeliveryRestrictedZipBySearch(String zipcode);
  //
  // Future<dynamic> getDeliveryRestrictedCountryBySearch(String country);
}
