import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_country_textfield_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/kolitrend_shipping/controllers/shipping_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/kolitrend_shipping/domain/models/shipping_company_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/kolitrend_shipping/domain/models/shipping_deli_time_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/kolitrend_shipping/domain/models/shipping_mode_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/kolitrend_shipping/domain/models/shipping_package.dart';
import 'package:flutter_sixvalley_ecommerce/features/kolitrend_shipping/domain/models/shipping_pkg_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/kolitrend_shipping/domain/models/shipping_service_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/kolitrend_shipping/widgets/select_branch_bottom_sheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/kolitrend_shipping/widgets/select_shipping_delivery_times_bottom_sheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/kolitrend_shipping/widgets/select_shipping_mode_bottom_sheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/kolitrend_shipping/widgets/select_shipping_package_type_bottom_sheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/kolitrend_shipping/widgets/select_shipping_service_type_bottom_sheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/kolitrend_shipping/widgets/select_shipping_company_bottom_sheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/profile/screens/profile_screen1.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/domain/models/config_model.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_textfield_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../common/basewidget/amount_widget.dart';
import '../../../common/basewidget/show_custom_snakbar_widget.dart';
import '../../../helper/debounce_helper.dart';
import '../../../helper/price_converter.dart';
import '../../../main.dart';
import '../../address/controllers/address_controller.dart';
import '../../auth/widgets/code_picker_widget.dart';
import '../../buy_for_me/widgets/select_buy_for_me_currency_bottom_sheet_widget.dart';
import '../../splash/controllers/splash_controller.dart';

class KolitrendShippingFormScreen extends StatefulWidget {
  const KolitrendShippingFormScreen({super.key});
  @override
  KolitrendShippingFormScreenState createState() =>
      KolitrendShippingFormScreenState();
}

