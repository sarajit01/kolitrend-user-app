import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_with_action_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/order_filter_dialog_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/controllers/order_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/widgets/order_shimmer_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/widgets/order_status_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/widgets/order_type_button_widget.dart'; // Assuming this is where OrderTypeButton is defined
import 'package:flutter_sixvalley_ecommerce/features/order/widgets/order_widget.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/no_internet_screen_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/not_loggedin_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/paginated_list_view_widget.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  final bool isBacButtonExist;
  const OrderScreen({super.key, this.isBacButtonExist = true});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  ScrollController scrollController = ScrollController();
  bool isGuestMode =
      !Provider.of<AuthController>(Get.context!, listen: false).isLoggedIn();
  @override
  void initState() {
    super.initState();
    // Ensure getOrderStatuses also notifies listeners or updates a list that Consumer can react to.
    Provider.of<OrderController>(context, listen: false)
        .getOrderStatuses()
        .then((_) {
      // After statuses are fetched, set the initial index if needed and load orders.
      // This logic might need adjustment based on how OrderController handles initial state.
      if (!isGuestMode &&
          mounted &&
          Provider.of<OrderController>(context, listen: false)
                  .orderStatusList != // Assuming orderStatusList is the name in OrderController
              null &&
          Provider.of<OrderController>(context, listen: false)
              .orderStatusList!
              .isNotEmpty) {
        Provider.of<OrderController>(context, listen: false)
            .setIndex(0, notify: true); // Notify to update UI with selected tab
        // getOrderList is called within setIndex in the controller
      } else if (!isGuestMode) {
        // Fallback if statuses couldn't be loaded, or handle as error
        // Or, if setIndex(0) implicitly handles 'ongoing' without API-fetched statuses initially:
         Provider.of<OrderController>(context, listen: false).setIndex(0, notify: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    Widget filterIconWidget =  Container(
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border.all(
                color:
                Theme.of(context).primaryColor.withValues(alpha: .5)),
            borderRadius:
            BorderRadius.circular(Dimensions.paddingSizeExtraSmall)),
        width: 30,
        height: 30,
        child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Image.asset(Images.filterImage,
                color: Theme.of(context).textTheme.bodyLarge?.color)
        )
    );

    return Scaffold(
      appBar: CustomAppBarWithAction(
          title: getTranslated('order', context),
          showActionButton: true,
          isBackButtonExist: widget.isBacButtonExist,
          actionIconWidget: filterIconWidget,
          onActionPressed: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor:
                Colors.transparent,
                builder: (c) =>
                    OrderFilterDialog()
            );
          },

      ),

      body: isGuestMode
          ? NotLoggedInWidget(
              message: getTranslated('to_view_the_order_history', context))
          : Consumer<OrderController>(
              builder: (context, orderController, child) {
              // Assuming orderController.orderStatusList is the list of status objects
              // And each status object has a 'localizationKey' (e.g., 'RUNNING', 'DELIVERED')
              // And OrderController.setIndex(index) now uses this index to correctly
              // set its internal 'selectedType' based on this orderStatusList.

              return Column(
                children: [
                  // if (orderController.orderStatusList != null &&
                  //     orderController.orderStatusList!.isNotEmpty)
                  //   Padding(
                  //       padding:
                  //           const EdgeInsets.all(Dimensions.paddingSizeLarge),
                  //       child: SingleChildScrollView(
                  //         scrollDirection: Axis.horizontal,
                  //         physics: const BouncingScrollPhysics(),
                  //         child: Row(
                  //           children: List.generate(
                  //             orderController.orderStatusList!.length,
                  //             (int index) {
                  //               // IMPORTANT: Replace 'localizationKey' with the actual property name
                  //               // in your status object that holds the translation key.
                  //               // If the name itself is the key (like 'RUNNING'), use status.name or similar.
                  //               var status = orderController.orderStatusList![index];
                  //               String buttonText = getTranslated(getTranslated(status.statusName, context), context) ?? status.statusName!;
                  //
                  //               return Padding(
                  //                 padding: EdgeInsetsDirectional.only(
                  //                     end: index == orderController.orderStatusList!.length - 1
                  //                         ? 0
                  //                         : Dimensions.paddingSizeSmall),
                  //                 child: OrderStatusTypeButton( // Ensure OrderTypeButton is the correct widget name
                  //                   orderStatus: status, // Use the correct property name
                  //                 ),
                  //               );
                  //             },
                  //           ),
                  //         ),
                  //       ))
                  // else
                  //   Container( // Placeholder while statuses are loading or if empty
                  //     height: 50, // Adjust height as needed
                  //     alignment: Alignment.center,
                  //     // child: CircularProgressIndicator(), // Optional: show a loader
                  //   ),

                  SizedBox(height: 12),

                  Expanded(
                      child: orderController.orderModel != null
                          ? (orderController.orderModel!.orders != null &&
                                  orderController
                                      .orderModel!.orders!.isNotEmpty)
                              ? SingleChildScrollView(
                                  controller: scrollController,
                                  child: PaginatedListView(
                                    scrollController: scrollController,
                                    onPaginate: (int? offset) async {
                                      await orderController.getOrderList(
                                          offset!,
                                          orderController.selectedType);
                                    },
                                    totalSize:
                                        orderController.orderModel?.totalSize,
                                    offset: orderController
                                                .orderModel?.offset !=
                                            null
                                        ? int.parse(
                                            orderController.orderModel!.offset!)
                                        : 1,
                                    itemView: ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: orderController
                                          .orderModel?.orders!.length,
                                      padding: const EdgeInsets.all(0),
                                      itemBuilder: (context, index) =>
                                          OrderWidget(
                                              orderModel: orderController
                                                  .orderModel?.orders![index]),
                                    ),
                                  ),
                                )
                              : const NoInternetOrDataScreenWidget(
                                  isNoInternet: false,
                                  icon: Images.noOrder,
                                  message: 'no_order_found',
                                )
                          : const OrderShimmerWidget())
                ],
              );
            }),
    );
  }
}
