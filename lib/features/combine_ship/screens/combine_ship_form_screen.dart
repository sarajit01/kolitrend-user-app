import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/combine_ship/widgets/combine_package.dart';
import 'package:flutter_sixvalley_ecommerce/features/kolitrend_shipping/controllers/shipping_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/kolitrend_shipping/widgets/select_branch_bottom_sheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/domain/models/order_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/profile/screens/profile_screen1.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_textfield_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../common/basewidget/amount_widget.dart';
import '../../../common/basewidget/no_internet_screen_widget.dart';
import '../../../common/basewidget/paginated_list_view_widget.dart';
import '../../../common/basewidget/show_custom_snakbar_widget.dart';
import '../../../helper/price_converter.dart';
import '../../../main.dart';
import '../../address/controllers/address_controller.dart';
import '../../auth/widgets/code_picker_widget.dart';
import '../../order/widgets/order_shimmer_widget.dart';
import '../../splash/controllers/splash_controller.dart';

class CombineShipFormScreen extends StatefulWidget {
  const CombineShipFormScreen({super.key});
  @override
  CombineShipFormScreenState createState() => CombineShipFormScreenState();
}

class CombineShipFormScreenState extends State<CombineShipFormScreen> {
  ScrollController scrollController = ScrollController();

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

  final TextEditingController _countryFilterController =
      TextEditingController();
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

  final List<String> items = List.generate(10, (i) => 'Item $i');

  List<Orders> orders = [];

  File? file;
  final picker = ImagePicker();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

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

