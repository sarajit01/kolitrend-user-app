import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/buy_for_me/controllers/buy_for_me_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/buy_for_me/domain/models/category_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/deal/controllers/featured_deal_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/deal/controllers/flash_deal_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/kolitrend_shipping/controllers/shipping_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/controllers/shop_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/controllers/category_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/controllers/localization_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sixvalley_ecommerce/features/brand/controllers/brand_controller.dart';

class SelectBuyForMeCategoryBottomSheetWidget extends StatefulWidget {

  BuyForMeCategory? selectedCategory;

  SelectBuyForMeCategoryBottomSheetWidget({super.key, this.selectedCategory});

  @override
  State<SelectBuyForMeCategoryBottomSheetWidget> createState() =>
      _SelectBuyForMeCategoryBottomSheetWidgetState();
}

class _SelectBuyForMeCategoryBottomSheetWidgetState
    extends State<SelectBuyForMeCategoryBottomSheetWidget> {

  late BuyForMeCategory? currentValue;


  @override
  void initState() {
    Provider.of<BuyForMeController>(context, listen: false).getCategories();
    currentValue = widget.selectedCategory;
  }


  @override
  Widget build(BuildContext context) {
    // final KolitrendShippingController kolitrendShippingController = Provider.of<KolitrendShippingController>(context, listen: false);

    return Consumer<BuyForMeController>(
        builder: (context, buyForMeController, _) {
      return SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(bottom: 40, top: 15),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(Dimensions.paddingSizeDefault))),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                    color: Theme.of(context).hintColor.withValues(alpha: .5),
                    borderRadius: BorderRadius.circular(20))),
            const SizedBox(
              height: 40,
            ),
            Text(getTranslated('Select Category', context)!,
                style: textBold.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                    color: Theme.of(context).textTheme.bodyLarge?.color)),
            Padding(
                padding: const EdgeInsets.only(
                    top: Dimensions.paddingSizeSmall,
                    bottom: Dimensions.paddingSizeLarge),
                child: Text(
                    '${getTranslated('Select category from the list', context)}',
                    style: textRegular.copyWith(
                        color: Theme.of(context).textTheme.bodyLarge?.color))),
            SizedBox(
              height: 400,
              child: SingleChildScrollView(
                child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: buyForMeController.categories?.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () {
                            setState(() {
                              currentValue =
                                  buyForMeController.categories![index];
                            });
                          },
                          child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  Dimensions.paddingSizeDefault,
                                  0,
                                  Dimensions.paddingSizeDefault,
                                  Dimensions.paddingSizeSmall),
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.paddingSizeExtraSmall),
                                      color: currentValue?.id ==
                                              buyForMeController
                                                  .categories![index].id
                                          ? Theme.of(context)
                                              .primaryColor
                                              .withValues(alpha: .1)
                                          : Theme.of(context).cardColor),
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              Dimensions.paddingSizeDefault,
                                          vertical:
                                              Dimensions.paddingSizeSmall),
                                      child: Row(children: [
                                        Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: Dimensions
                                                    .paddingSizeSmall),
                                            child: Text(
                                                buyForMeController
                                                    .categories![index].name!,
                                                style: textRegular.copyWith(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.color)))
                                      ])))));
                    }),
              ),
            ),

            Padding(
                padding: const EdgeInsets.fromLTRB(
                    Dimensions.paddingSizeDefault,
                    0,
                    Dimensions.paddingSizeDefault,
                    Dimensions.paddingSizeSmall),
                child: CustomButton(
                    buttonText: getTranslated("Done", context),
                    backgroundColor: Theme.of(context).primaryColor,
                  onTap: () => {
                      Navigator.pop(context, currentValue)
                  },
                )
            ),

            // SingleChildScrollView(
            //   child:
            //   ListView.builder(
            //       physics: const NeverScrollableScrollPhysics(),
            //       itemCount: buyForMeController.categories?.length,
            //       shrinkWrap: true,
            //       itemBuilder: (context, index) {
            //         return InkWell(
            //             onTap: () {
            //               setState(() {
            //                 buyForMeController.selectedCategory =
            //                     buyForMeController.categories![index];
            //                 Navigator.pop(context);
            //               });
            //             },
            //             child: Padding(
            //                 padding: const EdgeInsets.fromLTRB(
            //                     Dimensions.paddingSizeDefault,
            //                     0,
            //                     Dimensions.paddingSizeDefault,
            //                     Dimensions.paddingSizeSmall),
            //                 child: Container(
            //                     decoration: BoxDecoration(
            //                         borderRadius: BorderRadius.circular(
            //                             Dimensions.paddingSizeExtraSmall),
            //                         color: buyForMeController
            //                                     .selectedCategory?.id ==
            //                                 buyForMeController
            //                                     .categories![index].id
            //                             ? Theme.of(context)
            //                                 .primaryColor
            //                                 .withValues(alpha: .1)
            //                             : Theme.of(context).cardColor),
            //                     child: Padding(
            //                         padding: const EdgeInsets.symmetric(
            //                             horizontal:
            //                                 Dimensions.paddingSizeDefault,
            //                             vertical: Dimensions.paddingSizeSmall),
            //                         child: Row(children: [
            //                           Padding(
            //                               padding: const EdgeInsets.symmetric(
            //                                   horizontal:
            //                                       Dimensions.paddingSizeSmall),
            //                               child: Text(
            //                                   buyForMeController
            //                                       .categories![index].name!,
            //                                   style: textRegular.copyWith(
            //                                       color: Theme.of(context)
            //                                           .textTheme
            //                                           .bodyLarge
            //                                           ?.color)))
            //                         ])))));
            //       }),
            // ),
          ]),
        ),
      );
    });
  }
}
