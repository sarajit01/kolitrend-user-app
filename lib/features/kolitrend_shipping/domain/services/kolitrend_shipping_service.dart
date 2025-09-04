import 'package:flutter_sixvalley_ecommerce/features/kolitrend_shipping/domain/models/branch_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/kolitrend_shipping/domain/repositories/kolitrend_shipping_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/kolitrend_shipping/domain/services/kolitrend_shipping_service_interface.dart';

class KolitrendShippingService implements KolitrendShippingServiceInterface {
  KolitrendShippingRepositoryInterface kolitrendShippingRepositoryInterface;
  KolitrendShippingService(
      {required this.kolitrendShippingRepositoryInterface});

  List<CompanyBranch> _branchList = [];

  @override
  Future<void> getBranches(String countryOfOrigin) async {
    return await kolitrendShippingRepositoryInterface
        .getBranches(countryOfOrigin);
  }

  @override
  Future<void> getCombineShipRelatedOrders() async {
    return await kolitrendShippingRepositoryInterface
        .getCombineShipRelatedOrders();
  }

  @override
  Future<void> getShippingModes(
      String countryOfOrigin, String destinationCountry) async {
    return await kolitrendShippingRepositoryInterface.getShippingModes(
        countryOfOrigin, destinationCountry);
  }

  @override
  Future<void> getShippingCompanies(String countryOfOrigin,
      String destinationCountry, int shippingModeId) async {
    return await kolitrendShippingRepositoryInterface.getShippingCompanies(
        countryOfOrigin, destinationCountry, shippingModeId);
  }

  @override
  Future<void> getShippingPackageTypes(
      String countryOfOrigin,
      String destinationCountry,
      int shippingModeId,
      int shippingCompanyId) async {
    return await kolitrendShippingRepositoryInterface.getShippingPackageTypes(
        countryOfOrigin, destinationCountry, shippingModeId, shippingCompanyId);
  }

  @override
  Future<void> getShippingServices(
      String countryOfOrigin,
      String destinationCountry,
      int shippingModeId,
      int shippingCompanyId,
      int shippingPackageTypeId) async {
    return await kolitrendShippingRepositoryInterface.getShippingServices(
        countryOfOrigin,
        destinationCountry,
        shippingModeId,
        shippingCompanyId,
        shippingPackageTypeId);
  }

  @override
  Future<void> getShippingDeliveryTimes(
      String countryOfOrigin,
      String destinationCountry,
      int shippingModeId,
      int shippingCompanyId,
      int shippingPackageTypeId,
      int shippingServiceId) async {
    return await kolitrendShippingRepositoryInterface.getShippingDeliveryTimes(
        countryOfOrigin,
        destinationCountry,
        shippingModeId,
        shippingCompanyId,
        shippingPackageTypeId,
        shippingServiceId);
  }
}
