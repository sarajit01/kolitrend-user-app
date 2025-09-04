
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/address/domain/models/address_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/address/widgets/remove_address_bottom_sheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_svg/svg.dart';

import '../../../utill/custom_themes.dart';
import '../../../utill/dimensions.dart';
import '../../../utill/images.dart';
import '../screens/add_new_address_screen.dart';

class AddressCard extends StatefulWidget {

  AddressModel? address;
  int addressIndex;

  AddressCard({super.key , this.address, required this.addressIndex});

  @override
  State<AddressCard> createState() => _AddressCardState();

}

class _AddressCardState extends State<AddressCard> {

  late AddressModel? address;
  late int addressIndex;

  @override
  void initState() {
    super.initState();
    address = widget.address;
    addressIndex = widget.addressIndex;
  }

  @override
  Widget build(BuildContext context) {
    return

     address != null ?

      Container(
      padding: const EdgeInsets.all(
          Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(
              Dimensions.paddingSizeSmall)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            alignment: Alignment.centerLeft,
            width: double.infinity,
            padding: EdgeInsets.fromLTRB( 0, 0 , 0, 8),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.black.withAlpha(25)))
            ),
            child: Column(
              children: [
                Text('${address!.addressType?.toUpperCase()} (${getTranslated('Shipping Address'.toUpperCase(), context)})'
                  ,
                  style: textRegular.copyWith(
                      color: Theme.of(context).textTheme.bodyLarge?.color ,
                      fontWeight: FontWeight.normal
                  ),
                )
              ],
            ),
          ),


          SizedBox(height: 8),

          Text(
            '${getTranslated('First Name', context)} : ${address!.firstName}',
            style: textRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.color),
          ),

          SizedBox(height: 8),
          Text(
            '${getTranslated('Last Name', context)} : ${address!.lastName}',
            style: textRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.color),
          ),
          SizedBox(height: 8),
          Text(
            '${getTranslated('Company', context)} : ${address!.company}',
            style: textRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.color),
          ),
          SizedBox(height: 8),
          Text(
              '${getTranslated('address', context)} : ${address!.address}',
              style: textRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.color)),
          SizedBox(height: 8),

          Text(
            '${getTranslated('city', context)} : ${address!.city ?? ""}',
            style: textRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.color),
          ),
          SizedBox(height: 8),

          Text(
              '${getTranslated('zip', context)} : ${address!.zip ?? ""}',
              style: textRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.color)),
          SizedBox(height: 8),

          Row(
            children: [
              Text(
                '${getTranslated('Country', context)} : ${address!.country ?? ""}',
                style: textRegular.copyWith(
                    fontSize:
                    Dimensions.fontSizeDefault,
                    color: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.color),
              ),
              if (address!.countryCode !=
                  null)
                SizedBox(width: 8),
              ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child:  SvgPicture.network(
                    "https://cdnjs.cloudflare.com/ajax/libs/flag-icons/7.2.0/flags/1x1/${address!.countryCode!.toLowerCase()}.svg",
                    width: 24,
                  )
              )

            ],
          ),

          SizedBox(height: 8),

          Text(
            '${getTranslated('Phone', context)} : ${address!.phone ?? ""}',
            style: textRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.color),
          ),

          SizedBox(height: 8),

          Text(
            '${getTranslated('Email', context)} : ${address!.email ?? ""}',
            style: textRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.color),
          ),

          SizedBox(height: 8),

          Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => AddNewAddressScreen(
                                isBilling: address!.isBilling,
                                address: address,
                                isEnableUpdate: true))),
                    child: Container(
                      width: 40,
                      decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(5),
                          color: Theme.of(context)
                              .primaryColor
                              .withValues(alpha: .05)),
                      child: Padding(
                        padding: const EdgeInsets.all(
                            Dimensions.paddingSizeSmall),
                        child: Image.asset(Images.edit),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          backgroundColor:
                          Colors.transparent,
                          context: context,
                          builder: (_) =>
                              RemoveFromAddressBottomSheet(
                                  addressId: address!
                                      .id!,
                                  index: addressIndex));
                    },
                    child: Container(
                      width: 40,
                      decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(5),
                          color: Theme.of(context)
                              .primaryColor
                              .withValues(alpha: .05)),
                      child: const Padding(
                        padding: EdgeInsets.all(
                            Dimensions.paddingSizeSmall),
                        child: Icon(
                          Icons.delete_forever,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    ),

                    // child: const Padding(
                    //     padding: EdgeInsets.only(
                    //         top: Dimensions
                    //             .paddingSizeDefault),
                    //     child: Icon(
                    //       Icons.delete_forever,
                    //       color: Colors.red,
                    //       size: 30,
                    //     ))
                  )
                ],
              ))
        ],
      ),
    )

    :
      Text(getTranslated("Address data not found", context)!);

  }


}