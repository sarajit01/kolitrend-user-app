abstract class KolitrendShippingRepositoryInterface<T> {
  Future<void> getBranches(String countryOfOrigin);
  Future<void> getCombineShipRelatedOrders();
  Future<void> getShippingModes(
      String countryOfOrigin, String destinationCountry);
  Future<void> getShippingCompanies(
      String countryOfOrigin, String destinationCountry, int shippingModeId);
  Future<void> getShippingPackageTypes(String countryOfOrigin,
      String destinationCountry, int shippingModeId, int shippingCompanyId);
  Future<void> getShippingServices(
      String countryOfOrigin,
      String destinationCountry,
      int shippingModeId,
      int shippingCompanyId,
      int shippingPackageTypeId);
  Future<void> getShippingDeliveryTimes(
      String countryOfOrigin,
      String destinationCountry,
      int shippingModeId,
      int shippingCompanyId,
      int shippingPackageTypeId,
      int shippingServiceId);

  Future<void> getClientShippingRate(
      String countryOfOrigin,
      String destinationCountry,
      int shippingModeId,
      int shippingCompanyId,
      int shippingPackageTypeId,
      int shippingServiceId,
      int deliveryTimeId,
      double weight
   );
}
