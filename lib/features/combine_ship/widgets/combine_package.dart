import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/domain/models/order_model.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import '../../../helper/date_converter.dart';
import '../../../helper/price_converter.dart';
import '../../../utill/custom_themes.dart';
import '../../../utill/dimensions.dart';

class CombineShipPackageWidget extends StatelessWidget {

  final Orders? orderModel;

  const CombineShipPackageWidget({super.key, this.orderModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Image.network(
                'https://kolitrend.com/public/assets/back-end/img/400x400/img2.jpg'),
          ),
        ),
        Container(
            padding:
            EdgeInsets.all(4),
            child:  Column(
              children: [
                Row(
                  children: [
                    Text('${orderModel!.orderType}'),
                    Spacer(),
                    Text("${orderModel!.receivedPackageWeight != null ? orderModel!.receivedPackageWeight : 0} Kg")
                  ],
                ),
                Row(
                  children: [
                    Text('${orderModel!.createdAtFormatted}'),
                    Spacer(),
                    Text('${orderModel!.deliveryServiceName != null ? orderModel!.deliveryServiceName : 'No Service added yet'}')
                  ],
                ),

                SizedBox(height: Dimensions.paddingSizeSmall),


                CustomButton(
                  onTap: () => {},
                    backgroundColor: Theme.of(context).primaryColor,
                    buttonText: "View Package"),
                SizedBox(height: Dimensions.paddingSizeSmall)

              ],
            ))
      ],
    );
  }

}