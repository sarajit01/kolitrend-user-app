import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/address/controllers/address_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/address/widgets/address_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/features/address/widgets/address_widget.dart';
import 'package:flutter_sixvalley_ecommerce/localization/app_localization.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/no_internet_screen_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/address/widgets/remove_address_bottom_sheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/address/screens/add_new_address_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AddressListScreen extends StatefulWidget {
  const AddressListScreen({super.key});
  @override
  State<AddressListScreen> createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {
  @override
  void initState() {
    Provider.of<AddressController>(context, listen: false)
        .getAddressList(all: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('addresses', context)),
      floatingActionButton: FloatingActionButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => const AddNewAddressScreen(isBilling: false))),
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.add, color: Theme.of(context).highlightColor)),
      body: Consumer<AddressController>(
        builder: (context, locationProvider, child) {
          return locationProvider.addressList != null
              ?
                 locationProvider.addressList!.isEmpty
                  ? const NoInternetOrDataScreenWidget(
                      isNoInternet: false,
                      message: 'no_address_found',
                      icon: Images.noAddress,
                    )
                  : RefreshIndicator(
                      onRefresh: () async =>
                          await locationProvider.getAddressList(),
                      backgroundColor: Theme.of(context).secondaryHeaderColor,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(0),
                        itemCount: locationProvider
                            .addressList?.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  Dimensions.paddingSizeDefault,
                                  Dimensions.paddingSizeDefault,
                                  Dimensions.paddingSizeDefault,
                                  0),
                              child: AddressCard(
                                addressIndex: index,
                                address: locationProvider.addressList?[index],
                              ));
                        },
                      ))


              : const AddressShimmerWidget();
        },
      ),
    );
  }
}