class KolitrendShippingFormScreenState
    extends State<KolitrendShippingFormScreen> {
  String? countryOfOriginCode;
  String? senderCountryCode;
  String? destinationCountryCode;
  String? receipentCountryCode;

  final FocusNode _linkFocus = FocusNode();
  final FocusNode _senderBranchFocus = FocusNode();
  final FocusNode _senderFirstNameFocus = FocusNode();
  final FocusNode _senderLastNameFocus = FocusNode();
  final FocusNode _senderCompanyFocus = FocusNode();
  final FocusNode _senderAddressFocus = FocusNode();
  final FocusNode _senderZipFocus = FocusNode();
  final FocusNode _senderCityFocus = FocusNode();
  final FocusNode _senderCountryFocus = FocusNode();
  final FocusNode _senderPhoneFocus = FocusNode();
  final FocusNode _senderEmailFocus = FocusNode();

  final FocusNode _destinationCountryFocus = FocusNode();
  final FocusNode _recipientFirstNameFocus = FocusNode();
  final FocusNode _recipientLastNameFocus = FocusNode();
  final FocusNode _recipientCompanyFocus = FocusNode();
  final FocusNode _recipientAddressFocus = FocusNode();
  final FocusNode _recipientZipFocus = FocusNode();
  final FocusNode _recipientCityFocus = FocusNode();
  final FocusNode _recipientCountryFocus = FocusNode();

  final FocusNode _recipientPhoneFocus = FocusNode();
  final FocusNode _recipientEmailFocus = FocusNode();

  final FocusNode _shippingModeFocus = FocusNode();
  final FocusNode _shippingCompanyFocus = FocusNode();
  final FocusNode _shippingPackageTypeFocus = FocusNode();
  final FocusNode _shippingServiceFocus = FocusNode();
  final FocusNode _shippingDeliveryTimeFocus = FocusNode();

  final FocusNode _packageQuantityFocus = FocusNode();
  final FocusNode _packageDescFocus = FocusNode();
  final FocusNode _packageWeightFocus = FocusNode();
  final FocusNode _packageLengthFocus = FocusNode();
  final FocusNode _packageWidthFocus = FocusNode();
  final FocusNode _packageHeightFocus = FocusNode();
  final FocusNode _packageWeightVolFocus = FocusNode();
  final FocusNode _packageShipmentInvoiceAmountFocus = FocusNode();
  final FocusNode _packageCurrencyFocus = FocusNode();

  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _senderBranchController = TextEditingController();
  TextEditingController _senderFirstNameController = TextEditingController();

  final TextEditingController _senderLastNameController =
      TextEditingController();
  final TextEditingController _senderCompanyController =
      TextEditingController();
  final TextEditingController _senderAddressController =
      TextEditingController();
  final TextEditingController _senderZipController = TextEditingController();
  final TextEditingController _senderCityController = TextEditingController();
  final TextEditingController _senderPhoneController = TextEditingController();
  final TextEditingController _senderEmailController = TextEditingController();

  final TextEditingController _recipientFirstNameController =
      TextEditingController();
  final TextEditingController _recipientLastNameController =
      TextEditingController();
  final TextEditingController _recipientCompanyController =
      TextEditingController();
  final TextEditingController _recipientAddressController =
      TextEditingController();
  final TextEditingController _recipientZipController = TextEditingController();
  final TextEditingController _recipientCityController =
      TextEditingController();
  final TextEditingController _recipientPhoneController =
      TextEditingController();
  final TextEditingController _recipientEmailController =
      TextEditingController();

  final TextEditingController _shippingModeController = TextEditingController();
  final TextEditingController _shippingCompanyController =
      TextEditingController();
  final TextEditingController _shippingPackageTypeController =
      TextEditingController();
  final TextEditingController _shippingServiceController =
      TextEditingController();
  final TextEditingController _shippingDeliveryTimeController =
      TextEditingController();

  final TextEditingController _packageQuantityController =
      TextEditingController();
  final TextEditingController _packageDescController = TextEditingController();
  final TextEditingController _packageWeightController =
      TextEditingController();
  final TextEditingController _packageLengthController =
      TextEditingController();
  final TextEditingController _packageWidthController = TextEditingController();
  final TextEditingController _packageHeightController =
      TextEditingController();
  final TextEditingController _packageWeightVolController =
      TextEditingController();
  final TextEditingController _packageShipmentInvoiceAmountController =
      TextEditingController();
  final TextEditingController _packageCurrencyController =
      TextEditingController();

  final TextEditingController _countryOfOriginCodeController =
      TextEditingController();
  final TextEditingController _senderCountryCodeController =
      TextEditingController();
  final TextEditingController _destinationCountryCodeController =
      TextEditingController();
  final TextEditingController _recipientCodeController =
      TextEditingController();

  String _senderFirstName = '';

  bool showForm = true;
  bool showPackages = false;
  bool showAddPackageForm = false;
  String currentStep = "sender_info";

  final _debouncer = DebounceHelper(milliseconds: 2000); // 2s delay


  File? file;
  final picker = ImagePicker();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  final ImagePicker _picker = ImagePicker();
  List<XFile> _images = [];
  List<ShippingPackageModel> packages = [];

  void nextStep() {
    if (currentStep == "sender_info") {
      setState(() {
        currentStep = "recipient_info";
      });
    } else if (currentStep == "recipient_info") {
      setState(() {
        currentStep = "shipping_info";
      });
    } else if (currentStep == "shipping_info") {
      setState(() {
        currentStep = "gallery";
      });
    } else if (currentStep == "gallery") {
      setState(() {
        currentStep = "add_package";
      });
    }
    else if (currentStep == "add_package") {
      setState(() {
        currentStep = "packages";
      });
    }
    else if (currentStep == "packages") {
      setState(() {
        currentStep = "overview";
      });
    }
  }

  void previousStep() {

    if (currentStep == "overview") {
      setState(() {
        currentStep = "packages";
      });
    } else if (currentStep == "packages") {
      setState(() {
        currentStep = "add_package";
      });
    }
    else if (currentStep == "add_package") {
      setState(() {
        currentStep = "gallery";
      });
    }
    else if (currentStep == "gallery") {
      setState(() {
        currentStep = "shipping_info";
      });
    } else if (currentStep == "shipping_info") {
      setState(() {
        currentStep = "recipient_info";
      });
    }  else if (currentStep == "recipient_info") {
      setState(() {
        currentStep = "sender_info";
      });
    }

  }


  Future<void> _pickImages() async {
    final selected = await _picker.pickMultiImage();
    if (selected != null) {
      setState(() {
        _images.addAll(selected);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  void _choose() async {
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 500,
        maxWidth: 500);
    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
      }
    });
  }

  void _openPackageCurrencyBottomSheet() async {
    final value = await showModalBottomSheet<CurrencyList?>(
        context: Get.context!,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (_) => SelectBuyForMeCurrencyBottomSheetWidget(
            selectedCurrencyCode: _packageCurrencyController.text));
    if (value != null) {
      print("Result from Dialog");
      setState(() {
        _packageCurrencyController.text = value!.code!;
      });
    }
  }

  _onCountryOfOriginCodeChanged(String? countryCode) {
    countryOfOriginCode = countryCode;
    Provider.of<KolitrendShippingController>(context, listen: false)
        .getBranches(countryOfOriginCode!);
    Provider.of<KolitrendShippingController>(context, listen: false)
        .onCountryChanged(countryOfOriginCode!, destinationCountryCode!);
  }

  _onDestinationCountryCodeChanged(String? countryCode) {
    destinationCountryCode = countryCode;
    Provider.of<KolitrendShippingController>(context, listen: false)
        .onCountryChanged(countryOfOriginCode!, destinationCountryCode!);
  }

  _onSenderCountryCodeChanged(String? countryCode) {
    senderCountryCode = countryCode;
  }

  _onReceipentCodeChanged(String? countryCode) {
    receipentCountryCode = countryCode;
  }

  @override
  void initState() {
    countryOfOriginCode ??= 'tr';
    destinationCountryCode ??= 'fr';

    _onCountryOfOriginCodeChanged(countryOfOriginCode);
  }

  void _openShippingModesBottomSheet() async {
    final value = await showModalBottomSheet<ShippingMode>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => SelectShippingModeBottomSheetWidget(
        selectedShippingMode:
            Provider.of<KolitrendShippingController>(context, listen: false)
                .selectedShippingMode,
        countryOfOrigin: _countryOfOriginCodeController.text,
        destinationCountry: _destinationCountryCodeController.text,
      ),
    );
    if (value != null) {
      setState(() {
        Provider.of<KolitrendShippingController>(context, listen: false)
            .selectedShippingMode = value as ShippingMode?;
        _shippingModeController.text = value!.shippingMode!;
      });
    }
  }

  void _openShippingCompaniesBottomSheet() async {
    final value = await showModalBottomSheet<ShippingCompany>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => SelectShippingCompanyBottomSheetWidget(
        selectedShippingCompany:
            Provider.of<KolitrendShippingController>(context, listen: false)
                .selectedShippingCompany,
        countryOfOrigin: _countryOfOriginCodeController.text,
        destinationCountry: _destinationCountryCodeController.text,
        shippingModeId:
            Provider.of<KolitrendShippingController>(context, listen: false)
                .selectedShippingMode
                ?.id,
      ),
    );

    if (value != null) {
      setState(() {
        Provider.of<KolitrendShippingController>(context, listen: false)
            .selectedShippingCompany = value;
        _shippingCompanyController.text = value!.company!;
      });
    }
  }

  void _openShippingPackageTypesBottomSheet() async {
    final value = await showModalBottomSheet<ShippingPackageType>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => SelectShippingPackageTypeBottomSheetWidget(
        selectedShippingPackageType:
            Provider.of<KolitrendShippingController>(context, listen: false)
                .selectedShippingPackageType,
        countryOfOrigin: _countryOfOriginCodeController.text,
        destinationCountry: _destinationCountryCodeController.text,
        shippingModeId:
            Provider.of<KolitrendShippingController>(context, listen: false)
                .selectedShippingMode
                ?.id,
        shippingCompanyId:
            Provider.of<KolitrendShippingController>(context, listen: false)
                .selectedShippingCompany
                ?.id,
      ),
    );

    if (value != null) {
      setState(() {
        Provider.of<KolitrendShippingController>(context, listen: false)
            .selectedShippingPackageType = value;
        _shippingPackageTypeController.text = value!.packagingTypeName!;
      });
    }
  }

  void _openShippingServicesBottomSheet() async {
    final value = await showModalBottomSheet<ShippingService>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => SelectShippingServiceBottomSheetWidget(
        selectedShippingService:
            Provider.of<KolitrendShippingController>(context, listen: false)
                .selectedShippingService,
        countryOfOrigin: _countryOfOriginCodeController.text,
        destinationCountry: _destinationCountryCodeController.text,
        shippingModeId:
            Provider.of<KolitrendShippingController>(context, listen: false)
                .selectedShippingMode
                ?.id,
        shippingCompanyId:
            Provider.of<KolitrendShippingController>(context, listen: false)
                .selectedShippingCompany
                ?.id,
        shippingPackageTypeId:
            Provider.of<KolitrendShippingController>(context, listen: false)
                .selectedShippingPackageType
                ?.id,
      ),
    );
    if (value != null) {
      setState(() {
        Provider.of<KolitrendShippingController>(context, listen: false)
            .selectedShippingService = value as ShippingService?;
        _shippingServiceController.text = value!.shippingService!;
      });
    }
  }

  void _openShippingDeliveryTimesBottomSheet() async {
    final value = await showModalBottomSheet<ShippingDeliveryTime>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => SelectShippingDeliveryTimeBottomSheetWidget(
        selectedShippingDeliveryTime:
            Provider.of<KolitrendShippingController>(context, listen: false)
                .selectedShippingDeliveryTime,
        countryOfOrigin: _countryOfOriginCodeController.text,
        destinationCountry: _destinationCountryCodeController.text,
        shippingModeId:
            Provider.of<KolitrendShippingController>(context, listen: false)
                .selectedShippingMode
                ?.id,
        shippingCompanyId:
            Provider.of<KolitrendShippingController>(context, listen: false)
                .selectedShippingCompany
                ?.id,
        shippingPackageTypeId:
            Provider.of<KolitrendShippingController>(context, listen: false)
                .selectedShippingPackageType
                ?.id,
        shippingServiceId:
            Provider.of<KolitrendShippingController>(context, listen: false)
                .selectedShippingService
                ?.id,
      ),
    );
    if (value != null) {
      setState(() {
        Provider.of<KolitrendShippingController>(context, listen: false)
            .selectedShippingDeliveryTime = value as ShippingDeliveryTime?;
        _shippingDeliveryTimeController.text = value!.deliveryTime!;
      });
    }
  }

  void _deleteItem(String id) {
    setState(() {
      packages.removeWhere((item) => item.id == id);
    });
    // Optional: Show a snackbar or confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Item deleted'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  _onPackageWidthChange(String value) {
    _debouncer.run(() {
      if (value.isNotEmpty) {
        _packageWidthController.text =
            double.tryParse(value)?.toStringAsFixed(2) ?? value;
        _calculateVolWeight();
      }
    });

  }

  _onPackageHeightChange(String value) {
    _debouncer.run((){
      if (value.isNotEmpty) {
        _packageHeightController.text =
            double.tryParse(value)?.toStringAsFixed(2) ?? value;
        _calculateVolWeight();
      }
    });

  }

  _onPackageLengthChange(String value) {
    _debouncer.run(() {
      if (value.isNotEmpty) {
        _packageLengthController.text =
            double.tryParse(value)?.toStringAsFixed(2) ?? value;
        _calculateVolWeight();
      }
    });

  }

  _calculateVolWeight() {
    if (_packageWidthController.text.isNotEmpty &&
        _packageLengthController.text.isNotEmpty &&
        _packageHeightController.text.isNotEmpty) {
      double? _pkgWidth = double.tryParse(_packageWidthController.text);
      double? _pkgHeight = double.tryParse(_packageHeightController.text);
      double? _pkgLength = double.tryParse(_packageLengthController.text);

      if (_pkgWidth != null && _pkgHeight != null && _pkgLength != null) {
        double dividableValueBasedOnMode = 0;
        if (_shippingModeController.text.isNotEmpty &&
            _shippingModeController.text.toLowerCase().contains('road')) {
          dividableValueBasedOnMode = 3000;
        } else if (_shippingModeController.text.isNotEmpty &&
            _shippingModeController.text.toLowerCase().contains('air')) {
          dividableValueBasedOnMode = 5000;
        }

        _packageWeightVolController.text =
            ((_pkgWidth * _pkgHeight * _pkgLength) / dividableValueBasedOnMode)
                .toStringAsFixed(2);
      }
    }
  }

  _addPackage() {
    if (_packageQuantityController.text.isEmpty) {
      showCustomSnackBar(
          getTranslated('Please enter package quantity', context), context);
      return;
    }

    if (_packageDescController.text.isEmpty) {
      showCustomSnackBar(
          getTranslated('Please enter package description', context), context);
      return;
    }

    if (_packageWeightController.text.isEmpty) {
      showCustomSnackBar(
          getTranslated('Please enter package weight', context), context);
      return;
    }

    if (_packageLengthController.text.isEmpty) {
      showCustomSnackBar(
          getTranslated('Please enter package length', context), context);
      return;
    }

    if (_packageWidthController.text.isEmpty){
      showCustomSnackBar( getTranslated('Please enter package width', context), context);
      return;
    }

    if (_packageHeightController.text.isEmpty){
      showCustomSnackBar( getTranslated('Please enter package height', context), context);
      return;
    }

    if (_packageWeightVolController.text.isEmpty){
      showCustomSnackBar( getTranslated('Please fill the fields so that package volumetric weight can be calculated',
          context), context);
      return;
    }

    setState(() {
      packages.add(ShippingPackageModel(
        id: Uuid().v1() ,
        quantity: int.tryParse(_packageQuantityController.text),
        description: _packageDescController.text,
        weight: double.tryParse(_packageWeightController.text),
        length: double.tryParse(_packageLengthController.text),
        width: double.tryParse(_packageWidthController.text),
        height: double.tryParse(_packageHeightController.text),
        vol_weight: double.tryParse(_packageWeightVolController.text),
        shipment_invoice_amount: double.tryParse(_packageShipmentInvoiceAmountController.text),
        currency: _packageCurrencyController.text ,
        price: 0.00
      )
      );
    });

    showCustomSnackBar(getTranslated("Package Added Successfully", context), context, isError: false, isToaster: false);
    return;

  }

  _updateUserAccount() async {
    showCustomSnackBar(
        getTranslated('Something went wrong in API response!', Get.context!),
        Get.context!,
        isError: true);
    // String firstName = _firstNameController.text.trim();
    // String lastName = _lastNameController.text.trim();
    // String email = _emailController.text.trim();
    // String phoneNumber = _phoneController.text.trim();
    // String password = _passwordController.text.trim();
    // String confirmPassword = _confirmPasswordController.text.trim();
    //
    // if(Provider.of<ProfileController>(context, listen: false).userInfoModel!.fName == _firstNameController.text
    //     && Provider.of<ProfileController>(context, listen: false).userInfoModel!.lName == _lastNameController.text
    //     && Provider.of<ProfileController>(context, listen: false).userInfoModel!.phone == _phoneController.text && file == null
    //     && _passwordController.text.isEmpty && _confirmPasswordController.text.isEmpty) {
    //
    // showCustomSnackBar(getTranslated('change_something_to_update', context), context);
    //
    // }
    //
    // else if (firstName.isEmpty) {
    //   showCustomSnackBar(getTranslated('first_name_is_required', context), context);
    // }
    //
    // else if(lastName.isEmpty) {
    //   showCustomSnackBar(getTranslated('last_name_is_required', context), context);
    // }

    // else if (email.isEmpty) {
    //   showCustomSnackBar(getTranslated('email_is_required', context), context);
    //
    // }
    //
    // else if (phoneNumber.isEmpty) {
    //   showCustomSnackBar(getTranslated('phone_must_be_required', context), context);
    // }
    //
    // else if((password.isNotEmpty && password.length < 8) || (confirmPassword.isNotEmpty && confirmPassword.length < 8)) {
    //   showCustomSnackBar(getTranslated('minimum_password_is_8_character', context), context);
    // }
    //
    // else if(password != confirmPassword) {
    //   showCustomSnackBar(getTranslated('confirm_password_not_matched', context), context);
    // }

    // else {
    //   ProfileModel updateUserInfoModel = Provider.of<ProfileController>(context, listen: false).userInfoModel!;
    //   updateUserInfoModel.method = 'put';
    //   updateUserInfoModel.fName = _firstNameController.text;
    //   updateUserInfoModel.lName = _lastNameController.text;
    //   updateUserInfoModel.phone = _phoneController.text;
    //   String pass = _passwordController.text;
    //
    //   await Provider.of<ProfileController>(context, listen: false).updateUserInfo(
    //     updateUserInfoModel, pass, file, Provider.of<AuthController>(context, listen: false).getUserToken(),
    //   ).then((response) {
    //     if(response.isSuccess) {
    //       if(context.mounted) {
    //         Provider.of<ProfileController>(Get.context!, listen: false).getUserInfo(Get.context!);
    //         showCustomSnackBar(getTranslated('profile_info_updated_successfully', Get.context!), Get.context!, isError: false);
    //       }
    //
    //       _passwordController.clear();
    //       _confirmPasswordController.clear();
    //       setState(() {});
    //     }else {
    //       showCustomSnackBar(response.message??'', Get.context!, isError: true);
    //     }
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Consumer<KolitrendShippingController>(
        builder: (context, kolitrendShippingController, child) {
          // _firstNameController.text = profile.userInfoModel!.fName??'';
          // _lastNameController.text = profile.userInfoModel!.lName??'';
          // _emailController.text = profile.userInfoModel!.email??'';
          // _phoneController.text = profile.userInfoModel!.phone??'';

          if (kolitrendShippingController.branchesList.isNotEmpty) {
            _senderBranchController.text =
                kolitrendShippingController.branchesList[0].branchName ?? "";
            _senderFirstNameController.text =
                kolitrendShippingController.branchesList[0].firstName ?? "";
            _senderLastNameController.text =
                kolitrendShippingController.branchesList[0].lastName ?? "";
            _senderEmailController.text =
                kolitrendShippingController.branchesList[0].email ?? "";
            _senderCompanyController.text =
                kolitrendShippingController.branchesList[0].companyName ?? "";
            _senderAddressController.text =
                kolitrendShippingController.branchesList[0].address ?? "";
            _senderCityController.text =
                kolitrendShippingController.branchesList[0].city ?? "";
            _senderZipController.text =
                kolitrendShippingController.branchesList[0].zip ?? "";
            _senderPhoneController.text =
                kolitrendShippingController.branchesList[0].phone ?? "";
            _senderCountryCodeController.text =
                kolitrendShippingController.branchesList[0].countryCode ??
                    _countryOfOriginCodeController.text;
          }

          if (_recipientCodeController.text.isEmpty) {
            _recipientCodeController.text = 'fr';
          }

          if (kolitrendShippingController.shippingModesList.isNotEmpty) {
            _shippingModeController.text =
                kolitrendShippingController.shippingModesList[0]!.shippingMode!;
          }

          if (kolitrendShippingController.shippingCompaniesList.isNotEmpty) {
            _shippingCompanyController.text =
                kolitrendShippingController.shippingCompaniesList[0]!.company!;
          }

          if (kolitrendShippingController.shippingPackageTypesList.isNotEmpty) {
            _shippingPackageTypeController.text = kolitrendShippingController
                .shippingPackageTypesList[0]!.packagingTypeName!;
          }

          if (kolitrendShippingController.shippingServicesList.isNotEmpty) {
            _shippingServiceController.text = kolitrendShippingController
                .shippingServicesList[0]!.shippingService!;
          }

          if (kolitrendShippingController
              .shippingDeliveryTimesList.isNotEmpty) {
            _shippingDeliveryTimeController.text = kolitrendShippingController
                .shippingDeliveryTimesList[0]!.deliveryTime!;
          }

          if (Provider.of<SplashController>(context).myCurrency != null) {
            if (_packageCurrencyController.text.isEmpty) {
              _packageCurrencyController.text =
                  Provider.of<SplashController>(context).myCurrency!.code!;
            }
          }

          return Stack(clipBehavior: Clip.none, children: [
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                color: Provider.of<ThemeController>(context, listen: false)
                        .darkTheme
                    ? Theme.of(context).cardColor
                    : Theme.of(context).primaryColor),
            Container(
                transform: Matrix4.translationValues(-10, 0, 0),
                child: Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: SizedBox(
                        width: 110,
                        child: Image.asset(Images.shadow,
                            opacity: const AlwaysStoppedAnimation(0.75))))),
            Positioned(
                right: -70,
                top: 150,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                          color: Theme.of(context)
                              .cardColor
                              .withValues(alpha: .05),
                          width: 25)),
                )),
            Container(
                padding: const EdgeInsets.only(top: 35, left: 15),
                child: Row(children: [
                  CupertinoNavigationBarBackButton(
                    onPressed: () => Navigator.of(context).pop(),
                    color: Colors.white,
                  ),
                  const SizedBox(width: 10),
                  Text(getTranslated('Kolitrend Shipping', context) ?? "",
                      style: textRegular.copyWith(
                          fontSize: 20, color: Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),

                ])),
            Container(
              padding: const EdgeInsets.only(top: 75),
              child: Column(children: [
                // Column(children: [
                //
                //   Container(margin: const EdgeInsets.only(top: Dimensions.marginSizeExtraLarge),
                //     alignment: Alignment.center,
                //     decoration: BoxDecoration(
                //       color: Theme.of(context).cardColor,
                //       border: Border.all(color: Colors.white, width: 3),
                //       shape: BoxShape.circle,),
                //     child: Stack(clipBehavior: Clip.none, children: [
                //
                //       ClipRRect(borderRadius: BorderRadius.circular(50),
                //         child: file == null ?
                //         CustomImageWidget(image: "${profile.userInfoModel!.imageFullUrl?.path}",
                //           height: Dimensions.profileImageSize, fit: BoxFit.cover,width: Dimensions.profileImageSize,) :
                //         Image.file(file!, width: Dimensions.profileImageSize,
                //             height: Dimensions.profileImageSize, fit: BoxFit.fill),
                //       ),
                //
                //       Positioned(bottom: 0, right: -10,
                //           child: CircleAvatar(backgroundColor: Theme.of(context).primaryColor,
                //               radius: 14,
                //               child: IconButton(
                //                 onPressed: _choose,
                //                 padding: const EdgeInsets.all(0),
                //                 icon: Icon(Icons.camera_alt_sharp, color:  Theme.of(context).colorScheme.secondaryContainer, size: 18),
                //               ),
                //           ),
                //       )
                //     ]),
                //   ),
                //
                //   Text(
                //     '${profile.userInfoModel!.fName} ${profile.userInfoModel!.lName ?? ''}',
                //     style: textBold.copyWith(color:  Theme.of(context).colorScheme.secondaryContainer, fontSize: Dimensions.fontSizeLarge),
                //   ),
                // ]),

                const SizedBox(height: Dimensions.paddingSizeLarge),

                // if (currentStep == "sender_info") ... [
                //
                //   Expanded(
                //     child: Container(
                //       padding: const EdgeInsets.symmetric(
                //           horizontal: Dimensions.paddingSizeDefault),
                //       decoration: BoxDecoration(
                //         color: Theme.of(context).highlightColor,
                //         borderRadius: const BorderRadius.only(
                //           topLeft: Radius.circular(Dimensions.marginSizeDefault),
                //           topRight: Radius.circular(Dimensions.marginSizeDefault),
                //         ),
                //       ),
                //       child: ListView(
                //         physics: const BouncingScrollPhysics(),
                //         children: [
                //           InkWell(
                //             child: const Text('Sender Information'),
                //             onTap: () {
                //               Navigator.of(context).push(MaterialPageRoute(
                //                   builder: (context) => const ProfileScreen1()));
                //             },
                //           ),
                //
                //           const SizedBox(height: Dimensions.paddingSizeSmall),
                //
                //           // SizedBox(
                //           //   height: 60,
                //           //   child: Consumer<AddressController>(
                //           //      builder: (context, addressController, _) {
                //           //        return Column(
                //           //          crossAxisAlignment: CrossAxisAlignment.start,
                //           //          children: [
                //           //            Container(
                //           //              width: MediaQuery.of(context).size.width,
                //           //              decoration: BoxDecoration(
                //           //                color: Theme.of(context).cardColor,
                //           //                borderRadius: BorderRadius.circular(5),
                //           //                border: Border.all(
                //           //                  width: .1,
                //           //                  color: Theme.of(context).hintColor.withValues(alpha: 0.01)
                //           //                )
                //           //              ),
                //           //              child: DropdownButtonFormField2<String>(
                //           //                isExpanded: true,
                //           //                isDense: true,
                //           //
                //           //                decoration: InputDecoration(
                //           //                  contentPadding:
                //           //                    const EdgeInsets.symmetric(vertical: 0),
                //           //                  border: OutlineInputBorder(
                //           //                    borderRadius: BorderRadius.circular(5)
                //           //                  )
                //           //                ),
                //           //                hint: Row(
                //           //                 children: [
                //           //                   Image.asset(Images.country),
                //           //                   const SizedBox(width: Dimensions.paddingSizeSmall) ,
                //           //                   Text(_countryOfOriginCodeController.text, style: textRegular.copyWith(
                //           //                     fontSize: Dimensions.fontSizeDefault ,
                //           //                     color: Theme.of(context).textTheme.bodyLarge!.color
                //           //                   )
                //           //                   )
                //           //                 ]
                //           //                ),
                //           //                items: addressController.countryList
                //           //                .map((item) => DropdownMenuItem<String>(
                //           //                  value: item.code,
                //           //                  child: Text(item.name!, style: textRegular.copyWith(
                //           //                    fontSize: Dimensions.fontSizeDefault,
                //           //                    color: Theme.of(context)
                //           //                      .textTheme.bodyLarge!.color
                //           //                  )),
                //           //                )).toList(),
                //           //
                //           //                buttonStyleData: const ButtonStyleData(
                //           //                  padding: EdgeInsets.only(right: 8)
                //           //                ),
                //           //                dropdownStyleData: DropdownStyleData(
                //           //                  decoration: BoxDecoration(
                //           //                    borderRadius: BorderRadius.circular(5)
                //           //                  )
                //           //                ),
                //           //                menuItemStyleData: const MenuItemStyleData(
                //           //                  padding: EdgeInsets.symmetric(horizontal: 16)
                //           //                ),
                //           //              ),
                //           //            )
                //           //          ],
                //           //        );
                //           //      }
                //           //   ),
                //           //
                //           // ),
                //
                //           CustomCountryFieldWidget(
                //               label: getTranslated('Country of Origin', context),
                //               selectedCountryCode: countryOfOriginCode,
                //               onCountryChanged: _onCountryOfOriginCodeChanged),
                //
                //           SizedBox(height: Dimensions.paddingSizeLarge),
                //
                //           // Text('${kolitrendShippingController.branchesList[0].branchName}'),
                //           CustomTextFieldWidget(
                //             labelText: getTranslated('Select Branch', context),
                //             // labelText: "Your First Name",
                //             // hintText: kolitrendShippingController.branchesList[0]?.branchName,
                //             inputType: TextInputType.name,
                //             focusNode: _senderBranchFocus,
                //             nextFocus: _senderFirstNameFocus,
                //             required: true,
                //             readOnly: true,
                //             controller: _senderBranchController,
                //             // onTap: () => showModalBottomSheet(
                //             //   backgroundColor: Colors.transparent,
                //             //   isScrollControlled: true,
                //             //   context: context,
                //             //   builder: (_) =>
                //             //       const SelectBranchBottomSheetWidget(),
                //             // ),
                //           ),
                //           const SizedBox(height: Dimensions.paddingSizeLarge),
                //
                //           CustomTextFieldWidget(
                //             labelText: getTranslated('First Name', context),
                //             // labelText: "Your First Name",
                //             inputType: TextInputType.name,
                //             focusNode: _senderFirstNameFocus,
                //             nextFocus: _senderLastNameFocus,
                //             required: true,
                //             readOnly: true,
                //             hintText: 'John',
                //             controller: _senderFirstNameController,
                //             onChanged: (text) {
                //               setState(() {
                //                 // Update whatever state is driven by this text
                //                 _senderFirstName = text;
                //               });
                //             },
                //           ),
                //           const SizedBox(height: Dimensions.paddingSizeLarge),
                //
                //           CustomTextFieldWidget(
                //             labelText: getTranslated('Last Name', context),
                //             // labelText: "Your First Name",
                //             inputType: TextInputType.name,
                //             focusNode: _senderLastNameFocus,
                //             nextFocus: _senderCompanyFocus,
                //             required: true,
                //             readOnly: true,
                //             hintText: 'Doe',
                //             controller: _senderLastNameController,
                //           ),
                //           const SizedBox(height: Dimensions.paddingSizeLarge),
                //
                //           CustomTextFieldWidget(
                //             labelText: getTranslated('Company', context),
                //             // labelText: "Your First Name",
                //             inputType: TextInputType.name,
                //             focusNode: _senderCompanyFocus,
                //             nextFocus: _senderAddressFocus,
                //             required: true,
                //             readOnly: true,
                //             hintText: 'ABC LLC',
                //             controller: _senderCompanyController,
                //           ),
                //           const SizedBox(height: Dimensions.paddingSizeLarge),
                //
                //           CustomTextFieldWidget(
                //             labelText: getTranslated('Address', context),
                //             // labelText: "Your First Name",
                //             inputType: TextInputType.name,
                //             focusNode: _senderAddressFocus,
                //             nextFocus: _senderZipFocus,
                //             required: true,
                //             readOnly: true,
                //             hintText: 'AD Street',
                //             controller: _senderAddressController,
                //           ),
                //           const SizedBox(height: Dimensions.paddingSizeLarge),
                //
                //           CustomTextFieldWidget(
                //             labelText: getTranslated('Zip Code', context),
                //             // labelText: "Your First Name",
                //             inputType: TextInputType.name,
                //             focusNode: _senderZipFocus,
                //             nextFocus: _senderCityFocus,
                //             required: true,
                //             readOnly: true,
                //             hintText: '4534667',
                //             controller: _senderZipController,
                //           ),
                //           const SizedBox(height: Dimensions.paddingSizeLarge),
                //
                //           CustomTextFieldWidget(
                //             labelText: getTranslated('City', context),
                //             // labelText: "Your First Name",
                //             inputType: TextInputType.name,
                //             focusNode: _senderCityFocus,
                //             nextFocus: _senderPhoneFocus,
                //             required: true,
                //             readOnly: true,
                //             hintText: 'Narayanganj',
                //             controller: _senderCityController,
                //           ),
                //           const SizedBox(height: Dimensions.paddingSizeLarge),
                //
                //           CustomCountryFieldWidget(
                //               label: getTranslated('Country', context),
                //               selectedCountryCode: senderCountryCode,
                //               onCountryChanged: _onSenderCountryCodeChanged),
                //
                //           const SizedBox(height: Dimensions.paddingSizeDefault),
                //
                //           CustomTextFieldWidget(
                //             labelText: getTranslated('Phone', context),
                //             // labelText: "Your First Name",
                //             inputType: TextInputType.name,
                //             focusNode: _senderPhoneFocus,
                //             nextFocus: _senderEmailFocus,
                //             required: true,
                //             hintText: '9054435454',
                //             controller: _senderPhoneController,
                //           ),
                //           const SizedBox(height: Dimensions.paddingSizeLarge),
                //
                //           CustomTextFieldWidget(
                //             labelText: getTranslated('Email', context),
                //             // labelText: "Your First Name",
                //             inputType: TextInputType.name,
                //             focusNode: _senderEmailFocus,
                //             nextFocus: _destinationCountryFocus,
                //             required: true,
                //             hintText: 'john@example.com',
                //             controller: _senderEmailController,
                //           ),
                //           const SizedBox(height: Dimensions.paddingSizeLarge),
                //
                //           InkWell(
                //             child: const Text('Recipient Information'),
                //             onTap: () {
                //               Navigator.of(context).push(MaterialPageRoute(
                //                   builder: (context) => const ProfileScreen1()));
                //             },
                //           ),
                //
                //           const SizedBox(height: Dimensions.paddingSizeSmall),
                //
                //           CustomCountryFieldWidget(
                //               label:
                //               getTranslated('Destination Country', context),
                //               selectedCountryCode: destinationCountryCode,
                //               onCountryChanged: _onDestinationCountryCodeChanged),
                //
                //           const SizedBox(height: Dimensions.paddingSizeLarge),
                //
                //           CustomTextFieldWidget(
                //             labelText: getTranslated('First Name', context),
                //             inputType: TextInputType.name,
                //             focusNode: _recipientFirstNameFocus,
                //             nextFocus: _recipientLastNameFocus,
                //             required: true,
                //             hintText: 'John',
                //             controller: _recipientFirstNameController,
                //           ),
                //           const SizedBox(height: Dimensions.paddingSizeLarge),
                //
                //           CustomTextFieldWidget(
                //             labelText: getTranslated('Last Name', context),
                //             inputType: TextInputType.name,
                //             focusNode: _recipientLastNameFocus,
                //             nextFocus: _recipientCompanyFocus,
                //             required: true,
                //             hintText: 'Doe',
                //             controller: _recipientLastNameController,
                //           ),
                //           const SizedBox(height: Dimensions.paddingSizeLarge),
                //
                //           CustomTextFieldWidget(
                //             labelText: getTranslated('Company', context),
                //             inputType: TextInputType.name,
                //             focusNode: _recipientCompanyFocus,
                //             nextFocus: _recipientAddressFocus,
                //             required: true,
                //             hintText: 'ABC LTD',
                //             controller: _recipientCompanyController,
                //           ),
                //           const SizedBox(height: Dimensions.paddingSizeLarge),
                //
                //           CustomTextFieldWidget(
                //             labelText: getTranslated('Address', context),
                //             inputType: TextInputType.name,
                //             focusNode: _recipientAddressFocus,
                //             nextFocus: _recipientZipFocus,
                //             required: true,
                //             hintText: 'RD Street',
                //             controller: _recipientAddressController,
                //           ),
                //           const SizedBox(height: Dimensions.paddingSizeLarge),
                //
                //           CustomTextFieldWidget(
                //             labelText: getTranslated('Zip Code', context),
                //             inputType: TextInputType.name,
                //             focusNode: _recipientZipFocus,
                //             nextFocus: _recipientCityFocus,
                //             required: true,
                //             hintText: '556544',
                //             controller: _recipientZipController,
                //           ),
                //           const SizedBox(height: Dimensions.paddingSizeLarge),
                //
                //           CustomTextFieldWidget(
                //             labelText: getTranslated('City', context),
                //             inputType: TextInputType.name,
                //             focusNode: _recipientCityFocus,
                //             nextFocus: _recipientCountryFocus,
                //             required: true,
                //             hintText: 'Narayanganj',
                //             controller: _recipientCityController,
                //           ),
                //           const SizedBox(height: Dimensions.paddingSizeLarge),
                //
                //           CustomCountryFieldWidget(
                //               label: getTranslated('Country', context),
                //               selectedCountryCode: receipentCountryCode,
                //               onCountryChanged: _onReceipentCodeChanged),
                //
                //           const SizedBox(height: Dimensions.paddingSizeLarge),
                //
                //           CustomTextFieldWidget(
                //             labelText: getTranslated('Phone', context),
                //             inputType: TextInputType.name,
                //             focusNode: _recipientPhoneFocus,
                //             nextFocus: _recipientEmailFocus,
                //             required: true,
                //             controller: _recipientPhoneController,
                //           ),
                //           const SizedBox(height: Dimensions.paddingSizeLarge),
                //
                //           CustomTextFieldWidget(
                //             labelText: getTranslated('Email', context),
                //             inputType: TextInputType.name,
                //             focusNode: _recipientEmailFocus,
                //             nextFocus: _shippingModeFocus,
                //             required: true,
                //             hintText: 'john@example.com',
                //             controller: _recipientEmailController,
                //           ),
                //           const SizedBox(height: Dimensions.paddingSizeLarge),
                //
                //           InkWell(
                //             child: const Text('Shipping Information'),
                //             onTap: () {
                //               Navigator.of(context).push(MaterialPageRoute(
                //                   builder: (context) => const ProfileScreen1()));
                //             },
                //           ),
                //
                //           const SizedBox(height: Dimensions.paddingSizeSmall),
                //
                //           CustomTextFieldWidget(
                //             labelText: getTranslated('Shipping Mode', context),
                //             inputType: TextInputType.name,
                //             focusNode: _shippingModeFocus,
                //             nextFocus: _shippingCompanyFocus,
                //             required: true,
                //             readOnly: true,
                //             hintText: getTranslated('Select', context),
                //             controller: _shippingModeController,
                //             onTap: _openShippingModesBottomSheet,
                //           ),
                //           const SizedBox(height: Dimensions.paddingSizeLarge),
                //
                //           CustomTextFieldWidget(
                //             labelText: getTranslated('Shipping Company', context),
                //             inputType: TextInputType.name,
                //             focusNode: _shippingCompanyFocus,
                //             nextFocus: _shippingPackageTypeFocus,
                //             required: true,
                //             readOnly: true,
                //             controller: _shippingCompanyController,
                //             hintText: getTranslated('Select', context),
                //             onTap: _openShippingCompaniesBottomSheet,
                //           ),
                //           const SizedBox(height: Dimensions.paddingSizeLarge),
                //
                //           CustomTextFieldWidget(
                //             labelText:
                //             getTranslated('Type of Packaging', context),
                //             inputType: TextInputType.name,
                //             focusNode: _shippingPackageTypeFocus,
                //             nextFocus: _shippingServiceFocus,
                //             required: true,
                //             readOnly: true,
                //             controller: _shippingPackageTypeController,
                //             hintText: getTranslated("Select", context),
                //             onTap: _openShippingPackageTypesBottomSheet,
                //           ),
                //           const SizedBox(height: Dimensions.paddingSizeLarge),
                //
                //           CustomTextFieldWidget(
                //             labelText: getTranslated('Shipping Service', context),
                //             inputType: TextInputType.name,
                //             focusNode: _shippingServiceFocus,
                //             nextFocus: _shippingDeliveryTimeFocus,
                //             required: true,
                //             readOnly: true,
                //             controller: _shippingServiceController,
                //             hintText: getTranslated("Select", context),
                //             onTap: _openShippingServicesBottomSheet,
                //           ),
                //           const SizedBox(height: Dimensions.paddingSizeLarge),
                //
                //           CustomTextFieldWidget(
                //             labelText: getTranslated('Delivery Time', context),
                //             inputType: TextInputType.name,
                //             focusNode: _shippingDeliveryTimeFocus,
                //             required: true,
                //             readOnly: true,
                //             controller: _shippingDeliveryTimeController,
                //             hintText: getTranslated("Select", context),
                //             onTap: _openShippingDeliveryTimesBottomSheet,
                //           ),
                //           const SizedBox(height: Dimensions.paddingSizeLarge),
                //
                //           if (_images.isNotEmpty)
                //             Container(
                //               height: 250,
                //               child: ListView(
                //                   physics: const BouncingScrollPhysics(),
                //                   children: [
                //                     SizedBox(height: 12),
                //                     Container(
                //                       height: 250,
                //                       child: GridView.builder(
                //                         itemCount: _images.length,
                //                         gridDelegate:
                //                         SliverGridDelegateWithFixedCrossAxisCount(
                //                           crossAxisCount: 3,
                //                           crossAxisSpacing: 8,
                //                           mainAxisSpacing: 8,
                //                         ),
                //                         itemBuilder: (context, index) {
                //                           return Stack(
                //                             children: [
                //                               Positioned.fill(
                //                                 child: Image.file(
                //                                   File(_images[index].path),
                //                                   fit: BoxFit.cover,
                //                                 ),
                //                               ),
                //                               Positioned(
                //                                 top: 2,
                //                                 right: 2,
                //                                 child: GestureDetector(
                //                                   onTap: () =>
                //                                       _removeImage(index),
                //                                   child: Container(
                //                                     decoration: BoxDecoration(
                //                                       color: Colors.black54,
                //                                       shape: BoxShape.circle,
                //                                     ),
                //                                     child: Icon(Icons.close,
                //                                         color: Colors.white,
                //                                         size: 20),
                //                                   ),
                //                                 ),
                //                               ),
                //                             ],
                //                           );
                //                         },
                //                       ),
                //                     ),
                //                     SizedBox(height: 12)
                //                   ]),
                //             ),
                //
                //           InkWell(
                //             onTap: _pickImages,
                //             child: Column(children: [
                //               _images.isEmpty
                //                   ? Container(
                //                 margin: const EdgeInsets.only(
                //                     top: Dimensions.marginSizeExtraLarge),
                //                 alignment: Alignment.center,
                //                 decoration: BoxDecoration(
                //                   color: Theme.of(context).cardColor,
                //                   border: Border.all(
                //                       color: Colors.white, width: 3),
                //                   shape: BoxShape.circle,
                //                 ),
                //                 child: Stack(
                //                     clipBehavior: Clip.none,
                //                     children: [
                //                       ClipRRect(
                //                           borderRadius:
                //                           BorderRadius.circular(20),
                //                           child: CustomImageWidget(
                //                             image: "",
                //                             // "${profile.userInfoModel!.imageFullUrl?.path}",
                //                             height:
                //                             Dimensions.profileImageSize,
                //                             fit: BoxFit.cover,
                //                             width:
                //                             Dimensions.profileImageSize,
                //                           )),
                //                     ]),
                //               )
                //                   : SizedBox(height: 12),
                //               Text(
                //                 _images.isEmpty
                //                     ? getTranslated(
                //                     "Upload Photos", Get.context!)!
                //                     : getTranslated(
                //                     "Add More Photos", Get.context!)!,
                //                 style: textBold.copyWith(
                //                     color: Theme.of(context).colorScheme.primary,
                //                     fontSize: Dimensions.fontSizeLarge),
                //               ),
                //             ]),
                //           ),
                //
                //           const SizedBox(height: Dimensions.paddingSizeLarge),
                //
                //           if (showForm == false || showForm == true) ...[
                //             SizedBox(height: 16),
                //
                //             InkWell(
                //               child: const Text('Packages Added'),
                //             ),
                //
                //             // Container holding the ListView
                //             Expanded(
                //               child: Container(
                //                 height: 400,
                //                 padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                //                 decoration: BoxDecoration(
                //                   color: Colors.white,
                //                   boxShadow: [
                //                     BoxShadow(
                //                       color: Colors.grey.withOpacity(0.3),
                //                       spreadRadius: 2,
                //                       blurRadius: 5,
                //                       offset: Offset(0, 3),
                //                     ),
                //                   ],
                //                 ),
                //                 child: packages.isEmpty
                //                     ? Center(
                //                     child: Text(
                //                       'No items yet!',
                //                       style: TextStyle(
                //                           fontSize: 18, color: Colors.grey),
                //                     ))
                //                     : ListView.builder(
                //                   itemCount: packages.length,
                //                   itemBuilder: (context, index) {
                //                     final item = packages[index];
                //                     return Card(
                //                       elevation:
                //                       2.0, // Slight elevation for each card
                //                       margin: const EdgeInsets.symmetric(
                //                           vertical: 8.0, horizontal: 4.0),
                //                       shape: RoundedRectangleBorder(
                //                         borderRadius:
                //                         BorderRadius.circular(10.0),
                //                       ),
                //                       child: Padding(
                //                         padding: const EdgeInsets.all(12.0),
                //                         child: Row(
                //                           mainAxisAlignment:
                //                           MainAxisAlignment
                //                               .spaceBetween,
                //                           children: <Widget>[
                //                             // Left side: Name and Category
                //                             Expanded(
                //                               // Use Expanded to prevent overflow if text is long
                //                               child: Column(
                //                                 crossAxisAlignment:
                //                                 CrossAxisAlignment
                //                                     .start,
                //                                 children: <Widget>[
                //                                   Text(
                //                                     "${getTranslated("Quantity", context)}: " + item.quantity
                //                                         .toString()!,
                //                                     style: TextStyle(
                //                                       fontSize: 16.0,
                //                                       fontWeight:
                //                                       FontWeight.bold,
                //                                     ),
                //                                     overflow: TextOverflow
                //                                         .ellipsis,
                //                                   ),
                //                                   SizedBox(height: 4.0),
                //                                   Text(
                //                                     "${getTranslated("Volumetric Weight", context)}: ${item.weight!.toStringAsFixed(2)} kg", // Format price
                //                                     style: TextStyle(
                //                                       fontSize: 14.0,
                //                                       color: Colors.grey.shade700,
                //                                     ),
                //                                   ),
                //
                //                                   SizedBox(height: 4.0),
                //                                   Text(
                //                                     "${getTranslated("Weight", context)}: ${item.weight!.toStringAsFixed(2)} kg", // Format price
                //                                     style: TextStyle(
                //                                       fontSize: 14.0,
                //                                       color: Colors.grey.shade700,
                //                                     ),
                //                                   ),
                //                                   SizedBox(height: 4.0),
                //                                   Text(
                //                                     "${item.width} X ${item.length} X ${item.height} cm"
                //                                     ,
                //                                     style: TextStyle(
                //                                       fontSize: 14.0,
                //                                       color: Colors
                //                                           .grey.shade700,
                //                                     ),
                //                                     overflow: TextOverflow
                //                                         .ellipsis,
                //                                   )
                //
                //                                 ],
                //                               ),
                //                             ),
                //                             SizedBox(
                //                                 width:
                //                                 16), // Spacing between left and right content
                //
                //                             // Right side: Price and Delete Icon
                //                             Row(
                //                               mainAxisAlignment: MainAxisAlignment
                //                                   .end,
                //                               children: <Widget>[
                //                                 Column(
                //                                   children: [
                //
                //
                //                                   ],
                //                                 ),
                //                                 SizedBox(width: 8.0),
                //                                 IconButton(
                //                                   icon: Icon(Icons
                //                                       .delete_outline_rounded),
                //                                   color:
                //                                   Colors.red.shade400,
                //                                   onPressed: () {
                //                                     _deleteItem(item.id!);
                //                                   },
                //                                   tooltip: 'Delete Item',
                //                                   constraints:
                //                                   BoxConstraints(), // Removes default padding if needed
                //                                   padding: EdgeInsets
                //                                       .zero, // Removes default padding
                //                                 ),
                //                               ],
                //                             ),
                //                           ],
                //                         ),
                //                       ),
                //                     );
                //                   },
                //                 ),
                //               ),
                //             ),
                //
                //             SizedBox(height: Dimensions.paddingSizeSmall),
                //
                //             Container(
                //               padding: EdgeInsets.fromLTRB(
                //                   Dimensions.paddingSizeDefault,
                //                   0,
                //                   Dimensions.paddingSizeDefault,
                //                   6),
                //               child: true
                //                   ? CustomButton(
                //                   onTap: () => {
                //                     setState(() {
                //                       showForm = true;
                //                     })
                //                   },
                //                   buttonText: getTranslated(
                //                       'Add New Package', context))
                //                   : Center(
                //                   child: CircularProgressIndicator(
                //                     valueColor: AlwaysStoppedAnimation<Color>(
                //                         Theme.of(context).primaryColor),
                //                   )),
                //             ),
                //           ],
                //
                //           InkWell(
                //             child: const Text('Package Information'),
                //           ),
                //
                //           const SizedBox(height: Dimensions.paddingSizeSmall),
                //
                //           CustomTextFieldWidget(
                //             labelText: getTranslated('Quantity', context),
                //             inputType: TextInputType.number,
                //             focusNode: _packageQuantityFocus,
                //             nextFocus: _packageDescFocus,
                //             required: true,
                //             controller: _packageQuantityController,
                //           ),
                //
                //           const SizedBox(height: Dimensions.paddingSizeLarge),
                //
                //           CustomTextFieldWidget(
                //             labelText:
                //             getTranslated('Package Description', context),
                //             inputType: TextInputType.name,
                //             focusNode: _packageDescFocus,
                //             nextFocus: _packageWeightFocus,
                //             required: true,
                //             controller: _packageDescController,
                //           ),
                //
                //           const SizedBox(height: Dimensions.paddingSizeLarge),
                //
                //           CustomTextFieldWidget(
                //             labelText: getTranslated('Weight (kg)', context),
                //             inputType: TextInputType.number,
                //             focusNode: _packageWeightFocus,
                //             nextFocus: _packageLengthFocus,
                //             required: true,
                //             controller: _packageWeightController,
                //           ),
                //
                //           const SizedBox(height: Dimensions.paddingSizeLarge),
                //
                //           CustomTextFieldWidget(
                //             labelText: getTranslated('Length (cm)', context),
                //             inputType: TextInputType.number,
                //             focusNode: _packageLengthFocus,
                //             nextFocus: _packageWidthFocus,
                //             required: true,
                //             onChanged: _onPackageLengthChange,
                //             controller: _packageLengthController,
                //           ),
                //
                //           const SizedBox(height: Dimensions.paddingSizeLarge),
                //
                //           CustomTextFieldWidget(
                //             labelText: getTranslated('Width (cm)', context),
                //             inputType: TextInputType.number,
                //             focusNode: _packageWidthFocus,
                //             nextFocus: _packageHeightFocus,
                //             required: true,
                //             onChanged: _onPackageWidthChange,
                //             controller: _packageWidthController,
                //           ),
                //
                //           const SizedBox(height: Dimensions.paddingSizeLarge),
                //
                //           CustomTextFieldWidget(
                //             labelText: getTranslated('Height (cm)', context),
                //             inputType: TextInputType.number,
                //             focusNode: _packageHeightFocus,
                //             nextFocus: _packageWeightVolFocus,
                //             required: true,
                //             onChanged: _onPackageHeightChange,
                //             controller: _packageHeightController,
                //           ),
                //
                //           const SizedBox(height: Dimensions.paddingSizeLarge),
                //
                //           CustomTextFieldWidget(
                //             labelText: getTranslated('Weight Vol (kg)', context),
                //             focusNode: _packageWeightVolFocus,
                //             nextFocus: _packageShipmentInvoiceAmountFocus,
                //             required: true,
                //             readOnly: true,
                //             controller: _packageWeightVolController,
                //           ),
                //
                //           const SizedBox(height: Dimensions.paddingSizeLarge),
                //
                //           CustomTextFieldWidget(
                //             labelText:
                //             getTranslated('Shipment Invoice Amount', context),
                //             inputType: TextInputType.number,
                //             focusNode: _packageShipmentInvoiceAmountFocus,
                //             nextFocus: _packageCurrencyFocus,
                //             required: true,
                //             controller: _packageShipmentInvoiceAmountController,
                //           ),
                //
                //           const SizedBox(height: Dimensions.paddingSizeLarge),
                //
                //           CustomTextFieldWidget(
                //               labelText: getTranslated('Currency', context),
                //               inputType: TextInputType.name,
                //               focusNode: _packageCurrencyFocus,
                //               required: true,
                //               readOnly: true,
                //               onTap: _openPackageCurrencyBottomSheet,
                //               controller: _packageCurrencyController),
                //
                //           const SizedBox(height: Dimensions.paddingSizeLarge),
                //
                //           Container(
                //             child: true
                //                 ? CustomButton(
                //                 onTap: _addPackage,
                //                 buttonText:
                //                 getTranslated('Add Package', context))
                //                 : Center(
                //                 child: CircularProgressIndicator(
                //                   valueColor: AlwaysStoppedAnimation<Color>(
                //                       Theme.of(context).primaryColor),
                //                 )),
                //           ),
                //
                //           const SizedBox(height: Dimensions.paddingSizeLarge),
                //
                //           Text(getTranslated('order_summary', context) ?? '',
                //               style: textMedium.copyWith(
                //                   fontSize: Dimensions.fontSizeLarge,
                //                   color: Theme.of(context)
                //                       .textTheme
                //                       .bodyLarge
                //                       ?.color)),
                //           const SizedBox(height: Dimensions.paddingSizeSmall),
                //
                //           Column(
                //             children: [
                //               AmountWidget(
                //                   title:
                //                   '${getTranslated('Weight', context)} ${'(${getTranslated('kg', context)})'}',
                //                   amount: "0.0"),
                //               AmountWidget(
                //                   title:
                //                   '${getTranslated('Volumetric Weight', context)} ${'(${getTranslated('kg', context)})'}',
                //                   amount: "0.0"),
                //               AmountWidget(
                //                   title:
                //                   '${getTranslated('Total Weight Calculation', context)} ${'(${getTranslated('kg', context)})'}',
                //                   amount: "0.0"),
                //               AmountWidget(
                //                   title: '${getTranslated('sub_total', context)}',
                //                   amount:
                //                   PriceConverter.convertPrice(context, 0)),
                //               AmountWidget(
                //                   title: getTranslated('Total', context),
                //                   amount: PriceConverter.convertPrice(context, 0))
                //             ],
                //           ),
                //
                //           const SizedBox(height: Dimensions.paddingSizeLarge),
                //           // InkWell(
                //           //   child: const Text('HEllo'),
                //           //   onTap: (){
                //           //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ProfileScreen1()));
                //           //   },
                //           // ),
                //         ],
                //       ),
                //     ),
                //   ),
                //
                // ] ,


                // For sender info step
                if (currentStep == "sender_info") ... [

                  Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeDefault),
                    decoration: BoxDecoration(
                      color: Theme.of(context).highlightColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(Dimensions.marginSizeDefault),
                        topRight: Radius.circular(Dimensions.marginSizeDefault),
                      ),
                    ),
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        InkWell(
                          child: const Text('Sender Information'),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const ProfileScreen1()));
                          },
                        ),

                        const SizedBox(height: Dimensions.paddingSizeSmall),


                        CustomCountryFieldWidget(
                            label: getTranslated('Country of Origin', context),
                            selectedCountryCode: countryOfOriginCode,
                            onCountryChanged: _onCountryOfOriginCodeChanged),

                        SizedBox(height: Dimensions.paddingSizeLarge),

                        // Text('${kolitrendShippingController.branchesList[0].branchName}'),
                        CustomTextFieldWidget(
                          labelText: getTranslated('Select Branch', context),
                          // labelText: "Your First Name",
                          // hintText: kolitrendShippingController.branchesList[0]?.branchName,
                          inputType: TextInputType.name,
                          focusNode: _senderBranchFocus,
                          nextFocus: _senderFirstNameFocus,
                          required: true,
                          readOnly: true,
                          controller: _senderBranchController,
                          // onTap: () => showModalBottomSheet(
                          //   backgroundColor: Colors.transparent,
                          //   isScrollControlled: true,
                          //   context: context,
                          //   builder: (_) =>
                          //       const SelectBranchBottomSheetWidget(),
                          // ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeLarge),

                        CustomTextFieldWidget(
                          labelText: getTranslated('First Name', context),
                          // labelText: "Your First Name",
                          inputType: TextInputType.name,
                          focusNode: _senderFirstNameFocus,
                          nextFocus: _senderLastNameFocus,
                          required: true,
                          readOnly: true,
                          hintText: 'John',
                          controller: _senderFirstNameController,
                          onChanged: (text) {
                            setState(() {
                              // Update whatever state is driven by this text
                              _senderFirstName = text;
                            });
                          },
                        ),
                        const SizedBox(height: Dimensions.paddingSizeLarge),

                        CustomTextFieldWidget(
                          labelText: getTranslated('Last Name', context),
                          // labelText: "Your First Name",
                          inputType: TextInputType.name,
                          focusNode: _senderLastNameFocus,
                          nextFocus: _senderCompanyFocus,
                          required: true,
                          readOnly: true,
                          hintText: 'Doe',
                          controller: _senderLastNameController,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeLarge),

                        CustomTextFieldWidget(
                          labelText: getTranslated('Company', context),
                          // labelText: "Your First Name",
                          inputType: TextInputType.name,
                          focusNode: _senderCompanyFocus,
                          nextFocus: _senderAddressFocus,
                          required: true,
                          readOnly: true,
                          hintText: 'ABC LLC',
                          controller: _senderCompanyController,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeLarge),

                        CustomTextFieldWidget(
                          labelText: getTranslated('Address', context),
                          // labelText: "Your First Name",
                          inputType: TextInputType.name,
                          focusNode: _senderAddressFocus,
                          nextFocus: _senderZipFocus,
                          required: true,
                          readOnly: true,
                          hintText: 'AD Street',
                          controller: _senderAddressController,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeLarge),

                        CustomTextFieldWidget(
                          labelText: getTranslated('Zip Code', context),
                          // labelText: "Your First Name",
                          inputType: TextInputType.name,
                          focusNode: _senderZipFocus,
                          nextFocus: _senderCityFocus,
                          required: true,
                          readOnly: true,
                          hintText: '4534667',
                          controller: _senderZipController,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeLarge),

                        CustomTextFieldWidget(
                          labelText: getTranslated('City', context),
                          // labelText: "Your First Name",
                          inputType: TextInputType.name,
                          focusNode: _senderCityFocus,
                          nextFocus: _senderPhoneFocus,
                          required: true,
                          readOnly: true,
                          hintText: 'Narayanganj',
                          controller: _senderCityController,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeLarge),

                        CustomCountryFieldWidget(
                            label: getTranslated('Country', context),
                            selectedCountryCode: senderCountryCode,
                            onCountryChanged: _onSenderCountryCodeChanged),

                        const SizedBox(height: Dimensions.paddingSizeDefault),

                        CustomTextFieldWidget(
                          labelText: getTranslated('Phone', context),
                          // labelText: "Your First Name",
                          inputType: TextInputType.name,
                          focusNode: _senderPhoneFocus,
                          nextFocus: _senderEmailFocus,
                          required: true,
                          hintText: '9054435454',
                          controller: _senderPhoneController,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeLarge),

                        CustomTextFieldWidget(
                          labelText: getTranslated('Email', context),
                          // labelText: "Your First Name",
                          inputType: TextInputType.name,
                          focusNode: _senderEmailFocus,
                          nextFocus: _destinationCountryFocus,
                          required: true,
                          hintText: 'john@example.com',
                          controller: _senderEmailController,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeLarge),


                      ],
                    ),
                  ),
                ),

                ] ,

                // For recipient info step
                if (currentStep == "recipient_info") ... [

                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeDefault),
                      decoration: BoxDecoration(
                        color: Theme.of(context).highlightColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(Dimensions.marginSizeDefault),
                          topRight: Radius.circular(Dimensions.marginSizeDefault),
                        ),
                      ),
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [

                          InkWell(
                            child: const Text('Recipient Information'),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const ProfileScreen1()));
                            },
                          ),

                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          CustomCountryFieldWidget(
                              label:
                              getTranslated('Destination Country', context),
                              selectedCountryCode: destinationCountryCode,
                              onCountryChanged: _onDestinationCountryCodeChanged),

                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          CustomTextFieldWidget(
                            labelText: getTranslated('First Name', context),
                            inputType: TextInputType.name,
                            focusNode: _recipientFirstNameFocus,
                            nextFocus: _recipientLastNameFocus,
                            required: true,
                            hintText: 'John',
                            controller: _recipientFirstNameController,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          CustomTextFieldWidget(
                            labelText: getTranslated('Last Name', context),
                            inputType: TextInputType.name,
                            focusNode: _recipientLastNameFocus,
                            nextFocus: _recipientCompanyFocus,
                            required: true,
                            hintText: 'Doe',
                            controller: _recipientLastNameController,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          CustomTextFieldWidget(
                            labelText: getTranslated('Company', context),
                            inputType: TextInputType.name,
                            focusNode: _recipientCompanyFocus,
                            nextFocus: _recipientAddressFocus,
                            required: true,
                            hintText: 'ABC LTD',
                            controller: _recipientCompanyController,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          CustomTextFieldWidget(
                            labelText: getTranslated('Address', context),
                            inputType: TextInputType.name,
                            focusNode: _recipientAddressFocus,
                            nextFocus: _recipientZipFocus,
                            required: true,
                            hintText: 'RD Street',
                            controller: _recipientAddressController,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          CustomTextFieldWidget(
                            labelText: getTranslated('Zip Code', context),
                            inputType: TextInputType.name,
                            focusNode: _recipientZipFocus,
                            nextFocus: _recipientCityFocus,
                            required: true,
                            hintText: '556544',
                            controller: _recipientZipController,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          CustomTextFieldWidget(
                            labelText: getTranslated('City', context),
                            inputType: TextInputType.name,
                            focusNode: _recipientCityFocus,
                            nextFocus: _recipientCountryFocus,
                            required: true,
                            hintText: 'Narayanganj',
                            controller: _recipientCityController,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          CustomCountryFieldWidget(
                              label: getTranslated('Country', context),
                              selectedCountryCode: receipentCountryCode,
                              onCountryChanged: _onReceipentCodeChanged),

                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          CustomTextFieldWidget(
                            labelText: getTranslated('Phone', context),
                            inputType: TextInputType.name,
                            focusNode: _recipientPhoneFocus,
                            nextFocus: _recipientEmailFocus,
                            required: true,
                            controller: _recipientPhoneController,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          CustomTextFieldWidget(
                            labelText: getTranslated('Email', context),
                            inputType: TextInputType.name,
                            focusNode: _recipientEmailFocus,
                            nextFocus: _shippingModeFocus,
                            required: true,
                            hintText: 'john@example.com',
                            controller: _recipientEmailController,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),

                        ],
                      ),
                    ),
                  ),

                ] ,

                // For shipping info step
                if (currentStep == "shipping_info") ... [

                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeDefault),
                      decoration: BoxDecoration(
                        color: Theme.of(context).highlightColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(Dimensions.marginSizeDefault),
                          topRight: Radius.circular(Dimensions.marginSizeDefault),
                        ),
                      ),
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [


                          InkWell(
                            child: const Text('Shipping Information'),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const ProfileScreen1()));
                            },
                          ),

                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          CustomTextFieldWidget(
                            labelText: getTranslated('Shipping Mode', context),
                            inputType: TextInputType.name,
                            focusNode: _shippingModeFocus,
                            nextFocus: _shippingCompanyFocus,
                            required: true,
                            readOnly: true,
                            hintText: getTranslated('Select', context),
                            controller: _shippingModeController,
                            onTap: _openShippingModesBottomSheet,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          CustomTextFieldWidget(
                            labelText: getTranslated('Shipping Company', context),
                            inputType: TextInputType.name,
                            focusNode: _shippingCompanyFocus,
                            nextFocus: _shippingPackageTypeFocus,
                            required: true,
                            readOnly: true,
                            controller: _shippingCompanyController,
                            hintText: getTranslated('Select', context),
                            onTap: _openShippingCompaniesBottomSheet,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          CustomTextFieldWidget(
                            labelText:
                            getTranslated('Type of Packaging', context),
                            inputType: TextInputType.name,
                            focusNode: _shippingPackageTypeFocus,
                            nextFocus: _shippingServiceFocus,
                            required: true,
                            readOnly: true,
                            controller: _shippingPackageTypeController,
                            hintText: getTranslated("Select", context),
                            onTap: _openShippingPackageTypesBottomSheet,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          CustomTextFieldWidget(
                            labelText: getTranslated('Shipping Service', context),
                            inputType: TextInputType.name,
                            focusNode: _shippingServiceFocus,
                            nextFocus: _shippingDeliveryTimeFocus,
                            required: true,
                            readOnly: true,
                            controller: _shippingServiceController,
                            hintText: getTranslated("Select", context),
                            onTap: _openShippingServicesBottomSheet,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          CustomTextFieldWidget(
                            labelText: getTranslated('Delivery Time', context),
                            inputType: TextInputType.name,
                            focusNode: _shippingDeliveryTimeFocus,
                            required: true,
                            readOnly: true,
                            controller: _shippingDeliveryTimeController,
                            hintText: getTranslated("Select", context),
                            onTap: _openShippingDeliveryTimesBottomSheet,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),

                        ],
                      ),
                    ),
                  ),

                ] ,

                // For gallery step
                if (currentStep == "gallery") ... [

                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeDefault),
                      decoration: BoxDecoration(
                        color: Theme.of(context).highlightColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(Dimensions.marginSizeDefault),
                          topRight: Radius.circular(Dimensions.marginSizeDefault),
                        ),
                      ),
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [


                          if (_images.isNotEmpty)
                            Container(
                              height: 250,
                              child: ListView(
                                  physics: const BouncingScrollPhysics(),
                                  children: [
                                    SizedBox(height: 12),
                                    Container(
                                      height: 250,
                                      child: GridView.builder(
                                        itemCount: _images.length,
                                        gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 8,
                                          mainAxisSpacing: 8,
                                        ),
                                        itemBuilder: (context, index) {
                                          return Stack(
                                            children: [
                                              Positioned.fill(
                                                child: Image.file(
                                                  File(_images[index].path),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Positioned(
                                                top: 2,
                                                right: 2,
                                                child: GestureDetector(
                                                  onTap: () =>
                                                      _removeImage(index),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.black54,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Icon(Icons.close,
                                                        color: Colors.white,
                                                        size: 20),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 12)
                                  ]),
                            ),

                          InkWell(
                            onTap: _pickImages,
                            child: Column(children: [
                              _images.isEmpty
                                  ? Container(
                                margin: const EdgeInsets.only(
                                    top: Dimensions.marginSizeExtraLarge),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  border: Border.all(
                                      color: Colors.white, width: 3),
                                  shape: BoxShape.circle,
                                ),
                                child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(20),
                                          child: CustomImageWidget(
                                            image: "",
                                            // "${profile.userInfoModel!.imageFullUrl?.path}",
                                            height:
                                            Dimensions.profileImageSize,
                                            fit: BoxFit.cover,
                                            width:
                                            Dimensions.profileImageSize,
                                          )),
                                    ]),
                              )
                                  : SizedBox(height: 12),
                              Text(
                                _images.isEmpty
                                    ? getTranslated(
                                    "Upload Photos", Get.context!)!
                                    : getTranslated(
                                    "Add More Photos", Get.context!)!,
                                style: textBold.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontSize: Dimensions.fontSizeLarge),
                              ),
                            ]),
                          ),

                        ],
                      ),
                    ),
                  ),

                ] ,


                // For add package step
                if (currentStep == "add_package") ... [

                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeDefault),
                      decoration: BoxDecoration(
                        color: Theme.of(context).highlightColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(Dimensions.marginSizeDefault),
                          topRight: Radius.circular(Dimensions.marginSizeDefault),
                        ),
                      ),
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [

                          InkWell(
                            child: const Text('Package Information'),
                          ),

                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          CustomTextFieldWidget(
                            labelText:
                            getTranslated('Package Description', context),
                            inputType: TextInputType.name,
                            focusNode: _packageDescFocus,
                            nextFocus: _packageWeightFocus,
                            required: true,
                            controller: _packageDescController,
                          ),

                          const SizedBox(height: Dimensions.paddingSizeLarge),


                          Row(
                            children: [
                              Expanded(child:
                              CustomTextFieldWidget(
                                labelText: getTranslated('Quantity', context),
                                inputType: TextInputType.number,
                                focusNode: _packageQuantityFocus,
                                nextFocus: _packageDescFocus,
                                required: true,
                                controller: _packageQuantityController,
                              ),
                              ) ,

                              SizedBox(width: 12),

                              Expanded(child:
                              CustomTextFieldWidget(
                                labelText: getTranslated('Weight (kg)', context),
                                inputType: TextInputType.number,
                                focusNode: _packageWeightFocus,
                                nextFocus: _packageLengthFocus,
                                required: true,
                                controller: _packageWeightController,
                              ),
                              )

                            ],
                          ),



                          const SizedBox(height: Dimensions.paddingSizeLarge),


                          Row(
                            children: [
                              Expanded(child:
                              CustomTextFieldWidget(
                                labelText: getTranslated('Length (cm)', context),
                                inputType: TextInputType.number,
                                focusNode: _packageLengthFocus,
                                nextFocus: _packageWidthFocus,
                                required: true,
                                onChanged: _onPackageLengthChange,
                                controller: _packageLengthController,
                              ),
                              ) ,

                              SizedBox(width: 12),

                              Expanded(child:

                              CustomTextFieldWidget(
                                labelText: getTranslated('Width (cm)', context),
                                inputType: TextInputType.number,
                                focusNode: _packageWidthFocus,
                                nextFocus: _packageHeightFocus,
                                required: true,
                                onChanged: _onPackageWidthChange,
                                controller: _packageWidthController,
                              ),
                              ) ,

                            ],
                          ),

                          const SizedBox(height: Dimensions.paddingSizeLarge),


                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child:
                              CustomTextFieldWidget(
                                labelText: getTranslated('Height (cm)', context),
                                inputType: TextInputType.number,
                                focusNode: _packageHeightFocus,
                                nextFocus: _packageWeightVolFocus,
                                required: true,
                                onChanged: _onPackageHeightChange,
                                controller: _packageHeightController,
                              ),
                              ) ,

                            ],


                          ),


                          const SizedBox(height: Dimensions.paddingSizeLarge),


                          CustomTextFieldWidget(
                            labelText: getTranslated('Volumetric Weight (kg)', context),
                            focusNode: _packageWeightVolFocus,
                            nextFocus: _packageShipmentInvoiceAmountFocus,
                            required: true,
                            readOnly: true,
                            controller: _packageWeightVolController,
                          ),


                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          Row(
                            children: [
                              Expanded(

                                flex: 2,

                                child:

                              CustomTextFieldWidget(
                                labelText:
                                getTranslated('Shipment Invoice Amount', context),
                                inputType: TextInputType.number,
                                focusNode: _packageShipmentInvoiceAmountFocus,
                                nextFocus: _packageCurrencyFocus,
                                required: true,
                                controller: _packageShipmentInvoiceAmountController,
                              ),
                              ) ,

                            ],
                          ),

                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          Expanded(
                            flex: 1,
                            child:
                            CustomTextFieldWidget(
                                labelText: getTranslated('Currency', context),
                                inputType: TextInputType.name,
                                focusNode: _packageCurrencyFocus,
                                required: true,
                                readOnly: true,
                                onTap: _openPackageCurrencyBottomSheet,
                                controller: _packageCurrencyController),
                          ),


                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          // Container(
                          //   child: true
                          //       ? CustomButton(
                          //       onTap: _addPackage,
                          //       buttonText:
                          //       getTranslated('Add Package', context))
                          //       : Center(
                          //       child: CircularProgressIndicator(
                          //         valueColor: AlwaysStoppedAnimation<Color>(
                          //             Theme.of(context).primaryColor),
                          //       )),
                          // ),

                        ],
                      ),
                    ),
                  ),

                ] ,


                // For packages step
                if (currentStep == "packages") ... [

                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeDefault),
                      decoration: BoxDecoration(
                        color: Theme.of(context).highlightColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(Dimensions.marginSizeDefault),
                          topRight: Radius.circular(Dimensions.marginSizeDefault),
                        ),
                      ),
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [


                          if (showForm == false || showForm == true) ...[

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(child:
                                InkWell(
                                  child: Text("${getTranslated("Packages Added", Get.context!)!} (${packages.length})"),
                                ),

                                ),


                                Expanded(child:

                                CustomButton(
                                    onTap: () => {
                                      setState(() {
                                        currentStep = "add_package";
                                      })
                                    },
                                    buttonText: getTranslated(
                                        'Add Another', context))
                                ),

                              ],
                            ),


                            SizedBox(height: 16),


                            // Container holding the ListView
                            Expanded(
                              child: Container(
                                height: 400,
                                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: packages.isEmpty
                                    ? Center(
                                    child: Text(
                                      'No items yet!',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.grey),
                                    ))
                                    : ListView.builder(
                                  itemCount: packages.length,
                                  itemBuilder: (context, index) {
                                    final item = packages[index];
                                    return Card(
                                      elevation:
                                      2.0, // Slight elevation for each card
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 4.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: <Widget>[
                                            // Left side: Name and Category
                                            Expanded(
                                              // Use Expanded to prevent overflow if text is long
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                children: <Widget>[
                                                  Text(
                                                    "${getTranslated("Quantity", context)}: " + item.quantity
                                                        .toString()!,
                                                    style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                    ),
                                                    overflow: TextOverflow
                                                        .ellipsis,
                                                  ),
                                                  SizedBox(height: 4.0),
                                                  Text(
                                                    "${getTranslated("Volumetric Weight", context)}: ${item.weight!.toStringAsFixed(2)} kg", // Format price
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors.grey.shade700,
                                                    ),
                                                  ),

                                                  SizedBox(height: 4.0),
                                                  Text(
                                                    "${getTranslated("Weight", context)}: ${item.weight!.toStringAsFixed(2)} kg", // Format price
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors.grey.shade700,
                                                    ),
                                                  ),
                                                  SizedBox(height: 4.0),
                                                  Text(
                                                    "${item.width} X ${item.length} X ${item.height} cm"
                                                    ,
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors
                                                          .grey.shade700,
                                                    ),
                                                    overflow: TextOverflow
                                                        .ellipsis,
                                                  )

                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                                width:
                                                16), // Spacing between left and right content

                                            // Right side: Price and Delete Icon
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .end,
                                              children: <Widget>[
                                                Column(
                                                  children: [


                                                  ],
                                                ),
                                                SizedBox(width: 8.0),
                                                IconButton(
                                                  icon: Icon(Icons
                                                      .delete_outline_rounded),
                                                  color:
                                                  Colors.red.shade400,
                                                  onPressed: () {
                                                    _deleteItem(item.id!);
                                                  },
                                                  tooltip: 'Delete Item',
                                                  constraints:
                                                  BoxConstraints(), // Removes default padding if needed
                                                  padding: EdgeInsets
                                                      .zero, // Removes default padding
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),

                            SizedBox(height: Dimensions.paddingSizeSmall),

                          ],

                        ],
                      ),
                    ),
                  ),

                ] ,


                // For sender info step
                if (currentStep == "overview") ... [

                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeDefault),
                      decoration: BoxDecoration(
                        color: Theme.of(context).highlightColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(Dimensions.marginSizeDefault),
                          topRight: Radius.circular(Dimensions.marginSizeDefault),
                        ),
                      ),
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [

                          Text(getTranslated('order_summary', context) ?? '',
                              style: textMedium.copyWith(
                                  fontSize: Dimensions.fontSizeLarge,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color)),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          Column(
                            children: [
                              AmountWidget(
                                  title:
                                  '${getTranslated('Weight', context)} ${'(${getTranslated('kg', context)})'}',
                                  amount: "0.0"),
                              AmountWidget(
                                  title:
                                  '${getTranslated('Volumetric Weight', context)} ${'(${getTranslated('kg', context)})'}',
                                  amount: "0.0"),
                              AmountWidget(
                                  title:
                                  '${getTranslated('Total Weight Calculation', context)} ${'(${getTranslated('kg', context)})'}',
                                  amount: "0.0"),
                              AmountWidget(
                                  title: '${getTranslated('sub_total', context)}',
                                  amount:
                                  PriceConverter.convertPrice(context, 0)),
                              AmountWidget(
                                  title: getTranslated('Total', context),
                                  amount: PriceConverter.convertPrice(context, 0))
                            ],
                          ),

                          const SizedBox(height: Dimensions.paddingSizeLarge),
                          // InkWell(
                          //   child: const Text('HEllo'),
                          //   onTap: (){
                          //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ProfileScreen1()));
                          //   },
                          // ),
                        ],
                      ),
                    ),
                  ),

                ] ,


                if (showPackages == true) ... [

                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeDefault),
                      decoration: BoxDecoration(
                        color: Theme.of(context).highlightColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(Dimensions.marginSizeDefault),
                          topRight: Radius.circular(Dimensions.marginSizeDefault),
                        ),
                      ),
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          
                              CustomButton(
                                  onTap: () => {
                                    setState(() {
                                       if (showAddPackageForm == false) {
                                         showAddPackageForm = true ;
                                         showPackages = false ;
                                       } else {
                                         showPackages = true;
                                         showAddPackageForm = false;
                                       }
                                    })
                                  },
                                  buttonText: getTranslated(
                                     showAddPackageForm == false ? 'Add New Package' : 'Add Another Package' ,
                                      context)
                              ),

                          // Row(
                          //   children: [
                          //     InkWell(
                          //       child:  Text('${getTranslated("Packages Added", context)}'),
                          //     ),
                          //
                          //     CustomButton(
                          //         onTap: () => {
                          //           setState(() {
                          //             showForm = true;
                          //           })
                          //         },
                          //         buttonText: getTranslated(
                          //             'Add New Package', context))
                          //
                          //
                          //   ],
                          // ),


                          // Container holding the ListView

                          if (showPackages == true) ... [

                            Expanded(
                              child: Container(
                                height: 400,
                                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: packages.isEmpty
                                    ? Center(
                                    child: Padding(padding: EdgeInsets.all(12),
                                         child:   Text(
                                           'No items yet!',
                                           style: TextStyle(
                                               fontSize: 18, color: Colors.grey),
                                         )
                                      )
                                   )
                                    : ListView.builder(
                                  itemCount: packages.length,
                                  itemBuilder: (context, index) {
                                    final item = packages[index];
                                    return Card(
                                      elevation:
                                      2.0, // Slight elevation for each card
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 4.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: <Widget>[
                                            // Left side: Name and Category
                                            Expanded(
                                              // Use Expanded to prevent overflow if text is long
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                children: <Widget>[
                                                  Text(
                                                    "${getTranslated("Quantity", context)}: " + item.quantity
                                                        .toString()!,
                                                    style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                    ),
                                                    overflow: TextOverflow
                                                        .ellipsis,
                                                  ),
                                                  SizedBox(height: 4.0),
                                                  Text(
                                                    "${getTranslated("Volumetric Weight", context)}: ${item.vol_weight!.toStringAsFixed(2)} kg", // Format price
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors.grey.shade700,
                                                    ),
                                                  ),

                                                  SizedBox(height: 4.0),
                                                  Text(
                                                    "${getTranslated("Weight", context)}: ${item.weight!.toStringAsFixed(2)} kg", // Format price
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors.grey.shade700,
                                                    ),
                                                  ),
                                                  SizedBox(height: 4.0),
                                                  Text(
                                                    "${item.width} X ${item.length} X ${item.height} cm"
                                                    ,
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors
                                                          .grey.shade700,
                                                    ),
                                                    overflow: TextOverflow
                                                        .ellipsis,
                                                  )

                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                                width:
                                                16), // Spacing between left and right content

                                            // Right side: Price and Delete Icon
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .end,
                                              children: <Widget>[
                                                Column(
                                                  children: [


                                                  ],
                                                ),
                                                SizedBox(width: 8.0),
                                                IconButton(
                                                  icon: Icon(Icons
                                                      .delete_outline_rounded),
                                                  color:
                                                  Colors.red.shade400,
                                                  onPressed: () {
                                                    _deleteItem(item.id!);
                                                  },
                                                  tooltip: 'Delete Item',
                                                  constraints:
                                                  BoxConstraints(), // Removes default padding if needed
                                                  padding: EdgeInsets
                                                      .zero, // Removes default padding
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),

                            SizedBox(height: Dimensions.paddingSizeSmall),

                          ] ,


                          if (showAddPackageForm == true && showForm == false) ...[

                          InkWell(
                            child: const Text('Package Information'),
                          ),

                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          CustomTextFieldWidget(
                            labelText: getTranslated('Quantity', context),
                            inputType: TextInputType.number,
                            focusNode: _packageQuantityFocus,
                            nextFocus: _packageDescFocus,
                            required: true,
                            controller: _packageQuantityController,
                          ),

                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          CustomTextFieldWidget(
                            labelText:
                            getTranslated('Package Description', context),
                            inputType: TextInputType.name,
                            focusNode: _packageDescFocus,
                            nextFocus: _packageWeightFocus,
                            required: true,
                            controller: _packageDescController,
                          ),

                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          CustomTextFieldWidget(
                            labelText: getTranslated('Weight (kg)', context),
                            inputType: TextInputType.number,
                            focusNode: _packageWeightFocus,
                            nextFocus: _packageLengthFocus,
                            required: true,
                            controller: _packageWeightController,
                          ),

                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          CustomTextFieldWidget(
                            labelText: getTranslated('Length (cm)', context),
                            inputType: TextInputType.number,
                            focusNode: _packageLengthFocus,
                            nextFocus: _packageWidthFocus,
                            required: true,
                            onChanged: _onPackageLengthChange,
                            controller: _packageLengthController,
                          ),

                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          CustomTextFieldWidget(
                            labelText: getTranslated('Width (cm)', context),
                            inputType: TextInputType.number,
                            focusNode: _packageWidthFocus,
                            nextFocus: _packageHeightFocus,
                            required: true,
                            onChanged: _onPackageWidthChange,
                            controller: _packageWidthController,
                          ),

                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          CustomTextFieldWidget(
                            labelText: getTranslated('Height (cm)', context),
                            inputType: TextInputType.number,
                            focusNode: _packageHeightFocus,
                            nextFocus: _packageWeightVolFocus,
                            required: true,
                            onChanged: _onPackageHeightChange,
                            controller: _packageHeightController,
                          ),

                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          CustomTextFieldWidget(
                            labelText: getTranslated('Weight Vol (kg)', context),
                            focusNode: _packageWeightVolFocus,
                            nextFocus: _packageShipmentInvoiceAmountFocus,
                            required: true,
                            readOnly: true,
                            controller: _packageWeightVolController,
                          ),

                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          CustomTextFieldWidget(
                            labelText:
                            getTranslated('Shipment Invoice Amount', context),
                            inputType: TextInputType.number,
                            focusNode: _packageShipmentInvoiceAmountFocus,
                            nextFocus: _packageCurrencyFocus,
                            required: true,
                            controller: _packageShipmentInvoiceAmountController,
                          ),

                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          CustomTextFieldWidget(
                              labelText: getTranslated('Currency', context),
                              inputType: TextInputType.name,
                              focusNode: _packageCurrencyFocus,
                              required: true,
                              readOnly: true,
                              onTap: _openPackageCurrencyBottomSheet,
                              controller: _packageCurrencyController),

                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          Container(
                            child: true
                                ? CustomButton(
                                onTap: _addPackage,
                                buttonText:
                                getTranslated('Add Package', context))
                                : Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor),
                                )),
                          ),

                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          ] ,


                          Text(getTranslated('order_summary', context) ?? '',
                              style: textMedium.copyWith(
                                  fontSize: Dimensions.fontSizeLarge,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color)),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          Column(
                            children: [
                              AmountWidget(
                                  title:
                                  '${getTranslated('Weight', context)} ${'(${getTranslated('kg', context)})'}',
                                  amount: "0.0"),
                              AmountWidget(
                                  title:
                                  '${getTranslated('Volumetric Weight', context)} ${'(${getTranslated('kg', context)})'}',
                                  amount: "0.0"),
                              AmountWidget(
                                  title:
                                  '${getTranslated('Total Weight Calculation', context)} ${'(${getTranslated('kg', context)})'}',
                                  amount: "0.0"),
                              AmountWidget(
                                  title: '${getTranslated('sub_total', context)}',
                                  amount:
                                  PriceConverter.convertPrice(context, 0)),
                              AmountWidget(
                                  title: getTranslated('Total', context),
                                  amount: PriceConverter.convertPrice(context, 0))
                            ],
                          ),

                          const SizedBox(height: Dimensions.paddingSizeLarge),
                          // InkWell(
                          //   child: const Text('HEllo'),
                          //   onTap: (){
                          //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ProfileScreen1()));
                          //   },
                          // ),
                        ],
                      ),
                    ),
                  ),

                ] ,



                Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: Dimensions.marginSizeLarge,
                      vertical: Dimensions.marginSizeSmall,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            currentStep != "sender_info" ? Expanded(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(
                                    0, 0,  Dimensions.paddingSizeSmall, 0),
                                child: true
                                    ? CustomButton(
                                        onTap: previousStep,
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        buttonText: getTranslated(
                                            'Back',
                                            context))
                                    : Center(
                                        child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Theme.of(context)
                                                    .secondaryHeaderColor),
                                      )),
                              ),
                            ) : SizedBox(width: 0),

                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB( currentStep!= "sender_info" ? Dimensions.paddingSizeSmall : 0 , 0, 0, 0),
                                child: true
                                    ? CustomButton(
                                    onTap: nextStep,
                                    backgroundColor:
                                    Theme.of(context).primaryColor,
                                    buttonText: getTranslated(
                                        'Next',
                                        context))
                                    : Center(
                                    child: CircularProgressIndicator(
                                      valueColor:
                                      AlwaysStoppedAnimation<Color>(
                                          Theme.of(context)
                                              .secondaryHeaderColor),
                                    )),
                              ),
                            ),

                          ],
                        ),
                      ],
                    )),
              ]),
            ),
          ]);
        },
      ),
    );
  }
}
