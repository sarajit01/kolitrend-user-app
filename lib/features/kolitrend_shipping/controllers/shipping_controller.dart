import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/address/domain/models/address_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/address/domain/models/label_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/address/domain/models/restricted_zip_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/address/domain/services/address_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/kolitrend_shipping/domain/models/branch_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/kolitrend_shipping/domain/models/shipping_company_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/kolitrend_shipping/domain/models/shipping_deli_time_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/kolitrend_shipping/domain/models/shipping_mode_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/kolitrend_shipping/domain/models/shipping_order_summary.dart';
import 'package:flutter_sixvalley_ecommerce/features/kolitrend_shipping/domain/models/shipping_pkg_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/kolitrend_shipping/domain/models/shipping_rates_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/kolitrend_shipping/domain/models/shipping_service_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/kolitrend_shipping/domain/services/kolitrend_shipping_service.dart';
import 'package:flutter_sixvalley_ecommerce/features/kolitrend_shipping/domain/services/kolitrend_shipping_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/domain/models/order_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/domain/models/order_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';

import '../../../data/local/cache_response.dart';
import '../../../localization/language_constrants.dart';
import '../../../utill/app_constants.dart';

class KolitrendShippingController with ChangeNotifier {
  final KolitrendShippingServiceInterface kolitrendShippingServiceInterface;
  KolitrendShippingController(
      {required this.kolitrendShippingServiceInterface});

  List<String> _restrictedCountryList = [];
  List<String> get restrictedCountryList => _restrictedCountryList;
  List<RestrictedZipModel> _restrictedZipList = [];
  List<RestrictedZipModel> get restrictedZipList => _restrictedZipList;

  // For branches based on country of origin
  List<CompanyBranch> _branches = [];
  List<CompanyBranch> get branchesList => _branches;

  // For shipping modes
  List<ShippingMode> _shippingModes = [];
  List<ShippingMode> get shippingModesList => _shippingModes;

  // For shipping companies
  List<ShippingCompany> _shippingCompanies = [];
  List<ShippingCompany> get shippingCompaniesList => _shippingCompanies;

  // For shipping package types
  List<ShippingPackageType> _shippingPackageTypes = [];
  List<ShippingPackageType> get shippingPackageTypesList =>
      _shippingPackageTypes;

  // For shipping services
  List<ShippingService> _shippingServices = [];
  List<ShippingService> get shippingServicesList => _shippingServices;

  // For shipping delivery times
  List<ShippingDeliveryTime> _shippingDeliveryTimes = [];
  List<ShippingDeliveryTime> get shippingDeliveryTimesList =>
      _shippingDeliveryTimes;

  ShippingMode? selectedShippingMode;
  ShippingCompany? selectedShippingCompany;
  ShippingPackageType? selectedShippingPackageType;
  ShippingService? selectedShippingService;
  ShippingDeliveryTime? selectedShippingDeliveryTime;

  ShippingOrderSummary? shippingOrderSummary;

  OrderModel? combineShipRelatedOrdersModel;
  List<Orders> _combineShipRelatedOrders = [];
  List<Orders> get combineShipRelatedOrdersList => _combineShipRelatedOrders;

  final List<String> _zipNameList = [];
  List<String> get zipNameList => _zipNameList;
  final TextEditingController _searchZipController = TextEditingController();
  TextEditingController get searchZipController => _searchZipController;
  final TextEditingController _searchCountryController =
      TextEditingController();
  TextEditingController get searchCountryController => _searchCountryController;
  List<AddressModel>? _addressList;
  List<AddressModel>? get addressList => _addressList;
  CompanyBranchesModel? companyBranchesModel;
  ShippingModesModel? shippingModesModel;
  ShippingCompaniesModel? shippingCompaniesModel;
  ShippingPackageTypesModel? shippingPackageTypesModel;
  ShippingServicesModel? shippingServicesModel;
  ShippingDeliveryTimesModel? shippingDeliveryTimesModel;
  ClientShippingRate? clientShippingRateModel;

