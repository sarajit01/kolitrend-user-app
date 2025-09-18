import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/controllers/order_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/domain/models/order_status_model.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:provider/provider.dart';

class OrderStatusTypeButton extends StatelessWidget {
  final OrderStatusModel orderStatus;

  const OrderStatusTypeButton({super.key, required this.orderStatus});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<OrderController>(builder: (context, orderController, _) {
        return TextButton(
          onPressed: () => orderController.setSelectedStatus(orderStatus),
          style: TextButton.styleFrom(padding: const EdgeInsets.all(0)),
          child: Container(
            height: 35,
            padding: EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: orderController.selectedStatus?.value == orderStatus.value
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).primaryColor.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(50)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(orderStatus.statusName!,
                    style: titilliumBold.copyWith(
                        color: Provider.of<ThemeController>(context).darkTheme
                            ? Theme.of(context).textTheme.bodyLarge?.color
                            : orderController.selectedStatus?.value != orderStatus.value
                                ? Theme.of(context).textTheme.bodyLarge?.color
                                : Theme.of(context).cardColor)),
                const SizedBox(width: 5),
              ],
            ),
          ),
        );
      }),
    );
  }
}
