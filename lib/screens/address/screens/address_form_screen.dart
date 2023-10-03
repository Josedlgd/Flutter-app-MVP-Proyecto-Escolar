import 'package:domas_ecommerce/constant/app_color.dart';
import 'package:domas_ecommerce/constants.dart';
import 'package:domas_ecommerce/models/models.dart';
import 'package:domas_ecommerce/providers/providers.dart';
import 'package:domas_ecommerce/screens/screens.dart';
import 'package:domas_ecommerce/services/services.dart';
import 'package:domas_ecommerce/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AddressFromScreen extends StatelessWidget {
  final String navTitle;
  final String title;
  final String subTitle;
  final Address address;
  final int index;
  const AddressFromScreen(
      {super.key,
      required this.navTitle,
      required this.title,
      required this.subTitle,
      required this.address,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(navTitle,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600)),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: SvgPicture.asset('assets/icons/Arrow-left.svg'),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        physics: const BouncingScrollPhysics(),
        children: [
          // Section 1 - Header
          Container(
            margin: const EdgeInsets.only(top: 20, bottom: 12),
            child: Text(
              title,
              style: const TextStyle(
                color: AppColor.secondary,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 32),
            child: Text(
              subTitle,
              style: TextStyle(
                  color: AppColor.secondary.withOpacity(0.7),
                  fontSize: 12,
                  height: 150 / 100),
            ),
          ),
          ChangeNotifierProvider(
            create: (_) => AddressFormProvider(),
            child: _AddressForm(
              address: address,
              index: index,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressForm extends StatelessWidget {
  final Address address;
  final int index;

  const _AddressForm({required this.address, required this.index});
  @override
  Widget build(BuildContext context) {
    final completeForm = Provider.of<AddressFormProvider>(context);
    if (address.street == '') {
      return Form(
        key: completeForm.formKey,
        child: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset('assets/icons/Location.svg',
                    color: AppColor.primary),
                const SizedBox(
                  width: 5,
                ),
                const Text(
                  'Dirección',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            TextFormField(
              autofocus: false,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                hintText: 'Ingresa tu calle',
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: AppColor.border, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: AppColor.primary, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                fillColor: AppColor.primarySoft,
                filled: true,
              ),
              onChanged: (value) => completeForm.street = value,
              validator: (value) {
                return (value != '')
                    ? null
                    : 'Debes ingresar el nombre de tu calle';
              },
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextFormField(
                    autofocus: false,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      errorStyle: const TextStyle(
                        fontSize: 0.0,
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                        gapPadding: 0,
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                        gapPadding: 0.0,
                      ),
                      hintText: 'Número exterior',
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: AppColor.border, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: AppColor.primary, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      fillColor: AppColor.primarySoft,
                      filled: true,
                    ),
                    onChanged: (value) {
                      if (int.tryParse(value) == null) {
                        completeForm.numberExt = 0;
                      } else {
                        completeForm.numberExt = int.parse(value);
                      }
                    },
                    validator: (value) {
                      return (value != '') ? null : '';
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                      autofocus: false,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        errorStyle: const TextStyle(
                          fontSize: 0.0,
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                          gapPadding: 0,
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                          gapPadding: 0.0,
                        ),
                        hintText: 'Número interior',
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: AppColor.border, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: AppColor.primary, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        fillColor: AppColor.primarySoft,
                        filled: true,
                      ),
                      onChanged: (value) {
                        if (int.tryParse(value) == null) {
                          completeForm.numberInt = -1;
                        } else {
                          completeForm.numberInt = int.parse(value);
                        }
                      }),
                ),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            TextFormField(
              autofocus: false,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Ingresa tu código postal',
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: AppColor.border, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: AppColor.primary, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                fillColor: AppColor.primarySoft,
                filled: true,
              ),
              onChanged: (value) {
                if (int.tryParse(value) == null) {
                  completeForm.zipCode = -1;
                } else {
                  completeForm.zipCode = int.parse(value);
                }
              },
              validator: (value) {
                return (value != '') ? null : 'Debes ingresar tu código postal';
              },
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            TextFormField(
              autofocus: false,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                hintText: 'Ingresa tu colonia',
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: AppColor.border, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: AppColor.primary, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                fillColor: AppColor.primarySoft,
                filled: true,
              ),
              onChanged: (value) => completeForm.neighborhood = value,
              validator: (value) {
                return (value != '') ? null : 'Debes ingresar una colonia';
              },
            ),
            SizedBox(height: getProportionateScreenHeight(40)),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: completeForm.isLoading
                    ? null
                    : () async {
                        FocusScope.of(context).unfocus();
                        final authFirebaseService = AuthFirebaseService();

                        if (!completeForm.isValidForm()) return;

                        completeForm.isLoading = true;

                        authFirebaseService
                            .addAddressToUser(Address(
                                neighborhood: completeForm.neighborhood,
                                numberExt: completeForm.numberExt,
                                numberInt: completeForm.numberInt,
                                street: completeForm.street,
                                zipCode: completeForm.zipCode))
                            .then((value) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ProfileScreen()));
                          NotificationsService.showSnackbar(
                              '¡Se agregó una nueva dirección!', sucessColor);
                        }).onError((error, stackTrace) =>
                                NotificationsService.showSnackbar(
                                    error.toString(), errorColor));
                      },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
                  backgroundColor: AppColor.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                child: const Text(
                  'Agregar dirección',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(40)),
          ],
        ),
      );
    } else {
      completeForm.neighborhood = address.neighborhood!;
      completeForm.street = address.street!;
      completeForm.numberExt = address.numberExt!;
      completeForm.numberInt = address.numberInt!;
      completeForm.zipCode = address.zipCode!;
      return Form(
        key: completeForm.formKey,
        child: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset('assets/icons/Location.svg',
                    color: AppColor.primary),
                const SizedBox(
                  width: 5,
                ),
                const Text(
                  'Dirección',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            TextFormField(
              initialValue: address.street,
              autofocus: false,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                hintText: 'Ingresa tu calle',
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: AppColor.border, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: AppColor.primary, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                fillColor: AppColor.primarySoft,
                filled: true,
              ),
              onChanged: (value) => completeForm.street = value,
              validator: (value) {
                return (value != '')
                    ? null
                    : 'Debes ingresar el nombre de tu calle';
              },
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: address.numberExt.toString(),
                    autofocus: false,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      errorStyle: const TextStyle(
                        fontSize: 0.0,
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                        gapPadding: 0,
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                        gapPadding: 0.0,
                      ),
                      hintText: 'Número exterior',
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: AppColor.border, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: AppColor.primary, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      fillColor: AppColor.primarySoft,
                      filled: true,
                    ),
                    onChanged: (value) {
                      if (int.tryParse(value) == null) {
                        completeForm.numberExt = 0;
                      } else {
                        completeForm.numberExt = int.parse(value);
                      }
                    },
                    validator: (value) {
                      return (value != '') ? null : '';
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                      autofocus: false,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        errorStyle: const TextStyle(
                          fontSize: 0.0,
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                          gapPadding: 0,
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                          gapPadding: 0.0,
                        ),
                        hintText: 'Número interior',
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: AppColor.border, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: AppColor.primary, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        fillColor: AppColor.primarySoft,
                        filled: true,
                      ),
                      onChanged: (value) {
                        if (int.tryParse(value) == null) {
                          completeForm.numberInt = -1;
                        } else {
                          completeForm.numberInt = int.parse(value);
                        }
                      }),
                ),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            TextFormField(
              initialValue: address.zipCode.toString(),
              autofocus: false,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Ingresa tu código postal',
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: AppColor.border, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: AppColor.primary, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                fillColor: AppColor.primarySoft,
                filled: true,
              ),
              onChanged: (value) {
                if (int.tryParse(value) == null) {
                  completeForm.zipCode = -1;
                } else {
                  completeForm.zipCode = int.parse(value);
                }
              },
              validator: (value) {
                return (value != '') ? null : 'Debes ingresar tu código postal';
              },
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            TextFormField(
              initialValue: address.neighborhood,
              autofocus: false,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                hintText: 'Ingresa tu colonia',
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: AppColor.border, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: AppColor.primary, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                fillColor: AppColor.primarySoft,
                filled: true,
              ),
              onChanged: (value) => completeForm.neighborhood = value,
              validator: (value) {
                return (value != '') ? null : 'Debes ingresar una colonia';
              },
            ),
            SizedBox(height: getProportionateScreenHeight(40)),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final authFirebaseService = AuthFirebaseService();
                  authFirebaseService.removeAddressAtIndex(index).then((value) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfileScreen()));
                    NotificationsService.showSnackbar(
                        'Se eliminó la direección', warningColor);
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                child: const Text(
                  'Eliminar',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: completeForm.isLoading
                    ? null
                    : () async {
                        FocusScope.of(context).unfocus();
                        final authFirebaseService = AuthFirebaseService();

                        if (!completeForm.isValidForm()) return;

                        completeForm.isLoading = true;

                        authFirebaseService
                            .updateAddressAtIndex(
                                index,
                                Address(
                                    neighborhood: completeForm.neighborhood,
                                    numberExt: completeForm.numberExt,
                                    numberInt: completeForm.numberInt,
                                    street: completeForm.street,
                                    zipCode: completeForm.zipCode))
                            .then((value) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ProfileScreen()));
                          NotificationsService.showSnackbar(
                              '¡Se actualizó una nueva dirección!',
                              sucessColor);
                        }).onError((error, stackTrace) =>
                                NotificationsService.showSnackbar(
                                    error.toString(), errorColor));
                      },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
                  backgroundColor: AppColor.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                child: const Text(
                  'Editar dirección',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(40)),
          ],
        ),
      );
    }
  }
}
