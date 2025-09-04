import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/kolitrend_shipping/controllers/shipping_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/kolitrend_shipping/domain/models/shipping_mode_model.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:provider/provider.dart';

import '../../../common/basewidget/show_custom_snakbar_widget.dart';
import '../../../main.dart';

class SelectShippingModeBottomSheetWidget extends StatefulWidget {

  ShippingMode? selectedShippingMode;
  String? countryOfOrigin;
  String? destinationCountry;

  SelectShippingModeBottomSheetWidget({super.key, this.selectedShippingMode, this.countryOfOrigin, this.destinationCountry});

  @override
  State<SelectShippingModeBottomSheetWidget> createState() =>
      _SelectShippingModeBottomSheetWidgetState();
}

class _SelectShippingModeBottomSheetWidgetState
    extends State<SelectShippingModeBottomSheetWidget> {

  late ShippingMode?  selectedShippingMode;
  late String? countryOfOrigin;
  late String? destinationCountry;

  @override
  void initState() {
    selectedShippingMode = widget.selectedShippingMode;
    countryOfOrigin = widget.countryOfOrigin;
    destinationCountry = widget.destinationCountry;

    if (countryOfOrigin != null && destinationCountry != null) {
      Provider.of<KolitrendShippingController>(context, listen: false)
          .getShippingModes(countryOfOrigin!, destinationCountry!);
    } else {
      if (countryOfOrigin == null){
        showCustomSnackBar(
            getTranslated(
                'Please select country of origin', Get.context!),
            Get.context!,
            isError: true);
      } else {
        showCustomSnackBar(
            getTranslated(
                'Please select destination country', Get.context!),
            Get.context!,
            isError: true);
      }
    }

  }


  @override
  Widget build(BuildContext context) {
    // final KolitrendShippingController kolitrendShippingController = Provider.of<KolitrendShippingController>(context, listen: false);

    return Consumer<KolitrendShippingController>(
        builder: (context, kolitrendShippingController, _) {
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
            Text(getTranslated('Select Shipping Mode', context)!,
                style: textBold.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                    color: Theme.of(context).textTheme.bodyLarge?.color)),
            Padding(
                padding: const EdgeInsets.only(
                    top: Dimensions.paddingSizeSmall,
                    bottom: Dimensions.paddingSizeLarge),
                child: Text(
                    '${getTranslated('Select mode from the list', context)}',
                    style: textRegular.copyWith(
                        color: Theme.of(context).textTheme.bodyLarge?.color))),
            SizedBox(
              height: 400,
              child: SingleChildScrollView(
                child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: kolitrendShippingController.shippingModesList?.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () {
                            setState(() {
                              selectedShippingMode =
                                  kolitrendShippingController.shippingModesList![index];
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
                                      color: selectedShippingMode?.id ==
                                              kolitrendShippingController
                                                  .shippingModesList![index].id
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
                                                kolitrendShippingController
                                                    .shippingModesList![index].shippingMode!,
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
                      Navigator.pop(context, selectedShippingMode)
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
