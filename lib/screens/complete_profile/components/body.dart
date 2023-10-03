import 'package:domas_ecommerce/components/default_button.dart';
import 'package:domas_ecommerce/constant/app_color.dart';
import 'package:domas_ecommerce/constants.dart';
import 'package:domas_ecommerce/models/models.dart';
import 'package:domas_ecommerce/providers/providers.dart';
import 'package:domas_ecommerce/screens/screens.dart';
import 'package:domas_ecommerce/services/services.dart';
import 'package:domas_ecommerce/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      physics: const BouncingScrollPhysics(),
      children: [
        // Section 1 - Header
        Container(
          margin: const EdgeInsets.only(top: 20, bottom: 12),
          child: const Text(
            'Estás a punto de ser parte de DoMas',
            style: TextStyle(
              color: AppColor.secondary,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 32),
          child: Text(
            'Completa tu perfil ingresando \ntu información personal.',
            style: TextStyle(
                color: AppColor.secondary.withOpacity(0.7),
                fontSize: 12,
                height: 150 / 100),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => CompleteFormProvider(),
          child: _CompleteProfileForm(),
        ),
      ],
    );
  }
}

class _CompleteProfileForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final completeForm = Provider.of<CompleteFormProvider>(context);
    return Form(
      key: completeForm.formKey,
      child: Column(
        children: [
          Row(
            children: [
              SvgPicture.asset('assets/icons/Profile.svg',
                  color: AppColor.primary),
              const SizedBox(
                width: 5,
              ),
              const Text(
                'Datos personales',
                textAlign: TextAlign.start,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ],
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          TextFormField(
            autofocus: false,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              hintText: 'Ingresa tu nombre(s)',
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColor.border, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColor.primary, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              fillColor: AppColor.primarySoft,
              filled: true,
            ),
            onChanged: (value) => completeForm.name = value,
            validator: (value) {
              RegExp regExp = nameValidatorRegExp;

              return regExp.hasMatch(value ?? '') ? null : invalidNameError;
            },
          ),
          SizedBox(height: getProportionateScreenHeight(20)),
          TextFormField(
            autofocus: false,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              hintText: 'Ingresa tu apellido(s)',
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColor.border, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColor.primary, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              fillColor: AppColor.primarySoft,
              filled: true,
            ),
            onChanged: (value) => completeForm.lastName = value,
            validator: (value) {
              RegExp regExp = nameValidatorRegExp;

              return regExp.hasMatch(value ?? '') ? null : invalidLastNameError;
            },
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            width: double.infinity,
            height: 2,
            color: AppColor.border,
          ),
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
                borderSide: const BorderSide(color: AppColor.border, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColor.primary, width: 1),
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
                borderSide: const BorderSide(color: AppColor.border, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColor.primary, width: 1),
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
                borderSide: const BorderSide(color: AppColor.border, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColor.primary, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              fillColor: AppColor.primarySoft,
              filled: true,
            ),
            onChanged: (value) => completeForm.neighborhood = value,
            validator: (value) {
              return (value != '')
                  ? null
                  : 'Debes ingresar una dirección válida';
            },
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            width: double.infinity,
            height: 2,
            color: AppColor.border,
          ),
          Row(
            children: [
              SvgPicture.asset('assets/icons/Bookmark.svg',
                  color: AppColor.primary),
              const SizedBox(
                width: 5,
              ),
              const Text(
                'Contacto',
                textAlign: TextAlign.start,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ],
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          TextFormField(
            autofocus: false,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: 'Ingresa tu teléfono',
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColor.border, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColor.primary, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              fillColor: AppColor.primarySoft,
              filled: true,
            ),
            onChanged: (value) => completeForm.phoneNumber = int.parse(value),
            validator: (value) {
              RegExp regExp = phoneValidatorRegExp;

              return regExp.hasMatch(value ?? '') ? null : invalidPhoneError;
            },
          ),
          SizedBox(height: getProportionateScreenHeight(20)),
          TextFormField(
            autofocus: false,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              hintText: 'Ingresa el alías',
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColor.border, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColor.primary, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              fillColor: AppColor.primarySoft,
              filled: true,
            ),
            onChanged: (value) => completeForm.contactName = value,
            validator: (value) {
              return (value != '') ? null : 'Debes ingresar el alias';
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

                      Address address = Address(
                          neighborhood: completeForm.neighborhood,
                          numberExt: completeForm.numberExt,
                          numberInt: completeForm.numberInt,
                          street: completeForm.street,
                          zipCode: completeForm.zipCode);

                      List<Address> addresses = [address];

                      PhoneNumber phoneNumber = PhoneNumber(
                          contactName: completeForm.contactName,
                          phoneNumber: completeForm.phoneNumber);

                      List<PhoneNumber> phoneNumbers = [phoneNumber];

                      UserApp userApp = UserApp(
                          addresses: addresses,
                          lastName: completeForm.lastName,
                          name: completeForm.name,
                          phoneNumbers: phoneNumbers);

                      final String? errorMessagge =
                          authFirebaseService.createUserDB(userApp);

                      if (errorMessagge == null) {
                        Navigator.pushReplacementNamed(
                            context, HomeScreen.routeName);
                        NotificationsService.showSnackbar(
                            '¡Se ha completado tu perfil!', sucessColor);
                      } else {
                        NotificationsService.showSnackbar(
                            errorMessagge, errorColor);
                      }
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
                'Completar perfil',
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
