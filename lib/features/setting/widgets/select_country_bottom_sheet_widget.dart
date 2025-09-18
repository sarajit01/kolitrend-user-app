import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/address/domain/models/address_model.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Added for SVG flags
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:provider/provider.dart';

import '../../../main.dart'; // Assuming Get.context comes from here

class SelectCountryBottomSheetWidget extends StatefulWidget {
  final String? title;
  final String? selectedCountryCode;
  const SelectCountryBottomSheetWidget({super.key, this.title, this.selectedCountryCode});

  @override
  State<SelectCountryBottomSheetWidget> createState() =>
      _SelectCountryBottomSheetWidgetState();
}

class _SelectCountryBottomSheetWidgetState
    extends State<SelectCountryBottomSheetWidget> {
  String title = "";
  String? selectedCountryCode;

  @override
  void initState() {
    super.initState();
    // Initialize selectedIndex. Consider if it should come from SplashController
    // if a country is already selected. For now, defaulting to the first.
    title = widget.title ?? getTranslated("select_country", Get.context!)!;
    selectedCountryCode = widget.selectedCountryCode ;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Padding for the content inside, excluding draggable handle area (handle has its own padding)
      // This padding ensures content doesn't stick to edges and is keyboard safe.
      padding: EdgeInsets.only(
        left: Dimensions.paddingSizeDefault,
        right: Dimensions.paddingSizeDefault,
        bottom: MediaQuery.of(context).viewInsets.bottom + Dimensions.paddingSizeSmall, // Keyboard safe + space for button
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(Dimensions.paddingSizeDefault),
        ),
      ),
      child: Consumer<SplashController>(builder: (context, splashController, _) {
        return Column( // Main layout: Handle, Title, Scrollable List, Button
          mainAxisSize: MainAxisSize.min, // Crucial for bottom sheet height behavior
          children: [
            // Draggable handle
            Padding(
              padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeSmall),
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                    color: Theme.of(context).hintColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),

            // Fixed Title
            Text(
              title,
              style: textBold.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  color: Theme.of(context).textTheme.bodyLarge?.color),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: Dimensions.paddingSizeSmall,
                  bottom: Dimensions.paddingSizeDefault), // Space before the list starts
              child: Text(
                  '${getTranslated('Choose Country From List', context)}',
                  textAlign: TextAlign.center,
                  style: textRegular.copyWith(
                      color: Theme.of(context).textTheme.bodyLarge?.color)),
            ),

            // Scrollable Country List Area
            Expanded(
              child: (splashController.configModel != null &&
                  splashController.configModel!.countries != null &&
                  splashController.configModel!.countries!.isNotEmpty)
                  ? RepaintBoundary(
                child: ListView.builder(
                  // No shrinkWrap or NeverScrollableScrollPhysics needed here
                  // as ListView is now directly scrollable within Expanded.
                    padding: EdgeInsets.zero, // No extra padding for the ListView itself
                    itemCount:
                    splashController.configModel?.countries?.length,
                    itemBuilder: (context, index) {
                      final country = splashController.configModel!.countries![index];
                      // Assuming all countries displayed are active/selectable
                      final bool isActive = true;

                      if (!isActive) {
                        return const SizedBox.shrink(); // Skip inactive if any
                      }

                      // Use the actual country code from your model for the flag
                      String countryCodeForFlag = country.code?.toLowerCase() ?? '';

                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedCountryCode = country.code;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric( // Padding for each list item
                              vertical: Dimensions.paddingSizeExtraSmall),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeDefault,
                                vertical: Dimensions.paddingSizeEight),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.paddingSizeExtraSmall),
                                color: selectedCountryCode?.toLowerCase() == splashController.configModel!.countries![index].code?.toLowerCase()
                                    ? Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.1)
                                    : Colors.transparent // Or Theme.of(context).cardColor
                            ),
                            child: Row(
                              children: [
                                if (countryCodeForFlag.isNotEmpty)
                                  ClipOval(
                                    child: SvgPicture.network(
                                      'https://cdnjs.cloudflare.com/ajax/libs/flag-icons/7.2.0/flags/1x1/$countryCodeForFlag.svg',
                                      width: 30,
                                      height: 30,
                                      fit: BoxFit.cover,
                                      placeholderBuilder: (BuildContext context) =>
                                      const CircleAvatar( // Fallback while loading or if error
                                          radius: 15,
                                          backgroundColor: Colors.grey,
                                          child: Icon(Icons.public, size: 15, color: Colors.grey)),
                                    ),
                                  )
                                else // Fallback if no country code can be derived
                                  const CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Colors.grey,
                                    child: Icon(Icons.public, size: 15, color: Colors.grey),
                                  ),
                                const SizedBox(width: Dimensions.paddingSizeSmall),
                                Expanded(
                                  child: Text(
                                    "${country.name}" ?? getTranslated('not_available', context)!,
                                    style: textRegular.copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.color),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              )
                  : Center( // Display if the list of countries is empty or null
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    getTranslated("no_countries_available", context) ?? "No countries available",
                    style: textRegular.copyWith(color: Theme.of(context).hintColor),
                  ),
                ),
              ),
            ),

            // Fixed "Select" Button
            Padding(
              padding: const EdgeInsets.only(
                  top: Dimensions.paddingSizeDefault, // Space above the button
                  bottom: Dimensions.paddingSizeSmall // Ensures some space even if viewInsets.bottom is 0
              ),
              child: CustomButton(
                buttonText: '${getTranslated('select', context)}',
                onTap: () {
                  // Ensure countries list is not empty and an item is selectable
                  Navigator.pop(context , selectedCountryCode);
                },
              ),
            )
          ],
        );
      }),
    );
  }
}
