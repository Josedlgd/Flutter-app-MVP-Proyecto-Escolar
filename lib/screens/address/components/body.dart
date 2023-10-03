import 'package:domas_ecommerce/constant/app_color.dart';
import 'package:domas_ecommerce/models/models.dart';
import 'package:domas_ecommerce/screens/address/screens/address_form_screen.dart';
import 'package:domas_ecommerce/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class Body extends StatelessWidget {
  const Body({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserApp>(
      future: Provider.of<AuthFirebaseService>(context).getUserData(),
      builder: (context, AsyncSnapshot<UserApp> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final userAppData = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: userAppData.addresses.length,
            itemBuilder: (BuildContext context, int index) {
              // Section 2 - Shipping Information
              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 12, bottom: 20),
                decoration: BoxDecoration(
                  color: AppColor.primarySoft,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColor.border, width: 1),
                ),
                child: Column(
                  children: [
                    // header
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Información de envío',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColor.secondary),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => AddressFromScreen(
                                        address: userAppData.addresses[index],
                                        navTitle: 'Editar una dirección',
                                        subTitle:
                                            'Completa los datos para editar \nla dirección.',
                                        title: 'Puedes editar la dirección',
                                        index: index,
                                      )));
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: AppColor.primary,
                              shape: const CircleBorder(),
                              backgroundColor: AppColor.border,
                              elevation: 0,
                              padding: const EdgeInsets.all(0),
                            ),
                            child: SvgPicture.asset(
                              'assets/icons/Pencil.svg',
                              width: 16,
                              color: AppColor.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Name
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 12),
                            child: SvgPicture.asset('assets/icons/Profile.svg',
                                width: 18),
                          ),
                          Expanded(
                            child: Text(
                              "${userAppData.name} ${userAppData.lastName}",
                              style: TextStyle(
                                color: AppColor.secondary.withOpacity(0.7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Address
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 12),
                            child: SvgPicture.asset('assets/icons/Home.svg',
                                width: 18),
                          ),
                          Expanded(
                            child: Text(
                              "${userAppData.addresses[index].street} #${userAppData.addresses[index].numberExt}, ${userAppData.addresses[index].neighborhood}, ${userAppData.addresses[index].zipCode}.",
                              style: TextStyle(
                                color: AppColor.secondary.withOpacity(0.7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Phone Number
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 12),
                          child: SvgPicture.asset('assets/icons/Profile.svg',
                              width: 18),
                        ),
                        Expanded(
                          child: Text(
                            "${userAppData.phoneNumbers[0].phoneNumber}",
                            style: TextStyle(
                              color: AppColor.secondary.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          return const Text('No user data');
        }
      },
    );
  }
}
