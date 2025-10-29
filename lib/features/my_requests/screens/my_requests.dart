import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_with_action_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/request_filter_dialog_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/my_requests/controllers/my_requests_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/my_requests/widgets/my_request_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/controllers/order_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/widgets/order_shimmer_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/widgets/order_type_button_widget.dart';
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

class MyRequestsScreen extends StatefulWidget {
  final bool isBacButtonExist;
  const MyRequestsScreen({super.key, this.isBacButtonExist = true});

  @override
  State<MyRequestsScreen> createState() => _MyRequestsScreenState();
}

class _MyRequestsScreenState extends State<MyRequestsScreen> {
  ScrollController scrollController = ScrollController();
  bool isGuestMode =
      !Provider.of<AuthController>(Get.context!, listen: false).isLoggedIn();
  @override
  void initState() {
    if (!isGuestMode) {
      Provider.of<MyRequestsController>(context, listen: false)
          .setIndex(0, notify: false);
      Provider.of<MyRequestsController>(context, listen: false)
          .getMyRequestsList(1, '', 'buy_for_me');
    }
    super.initState();
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
          title: getTranslated('My Requests', context),
          actionIconWidget: filterIconWidget,
          onActionPressed: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor:
                Colors.transparent,
                builder: (c) =>
                    RequestsFilterDialog()
            );
          },
          isBackButtonExist: widget.isBacButtonExist),
      body: isGuestMode
          ? NotLoggedInWidget(
              message: getTranslated('to_view_the_order_history', context))
          : Consumer<MyRequestsController>(
              builder: (context, myRequestController, child) {
              return Column(
                children: [
                  // Padding(
                  //     padding:
                  //         const EdgeInsets.all(Dimensions.paddingSizeLarge),
                  //     child: Row(children: [
                  //       OrderTypeButton(
                  //           text: getTranslated('Buy For Me', context),
                  //           index: 0),
                  //       const SizedBox(width: Dimensions.paddingSizeSmall),
                  //       OrderTypeButton(
                  //           text: getTranslated('Kolitrend', context),
                  //           index: 1),
                  //       const SizedBox(width: Dimensions.paddingSizeSmall),
                  //       OrderTypeButton(
                  //           text: getTranslated('Combine & Ship', context),
                  //           index: 2)
                  //     ])),
                  Expanded(
                      child: myRequestController.myRequestModel != null
                          ? (myRequestController.myRequestModel!.myRequests !=
                                      null &&
                                  myRequestController
                                      .myRequestModel!.myRequests!.isNotEmpty)
                              ? SingleChildScrollView(
                                  controller: scrollController,
                                  child: PaginatedListView(
                                    scrollController: scrollController,
                                    onPaginate: (int? offset) async {
                                      await myRequestController
                                          .getMyRequestsList(offset!, '',
                                              myRequestController.selectedType);
                                    },
                                    totalSize: myRequestController
                                        .myRequestModel?.totalSize,
                                    offset: myRequestController
                                                .myRequestModel?.offset !=
                                            null
                                        ? int.parse(myRequestController
                                            .myRequestModel!.offset!)
                                        : 1,
                                    itemView: ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: myRequestController
                                          .myRequestModel?.myRequests!.length,
                                      padding: const EdgeInsets.all(0),
                                      itemBuilder: (context, index) =>
                                          MyRequestWidget(
                                              myRequestModel:
                                                  myRequestController
                                                      .myRequestModel
                                                      ?.myRequests![index]),
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
