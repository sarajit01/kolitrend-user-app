
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_asset_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/address/domain/models/address_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/domain/models/config_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/responsive_helper.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/widgets/code_picker_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../features/setting/widgets/select_country_bottom_sheet_widget.dart';
import '../../features/splash/controllers/splash_controller.dart';
import '../../localization/language_constrants.dart';
import '../../main.dart';

class CustomCountryFieldWidget extends StatefulWidget {
  final String? label;
  final String? selectedCountryCode;
  final ValueChanged<String>? onCountryChanged;

  const CustomCountryFieldWidget({
    super.key, this.label,
    this.selectedCountryCode,
    this.onCountryChanged
  });

  @override
  State<CustomCountryFieldWidget> createState() => _CustomCountryFieldWidgetState();
}

class _CustomCountryFieldWidgetState extends State<CustomCountryFieldWidget> {

  late String label;
  late String selectedCountryCode;
  late CountryModel? selectedCountry;

  @override
  void initState() {
    super.initState();
    label = widget.label ?? getTranslated("Select Country", context)!;
    selectedCountryCode = widget.selectedCountryCode ?? "tr";

    selectedCountry = Provider.of<SplashController>(context, listen: false).getCountryByCode(selectedCountryCode);

  }

  @override
  void dispose() {
    super.dispose();
  }

  void _openCountryBottomSheet() async {
    final value = await showModalBottomSheet<CountryModel?>(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext _bc){
          return FractionallySizedBox(
            heightFactor: 0.7,
            child: SelectCountryBottomSheetWidget(
              title: getTranslated("Select ${label}", context),
              selectedCountryCode: selectedCountryCode,
            ),
          );
        }
    );
    if (value != null) {
      print("Value from bottom sheet of custom country textfield");
      print(value.name);
      setState(()  {
        selectedCountryCode = value.code!;
        selectedCountry = value;
        widget.onCountryChanged?.call(value.code!);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _openCountryBottomSheet,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
                SizedBox(height: 4),
                Container(
                  height: 55,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(
                      vertical:
                      Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          Dimensions.paddingSizeSmall),
                      color: Theme.of(context).cardColor,
                      border: Border.all(
                          color: Theme.of(context)
                              .hintColor
                              .withValues(alpha: .5))),
                  child:
                  Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.center,
                    spacing: 4,
                    children: [
                      SizedBox(width: 8),
                      SvgPicture.network(
                        'https://cdnjs.cloudflare.com/ajax/libs/flag-icons/7.2.0/flags/1x1/${selectedCountryCode.toLowerCase()}.svg',
                        width: 24, // Adjust size as needed
                        height: 24, // Adjust size as needed
                        fit: BoxFit
                            .cover, // Ensures the SVG covers the circular area
                        // Optional: Apply a color filter if the SVGs are monochrome and need to match icon theme
                        // colorFilter: ColorFilter.mode(Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white, BlendMode.srcIn),
                        placeholderBuilder:
                            (BuildContext context) => Icon(
                            Icons.flag_outlined,
                            color: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.color),
                      ),
                      SizedBox(width: 4),
                      Text(
                        getTranslated(
                            "${selectedCountry?.name}", Get.context!)!
                        ,
                        style: textRegular.copyWith(
                            color: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .color,
                            fontSize:
                            Dimensions.fontSizeLarge),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      )

    );
  }

}