  Future<void> getBranches(String countryOfOrigin) async {
    _branches = [];
    var localData =
        await database.getCacheResponseById(AppConstants.shippingBranchesUri+countryOfOrigin);
    if (localData != null) {
      companyBranchesModel =
          CompanyBranchesModel.fromJson(jsonDecode(localData.response));
      companyBranchesModel?.companyBranches
          ?.forEach((branch) => _branches.add(branch));

      notifyListeners();
    }

    ApiResponseModel apiResponse =
        await kolitrendShippingServiceInterface.getBranches(countryOfOrigin);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _branches = [];
      print("List of Branches from API:");
      companyBranchesModel =
          CompanyBranchesModel.fromJson(apiResponse.response?.data);
      companyBranchesModel?.companyBranches
          ?.forEach((branch) => _branches.add(branch));
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future<void> onCountryChanged(
      String countryOfOrigin, String destinationCountry) async {
    await getShippingModes(countryOfOrigin, destinationCountry);
    notifyListeners();
  }

  Future<void> getShippingModes(
      String countryOfOrigin, String destinationCountry) async {
    var localData =
        await database.getCacheResponseById(AppConstants.shippingModes);
    // if (localData != null){
    //   shippingModesModel = ShippingModesModel.fromJson(jsonDecode(localData.response));
    //   shippingModesModel?.modes
    //       ?.forEach((mode) => _shippingModes.add(mode));
    // }

    ApiResponseModel apiResponse = await kolitrendShippingServiceInterface
        .getShippingModes(countryOfOrigin, destinationCountry);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _shippingModes = [];
      print("List of Shipping Modes from API:");
      shippingModesModel =
          ShippingModesModel.fromJson(apiResponse.response?.data);
      shippingModesModel?.modes?.forEach((mode) => _shippingModes.add(mode));

      // fetch companies instantly after fetching shipping modes
      if (shippingModesList.isNotEmpty) {
        selectedShippingMode = shippingModesList[0];
        await getShippingCompanies(
            countryOfOrigin, destinationCountry, selectedShippingMode!.id!);
      }

      if (localData != null) {
        await database.updateCacheResponse(
            AppConstants.shippingModes,
            CacheResponseCompanion(
              endPoint: const Value(AppConstants.shippingModes),
              header: Value(jsonEncode(apiResponse.response!.headers.map)),
              response: Value(jsonEncode(apiResponse.response!.data)),
            ));
      } else {
        await database.insertCacheResponse(
          CacheResponseCompanion(
            endPoint: const Value(AppConstants.shippingModes),
            header: Value(jsonEncode(apiResponse.response!.headers.map)),
            response: Value(jsonEncode(apiResponse.response!.data)),
          ),
        );
      }
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future<void> getShippingCompanies(String countryOfOrigin,
      String destinationCountry, int shippingModeId) async {
    ApiResponseModel apiResponse =
        await kolitrendShippingServiceInterface.getShippingCompanies(
            countryOfOrigin, destinationCountry, shippingModeId);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _shippingCompanies = [];
      print("List of Shipping companies from API:");
      shippingCompaniesModel =
          ShippingCompaniesModel.fromJson(apiResponse.response?.data);
      shippingCompaniesModel?.companies
          ?.forEach((company) => _shippingCompanies.add(company));

      // fetch packaging types instantly after fetching shipping companies
      if (shippingCompaniesList.isNotEmpty) {
        selectedShippingCompany = shippingCompaniesList[0];
        await getShippingPackageTypes(countryOfOrigin, destinationCountry,
            selectedShippingMode!.id!, selectedShippingCompany!.id!);
      }
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future<void> getShippingPackageTypes(
      String countryOfOrigin,
      String destinationCountry,
      int shippingModeId,
      int shippingCompanyId) async {
    if (countryOfOrigin == null) {
      showCustomSnackBar(
          getTranslated('Please select country of origin', Get.context!),
          Get.context!,
          isError: true);
      return;
    }

    if (destinationCountry == null) {
      showCustomSnackBar(
          getTranslated('Please select destination country', Get.context!),
          Get.context!,
          isError: true);
      return;
    }

    if (selectedShippingMode == null) {
      showCustomSnackBar(
          getTranslated('Please select shipping mode', Get.context!),
          Get.context!,
          isError: true);
      return;
    }

    if (selectedShippingCompany == null) {
      showCustomSnackBar(
          getTranslated('Please select shipping company', Get.context!),
          Get.context!,
          isError: true);
      return;
    }

    ApiResponseModel apiResponse =
        await kolitrendShippingServiceInterface.getShippingPackageTypes(
            countryOfOrigin!,
            destinationCountry!,
            selectedShippingMode!.id!,
            selectedShippingCompany!.id!);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _shippingPackageTypes = [];
      print("List of Shipping package types from API:");
      shippingPackageTypesModel =
          ShippingPackageTypesModel.fromJson(apiResponse.response?.data);
      shippingPackageTypesModel?.packageTypes
          ?.forEach((pkgType) => _shippingPackageTypes.add(pkgType));

      // fetch services instantly after fetching shipping companies
      if (shippingPackageTypesList.isNotEmpty) {
        selectedShippingPackageType = shippingPackageTypesList[0];
        await getShippingServices(
            countryOfOrigin,
            destinationCountry,
            selectedShippingMode!.id!,
            selectedShippingCompany!.id!,
            selectedShippingPackageType!.id!);
      }
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future<void> getShippingServices(
      String countryOfOrigin,
      String destinationCountry,
      int shippingModeId,
      int shippingCompanyId,
      int shippingPackageTypeId) async {
    if (selectedShippingMode == null) {
      showCustomSnackBar(
          getTranslated('Please select shipping mode', Get.context!),
          Get.context!,
          isError: true);
      return;
    }

    if (selectedShippingCompany == null) {
      showCustomSnackBar(
          getTranslated('Please select shipping company', Get.context!),
          Get.context!,
          isError: true);
      return;
    }

    if (selectedShippingPackageType == null) {
      showCustomSnackBar(
          getTranslated('Please select package type', Get.context!),
          Get.context!,
          isError: true);
      return;
    }

    ApiResponseModel apiResponse =
        await kolitrendShippingServiceInterface.getShippingServices(
            countryOfOrigin!,
            destinationCountry!,
            selectedShippingMode!.id!,
            selectedShippingCompany!.id!,
            selectedShippingPackageType!.id!);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _shippingServices = [];
      print("List of Shipping service types from API:");
      shippingServicesModel =
          ShippingServicesModel.fromJson(apiResponse.response?.data);
      shippingServicesModel?.shippingServices
          ?.forEach((service) => _shippingServices.add(service));

      // fetch packaging types instantly after fetching shipping companies
      if (shippingServicesList.isNotEmpty) {
        selectedShippingService = shippingServicesList[0];
        await getShippingDeliveryTimes(
            countryOfOrigin,
            destinationCountry,
            selectedShippingMode!.id!,
            selectedShippingCompany!.id!,
            selectedShippingPackageType!.id!);
      }
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future<void> getShippingDeliveryTimes(
      String countryOfOrigin,
      String destinationCountry,
      int shippingModeId,
      int shippingCompanyId,
      int shippingPackageTypeId) async {
    if (selectedShippingMode == null) {
      showCustomSnackBar(
          getTranslated('Please select shipping mode', Get.context!),
          Get.context!,
          isError: true);
      return;
    }

    if (selectedShippingCompany == null) {
      showCustomSnackBar(
          getTranslated('Please select shipping company', Get.context!),
          Get.context!,
          isError: true);
      return;
    }

    if (selectedShippingPackageType == null) {
      showCustomSnackBar(
          getTranslated('Please select package type', Get.context!),
          Get.context!,
          isError: true);
      return;
    }

    if (selectedShippingService == null) {
      showCustomSnackBar(
          getTranslated('Please select shipping service', Get.context!),
          Get.context!,
          isError: true);
      return;
    }

    ApiResponseModel apiResponse =
        await kolitrendShippingServiceInterface.getShippingDeliveryTimes(
            countryOfOrigin!,
            destinationCountry!,
            selectedShippingMode!.id!,
            selectedShippingCompany!.id!,
            selectedShippingPackageType!.id!,
            selectedShippingService!.id!);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _shippingDeliveryTimes = [];
      print("List of Shipping delivery times from API:");
      shippingDeliveryTimesModel =
          ShippingDeliveryTimesModel.fromJson(apiResponse.response?.data);
      shippingDeliveryTimesModel?.deliveryTimes
          ?.forEach((deliveryTime) => _shippingDeliveryTimes.add(deliveryTime));
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future<void> getShippingRate(
      String countryOfOrigin,
      String destinationCountry,
      double weight
      ) async {
    if (selectedShippingMode == null) {
      showCustomSnackBar(
          getTranslated('Please select shipping mode', Get.context!),
          Get.context!,
          isError: true);
      return;
    }

    if (selectedShippingCompany == null) {
      showCustomSnackBar(
          getTranslated('Please select shipping company', Get.context!),
          Get.context!,
          isError: true);
      return;
    }

    if (selectedShippingPackageType == null) {
      showCustomSnackBar(
          getTranslated('Please select package type', Get.context!),
          Get.context!,
          isError: true);
      return;
    }

    if (selectedShippingService == null) {
      showCustomSnackBar(
          getTranslated('Please select shipping service', Get.context!),
          Get.context!,
          isError: true);
      return;
    }

    if (selectedShippingDeliveryTime == null) {
      showCustomSnackBar(
          getTranslated('Please select delivery time', Get.context!),
          Get.context!,
          isError: true);
      return;
    }

    if (weight <= 0) {
      showCustomSnackBar(
          getTranslated('Please add packages, rate cannot be calculated for 0 weight', Get.context!),
          Get.context!,
          isError: true);
      return;
    }


    ApiResponseModel apiResponse =
    await kolitrendShippingServiceInterface.getClientShippingRate(
        countryOfOrigin!,
        destinationCountry!,
        selectedShippingMode!.id!,
        selectedShippingCompany!.id!,
        selectedShippingPackageType!.id!,
        selectedShippingService!.id!,
        selectedShippingDeliveryTime!.id!,
        weight
    );
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {

      print("List of Shipping rates from API:");

      clientShippingRateModel =
          ClientShippingRate.fromJson(apiResponse.response?.data);
      if (clientShippingRateModel?.rate != null){
        shippingOrderSummary?.subTotal = clientShippingRateModel!.rate;
        shippingOrderSummary?.total = clientShippingRateModel!.rate;
      }
      // if (clientShippingRateModel?.error != null){
      //   showCustomSnackBar(getTranslated(clientShippingRateModel!.error!, Get.context!), Get.context!);
      // }
      print("client shipping rates ${clientShippingRateModel.toString()}");
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future<void> getCombineShipRelatedOrders() async {
    ApiResponseModel apiResponse =
        await kolitrendShippingServiceInterface.getCombineShipRelatedOrders();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      print("List of Combine Ship Orders from API:");
      _combineShipRelatedOrders = [];
      combineShipRelatedOrdersModel =
          OrderModel.fromJson(apiResponse.response?.data);
      combineShipRelatedOrdersModel?.orders
          ?.forEach((order) => _combineShipRelatedOrders.add(order));
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

// Future<void> getRestrictedDeliveryZipList() async {
  //   ApiResponseModel apiResponse =
  //       await addressServiceInterface.getDeliveryRestrictedZipList();
  //   if (apiResponse.response != null &&
  //       apiResponse.response?.statusCode == 200) {
  //     _restrictedZipList = [];
  //     apiResponse.response!.data.forEach((address) =>
  //         _restrictedZipList.add(RestrictedZipModel.fromJson(address)));
  //   } else {
  //     ApiChecker.checkApi(apiResponse);
  //   }
  //   notifyListeners();
  // }
  //
  // Future<void> getDeliveryRestrictedZipBySearch(String searchName) async {
  //   _restrictedZipList = [];
  //   ApiResponseModel response = await addressServiceInterface
  //       .getDeliveryRestrictedZipBySearch(searchName);
  //   if (response.response!.statusCode == 200) {
  //     _restrictedZipList = [];
  //     response.response!.data.forEach((address) {
  //       _restrictedZipList.add(RestrictedZipModel.fromJson(address));
  //     });
  //   } else {
  //     ApiChecker.checkApi(response);
  //   }
  //   notifyListeners();
  // }
  //
  // Future<void> getDeliveryRestrictedCountryBySearch(String searchName) async {
  //   _restrictedCountryList = [];
  //   ApiResponseModel response = await addressServiceInterface
  //       .getDeliveryRestrictedCountryBySearch(searchName);
  //   if (response.response!.statusCode == 200) {
  //     _restrictedCountryList = [];
  //     response.response!.data
  //         .forEach((address) => _restrictedCountryList.add(address));
  //   } else {
  //     ApiChecker.checkApi(response);
  //   }
  //   notifyListeners();
  // }
  //
  // bool _isLoading = false;
  // bool get isLoading => _isLoading;
  //
  // Future<List<AddressModel>?> getAddressList(
  //     {bool fromRemove = false,
  //     bool isShipping = false,
  //     bool isBilling = false,
  //     bool all = false}) async {
  //   _addressList = await addressServiceInterface.getList(
  //       isShipping: isShipping,
  //       isBilling: isBilling,
  //       fromRemove: fromRemove,
  //       all: all);
  //   notifyListeners();
  //   return _addressList;
  // }
  //
  // Future<void> deleteAddress(int id) async {
  //   ApiResponseModel apiResponse = await addressServiceInterface.delete(id);
  //   if (apiResponse.response != null &&
  //       apiResponse.response!.statusCode == 200) {
  //     showCustomSnackBar(apiResponse.response!.data['message'], Get.context!,
  //         isError: false);
  //     getAddressList(fromRemove: true);
  //   } else {
  //     ApiChecker.checkApi(apiResponse);
  //   }
  //   notifyListeners();
  // }
  //
  // Future<ApiResponseModel> addAddress(AddressModel addressModel) async {
  //   _isLoading = true;
  //   notifyListeners();
  //   ApiResponseModel apiResponse =
  //       await addressServiceInterface.add(addressModel);
  //   _isLoading = false;
  //   if (apiResponse.response != null &&
  //       apiResponse.response!.statusCode == 200) {
  //     showCustomSnackBar(apiResponse.response!.data["message"], Get.context!,
  //         isError: false);
  //     getAddressList();
  //   } else {
  //     ApiChecker.checkApi(apiResponse);
  //   }
  //   notifyListeners();
  //   return apiResponse;
  // }
  //
  // Future<void> updateAddress(BuildContext context,
  //     {required AddressModel addressModel, int? addressId}) async {
  //   _isLoading = true;
  //   notifyListeners();
  //   ApiResponseModel apiResponse =
  //       await addressServiceInterface.update(addressModel.toJson(), addressId!);
  //   _isLoading = false;
  //   if (apiResponse.response != null &&
  //       apiResponse.response!.statusCode == 200) {
  //     Navigator.pop(Get.context!);
  //     getAddressList();
  //     showCustomSnackBar(apiResponse.response!.data['message'], Get.context!,
  //         isError: false);
  //   } else {
  //     ApiChecker.checkApi(apiResponse);
  //   }
  //
  //   notifyListeners();
  // }
  //
  // void setZip(String zip) {
  //   _searchZipController.text = zip;
  //   notifyListeners();
  // }
  //
  // void setCountry(String country) {
  //   _searchCountryController.text = country;
  //   notifyListeners();
  // }
  //
  // List<LabelAsModel> addressTypeList = [];
  // int _selectAddressIndex = 0;
  //
  // int get selectAddressIndex => _selectAddressIndex;
  //
  // updateAddressIndex(int index, bool notify) {
  //   _selectAddressIndex = index;
  //   if (notify) {
  //     notifyListeners();
  //   }
  // }
  //
  // Future<List<LabelAsModel>> getAddressType() async {
  //   if (addressTypeList.isEmpty) {
  //     addressTypeList = [];
  //     addressTypeList = addressServiceInterface.getAddressType();
  //   }
  //   return addressTypeList;
  // }
}