  @override
  void initState() {
    super.initState();
    if (_countryOfOriginCodeController.text.isNotEmpty) {
      Provider.of<KolitrendShippingController>(context, listen: false)
          .getBranches(_countryOfOriginCodeController.text);
    } else {
      Provider.of<KolitrendShippingController>(context, listen: false)
          .getBranches('tr');
    }
    print("Fetching orders");
    Provider.of<KolitrendShippingController>(context, listen: false)
        .getCombineShipRelatedOrders();
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

          _countryFilterController.text = 'fr';
          _countryOfOriginCodeController.text = 'tr';
          _destinationCountryCodeController.text = 'fr';

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
                kolitrendShippingController.branchesList[0].countryCode ?? "";
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
                  const SizedBox(width: 4),
                  Text(getTranslated('Combine & Ship', context) ?? "",
                      style: textRegular.copyWith(
                          fontSize: 20, color: Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const Spacer(),
                  OutlinedButton(
                    onPressed: () {
                      // Handle submit action
                      setState(() {
                      });
                    },
                    child: Text(
                      getTranslated("Submit", context)!,
                      style: TextStyle(color: Colors.white), // Text color
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: Colors.white, width: 2), // White outline
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            12.0), // Optional: for rounded corners
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 4.0), // Optional: padding
                      // You can also set foregroundColor here if you don't want to set it in TextStyle
                      // foregroundColor: Colors.white,
                    ),
                  ),
                  SizedBox(width: 16),

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
                        ...[
                          Text(
                              getTranslated(
                                  'Select Country of Origin', context)!,
                              style: textRegular.copyWith(
                                color: Theme.of(context).hintColor,
                                fontSize: Dimensions.fontSizeSmall,
                              )),
                          const SizedBox(
                              height: Dimensions.paddingSizeExtraSmall),
                          SizedBox(
                              height: 60,
                              child: Consumer<AddressController>(
                                  builder: (context, addressController, _) {
                                return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Provider.of<SplashController>(context,
                                                      listen: false)
                                                  .configModel!
                                                  .deliveryCountryRestriction ==
                                              1
                                          ? Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .cardColor,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                      width: .1,
                                                      color: Theme.of(context)
                                                          .hintColor
                                                          .withValues(
                                                              alpha: 0.1))),
                                              child: DropdownButtonFormField2<
                                                  String>(
                                                isExpanded: true,
                                                isDense: true,
                                                decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            vertical: 0),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5))),
                                                hint: Row(
                                                  children: [
                                                    Image.asset(Images.country),
                                                    const SizedBox(
                                                        width: Dimensions
                                                            .paddingSizeSmall),
                                                    Text(
                                                        _countryOfOriginCodeController
                                                            .text,
                                                        style: textRegular
                                                            .copyWith(
                                                                fontSize: Dimensions
                                                                    .fontSizeDefault,
                                                                color: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyLarge!
                                                                    .color)),
                                                  ],
                                                ),
                                                items: addressController
                                                    .restrictedCountryList
                                                    .map((item) => DropdownMenuItem<String>(
                                                        value: item,
                                                        child: Text(item,
                                                            style: textRegular.copyWith(
                                                                fontSize: Dimensions
                                                                    .fontSizeSmall,
                                                                color: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyLarge
                                                                    ?.color))))
                                                    .toList(),
                                                onChanged: (value) {
                                                  _countryOfOriginCodeController
                                                      .text = value!;
                                                  print(
                                                      "Selected Country of Origin");
                                                  print(value);
                                                  kolitrendShippingController
                                                      .getBranches(value);
                                                },
                                                buttonStyleData:
                                                    const ButtonStyleData(
                                                  padding:
                                                      EdgeInsets.only(right: 8),
                                                ),
                                                iconStyleData: IconStyleData(
                                                    icon: Icon(
                                                        Icons.arrow_drop_down,
                                                        color: Theme.of(context)
                                                            .hintColor),
                                                    iconSize: 24),
                                                dropdownStyleData:
                                                    DropdownStyleData(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                ),
                                                menuItemStyleData:
                                                    const MenuItemStyleData(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    16)),
                                              ),
                                            )
                                          : Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: Dimensions
                                                          .paddingSizeSmall),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius
                                                      .circular(Dimensions
                                                          .paddingSizeSmall),
                                                  color: Theme.of(context)
                                                      .cardColor,
                                                  border: Border.all(
                                                      color: Theme.of(context)
                                                          .hintColor
                                                          .withValues(
                                                              alpha: .5))),
                                              child: CodePickerWidget(
                                                fromCountryList: true,
                                                padding: const EdgeInsets.only(
                                                    left: Dimensions
                                                        .paddingSizeSmall),
                                                flagWidth: 25,
                                                onChanged: (val) {
                                                  _countryOfOriginCodeController
                                                      .text = val.name!;
                                                  print(
                                                      "Selected country code");
                                                  print(val.code);

                                                  kolitrendShippingController
                                                      .getBranches(val.code!);
                                                },
                                                initialSelection:
                                                    _countryOfOriginCodeController
                                                        .text,
                                                showDropDownButton: true,
                                                showCountryOnly: false,
                                                showOnlyCountryWhenClosed: true,
                                                showFlagDialog: true,
                                                hideMainText: false,
                                                showFlagMain: false,
                                                dialogBackgroundColor:
                                                    Theme.of(context).cardColor,
                                                barrierColor:
                                                    Provider.of<ThemeController>(
                                                                context)
                                                            .darkTheme
                                                        ? Colors.black
                                                            .withValues(
                                                                alpha: 0.4)
                                                        : null,
                                                textStyle: textRegular.copyWith(
                                                  fontSize:
                                                      Dimensions.fontSizeLarge,
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .color,
                                                ),
                                                dialogTextStyle:
                                                    textRegular.copyWith(
                                                  fontSize: Dimensions
                                                      .fontSizeDefault,
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .color,
                                                ),
                                              ),
                                            ),
                                    ]);
                              })),
                        ],

                        ...[
                          Text(
                              getTranslated(
                                  'Select Destination Country', context)!,
                              style: textRegular.copyWith(
                                color: Theme.of(context).hintColor,
                                fontSize: Dimensions.fontSizeSmall,
                              )),
                          const SizedBox(
                              height: Dimensions.paddingSizeExtraSmall),
                          SizedBox(
                              height: 60,
                              child: Consumer<AddressController>(
                                  builder: (context, addressController, _) {
                                return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Provider.of<SplashController>(context,
                                                      listen: false)
                                                  .configModel!
                                                  .deliveryCountryRestriction ==
                                              1
                                          ? Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .cardColor,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                      width: .1,
                                                      color: Theme.of(context)
                                                          .hintColor
                                                          .withValues(
                                                              alpha: 0.1))),
                                              child: DropdownButtonFormField2<
                                                  String>(
                                                isExpanded: true,
                                                isDense: true,
                                                decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            vertical: 0),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5))),
                                                hint: Row(
                                                  children: [
                                                    Image.asset(Images.country),
                                                    const SizedBox(
                                                        width: Dimensions
                                                            .paddingSizeSmall),
                                                    Text(
                                                        _destinationCountryCodeController
                                                            .text,
                                                        style: textRegular
                                                            .copyWith(
                                                                fontSize: Dimensions
                                                                    .fontSizeDefault,
                                                                color: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyLarge!
                                                                    .color)),
                                                  ],
                                                ),
                                                items: addressController
                                                    .restrictedCountryList
                                                    .map((item) => DropdownMenuItem<String>(
                                                        value: item,
                                                        child: Text(item,
                                                            style: textRegular.copyWith(
                                                                fontSize: Dimensions
                                                                    .fontSizeSmall,
                                                                color: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyLarge
                                                                    ?.color))))
                                                    .toList(),
                                                onChanged: (value) {
                                                  _countryOfOriginCodeController
                                                      .text = value!;
                                                  print(
                                                      "Selected Destination Country");
                                                  print(value);
                                                  kolitrendShippingController
                                                      .getBranches(value);
                                                },
                                                buttonStyleData:
                                                    const ButtonStyleData(
                                                  padding:
                                                      EdgeInsets.only(right: 8),
                                                ),
                                                iconStyleData: IconStyleData(
                                                    icon: Icon(
                                                        Icons.arrow_drop_down,
                                                        color: Theme.of(context)
                                                            .hintColor),
                                                    iconSize: 24),
                                                dropdownStyleData:
                                                    DropdownStyleData(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                ),
                                                menuItemStyleData:
                                                    const MenuItemStyleData(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    16)),
                                              ),
                                            )
                                          : Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: Dimensions
                                                          .paddingSizeSmall),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius
                                                      .circular(Dimensions
                                                          .paddingSizeSmall),
                                                  color: Theme.of(context)
                                                      .cardColor,
                                                  border: Border.all(
                                                      color: Theme.of(context)
                                                          .hintColor
                                                          .withValues(
                                                              alpha: .5))),
                                              child: CodePickerWidget(
                                                fromCountryList: true,
                                                padding: const EdgeInsets.only(
                                                    left: Dimensions
                                                        .paddingSizeSmall),
                                                flagWidth: 25,
                                                onChanged: (val) {
                                                  _destinationCountryCodeController
                                                      .text = val.name!;
                                                  print(
                                                      "Selected country code");
                                                  print(val.code);

                                                  kolitrendShippingController
                                                      .getBranches(val.code!);
                                                },
                                                initialSelection:
                                                    _destinationCountryCodeController
                                                        .text,
                                                showDropDownButton: true,
                                                showCountryOnly: false,
                                                showOnlyCountryWhenClosed: true,
                                                showFlagDialog: true,
                                                hideMainText: false,
                                                showFlagMain: false,
                                                dialogBackgroundColor:
                                                    Theme.of(context).cardColor,
                                                barrierColor:
                                                    Provider.of<ThemeController>(
                                                                context)
                                                            .darkTheme
                                                        ? Colors.black
                                                            .withValues(
                                                                alpha: 0.4)
                                                        : null,
                                                textStyle: textRegular.copyWith(
                                                  fontSize:
                                                      Dimensions.fontSizeLarge,
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .color,
                                                ),
                                                dialogTextStyle:
                                                    textRegular.copyWith(
                                                  fontSize: Dimensions
                                                      .fontSizeDefault,
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .color,
                                                ),
                                              ),
                                            ),
                                    ]);
                              })),
                        ],

                        SizedBox(
                          height: 60,
                          child: Consumer<KolitrendShippingController>(builder:
                              (context, kolitrendShippingController, _) {
                            return (Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .hintColor
                                            .withValues(alpha: 0.5),
                                        width: 1),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Checkbox(value: true, onChanged: (val) {}),
                                    const Text(
                                        "Combine all your packages in a shipment"),
                                  ],
                                )));
                          }),
                        ),

                        const SizedBox(
                            height: Dimensions.paddingSizeExtraSmall),
                        Text(
                          "Please do not combine your items if you are still waiting for a package that should be added later",
                          style: textRegular.copyWith(
                              color: Theme.of(context).hintColor),
                        ),

                        const SizedBox(height: Dimensions.paddingSizeLarge),

                        // Text('${kolitrendShippingController.branchesList[0].branchName}'),
                        CustomTextFieldWidget(
                          labelText: getTranslated(
                              'Select Kolitrend Local Warehouse', context),
                          // labelText: "Your First Name",
                          hintText: getTranslated("Select", context),
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

                        ...[
                          Text(
                              getTranslated(
                                  'Select Country to Filter', context)!,
                              style: textRegular.copyWith(
                                color: Theme.of(context).hintColor,
                                fontSize: Dimensions.fontSizeSmall,
                              )),
                          const SizedBox(
                              height: Dimensions.paddingSizeExtraSmall),
                          SizedBox(
                              height: 60,
                              child: Consumer<AddressController>(
                                  builder: (context, addressController, _) {
                                return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Provider.of<SplashController>(context,
                                                      listen: false)
                                                  .configModel!
                                                  .deliveryCountryRestriction ==
                                              1
                                          ? Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .cardColor,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                      width: .1,
                                                      color: Theme.of(context)
                                                          .hintColor
                                                          .withValues(
                                                              alpha: 0.1))),
                                              child: DropdownButtonFormField2<
                                                  String>(
                                                isExpanded: true,
                                                isDense: true,
                                                decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            vertical: 0),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5))),
                                                hint: Row(
                                                  children: [
                                                    Image.asset(Images.country),
                                                    const SizedBox(
                                                        width: Dimensions
                                                            .paddingSizeSmall),
                                                    Text(
                                                        _senderCountryCodeController
                                                            .text,
                                                        style: textRegular
                                                            .copyWith(
                                                                fontSize: Dimensions
                                                                    .fontSizeDefault,
                                                                color: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyLarge!
                                                                    .color)),
                                                  ],
                                                ),
                                                items: addressController
                                                    .restrictedCountryList
                                                    .map((item) => DropdownMenuItem<String>(
                                                        value: item,
                                                        child: Text(item,
                                                            style: textRegular.copyWith(
                                                                fontSize: Dimensions
                                                                    .fontSizeSmall,
                                                                color: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyLarge
                                                                    ?.color))))
                                                    .toList(),
                                                onChanged: (value) {
                                                  _senderCountryCodeController
                                                      .text = value!;
                                                },
                                                buttonStyleData:
                                                    const ButtonStyleData(
                                                  padding:
                                                      EdgeInsets.only(right: 8),
                                                ),
                                                iconStyleData: IconStyleData(
                                                    icon: Icon(
                                                        Icons.arrow_drop_down,
                                                        color: Theme.of(context)
                                                            .hintColor),
                                                    iconSize: 24),
                                                dropdownStyleData:
                                                    DropdownStyleData(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                ),
                                                menuItemStyleData:
                                                    const MenuItemStyleData(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    16)),
                                              ),
                                            )
                                          : Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: Dimensions
                                                          .paddingSizeSmall),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius
                                                      .circular(Dimensions
                                                          .paddingSizeSmall),
                                                  color: Theme.of(context)
                                                      .cardColor,
                                                  border: Border.all(
                                                      color: Theme.of(context)
                                                          .hintColor
                                                          .withValues(
                                                              alpha: .5))),
                                              child: CodePickerWidget(
                                                fromCountryList: true,
                                                padding: const EdgeInsets.only(
                                                    left: Dimensions
                                                        .paddingSizeSmall),
                                                flagWidth: 25,
                                                onChanged: (val) {
                                                  _countryFilterController
                                                      .text = val.name!;
                                                },
                                                initialSelection:
                                                    _countryFilterController
                                                        .text,
                                                showDropDownButton: true,
                                                showCountryOnly: false,
                                                showOnlyCountryWhenClosed: true,
                                                showFlagDialog: true,
                                                hideMainText: false,
                                                showFlagMain: false,
                                                dialogBackgroundColor:
                                                    Theme.of(context).cardColor,
                                                barrierColor:
                                                    Provider.of<ThemeController>(
                                                                context)
                                                            .darkTheme
                                                        ? Colors.black
                                                            .withValues(
                                                                alpha: 0.4)
                                                        : null,
                                                textStyle: textRegular.copyWith(
                                                  fontSize:
                                                      Dimensions.fontSizeLarge,
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .color,
                                                ),
                                                dialogTextStyle:
                                                    textRegular.copyWith(
                                                  fontSize: Dimensions
                                                      .fontSizeDefault,
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .color,
                                                ),
                                              ),
                                            ),
                                    ]);
                              })),
                        ],

                        InkWell(
                          child: Consumer<KolitrendShippingController>(builder:
                              (context, kolitrendShippingController, _) {
                            return Text(
                                "Number of Packages in all Kolitrend Warehouses :  ${kolitrendShippingController.combineShipRelatedOrdersModel?.orders?.length}");
                          }),
                          onTap: () {},
                        ),

                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        // Expanded(
                        //   child:
                        //   ListView.builder(
                        //     itemCount: items.length,
                        //     prototypeItem: ListTile(title: Text(items.first)),
                        //     itemBuilder: (context, index) {
                        //       return Column(
                        //         children: [
                        //           Container(
                        //             width: double.infinity,
                        //             child: FittedBox(
                        //               fit: BoxFit.contain,
                        //               child: Image.network(
                        //                   'https://kolitrend.com/public/assets/back-end/img/400x400/img2.jpg'),
                        //             ),
                        //           ),
                        //           Container(
                        //               padding: EdgeInsets.all(4),
                        //               child: const Column(
                        //                 children: [
                        //                   Row(
                        //                     children: [
                        //                       Text("Default Type"),
                        //                       Spacer(),
                        //                       Text("Kg")
                        //                     ],
                        //                   ),
                        //                   Row(
                        //                     children: [
                        //                       Text("Date"),
                        //                       Spacer(),
                        //                       Text("Service")
                        //                     ],
                        //                   ),
                        //                 ],
                        //               ))
                        //         ],
                        //       );
                        //     },
                        //   ),
                        // ),

                        // Expanded(child: Consumer<KolitrendShippingController>(builder: (context, kolitrendShippingController, _){
                        //   return
                        //     ListView.builder(
                        //     shrinkWrap: true,
                        //     itemCount: kolitrendShippingController?.combineShipRelatedOrdersModel?.orders?.length,
                        //     itemBuilder: (context, index) {
                        //       return Column(
                        //         children: [
                        //           Container(
                        //             width: double.infinity,
                        //             child: FittedBox(
                        //               fit: BoxFit.contain,
                        //               child: Image.network(
                        //                   'https://kolitrend.com/public/assets/back-end/img/400x400/img2.jpg'),
                        //             ),
                        //           ),
                        //           Container(
                        //               padding: EdgeInsets.all(4),
                        //               child: const Column(
                        //                 children: [
                        //                   Row(
                        //                     children: [
                        //                       InkWell(
                        //                         child: Consumer<KolitrendShippingController>(builder: (_,__,__){
                        //                           return Text("")
                        //                         }),
                        //                       ),
                        //                       Spacer(),
                        //                       Text("Kg")
                        //                     ],
                        //                   ),
                        //                   Row(
                        //                     children: [
                        //                       Text("Date"),
                        //                       Spacer(),
                        //                       Text("Service")
                        //                     ],
                        //                   ),
                        //                 ],
                        //               ))
                        //         ],
                        //       );
                        //     },
                        //   ),
                        //
                        // })
                        //
                        // ),

                        Expanded(
                            child: kolitrendShippingController
                                        .combineShipRelatedOrdersModel !=
                                    null
                                ? (kolitrendShippingController
                                                .combineShipRelatedOrdersModel!
                                                .orders !=
                                            null &&
                                        kolitrendShippingController
                                            .combineShipRelatedOrdersModel!
                                            .orders!
                                            .isNotEmpty)
                                    ? SingleChildScrollView(
                                        controller: scrollController,
                                        child: PaginatedListView(
                                          scrollController: scrollController,
                                          onPaginate: (int? offset) async {},
                                          totalSize: kolitrendShippingController
                                              .combineShipRelatedOrdersModel
                                              ?.orders
                                              ?.length,
                                          offset: 1,
                                          itemView: ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: kolitrendShippingController
                                                  .combineShipRelatedOrdersModel
                                                  ?.orders
                                                  ?.length,
                                              padding: const EdgeInsets.all(0),
                                              itemBuilder: (context, index) =>
                                                  CombineShipPackageWidget(
                                                      orderModel:
                                                          kolitrendShippingController
                                                              ?.combineShipRelatedOrdersModel
                                                              ?.orders?[index])
                                              // Column(
                                              //
                                              //   children: [
                                              //     Container(
                                              //       width: double.infinity,
                                              //       child: FittedBox(
                                              //         fit: BoxFit.contain,
                                              //         child: Image.network(
                                              //             'https://kolitrend.com/public/assets/back-end/img/400x400/img2.jpg'),
                                              //       ),
                                              //     ),
                                              //     Container(
                                              //         padding:
                                              //             EdgeInsets.all(4),
                                              //         child: const Column(
                                              //           children: [
                                              //             Row(
                                              //               children: [
                                              //
                                              //                 Spacer(),
                                              //                 Text("Kg")
                                              //               ],
                                              //             ),
                                              //             Row(
                                              //               children: [
                                              //                 Text("Date"),
                                              //                 Spacer(),
                                              //                 Text(
                                              //                     "Service")
                                              //               ],
                                              //             ),
                                              //           ],
                                              //         ))
                                              //   ],
                                              // )
                                              // OrderWidget(
                                              //     orderModel: orderController
                                              //         .orderModel?.orders![index]),
                                              ),
                                        ),
                                      )
                                    : const NoInternetOrDataScreenWidget(
                                        isNoInternet: false,
                                        icon: Images.noOrder,
                                        message: 'no_package_found',
                                      )
                                : const OrderShimmerWidget()),

                        // Expanded(
                        //   child: ListView.builder(
                        //     itemCount: kolitrendShippingController
                        //         .combineShipRelatedOrdersModel?.orders?.length,
                        //     prototypeItem: ListTile(title: Text("List of packages")),
                        //     itemBuilder: (context, index) {
                        //       return Column(
                        //         children: [
                        //           Container(
                        //             width: double.infinity,
                        //             child: FittedBox(
                        //               fit: BoxFit.contain,
                        //               child: Image.network(
                        //                   'https://kolitrend.com/public/assets/back-end/img/400x400/img2.jpg'),
                        //             ),
                        //           ),
                        //           Container(
                        //               padding: EdgeInsets.all(4),
                        //               child: const Column(
                        //                 children: [
                        //                   Row(
                        //                     children: [
                        //                       Text("Default Type"),
                        //                       Spacer(),
                        //                       Text("Kg")
                        //                     ],
                        //                   ),
                        //                   Row(
                        //                     children: [
                        //                       Text("Date"),
                        //                       Spacer(),
                        //                       Text("Service")
                        //                     ],
                        //                   ),
                        //                 ],
                        //               ))
                        //         ],
                        //       );
                        //     },
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ),

                // Container(
                //     margin: const EdgeInsets.symmetric(
                //       horizontal: Dimensions.marginSizeLarge,
                //       vertical: Dimensions.marginSizeSmall,
                //     ),
                //     child: Column(
                //       children: [
                //         Row(
                //           children: [
                //             Expanded(
                //               child: Container(
                //                 child: true
                //                     ? CustomButton(
                //                         onTap: _updateUserAccount,
                //                         backgroundColor:
                //                             Theme.of(context).primaryColor,
                //                         buttonText: getTranslated(
                //                             'Create Combine & Ship Order',
                //                             context))
                //                     : Center(
                //                         child: CircularProgressIndicator(
                //                         valueColor:
                //                             AlwaysStoppedAnimation<Color>(
                //                                 Theme.of(context)
                //                                     .secondaryHeaderColor),
                //                       )),
                //               ),
                //             ),
                //           ],
                //         ),
                //         Row(
                //           children: [
                //             Expanded(
                //               child: Container(
                //                 child: true
                //                     ? CustomButton(
                //                         onTap: _updateUserAccount,
                //                         backgroundColor:
                //                             Theme.of(context).disabledColor,
                //                         buttonText: getTranslated(
                //                             'Combine & Ship Requests', context))
                //                     : Center(
                //                         child: CircularProgressIndicator(
                //                         valueColor:
                //                             AlwaysStoppedAnimation<Color>(
                //                                 Theme.of(context)
                //                                     .secondaryHeaderColor),
                //                       )),
                //               ),
                //             ),
                //           ],
                //         ),
                //       ],
                //     )),
              ]),
            ),
          ]);
        },
      ),
    );
  }
}
