import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/kolitrend_shipping/controllers/shipping_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/kolitrend_shipping/domain/models/shipping_deli_time_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/kolitrend_shipping/domain/models/shipping_mode_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/kolitrend_shipping/domain/models/shipping_pkg_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/kolitrend_shipping/domain/models/shipping_service_model.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:provider/provider.dart';

import '../../../common/basewidget/show_custom_snakbar_widget.dart';
import '../../../main.dart';

class SelectShippingDeliveryTimeBottomSheetWidget extends StatefulWidget {
  ShippingDeliveryTime? selectedShippingDeliveryTime;

  String? countryOfOrigin;
  String? destinationCountry;
  int? shippingModeId;
  int? shippingCompanyId;
  int? shippingPackageTypeId;
  int? shippingServiceId;

  SelectShippingDeliveryTimeBottomSheetWidget({
    super.key,
    this.selectedShippingDeliveryTime,
    this.countryOfOrigin,
    this.destinationCountry,
    this.shippingModeId,
    this.shippingCompanyId,
    this.shippingPackageTypeId,
    this.shippingServiceId
  });

  @override
  State<SelectShippingDeliveryTimeBottomSheetWidget> createState() =>
      _SelectShippingDeliveryTimeBottomSheetWidgetState();
}

class _SelectShippingDeliveryTimeBottomSheetWidgetState
    extends State<SelectShippingDeliveryTimeBottomSheetWidget> {

  late ShippingDeliveryTime? selectedShippingDeliveryTime;
  late String? countryOfOrigin;
  late String? destinationCountry;
  late int? shippingModeId;
  late int? shippingCompanyId;
  late int? shippingPackageTypeId;
  late int? shippingServiceId;

  @override
  void initState() {
    selectedShippingDeliveryTime = widget.selectedShippingDeliveryTime;
    countryOfOrigin = widget.countryOfOrigin;
    destinationCountry = widget.destinationCountry;
    shippingModeId = widget.shippingModeId;
    shippingCompanyId = widget.shippingCompanyId;
    shippingPackageTypeId = widget.shippingPackageTypeId;
    shippingServiceId = widget.shippingServiceId;

    if (countryOfOrigin == null) {
      showCustomSnackBar(
          getTranslated('Please select from country of origin', Get.context!),
          Get.context!,
          isError: true);
    } else if (destinationCountry == null) {
      showCustomSnackBar(
          getTranslated('Please select destination country', Get.context!),
          Get.context!,
          isError: true);
    } else if (shippingModeId == null) {
      showCustomSnackBar(
          getTranslated('Please select shipping mode', Get.context!),
          Get.context!,
          isError: true);
    } else if (shippingCompanyId == null) {
      showCustomSnackBar(
          getTranslated('Please select shipping company', Get.context!),
          Get.context!,
          isError: true);
    } else if (shippingPackageTypeId == null) {
      showCustomSnackBar(
          getTranslated('Please select shipping package type', Get.context!),
          Get.context!,
          isError: true);
    }
    else if (shippingServiceId == null) {
      showCustomSnackBar(
          getTranslated('Please select shipping service', Get.context!),
          Get.context!,
          isError: true);
    }

    else {
      Provider.of<KolitrendShippingController>(context, listen: false)
          .getShippingDeliveryTimes(countryOfOrigin!, destinationCountry!, shippingModeId!, shippingCompanyId!,
        shippingPackageTypeId! );
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
            Text(getTranslated('Select Delivery Time', context)!,
                style: textBold.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                    color: Theme.of(context).textTheme.bodyLarge?.color)),
            Padding(
                padding: const EdgeInsets.only(
                    top: Dimensions.paddingSizeSmall,
                    bottom: Dimensions.paddingSizeLarge),
                child: Text(
                    '${getTranslated('Select delivery time from the list', context)}',
                    style: textRegular.copyWith(
                        color: Theme.of(context).textTheme.bodyLarge?.color))),
            SizedBox(
              height: 400,
              child: SingleChildScrollView(
                child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        kolitrendShippingController.shippingDeliveryTimesList?.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () {
                            setState(() {
                              selectedShippingDeliveryTime = kolitrendShippingController.shippingDeliveryTimesList![index];
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
                                      color: selectedShippingDeliveryTime?.id ==
                                              kolitrendShippingController
                                                  .shippingDeliveryTimesList![
                                                      index]
                                                  .id
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
                                                    .shippingDeliveryTimesList![
                                                        index]
                                                    .deliveryTime!,
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
                  onTap: () =>
                      {Navigator.pop(context, selectedShippingDeliveryTime)},
                )),

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
