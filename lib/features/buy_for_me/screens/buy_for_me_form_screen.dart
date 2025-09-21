import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_country_textfield_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/tappable_tooltip.dart';
import 'package:flutter_sixvalley_ecommerce/features/buy_for_me/controllers/buy_for_me_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/buy_for_me/domain/models/buy_for_me_product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/buy_for_me/domain/models/category_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/buy_for_me/widgets/select_buy_for_me_currency_bottom_sheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/profile/screens/profile_screen1.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/domain/models/config_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/debounce_helper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_textfield_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../common/basewidget/amount_widget.dart';
import '../../../helper/price_converter.dart';
import '../../address/controllers/address_controller.dart';
import '../../auth/widgets/code_picker_widget.dart';
import '../../splash/controllers/splash_controller.dart';
import '../domain/models/image_upload_model.dart';
import '../widgets/image_uploader_widget.dart';
import '../widgets/select_buy_for_me_category_bottom_sheet_widget.dart';

class ListItem {
  final String id; // Unique ID for deletion
  final String name;
  final String category;
  final double price;

  ListItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
  });
}

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

  // Error text state variables
  String? _linkErrorText;
  String? _productNameErrorText;
  String? _categoryErrorText;
  String? _productColorErrorText;
  String? _productSizeErrorText;
  String? _descriptionErrorText;
  String? _quantityErrorText;
  String? _localItemPriceErrorText;
  String? _localItemCurrencyErrorText;
  String? _localShipCostErrorText;
  String? _localShipCurrencyErrorText;
  String? _storeNameErrorText;
  String? _buyingCountryErrorText;
  String? _deliveryCountryErrorText;

  List<File> files = [];

  List<String> _productImageUrls = []; // To store URLs from the uploader

  File? file;
  CurrencyList? itemPriceLocalCurrency;
  CurrencyList? shippingCostLocalCurrency;

  List<BuyForMeProduct> products = [];

  final picker = ImagePicker();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  final _debouncer = DebounceHelper(milliseconds: 2000); // 500ms delay

  bool showForm = true;

  final List<ListItem> _items = [
    ListItem(id: '1', name: 'Flutter Pro', category: 'Book', price: 29.99),
    ListItem(id: '2', name: 'Dart Essentials', category: 'Book', price: 19.50),
    ListItem(id: '3', name: 'Mobile UX', category: 'Course', price: 99.00),
    ListItem(
        id: '4', name: 'State Management Guide', category: 'PDF', price: 9.99),
    ListItem(id: '5', name: 'Widget Mastery', category: 'Book', price: 35.00),
    ListItem(id: '1', name: 'Flutter Pro', category: 'Book', price: 29.99),
    ListItem(id: '2', name: 'Dart Essentials', category: 'Book', price: 19.50),
    ListItem(id: '3', name: 'Mobile UX', category: 'Course', price: 99.00),
    ListItem(
        id: '4', name: 'State Management Guide', category: 'PDF', price: 9.99),
    ListItem(id: '5', name: 'Widget Mastery', category: 'Book', price: 35.00),
    ListItem(id: '1', name: 'Flutter Pro', category: 'Book', price: 29.99),
    ListItem(id: '2', name: 'Dart Essentials', category: 'Book', price: 19.50),
    ListItem(id: '3', name: 'Mobile UX', category: 'Course', price: 99.00),
    ListItem(
        id: '4', name: 'State Management Guide', category: 'PDF', price: 9.99),
    ListItem(id: '5', name: 'Widget Mastery', category: 'Book', price: 35.00),
    ListItem(id: '1', name: 'Flutter Pro', category: 'Book', price: 29.99),
    ListItem(id: '2', name: 'Dart Essentials', category: 'Book', price: 19.50),
    ListItem(id: '3', name: 'Mobile UX', category: 'Course', price: 99.00),
    ListItem(
        id: '4', name: 'State Management Guide', category: 'PDF', price: 9.99),
    ListItem(id: '5', name: 'Widget Mastery', category: 'Book', price: 35.00),
  ];

  @override
  void dispose() {
    _debouncer.dispose(); // Important for preventing memory leaks
    super.dispose();
  }

  void _onFormFieldUpdate(String value) {
    _debouncer.run(() {
      print("Order summary to be updated");
      _updateProductOrderSummary();
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
        _updateProductOrderSummary();
      });
    }
  }

  void _openItemLocalCurrencyBottomSheet() async {
    final value = await showModalBottomSheet<CurrencyList?>(
        context: Get.context!,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (_) => SelectBuyForMeCurrencyBottomSheetWidget(
            selectedCurrencyCode: _localItemCurrencyController.text));
    if (value != null) {
      print("Result from Dialog");
      setState(() {
        itemPriceLocalCurrency = value;
        _localItemCurrencyController.text = value!.code!;
        _onLocalItemPriceUpdate();
        _updateProductOrderSummary();
      });
    }
  }

  void _openShippingCostLocalCurrencyBottomSheet() async {
    final value = await showModalBottomSheet<CurrencyList?>(
        context: Get.context!,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (_) => SelectBuyForMeCurrencyBottomSheetWidget(
            selectedCurrencyCode: _localShipCurrencyController.text));
    if (value != null) {
      print("Result from Dialog");
      setState(() {
        shippingCostLocalCurrency = value;
        _localShipCurrencyController.text = value!.code!;
        _updateProductOrderSummary();
        _onLocalShippingCostUpdate();
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

  List<ImageUploadModel> _imageUploads = [];
  Dio _dio = Dio(); // Create a Dio instance

  Future<void> _pickImages() async {
    final List<XFile> selectedFiles = await _picker.pickMultiImage();
    if (selectedFiles.isNotEmpty) {
      setState(() {
        for (var file in selectedFiles) {
          final newImageUpload = ImageUploadModel(file: file);
          _imageUploads.add(newImageUpload);
          _uploadImage(newImageUpload); // Start upload immediately
        }
      });
    }
  }

  // Modify _removeImage
  void _removeImage(ImageUploadModel imageToRemove) {
    // Parameter type changed
    // TODO: If imageToRemove.status == ImageUploadStatus.uploading,
    // you might want to cancel the Dio request. Dio supports CancelToken for this.
    setState(() {
      _imageUploads.remove(imageToRemove);
    });
  }

  // In BuyForMeFormScreenState

  Future<void> _uploadImage(ImageUploadModel imageModel) async {
    setState(() {
      imageModel.status = ImageUploadStatus.uploading;
      imageModel.progress = 0.0;
    });

    String fileName = imageModel.file.path.split('/').last;
    FormData formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(imageModel.file.path,
          filename: fileName),
      // You can add other form data if your API expects it
      // "user_id": "123",
    });

    // IMPORTANT: Replace with your actual Laravel API endpoint
    String uploadUrl = 'YOUR_LARAVEL_API_ENDPOINT/upload-image';

    try {
      Response response = await _dio.post(
        uploadUrl,
        data: formData,
        onSendProgress: (int sent, int total) {
          if (total != 0) {
            setState(() {
              imageModel.progress = sent / total;
            });
          }
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Assuming your API returns JSON with a 'url' or 'file_path' key
        final responseData = response.data;
        setState(() {
          imageModel.status = ImageUploadStatus.completed;
          // Adjust based on your API response structure
          imageModel.uploadedUrl =
              responseData['url'] ?? responseData['file_path'];
          imageModel.progress = 1.0;
        });
      } else {
        setState(() {
          imageModel.status = ImageUploadStatus.failed;
          imageModel.error = "Upload failed. Status: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        imageModel.status = ImageUploadStatus.failed;
        imageModel.error = e.toString();
      });
    }
  }

  bool _checkIfOrderSummaryUpdatable() {
    // check if category was selected
    if (Provider.of<BuyForMeController>(Get.context!, listen: false)
            .selectedCategory ==
        null) {
      return false;
    }

    // check if quantity was filled up
    if (_quantityController.text.isEmpty) {
      return false;
    }

    // check if local item price was filled up
    if (_localItemPriceController.text.isEmpty) {
      return false;
    }

    // check if local item currency was filled up
    if (_localItemCurrencyController.text.isEmpty) {
      return false;
    }

    // check if ship cost was filled up
    if (_localShipCostController.text.isEmpty) {
      return false;
    }

    // check if ship currency was filled up
    if (_localShipCurrencyController.text.isEmpty) {
      return false;
    }

    // check if buying country was filled up
    if (_buyingCountryCodeController.text.isEmpty) {
      return false;
    }

    // check if delivery country was filled up
    if (_deliveryCountryCodeController.text.isEmpty) {
      return false;
    }

    return true;
  }

  _updateProductOrderSummary() async {
    if (_checkIfOrderSummaryUpdatable() == false) {
      print("All fields required to be filled");
      return;
    }

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
    if (Provider.of<BuyForMeController>(Get.context!, listen: false)
            .selectedCategory !=
        null) {
      product.categoryId =
          Provider.of<BuyForMeController>(Get.context!, listen: false)
              .selectedCategory!
              .id;
      product.category =
          Provider.of<BuyForMeController>(Get.context!, listen: false)
              .selectedCategory;
    }
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

  void _deleteItem(String id) {
    setState(() {
      _items.removeWhere((item) => item.id == id);
    });
    // Optional: Show a snackbar or confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Item deleted'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _addProduct() async {
    bool hasError = false;
    // Clear previous errors
    setState(() {
      _linkErrorText = null;
      _productNameErrorText = null;
      _categoryErrorText = null;
      _productColorErrorText = null;
      _productSizeErrorText = null;
      _descriptionErrorText = null;
      _quantityErrorText = null;
      _localItemPriceErrorText = null;
      _localItemCurrencyErrorText = null;
      _localShipCostErrorText = null;
      _localShipCurrencyErrorText = null;
      _storeNameErrorText = null;
      _buyingCountryErrorText = null;
      _deliveryCountryErrorText = null;
    });

    // Validate product URL
    if (_linkController.text.isEmpty) {
      _linkErrorText = getTranslated('Product url is required', Get.context!);
      hasError = true;
    } else {
      final Uri? uri = Uri.tryParse(_linkController.text);
      if (uri == null || (!uri.isScheme('HTTP') && !uri.isScheme('HTTPS'))) {
        _linkErrorText =
            getTranslated('Please enter a valid product url', Get.context!);
        hasError = true;
      }
    }

    // Validate product name
    if (_productNameController.text.isEmpty) {
      _productNameErrorText =
          getTranslated('Product name is required', Get.context!);
      hasError = true;
    }

    // Validate product category
    if (Provider.of<BuyForMeController>(Get.context!, listen: false)
            .selectedCategory ==
        null) {
      _categoryErrorText =
          getTranslated('Product category is required', Get.context!);
      hasError = true;
    }

    // Validate product color
    if (_productColorController.text.isEmpty) {
      _productColorErrorText =
          getTranslated('Product color is required', Get.context!);
      hasError = true;
    }

    // Validate product size
    if (_productSizeController.text.isEmpty) {
      _productSizeErrorText =
          getTranslated('Product size is required', Get.context!);
      hasError = true;
    }

    // Validate product description
    if (_descriptionController.text.isEmpty) {
      _descriptionErrorText =
          getTranslated('Product description is required', Get.context!);
      hasError = true;
    }

    // Validate product quantity
    if (_quantityController.text.isEmpty) {
      _quantityErrorText =
          getTranslated('Product quantity is required', Get.context!);
      hasError = true;
    }

    // Validate item local price
    if (_localItemPriceController.text.isEmpty) {
      _localItemPriceErrorText =
          getTranslated('Please enter item local price', Get.context!);
      hasError = true;
    }

    // Validate item local currency
    if (_localItemCurrencyController.text.isEmpty) {
      _localItemCurrencyErrorText =
          getTranslated('Please select item local currency', Get.context!);
      hasError = true;
    }

    // Validate ship cost
    if (_localShipCostController.text.isEmpty) {
      _localShipCostErrorText =
          getTranslated('Please enter ship cost', Get.context!);
      hasError = true;
    }

    // Validate ship local currency
    if (_localShipCurrencyController.text.isEmpty) {
      _localShipCurrencyErrorText =
          getTranslated('Please select ship local currency', Get.context!) ??
              'Please select ship local currency'; // Added a default value
      hasError = true;
    }

    // Validate store name
    if (_storeNameController.text.isEmpty) {
      _storeNameErrorText =
          getTranslated('Please enter store name', Get.context!);
      hasError = true;
    }

    // Validate buying country
    if (_buyingCountryCodeController.text.isEmpty) {
      _buyingCountryErrorText =
          getTranslated('Please select buying country', Get.context!);
      hasError = true;
    }

    // Validate delivery country
    if (_deliveryCountryCodeController.text.isEmpty) {
      _deliveryCountryErrorText =
          getTranslated('Please select delivery country', Get.context!);
      hasError = true;
    }

    if (hasError) {
      setState(() {}); // Trigger UI update to show errors
      return;
    }

    // Add Product to list
    BuyForMeProduct product = _setProduct();
    product.total = Provider.of<BuyForMeController>(Get.context!, listen: false)
        .buyForMeProductOrderSummary!
        .total!;

    product.tempSessionToken = Uuid().v1().toString();
    products.add(product);

    // Clear form fields
    _linkController.clear();
    _productNameController.clear();
    Provider.of<BuyForMeController>(Get.context!, listen: false)
        .selectedCategory = null;
    _productCategoryController.clear();
    _productColorController.clear();
    _productSizeController.clear();
    _descriptionController.clear();
    _quantityController.clear();
    _localItemPriceController.clear();
    // _localItemCurrencyController.clear(); // Usually auto-populated or reset by splash
    // _localShipCurrencyController.clear(); // Usually auto-populated or reset by splash
    _storeNameController.clear();
    // _buyingCountryCodeController.clear(); // Usually has default
    // _deliveryCountryCodeController.clear(); // Usually has default
    _images.clear();

    setState(() {
      showForm = false;
      // Clear error messages explicitly after successful submission
      _linkErrorText = null;
      _productNameErrorText = null;
      _categoryErrorText = null;
      _productColorErrorText = null;
      _productSizeErrorText = null;
      _descriptionErrorText = null;
      _quantityErrorText = null;
      _localItemPriceErrorText = null;
      _localItemCurrencyErrorText = null;
      _localShipCostErrorText = null;
      _localShipCurrencyErrorText = null;
      _storeNameErrorText = null;
      _buyingCountryErrorText = null;
      _deliveryCountryErrorText = null;
    });

    // Resetting default values for currency and quantity as in initial build
    _quantityController.text = '1';
    if (Provider.of<SplashController>(Get.context!, listen: false).myCurrency !=
        null) {
      itemPriceLocalCurrency =
          Provider.of<SplashController>(Get.context!, listen: false).myCurrency;
      shippingCostLocalCurrency = itemPriceLocalCurrency;
      _localItemCurrencyController.text = itemPriceLocalCurrency!.code!;
      _localShipCurrencyController.text = shippingCostLocalCurrency!.code!;
    }
    _buyingCountryCodeController.text = 'tr'; // Reset to default
    _deliveryCountryCodeController.text = 'fr'; // Reset to default

    showCustomSnackBar("Added successfully", context,
        isError: false, isToaster: true);
  }

  _onLocalItemPriceUpdate() {
    if (_localItemPriceController.text.isNotEmpty) {
      _itemPriceController.text =
          (double.parse(_localItemPriceController.text) /
                  itemPriceLocalCurrency!.exchangeRate!)
              .toStringAsFixed(2);
    }
  }

  _onLocalShippingCostUpdate() {
    if (_localShipCostController.text.isNotEmpty) {
      _shipCostController.text = (double.parse(_localShipCostController.text) /
              shippingCostLocalCurrency!.exchangeRate!)
          .toStringAsFixed(2);
    }
  }

  _onBuyingCountryChanged(String buyingCountry){
    print("Buying country changed");
    print(buyingCountry);
  }

  _onDeliveryCountryChanged(String deliveryCountry){
    print("Delivery country changed");
    print(deliveryCountry);
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

  Widget _buildErrorText(String? errorText) {
    if (errorText != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 4.0, left: 2.0),
        child: Text(
          errorText,
          style:
              TextStyle(color: Colors.red, fontSize: Dimensions.fontSizeSmall),
        ),
      );
    }
    return SizedBox.shrink();
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
              itemPriceLocalCurrency =
                  Provider.of<SplashController>(Get.context!, listen: false)
                      .myCurrency;
              _localItemCurrencyController.text = itemPriceLocalCurrency!.code!;
            }
            if (_localShipCurrencyController.text.isEmpty) {
              shippingCostLocalCurrency =
                  Provider.of<SplashController>(Get.context!, listen: false)
                      .myCurrency;

              _localShipCurrencyController.text =
                  shippingCostLocalCurrency!.code!;
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
                  if (showForm == true) ...[
                    Spacer(),
                    OutlinedButton(
                      onPressed: () {
                        // Handle submit action
                        setState(() {
                          showForm = false;
                        });
                      },
                      child: Text(
                        getTranslated("View Added Items", context)!,
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
                  ],
                  if (showForm == false) ...[
                    Spacer(),
                    OutlinedButton(
                      onPressed: () {
                        // Handle submit action
                        setState(() {
                          showForm = false;
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
                  ],
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

                if (showForm == false) ...[
                  SizedBox(height: 16),
                  // Container holding the ListView
                  Expanded(
                    child: Container(
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
                      child: products.isEmpty
                          ? Center(
                              child: Text(
                              'No items yet!',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ))
                          : ListView.builder(
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                final item = products[index];
                                return Card(
                                  elevation:
                                      2.0, // Slight elevation for each card
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 4.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        // Left side: Name and Category
                                        Expanded(
                                          // Use Expanded to prevent overflow if text is long
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                item.product!,
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(height: 4.0),
                                              Text(
                                                item.category!.name!,
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors.grey.shade700,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                            width:
                                                16), // Spacing between left and right content

                                        // Right side: Price and Delete Icon
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              '\$${item.total!.toStringAsFixed(2)}', // Format price
                                              style: TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w500,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                            SizedBox(width: 8.0),
                                            IconButton(
                                              icon: Icon(
                                                  Icons.delete_outline_rounded),
                                              color: Colors.red.shade400,
                                              onPressed: () {
                                                _deleteItem(
                                                    item.tempSessionToken!);
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

                  Container(
                    padding: EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault,
                        0, Dimensions.paddingSizeDefault, 6),
                    child: true
                        ? CustomButton(
                            onTap: () => {
                                  setState(() {
                                    showForm = true;
                                  })
                                },
                            buttonText: getTranslated('Add New Item', context))
                        : Center(
                            child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor),
                          )),
                  ),
                ],

                if (showForm == true) ...[
                  const SizedBox(height: Dimensions.paddingSizeLarge),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeDefault),
                      decoration: BoxDecoration(
                        color: Theme.of(context).highlightColor,
                        borderRadius: const BorderRadius.only(
                          topLeft:
                              Radius.circular(Dimensions.marginSizeDefault),
                          topRight:
                              Radius.circular(Dimensions.marginSizeDefault),
                        ),
                      ),
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextFieldWidget(
                                  labelText: getTranslated('Link', context),
                                  inputType: TextInputType.name,
                                  focusNode: _linkFocus,
                                  nextFocus: _productNameFocus,
                                  required: true,
                                  hintText: 'https://',
                                  controller: _linkController,
                                  onChanged: (value) {
                                    if (_linkErrorText != null)
                                      setState(() => _linkErrorText = null);
                                  },
                                ),
                                _buildErrorText(_linkErrorText),
                              ]),

                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          InkWell(child: const Text('Product Information')),

                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextFieldWidget(
                                  labelText:
                                      getTranslated('Product Name', context),
                                  inputType: TextInputType.name,
                                  focusNode: _productNameFocus,
                                  nextFocus: _productCategoryFocus,
                                  required: true,
                                  hintText:
                                      getTranslated("Product Name", context),
                                  controller: _productNameController,
                                  onChanged: (value) {
                                    if (_productNameErrorText != null)
                                      setState(
                                          () => _productNameErrorText = null);
                                  },
                                ),
                                _buildErrorText(_productNameErrorText),
                              ]),
                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextFieldWidget(
                                  labelText: getTranslated(
                                      'Product Category', context),
                                  inputType: TextInputType.name,
                                  focusNode: _productCategoryFocus,
                                  nextFocus: _productColorFocus,
                                  required: true,
                                  readOnly: true,
                                  hintText: getTranslated(
                                      "Select a Category", context),
                                  controller: _productCategoryController,
                                  onTap: _openCategoryBottomSheet,
                                ),
                                _buildErrorText(_categoryErrorText),
                              ]),

                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomTextFieldWidget(
                                        labelText:
                                            getTranslated('Color', context),
                                        inputType: TextInputType.name,
                                        focusNode: _productColorFocus,
                                        nextFocus: _productSizeFocus,
                                        required: true,
                                        controller: _productColorController,
                                        onChanged: (value) {
                                          if (_productColorErrorText != null)
                                            setState(() =>
                                                _productColorErrorText = null);
                                        },
                                      ),
                                      _buildErrorText(_productColorErrorText),
                                    ]),
                              ),

                              SizedBox(width: 12), // optional spacing
                              Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomTextFieldWidget(
                                        labelText:
                                            getTranslated('Size', context),
                                        inputType: TextInputType.name,
                                        focusNode: _productSizeFocus,
                                        nextFocus: _descriptionFocus,
                                        required: true,
                                        controller: _productSizeController,
                                        onChanged: (value) {
                                          if (_productSizeErrorText != null)
                                            setState(() =>
                                                _productSizeErrorText = null);
                                        },
                                      ),
                                      _buildErrorText(_productSizeErrorText),
                                    ]),
                              ),
                            ],
                          ),

                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextFieldWidget(
                                  labelText:
                                      getTranslated('Description', context),
                                  inputType: TextInputType.multiline,
                                  maxLines:
                                      3, // Allow multiple lines for description
                                  focusNode: _descriptionFocus,
                                  nextFocus: _quantityFocus,
                                  required: true,
                                  hintText: getTranslated(
                                      "Enter Product Description", context),
                                  controller: _descriptionController,
                                  onChanged: (value) {
                                    if (_descriptionErrorText != null)
                                      setState(
                                          () => _descriptionErrorText = null);
                                  },
                                ),
                                _buildErrorText(_descriptionErrorText),
                              ]),

                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          ImageUploaderWidget(
                            uploadUrl: "https://www.kolitrend.com" +
                                AppConstants
                                    .imgUploadUri, // IMPORTANT: Replace this
                            dioInstance:
                                _dio, // Pass your existing Dio instance
                            onUploadComplete: (List<String> urls) {
                              setState(() {
                                _productImageUrls = urls;
                              });
                              // You might want to trigger _updateProductOrderSummary() if images affect the summary
                              print("Uploaded image URLs: $urls");
                            },
                            maxImages: 20, // Example: limit to 5 images
                          ),

                          // Container(
                          //   height: 250,
                          //   child: ListView(
                          //       physics: const BouncingScrollPhysics(),
                          //       children: [
                          //         SizedBox(height: 12),
                          //         Container(
                          //           height: 250,
                          //           child: GridView.builder(
                          //             itemCount: _images.length,
                          //             gridDelegate:
                          //                 SliverGridDelegateWithFixedCrossAxisCount(
                          //               crossAxisCount: 3,
                          //               crossAxisSpacing: 8,
                          //               mainAxisSpacing: 8,
                          //             ),
                          //             itemBuilder: (context, index) {
                          //               return Stack(
                          //                 children: [
                          //                   Positioned.fill(
                          //                     child: Image.file(
                          //                       File(_images[index].path),
                          //                       fit: BoxFit.cover,
                          //                     ),
                          //                   ),
                          //                   Positioned(
                          //                     top: 2,
                          //                     right: 2,
                          //                     child: GestureDetector(
                          //                       onTap: () =>
                          //                           _removeImage(index),
                          //                       child: Container(
                          //                         decoration: BoxDecoration(
                          //                           color: Colors.black54,
                          //                           shape: BoxShape.circle,
                          //                         ),
                          //                         child: Icon(Icons.close,
                          //                             color: Colors.white,
                          //                             size: 20),
                          //                       ),
                          //                     ),
                          //                   ),
                          //                 ],
                          //               );
                          //             },
                          //           ),
                          //         ),
                          //         SizedBox(height: 12)
                          //       ]),
                          // ),

                          // InkWell(
                          //   onTap: _pickImages,
                          //   child: Column(children: [
                          //     _images.isEmpty
                          //         ? Container(
                          //             margin: const EdgeInsets.only(
                          //                 top: Dimensions.marginSizeExtraLarge),
                          //             alignment: Alignment.center,
                          //             decoration: BoxDecoration(
                          //               color: Theme.of(context).cardColor,
                          //               border: Border.all(
                          //                   color: Colors.white, width: 3),
                          //               shape: BoxShape.circle,
                          //             ),
                          //             child: Stack(
                          //                 clipBehavior: Clip.none,
                          //                 children: [
                          //                   ClipRRect(
                          //                       borderRadius:
                          //                           BorderRadius.circular(20),
                          //                       child: CustomImageWidget(
                          //                         image: "",
                          //                         // "${profile.userInfoModel!.imageFullUrl?.path}",
                          //                         height: Dimensions
                          //                             .profileImageSize,
                          //                         fit: BoxFit.cover,
                          //                         width: Dimensions
                          //                             .profileImageSize,
                          //                       )),
                          //                 ]),
                          //           )
                          //         : SizedBox(height: 12),
                          //     Text(
                          //       _images.isEmpty
                          //           ? getTranslated(
                          //               "Upload Photos", Get.context!)!
                          //           : getTranslated(
                          //               "Add More Photos", Get.context!)!,
                          //       style: textBold.copyWith(
                          //           color:
                          //               Theme.of(context).colorScheme.primary,
                          //           fontSize: Dimensions.fontSizeLarge),
                          //     ),
                          //   ]),
                          // ),

                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextFieldWidget(
                                  labelText: getTranslated('Quantity', context),
                                  inputType:
                                      TextInputType.number, // Changed to number
                                  focusNode: _quantityFocus,
                                  nextFocus: _localItemPriceFocus,
                                  required: true,
                                  hintText:
                                      getTranslated("Enter Quantity", context),
                                  controller: _quantityController,
                                  onChanged: (value) {
                                    _onFormFieldUpdate(value);
                                    if (_quantityErrorText != null)
                                      setState(() => _quantityErrorText = null);
                                  },
                                ),
                                _buildErrorText(_quantityErrorText),
                              ]),

                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          InkWell(
                            child: const Text('Local Item Price'),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const ProfileScreen1()));
                            },
                          ),

                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomTextFieldWidget(
                                        labelText: getTranslated(
                                            'Item Price', context),
                                        inputType:
                                            TextInputType.numberWithOptions(
                                                decimal:
                                                    true), // For decimal input
                                        focusNode: _localItemPriceFocus,
                                        nextFocus:
                                            _localShipCostFocus, // Check next focus
                                        required: true,
                                        onChanged: (value) {
                                          _onFormFieldUpdate(value);
                                          _onLocalItemPriceUpdate();
                                          if (_localItemPriceErrorText != null)
                                            setState(() =>
                                                _localItemPriceErrorText =
                                                    null);
                                        },
                                        hintText: getTranslated(
                                            "Price in Local Currency", context),
                                        controller: _localItemPriceController,
                                      ),
                                      _buildErrorText(_localItemPriceErrorText),
                                    ]),
                              ),
                              SizedBox(width: 12), // optional spacing
                              Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomTextFieldWidget(
                                          labelText: getTranslated(
                                              'Currency', context),
                                          inputType: TextInputType.name,
                                          required: true,
                                          readOnly: true,
                                          controller:
                                              _localItemCurrencyController,
                                          onTap: () =>
                                              _openItemLocalCurrencyBottomSheet()),
                                      _buildErrorText(
                                          _localItemCurrencyErrorText),
                                    ]),
                              ),
                            ],
                          ),

                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          Row(
                            children: [
                              Expanded(
                                child: CustomTextFieldWidget(
                                  labelText:
                                      getTranslated('Item Price', context),
                                  inputType: TextInputType.name,
                                  required: true,
                                  readOnly: true,
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
                          ),

                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomTextFieldWidget(
                                        labelText: getTranslated(
                                            'Shipping Cost', context),
                                        inputType:
                                            TextInputType.numberWithOptions(
                                                decimal:
                                                    true), // For decimal input
                                        focusNode: _localShipCostFocus,
                                        nextFocus:
                                            _storeNameFocus, // Check next focus
                                        required: true,
                                        hintText: getTranslated(
                                            "Cost in Local Currency", context),
                                        controller: _localShipCostController,
                                        onChanged: (value) {
                                          _onFormFieldUpdate(value);
                                          _onLocalShippingCostUpdate();
                                          if (_localShipCostErrorText != null)
                                            setState(() =>
                                                _localShipCostErrorText = null);
                                        },
                                      ),
                                      _buildErrorText(_localShipCostErrorText),
                                    ]),
                              ),
                              SizedBox(width: 12), // optional spacing
                              Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomTextFieldWidget(
                                          labelText: getTranslated(
                                              'Currency', context),
                                          inputType: TextInputType.name,
                                          required: true,
                                          readOnly: true,
                                          hintText:
                                              getTranslated("Select", context),
                                          controller:
                                              _localShipCurrencyController,
                                          onTap: () =>
                                              _openShippingCostLocalCurrencyBottomSheet()),
                                      _buildErrorText(
                                          _localShipCurrencyErrorText),
                                    ]),
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
                                  readOnly: true,
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
                                  hintText: "EUR",
                                  controller: _shipCurrencyController,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          InkWell(child: const Text('Other Information')),

                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextFieldWidget(
                                  labelText:
                                      getTranslated('Store Name', context),
                                  inputType: TextInputType.name,
                                  focusNode: _storeNameFocus,
                                  nextFocus: _buyingCountryFocus,
                                  required: true,
                                  hintText: getTranslated(
                                      "Enter Store Name", context),
                                  controller: _storeNameController,
                                  onChanged: (value) {
                                    if (_storeNameErrorText != null)
                                      setState(
                                          () => _storeNameErrorText = null);
                                  },
                                ),
                                _buildErrorText(_storeNameErrorText),
                              ]),

                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomCountryFieldWidget(label: getTranslated('Buying Country', context), selectedCountryCode: 'tr', onCountryChanged: _onBuyingCountryChanged),
                              _buildErrorText(_buyingCountryErrorText),

                            ],
                          ),

                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomCountryFieldWidget(label: getTranslated('Delivery Country', context), selectedCountryCode: 'fr', onCountryChanged: _onDeliveryCountryChanged),
                              _buildErrorText(_deliveryCountryErrorText),

                            ],
                          ),

                          const SizedBox(height: Dimensions.paddingSizeDefault),

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
                                  hintText: buyForMeController
                                      .buyForMeProductOrderSummary
                                      ?.subtotalHint,
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
                                  hintText: buyForMeController
                                      .buyForMeProductOrderSummary
                                      ?.serviceFeeHint,
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
                                  hintText: buyForMeController
                                      .buyForMeProductOrderSummary
                                      ?.inspectionFeeHint,
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
                                  hintText: buyForMeController
                                      .buyForMeProductOrderSummary?.vatHint,
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
                                  hintText: buyForMeController
                                      .buyForMeProductOrderSummary
                                      ?.customsFeeHint,
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
                                  hintText: buyForMeController
                                      .buyForMeProductOrderSummary
                                      ?.localDeliveryFeeHint,
                                  title:
                                      getTranslated('Local Delivery', context),
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
                                  hintText: buyForMeController
                                      .buyForMeProductOrderSummary
                                      ?.internationalDeliveryFeeHint,
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
                                  hintText: buyForMeController
                                                  .buyForMeProductOrderSummary
                                                  ?.total !=
                                              null &&
                                          buyForMeController
                                                  .buyForMeProductOrderSummary
                                                  ?.total! !=
                                              0
                                      ? getTranslated("Total Payable", context)
                                      : null,
                                  title: getTranslated(
                                      'TOTAL TO BE PAID', context),
                                  amount: PriceConverter.convertPrice(
                                      context,
                                      buyForMeController
                                                  .buyForMeProductOrderSummary !=
                                              null
                                          ? buyForMeController
                                              .buyForMeProductOrderSummary!
                                              .total
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
                                          valueColor: AlwaysStoppedAnimation<
                                                  Color>(
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
                                          valueColor: AlwaysStoppedAnimation<
                                                  Color>(
                                              Theme.of(context).primaryColor),
                                        )),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 12),

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
                ],

                //
                // if (showForm == false)
                //   Container(
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
                //                 child: !buyForMeController.isLoading
                //                     ? CustomButton(
                //                         onTap: _updateUserAccount,
                //                         backgroundColor:
                //                             Theme.of(context).disabledColor,
                //                         buttonText: getTranslated(
                //                             'My Requests', context))
                //                     : Center(
                //                         child: CircularProgressIndicator(
                //                         valueColor:
                //                             AlwaysStoppedAnimation<Color>(
                //                                 Theme.of(context)
                //                                     .secondaryHeaderColor),
                //                       )),
                //               ),
                //             ),
                //             SizedBox(width: 12), // optional spacing
                //             Expanded(
                //               child: Container(
                //                 child: !buyForMeController.isLoading
                //                     ? CustomButton(
                //                         onTap: _updateUserAccount,
                //                         buttonText: getTranslated(
                //                             'Submit', context))
                //                     : Center(
                //                         child: CircularProgressIndicator(
                //                         valueColor:
                //                             AlwaysStoppedAnimation<Color>(
                //                                 Theme.of(context).primaryColor),
                //                       )),
                //               ),
                //             ),
                //           ],
                //         )
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
