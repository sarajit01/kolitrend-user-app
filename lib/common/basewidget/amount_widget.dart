import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/tappable_tooltip.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class AmountWidget extends StatelessWidget {
  final String? title;
  final String amount;
  final String? hintText;

  const AmountWidget(
      {super.key, required this.title, required this.amount, this.hintText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: Dimensions.paddingSizeExtraSmall),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 4,
          children: [
            if (hintText != null)
              TappableTooltip(
                  child: Container(
                    padding: EdgeInsets.all(4), // Padding around the icon
                    decoration: BoxDecoration(
                      color: Colors
                          .grey.shade300, // Light background for the circle
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.question_mark_rounded,
                      size: 16, // Small icon size
                      color: Colors.grey.shade700, // Icon color
                    ),
                  ),
                  message: hintText!),
            Text(title!,
                style: titilliumRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .color!
                        .withValues(alpha: .65))),
          ],
        ),
        Text(amount,
            style: titilliumRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: Theme.of(context).textTheme.bodyLarge?.color)),
      ]),
    );
  }
}
