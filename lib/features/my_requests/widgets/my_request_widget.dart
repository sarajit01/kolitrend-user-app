import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/my_requests/domain/models/my_request_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/domain/models/order_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/screens/order_details_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/controllers/localization_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

class MyRequestWidget extends StatelessWidget {
  final MyRequests? myRequestModel;
  const MyRequestWidget({super.key, this.myRequestModel});

  @override
  Widget build(BuildContext context) {
    double orderAmount = myRequestModel!.totalAmount != null ? myRequestModel!.totalAmount! : 0.0;

    if (myRequestModel?.requestType == 'buy_for_me') {
      // double itemsPrice = 0;
      // double discount = 0;
      // double? eeDiscount = 0;
      // double tax = 0;
      // double coupon = 0;
      // double shipping = 0;
      // if (orderModel?.details != null && orderModel!.details!.isNotEmpty ) {
      //   coupon = orderModel?.discountAmount ?? 0;
      //   shipping = orderModel?.shippingCost ?? 0;
      //   for (var orderDetails in orderModel!.details!) {
      //     itemsPrice = itemsPrice + (orderDetails.price! * orderDetails.qty!);
      //     discount = discount + orderDetails.discount!;
      //     tax = tax + orderDetails.tax!;
      //
      //   }
      //   if(orderModel!.orderType == 'POS'){
      //     if(orderModel!.extraDiscountType == 'percent'){
      //       eeDiscount = itemsPrice * (orderModel!.extraDiscount!/100);
      //     }else{
      //       eeDiscount = orderModel!.extraDiscount;
      //     }
      //   }
      // }
      // double subTotal = itemsPrice +tax - discount;
      //
      // orderAmount = subTotal + shipping - coupon - eeDiscount!;
      //

      // double ? _extraDiscountAnount = 0;
      // if(orderModel.extraDiscount != null){
      //   _extraDiscountAnount = PriceConverter.convertWithDiscount(context, orderModel.totalProductPrice, orderModel.extraDiscount, orderModel.extraDiscountType == 'percent' ? 'percent' : 'amount' );
      //   if(_extraDiscountAnount != null) {
      //     double percentAmount = _extraDiscountAnount!;
      //     _extraDiscountAnount = orderModel.totalProductPrice! - percentAmount;
      //   }
      // }
      //
      // double totalDiscount = (_extraDiscountAnount! + orderModel.totalProductDiscount!);
      // double totalOrderAmount = (orderModel.totalProductPrice! + orderModel.totalTaxAmount!);
      //
      // orderAmount = totalOrderAmount - totalDiscount;
      //
      // orderAmount = orderModel.orderAmount! - orderModel.totalTaxAmount!;
    }

    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                OrderDetailsScreen(orderId: myRequestModel!.id)));
      },
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(
                bottom: Dimensions.paddingSizeSmall,
                left: Dimensions.paddingSizeSmall,
                right: Dimensions.paddingSizeSmall),
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              color: Theme.of(context).highlightColor,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withValues(alpha: .2),
                    spreadRadius: 1,
                    blurRadius: 7,
                    offset: const Offset(0, 1))
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(
                  width: 82,
                  height: 82,
                  child: Column(children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(
                            Dimensions.paddingSizeExtraSmall),
                        border: Border.all(
                            width: 1,
                            color: Theme.of(context)
                                .primaryColor
                                .withValues(alpha: .25)),
                        boxShadow: Provider.of<ThemeController>(context,
                                    listen: false)
                                .darkTheme
                            ? null
                            : [
                                BoxShadow(
                                    color: Colors.grey.withValues(alpha: .2),
                                    spreadRadius: 1,
                                    blurRadius: 7,
                                    offset: const Offset(0, 1))
                              ],
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              Dimensions.paddingSizeExtraSmall),
                          child: CustomImageWidget(
                              placeholder: Images.placeholder,
                              fit: BoxFit.scaleDown,
                              width: 70,
                              height: 70,
                              image: Provider.of<SplashController>(context,
                                          listen: false)
                                      .configModel!
                                      .companyFavIcon
                                      ?.path ??
                                  '')),
                    ),
                  ]),
                ),
                const SizedBox(width: Dimensions.paddingSizeLarge),
                Expanded(
                    flex: 5,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Expanded(
                                child: Text(
                                    '${getTranslated('Request', context)!}# ${myRequestModel!.id.toString()}',
                                    style: textBold.copyWith(
                                        fontSize: Dimensions.fontSizeDefault,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.color)))
                          ]),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          Text(
                              DateConverter.localDateToIsoStringAMPMOrder(
                                  DateTime.parse(myRequestModel!.createdAt!)),
                              style: textMedium.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: Theme.of(context).hintColor)),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          Text(
                              PriceConverter.convertPrice(
                                  context,
                                  myRequestModel!.requestType == 'POS'
                                      ? orderAmount
                                      : orderAmount),
                              style: textBold.copyWith(
                                  fontSize: Dimensions.fontSizeDefault,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color)),
                        ])),
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeSmall,
                        vertical: Dimensions.paddingSizeExtraSmall),
                    decoration: BoxDecoration(
                        color: myRequestModel!.status == 'New'
                            ? Theme.of(context)
                                .colorScheme
                                .onTertiaryContainer
                                .withValues(alpha: .10)
                            : myRequestModel!.status == 'Approved'
                                ? Theme.of(context)
                                    .primaryColor
                                    .withValues(alpha: .10)
                                : myRequestModel!.status == 'confirmed'
                                    ? Theme.of(context)
                                        .colorScheme
                                        .onTertiaryContainer
                                        .withValues(alpha: .10)
                                    : myRequestModel!.status == 'processing'
                                        ? Theme.of(context)
                                            .colorScheme
                                            .outline
                                            .withValues(alpha: .10)
                                        : myRequestModel!.status == 'Denied'
                                            ? Theme.of(context)
                                                .colorScheme
                                                .error
                                                .withValues(alpha: 0.10)
                                            : Theme.of(context)
                                                .colorScheme
                                                .secondary
                                                .withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(50)),
                    child: Text(
                        getTranslated('${myRequestModel!.status}', context) ??
                            '',
                        style: textMedium.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            fontWeight: FontWeight.w500,
                            color: myRequestModel!.status == 'New'
                                ? Theme.of(context)
                                    .colorScheme
                                    .onTertiaryContainer
                                : myRequestModel!.status == ''
                                    ? Theme.of(context).primaryColor
                                    : myRequestModel!.status == 'confirmed'
                                        ? Theme.of(context)
                                            .colorScheme
                                            .onTertiaryContainer
                                        : myRequestModel!.status == 'Approved'
                                            ? Theme.of(context)
                                                .colorScheme
                                                .outline
                                            : (myRequestModel!.status ==
                                                        'Denied' ||
                                                    myRequestModel!.status ==
                                                        "failed")
                                                ? Theme.of(context).colorScheme.error
                                                : Theme.of(context).colorScheme.secondary))),
              ]),
            ),
          ),
          Positioned(
              top: 2,
              left: Provider.of<LocalizationController>(context, listen: false)
                      .isLtr
                  ? 90
                  : MediaQuery.of(context).size.width - 50,
              child: Container(
                height: 22,
                width: 22,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle),
                child: FittedBox(
                    child: Text(
                  "${'1'}",
                  style: textRegular.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                )),
              )),
        ],
      ),
    );
  }
}
