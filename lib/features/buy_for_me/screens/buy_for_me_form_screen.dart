import 'dart:ffi';
import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/address/domain/models/address_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/buy_for_me/controllers/buy_for_me_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/buy_for_me/domain/models/buy_for_me_product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/buy_for_me/domain/models/category_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/buy_for_me/widgets/select_buy_for_me_currency_bottom_sheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/profile/controllers/profile_contrroller.dart';
import 'package:flutter_sixvalley_ecommerce/features/profile/domain/models/profile_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/profile/screens/profile_screen1.dart';
import 'package:flutter_sixvalley_ecommerce/helper/debounce_helper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_textfield_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/profile/widgets/delete_account_bottom_sheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import '../../../common/basewidget/amount_widget.dart';
import '../../../helper/price_converter.dart';
import '../../address/controllers/address_controller.dart';
import '../../auth/widgets/code_picker_widget.dart';
import '../../setting/screens/settings_screen.dart';
import '../../setting/widgets/select_currency_bottom_sheet_widget.dart';
import '../../setting/widgets/select_language_bottom_sheet_widget.dart';
import '../../splash/controllers/splash_controller.dart';
import '../widgets/select_buy_for_me_category_bottom_sheet_widget.dart';

class BuyForMeFormScreen extends StatefulWidget {
  const BuyForMeFormScreen({super.key});
  @override
  BuyForMeFormScreenState createState() => BuyForMeFormScreenState();
}

class BuyForMeFormScreenState extends State<BuyForMeFormScreen> {
  final FocusNode _linkFocus = FocusNode();
  final FocusNode _productNameFocus = FocusNode();
  final FocusNode _productColorFocus = FocusNode();
  final FocusNode _productSizeFocus = FocusNode();
  final FocusNode _productCategoryFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();
  final FocusNode _quantityFocus = FocusNode();
  final FocusNode _localItemPriceFocus = FocusNode();
  final FocusNode _itemPriceFocus = FocusNode();
  final FocusNode _localShipCostFocus = FocusNode();
  final FocusNode _shipCostFocus = FocusNode();
  final FocusNode _storeNameFocus = FocusNode();
  final FocusNode _buyingCountryFocus = FocusNode();
  final FocusNode _deliveryCountryFocus = FocusNode();

  final TextEditingController _linkController = TextEditingController();

  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productColorController = TextEditingController();
  final TextEditingController _productSizeController = TextEditingController();
  final TextEditingController _productCategoryController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _localItemPriceController =
      TextEditingController();
  final TextEditingController _localItemCurrencyController =
      TextEditingController();
  final TextEditingController _itemPriceController = TextEditingController();
  final TextEditingController _itemPriceCurrencyController =
      TextEditingController();

  final TextEditingController _localShipCostController =
      TextEditingController();

  final TextEditingController _localShipCurrencyController =
      TextEditingController();

  final TextEditingController _shipCostController = TextEditingController();
  final TextEditingController _shipCurrencyController = TextEditingController();

  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _buyingCountryCodeController =
      TextEditingController();
  final TextEditingController _deliveryCountryCodeController =
      TextEditingController();

  List<File> files = [];
  File? file;

  List<BuyForMeProduct> products = [];

  final picker = ImagePicker();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  final _debouncer = DebounceHelper(milliseconds: 500); // 500ms delay

  @override
  void dispose() {
    _debouncer.dispose(); // Important for preventing memory leaks
    super.dispose();
  }

  void _onFormFieldUpdate(String value){
    _debouncer.run(() {
      print("Testing debouncer");
    });
  }

  void _openCategoryBottomSheet() async {
    final value = await showModalBottomSheet<BuyForMeCategory>(
      context: Get.context!,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => SelectBuyForMeCategoryBottomSheetWidget(
          selectedCategory:
              Provider.of<BuyForMeController>(Get.context!, listen: false)
                  .selectedCategory),
    );
    if (value != null) {
      print("Result from Dialog");
      print(value);
      setState(() {
        Provider.of<BuyForMeController>(Get.context!, listen: false)
            .selectedCategory = value as BuyForMeCategory?;
      });
    }
  }

