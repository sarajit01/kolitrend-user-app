import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_loader_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/brand/domain/models/brand_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/domain/models/category_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/my_requests/domain/models/request_status_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/my_requests/domain/models/request_type_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/domain/models/order_status_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/domain/models/order_type_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/seller_product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/search_product/domain/models/author_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/brand/controllers/brand_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/controllers/category_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/search_product/controllers/search_product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:provider/provider.dart';

class RequestsFilterDialog extends StatefulWidget {

  final List<OrderStatusModel>? orderStatuses;

  const RequestsFilterDialog({super.key, this.orderStatuses});

  @override
  RequestsFilterDialogState createState() => RequestsFilterDialogState();
}

class RequestsFilterDialogState extends State<RequestsFilterDialog> {
  List<int> authors = [];
  List<int> publishingHouses = [];
  List<RequestStatusModel> requestStatuses = [];
  List<RequestTypeModel> requestTypes = [];
  String selectedRequestStatus= "all";
  String selectedRequestType = "all";
  String selectedOrderType= "all";

  @override
  void initState() {
    super.initState();
    requestStatuses = [
      RequestStatusModel(name: "All", value: "all"),
      RequestStatusModel(name: "New", value: "new"),
      RequestStatusModel(name: "Approved" , value: "approved"),
      RequestStatusModel(name: "Declined", value: "declined")
    ];
    requestTypes = [
      RequestTypeModel(name: "All", value: "all"),
      RequestTypeModel(name: "Buy For Me", value: "buy_for_me"),
      RequestTypeModel(name: "Kolitrend Shipping", value: "kolitrend_shipping"),
      RequestTypeModel(name: "Combine & Ship", value: "combine_and_ship"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

    return Dismissible(
      key: const Key('key'),
      direction: DismissDirection.down,
      onDismissed: (_) => Navigator.pop(context),
      child: Consumer<SearchProductController>(
          builder: (context, searchProvider, child) {


            return Consumer<CategoryController>(
                builder: (context, categoryProvider, _) {
                  return Consumer<BrandController>(
                      builder: (context, brandProvider, _) {
                        return Consumer<SellerProductController>(
                            builder: (context, productController, _) {
                              return Container(
                                constraints: BoxConstraints(maxHeight: size.height * 0.9),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).highlightColor,
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20))),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Column(mainAxisSize: MainAxisSize.min, children: [
                                        const SizedBox(height: Dimensions.paddingSizeSmall),
                                        Center(
                                            child: Container(
                                                width: 35,
                                                height: 4,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(
                                                        Dimensions.paddingSizeDefault),
                                                    color: Theme.of(context)
                                                        .hintColor
                                                        .withValues(alpha: .5)))),
                                        const SizedBox(height: Dimensions.paddingSizeDefault),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              // Opacity(
                                              //   opacity: 0,
                                              //   child: Row(children: [
                                              //     SizedBox(width: 20, child: Image.asset(Images.reset)),
                                              //     Text('${getTranslated('reset', context)}', style: textRegular.copyWith(color: Theme.of(context).primaryColor)),
                                              //     const SizedBox(width: Dimensions.paddingSizeDefault)
                                              //   ]),
                                              // ),

                                              const SizedBox(
                                                width: 64,
                                              ),

                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Padding(padding: EdgeInsets.only(right: 10) ,
                                                    child:
                                                    Text(getTranslated('filter', context) ?? '',
                                                        style: titilliumSemiBold.copyWith(
                                                            fontSize: Dimensions.fontSizeLarge,
                                                            color: Theme.of(context)
                                                                .textTheme
                                                                .bodyLarge
                                                                ?.color)),
                                                  )
                                                ],
                                              ),

                                            ]),
                                        Flexible(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context).viewInsets.bottom),
                                              child: SingleChildScrollView(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: Dimensions.paddingSizeDefault),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [

                                                    ...[
                                                      Padding(
                                                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                        child: Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                            children: [
                                                              const SizedBox(
                                                                  height: Dimensions.paddingSizeSmall),

                                                              Text(
                                                                  getTranslated(
                                                                      'Request Type', context)!,
                                                                  style: titilliumRegular.copyWith(
                                                                      fontSize:
                                                                      Dimensions.fontSizeDefault,
                                                                      color: Theme.of(context)
                                                                          .textTheme
                                                                          .bodyLarge
                                                                          ?.color)),
                                                              const SizedBox(
                                                                  height:
                                                                  Dimensions.paddingSizeExtraSmall),
                                                              Container(
                                                                padding: const EdgeInsets.symmetric(
                                                                    horizontal:
                                                                    Dimensions.paddingSizeSmall),
                                                                decoration: BoxDecoration(
                                                                  color: Theme.of(context).cardColor,
                                                                  border: Border.all(
                                                                      width: .7,
                                                                      color: Theme.of(context)
                                                                          .hintColor
                                                                          .withValues(alpha: .3)),
                                                                  borderRadius: BorderRadius.circular(
                                                                      Dimensions.paddingSizeExtraSmall),
                                                                ),
                                                                child: DropdownButton<String>(
                                                                  value: selectedRequestType,
                                                                  items: requestTypes.map((RequestTypeModel requestType) {
                                                                    return DropdownMenuItem<String>(
                                                                      value: requestType.value,
                                                                      child: Text(getTranslated(
                                                                          requestType.name, context)!),
                                                                    );
                                                                  }).toList(),
                                                                  onChanged: (value) {
                                                                    setState(() {
                                                                       selectedRequestType = value!;
                                                                    });
                                                                  },
                                                                  isExpanded: true,
                                                                  underline: const SizedBox(),
                                                                ),
                                                              ),

                                                              const SizedBox(
                                                                  height: Dimensions.paddingSizeSmall),

                                                              Text(
                                                                  getTranslated(
                                                                      'Request Status', context)!,
                                                                  style: titilliumRegular.copyWith(
                                                                      fontSize:
                                                                      Dimensions.fontSizeDefault,
                                                                      color: Theme.of(context)
                                                                          .textTheme
                                                                          .bodyLarge
                                                                          ?.color)),
                                                              const SizedBox(
                                                                  height:
                                                                  Dimensions.paddingSizeExtraSmall),
                                                              Container(
                                                                padding: const EdgeInsets.symmetric(
                                                                    horizontal:
                                                                    Dimensions.paddingSizeSmall),
                                                                decoration: BoxDecoration(
                                                                  color: Theme.of(context).cardColor,
                                                                  border: Border.all(
                                                                      width: .7,
                                                                      color: Theme.of(context)
                                                                          .hintColor
                                                                          .withValues(alpha: .3)),
                                                                  borderRadius: BorderRadius.circular(
                                                                      Dimensions.paddingSizeExtraSmall),
                                                                ),
                                                                child: DropdownButton<String>(
                                                                  value: selectedRequestStatus,
                                                                  items: requestStatuses.map((RequestStatusModel requestStatus) {
                                                                    return DropdownMenuItem<String>(
                                                                      value: requestStatus.value,
                                                                      child: Text(getTranslated(
                                                                          requestStatus.name, context)!),
                                                                    );
                                                                  }).toList(),
                                                                  onChanged: (value) {
                                                                    setState(() {
                                                                      selectedRequestStatus = value!;
                                                                    });
                                                                  },
                                                                  isExpanded: true,
                                                                  underline: const SizedBox(),
                                                                ),
                                                              ),



                                                            ]),
                                                      ),
                                                      const SizedBox(
                                                          height: Dimensions.paddingSizeSmall),


                                                    ],

                                                  ],
                                                ),
                                              ),
                                            )),

                                        Padding(
                                          padding:
                                          const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                          child: CustomButton(
                                              buttonText: getTranslated('apply', context),
                                              onTap: () => {}
                                          ),
                                        ),
                                      ])
                                    ]
                                ),
                              );
                            });
                      });
                });
          }),
    );
  }
}