  void _openItemLocalCurrencyBottomSheet() async {
    final value = await showModalBottomSheet<String?>(
        context: Get.context!,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (_) => SelectBuyForMeCurrencyBottomSheetWidget(
            selectedCurrency: _localItemCurrencyController.text));
    if (value != null) {
      print("Result from Dialog");
      setState(() {
        _localItemCurrencyController.text = value!;
      });
    }
  }

  void _openShippingCostLocalCurrencyBottomSheet() async {
    final value = await showModalBottomSheet<String?>(
        context: Get.context!,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (_) => SelectBuyForMeCurrencyBottomSheetWidget(
            selectedCurrency: _localShipCurrencyController.text));
    if (value != null) {
      print("Result from Dialog");
      setState(() {
        _localShipCurrencyController.text = value!;
      });
    }
  }

  void _chooseProductImg() async {
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 500,
        maxWidth: 500);
    setState(() {
      if (pickedFile != null) {
        files.add(File(pickedFile.path));
      }
    });
  }

  final ImagePicker _picker = ImagePicker();
  List<XFile> _images = [];

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

  _calculateProductFee(String value) async {
    BuyForMeProduct product = _setProduct();
    print("Product in action");
    print(product.deliveryCountry);
    print(product.buyingCountry);
    Provider.of<BuyForMeController>(Get.context!, listen: false)
        .productInAction = product;
    Provider.of<BuyForMeController>(Get.context!, listen: false)
        .calculateProductFee();
  }

  BuyForMeProduct _setProduct() {
    BuyForMeProduct product = BuyForMeProduct();
    product.product = _productNameController.text;
    product.url = _linkController.text;
    product.categoryId =
        Provider.of<BuyForMeController>(Get.context!, listen: false)
            .selectedCategory
            ?.id;
    product.color = _productColorController.text;
    product.size = _productSizeController.text;
    product.description = _descriptionController.text;
    product.quantity = int.tryParse(_quantityController.text);
    product.itemLocalPrice = double.tryParse(_localItemPriceController.text);
    product.itemPriceLocalCurrency = _localItemCurrencyController.text;
    product.shipLocalPrice = double.tryParse(_shipCostController.text);
    product.shipLocalCurrency = _shipCurrencyController.text;
    product.storeName = _storeNameController.text;
    product.deliveryCountry = _deliveryCountryCodeController.text;
    product.buyingCountry = _buyingCountryCodeController.text;

    return product;
  }

  void _addProduct() async {
    _setProduct();
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
      body: Consumer<BuyForMeController>(
        builder: (context, buyForMeController, child) {
          // _firstNameController.text = profile.userInfoModel!.fName??'';
          // _lastNameController.text = profile.userInfoModel!.lName??'';
          // _emailController.text = profile.userInfoModel!.email??'';
          // _phoneController.text = profile.userInfoModel!.phone??'';

          _deliveryCountryCodeController.text = 'fr';
          _buyingCountryCodeController.text = 'tr';
          _quantityController.text = '1';
          _itemPriceCurrencyController.text = 'EUR';
          _shipCurrencyController.text = 'EUR';

          if (Provider.of<SplashController>(context).myCurrency != null) {
            if (_localItemCurrencyController.text.isEmpty) {
              _localItemCurrencyController.text =
                  Provider.of<SplashController>(context).myCurrency!.code!;
            }
            if (_localShipCurrencyController.text.isEmpty) {
              _localShipCurrencyController.text =
                  Provider.of<SplashController>(context).myCurrency!.code!;
            }
          }

          _productCategoryController.text =
              (buyForMeController.selectedCategory != null
                  ? buyForMeController.selectedCategory!.name
                  : "")!;

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
                  Text(getTranslated('Buy For Me', context) ?? "",
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
                        CustomTextFieldWidget(
                          labelText: getTranslated('Link', context),
                          // labelText: "Your First Name",
                          inputType: TextInputType.name,
                          focusNode: _linkFocus,
                          nextFocus: _productNameFocus,
                          required: true,
                          hintText: 'https://',
                          controller: _linkController,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeLarge),

                        InkWell(
                          child: const Text('Product Information'),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const ProfileScreen1()));
                          },
                        ),

                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        CustomTextFieldWidget(
                          labelText: getTranslated('Product Name', context),
                          inputType: TextInputType.name,
                          focusNode: _productNameFocus,
                          nextFocus: _productCategoryFocus,
                          required: true,
                          hintText: "Product Name",
                          controller: _productNameController,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeLarge),

                        CustomTextFieldWidget(
                          labelText: getTranslated('Product Category', context),
                          inputType: TextInputType.name,
                          focusNode: _productCategoryFocus,
                          nextFocus: _productColorFocus,
                          required: true,
                          readOnly: true,
                          hintText: "Select a Category",
                          controller: _productCategoryController,
                          // onTap: () => showModalBottomSheet(
                          //   backgroundColor: Colors.transparent,
                          //   isScrollControlled: true,
                          //   context: context,
                          //   builder: (_) =>
                          //       const SelectBuyForMeCategoryBottomSheetWidget(),
                          // ),
                          onTap: _openCategoryBottomSheet,
                        ),

                        const SizedBox(height: Dimensions.paddingSizeLarge),

                        Row(
                          children: [
                            Expanded(
                              child: CustomTextFieldWidget(
                                labelText: getTranslated('Color', context),
                                inputType: TextInputType.name,
                                focusNode: _productColorFocus,
                                nextFocus: _productSizeFocus,
                                required: true,
                                controller: _productColorController,
                              ),
                            ),
                            SizedBox(width: 12), // optional spacing
                            Expanded(
                              child: CustomTextFieldWidget(
                                labelText: getTranslated('Size', context),
                                inputType: TextInputType.name,
                                focusNode: _productSizeFocus,
                                nextFocus: _descriptionFocus,
                                required: true,
                                controller: _productSizeController,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: Dimensions.paddingSizeLarge),

                        CustomTextFieldWidget(
                          labelText: getTranslated('Description', context),
                          inputType: TextInputType.name,
                          focusNode: _descriptionFocus,
                          nextFocus: _quantityFocus,
                          required: true,
                          hintText: "Enter Product Description",
                          controller: _descriptionController,
                        ),

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

                        const SizedBox(height: Dimensions.paddingSizeLarge),

                        CustomTextFieldWidget(
                          labelText: getTranslated('Quantity', context),
                          inputType: TextInputType.name,
                          focusNode: _quantityFocus,
                          nextFocus: _localItemPriceFocus,
                          required: true,
                          hintText: "Enter Quantity",
                          controller: _quantityController,
                          onChanged: _onFormFieldUpdate,
                        ),

                        const SizedBox(height: Dimensions.paddingSizeLarge),

                        InkWell(
                          child: const Text('Local Item Price'),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const ProfileScreen1()));
                          },
                        ),

                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        Row(
                          children: [
                            Expanded(
                              child: CustomTextFieldWidget(
                                labelText: getTranslated('Item Price', context),
                                inputType: TextInputType.name,
                                focusNode: _localItemPriceFocus,
                                nextFocus: _localShipCostFocus,
                                required: true,
                                onChanged: _onFormFieldUpdate,
                                hintText: "Price in Local Currency",
                                controller: _localItemPriceController,
                              ),
                            ),
                            SizedBox(width: 12), // optional spacing
                            Expanded(
                              child: CustomTextFieldWidget(
                                  labelText: getTranslated('Currency', context),
                                  inputType: TextInputType.name,
                                  required: true,
                                  readOnly: true,
                                  controller: _localItemCurrencyController,
                                  onTap: () =>
                                      _openItemLocalCurrencyBottomSheet()),
                            ),
                          ],
                        ),

                        const SizedBox(height: Dimensions.paddingSizeLarge),

                        Row(
                          children: [
                            Expanded(
                              child: CustomTextFieldWidget(
                                labelText: getTranslated('Item Price', context),
                                inputType: TextInputType.name,
                                required: true,
                                hintText: "Price in EUR",
                                controller: _itemPriceController,
                              ),
                            ),
                            SizedBox(width: 12), // optional spacing
                            Expanded(
                              child: CustomTextFieldWidget(
                                labelText: getTranslated('Currency', context),
                                inputType: TextInputType.name,
                                required: true,
                                readOnly: true,
                                controller: _itemPriceCurrencyController,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: Dimensions.paddingSizeLarge),

                        InkWell(
                          child: const Text('Local Ship'),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const ProfileScreen1()));
                          },
                        ),

                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        Row(
                          children: [
                            Expanded(
                              child: CustomTextFieldWidget(
                                labelText:
                                    getTranslated('Shipping Cost', context),
                                inputType: TextInputType.name,
                                focusNode: _localShipCostFocus,
                                nextFocus: _storeNameFocus,
                                required: true,
                                hintText: "Cost in Local Currency",
                                controller: _localShipCostController,
                                onChanged: _onFormFieldUpdate,
                              ),
                            ),
                            SizedBox(width: 12), // optional spacing
                            Expanded(
                              child: CustomTextFieldWidget(
                                  labelText: getTranslated('Currency', context),
                                  inputType: TextInputType.name,
                                  required: true,
                                  readOnly: true,
                                  hintText: "Select",
                                  controller: _localShipCurrencyController,
                                  onTap: () =>
                                      _openShippingCostLocalCurrencyBottomSheet()),
                            ),
                          ],
                        ),

                        const SizedBox(height: Dimensions.paddingSizeLarge),

                        Row(
                          children: [
                            Expanded(
                              child: CustomTextFieldWidget(
                                labelText:
                                    getTranslated('Shipping Cost', context),
                                inputType: TextInputType.name,
                                required: true,
                                hintText: "Cost in EUR",
                                controller: _shipCostController,
                              ),
                            ),
                            SizedBox(width: 12), // optional spacing
                            Expanded(
                              child: CustomTextFieldWidget(
                                labelText: getTranslated('Currency', context),
                                inputType: TextInputType.name,
                                required: true,
                                readOnly: true,
                                hintText: "Select",
                                controller: _shipCurrencyController,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: Dimensions.paddingSizeLarge),

                        InkWell(
                          child: const Text('Other Information'),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const ProfileScreen1()));
                          },
                        ),

                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        CustomTextFieldWidget(
                          labelText: getTranslated('Store Name', context),
                          inputType: TextInputType.name,
                          focusNode: _storeNameFocus,
                          nextFocus: _buyingCountryFocus,
                          required: true,
                          hintText: "",
                          controller: _storeNameController,
                        ),

                        const SizedBox(height: Dimensions.paddingSizeLarge),

                        ...[
                          Text(getTranslated('Buying Country', context)!,
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
                                                        _buyingCountryCodeController
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
                                                  _buyingCountryCodeController
                                                      .text = value!;
                                                  _calculateProductFee("");
                                                  print(
                                                      "Selected Country of Origin");
                                                  print(value);
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
                                                  _buyingCountryCodeController
                                                      .text = val.code!;
                                                  _calculateProductFee("");
                                                  print(
                                                      "Selected country code");
                                                  print(val.code);
                                                },
                                                initialSelection:
                                                    _buyingCountryCodeController
                                                        .text,
                                                showDropDownButton: true,
                                                showCountryOnly: true,
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
                          Text(getTranslated('Delivery Country', context)!,
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
                                                        _deliveryCountryCodeController
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
                                                  _deliveryCountryCodeController
                                                      .text = value!;
                                                  print(
                                                      "Selected Country of Origin");
                                                  print(value);
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
                                                  _deliveryCountryCodeController
                                                      .text = val.code!;
                                                  _calculateProductFee("");
                                                  print(
                                                      "Selected country code");
                                                  print(val.code);
                                                },
                                                initialSelection:
                                                    _deliveryCountryCodeController
                                                        .text,
                                                showDropDownButton: true,
                                                showCountryOnly: true,
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

                        Text(getTranslated('Order Summary', context) ?? '',
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
                                title: getTranslated('Subtotal', context),
                                amount: PriceConverter.convertPrice(
                                    context,
                                    buyForMeController
                                                .buyForMeProductOrderSummary !=
                                            null
                                        ? buyForMeController
                                            .buyForMeProductOrderSummary!
                                            .subtotal
                                        : 0)),
                            AmountWidget(
                                title: getTranslated('Service Fee', context),
                                amount: PriceConverter.convertPrice(
                                    context,
                                    buyForMeController
                                                .buyForMeProductOrderSummary !=
                                            null
                                        ? buyForMeController
                                            .buyForMeProductOrderSummary!
                                            .serviceFee
                                        : 0)),
                            AmountWidget(
                                title:
                                    getTranslated('Quality Control', context),
                                amount: PriceConverter.convertPrice(
                                    context,
                                    buyForMeController
                                                .buyForMeProductOrderSummary !=
                                            null
                                        ? buyForMeController
                                            .buyForMeProductOrderSummary!
                                            .inspectionFee
                                        : 0)),
                            AmountWidget(
                                title: getTranslated('VAT', context),
                                amount: PriceConverter.convertPrice(
                                    context,
                                    buyForMeController
                                                .buyForMeProductOrderSummary !=
                                            null
                                        ? buyForMeController
                                            .buyForMeProductOrderSummary!.vat
                                        : 0)),
                            AmountWidget(
                                title: getTranslated('Customs Duty', context),
                                amount: PriceConverter.convertPrice(
                                    context,
                                    buyForMeController
                                                .buyForMeProductOrderSummary !=
                                            null
                                        ? buyForMeController
                                            .buyForMeProductOrderSummary!
                                            .customsFee
                                        : 0)),
                            AmountWidget(
                                title: getTranslated('Local Delivery', context),
                                amount: PriceConverter.convertPrice(
                                    context,
                                    buyForMeController
                                                .buyForMeProductOrderSummary !=
                                            null
                                        ? buyForMeController
                                            .buyForMeProductOrderSummary!
                                            .localDeliveryFee
                                        : 0)),
                            AmountWidget(
                                title: getTranslated(
                                    'International Delivery', context),
                                amount: PriceConverter.convertPrice(
                                    context,
                                    buyForMeController
                                                .buyForMeProductOrderSummary !=
                                            null
                                        ? buyForMeController
                                            .buyForMeProductOrderSummary!
                                            .internationalDeliveryFee
                                        : 0)),
                            AmountWidget(
                                title:
                                    getTranslated('TOTAL TO BE PAID', context),
                                amount: PriceConverter.convertPrice(
                                    context,
                                    buyForMeController
                                                .buyForMeProductOrderSummary !=
                                            null
                                        ? buyForMeController
                                            .buyForMeProductOrderSummary!.total
                                        : 0))
                          ],
                        ),

                        const SizedBox(height: Dimensions.paddingSizeLarge),

                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: !buyForMeController.isLoading
                                    ? CustomButton(
                                        onTap: _updateUserAccount,
                                        backgroundColor:
                                            Theme.of(context).disabledColor,
                                        buttonText:
                                            getTranslated('cancel', context))
                                    : Center(
                                        child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Theme.of(context).primaryColor),
                                      )),
                              ),
                            ),
                            SizedBox(width: 12), // optional spacing

                            Expanded(
                              child: Container(
                                child: !buyForMeController.isLoading
                                    ? CustomButton(
                                        onTap: _addProduct,
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        buttonText:
                                            getTranslated('Add', context))
                                    : Center(
                                        child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Theme.of(context).primaryColor),
                                      )),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: Dimensions.paddingSizeSmall),

                        Container(
                          child: true
                              ? CustomButton(
                                  onTap: _updateUserAccount,
                                  buttonText:
                                      getTranslated('Add New Item', context))
                              : Center(
                                  child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor),
                                )),
                        ),

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

                Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: Dimensions.marginSizeLarge,
                      vertical: Dimensions.marginSizeSmall,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: !buyForMeController.isLoading
                                    ? CustomButton(
                                        onTap: _updateUserAccount,
                                        backgroundColor:
                                            Theme.of(context).disabledColor,
                                        buttonText: getTranslated(
                                            'My Requests', context))
                                    : Center(
                                        child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Theme.of(context)
                                                    .secondaryHeaderColor),
                                      )),
                              ),
                            ),
                            SizedBox(width: 12), // optional spacing
                            Expanded(
                              child: Container(
                                child: !buyForMeController.isLoading
                                    ? CustomButton(
                                        onTap: _updateUserAccount,
                                        buttonText: getTranslated(
                                            'Buy For Me', context))
                                    : Center(
                                        child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Theme.of(context).primaryColor),
                                      )),
                              ),
                            ),
                          ],
                        )
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
