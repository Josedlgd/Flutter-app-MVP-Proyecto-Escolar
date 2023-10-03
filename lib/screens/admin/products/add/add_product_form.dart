import 'dart:io';

import 'package:card_swiper/card_swiper.dart';
import 'package:domas_ecommerce/components/components.dart';
import 'package:domas_ecommerce/constants.dart';
import 'package:domas_ecommerce/controllers/general.dart';
import 'package:domas_ecommerce/models/models.dart';
import 'package:domas_ecommerce/services/sections_service.dart';
import 'package:domas_ecommerce/services/services.dart';
import 'package:domas_ecommerce/size_config.dart';
import 'package:domas_ecommerce/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddProductForm extends StatefulWidget {
  const AddProductForm({
    Key? key,
  }) : super(key: key);

  @override
  State<AddProductForm> createState() => _AddProductFormState();
}

//*FORM PRODUCT
class _AddProductFormState extends State<AddProductForm> {
  //NOTE //* SERVICES

  List<File> _lastUpdatPrincipalImages = [];

  List<File> get listOfImagesToSend => _lastUpdatPrincipalImages;

  set lastUpdatPrincipalImages(List<File> value) {
    _lastUpdatPrincipalImages = value;
  }

  File? _lastUpdateVariantImages;

  File? get lastUpdateVariantImages => _lastUpdateVariantImages;

  set lastUpdateVariantImages(File? value) {
    _lastUpdateVariantImages = value;
  }

  ProductsService get productService => GetIt.instance<ProductsService>();
  CategoriesService get categoriesService =>
      GetIt.instance<CategoriesService>();

  //NOTE //* VARIANTS

  bool _variantsForProduct = true;

  bool get variantsForProduct => _variantsForProduct;
  set variantsForProduct(bool value) {
    _variantsForProduct = value;
  }

  bool _productHasMultipleSize = true;

  bool get productHasMultipleSize => _productHasMultipleSize;

  set productHasMultipleSize(bool value) {
    _productHasMultipleSize = value;
  }

  CategoriesService? categoryService;
  SectionService? sectionService;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    variantsForProduct = productService.product.titleOptions != null &&
            productService.product.titleOptions!.isNotEmpty &&
            productService.product.productOptions != null &&
            productService.product.productOptions!.isNotEmpty
        ? true
        : false;
  }

  //NOTE   // * ----------------------------- SAVE IMAGES FILES  * ----------------------------- //

  onTapSelectPicture(
      {required ImageSource howUpload, required String whereToSave}) async {
    final picker = ImagePicker();

    Navigator.of(context).pop();

    final XFile? pickedFile =
        await picker.pickImage(source: howUpload, imageQuality: 100);

    if (pickedFile != null) {
      final imageToAdd = File(pickedFile.path);
      switch (whereToSave) {
        case 'principal':
          productService.selectedPictures.isEmpty
              ? productService.selectedPictures = [imageToAdd]
              : productService.selectedPictures.add(imageToAdd);
          debugPrint(
              'Imagen guardada Principal: ${productService.selectedPictures.last.path}');
          setState(() {});
          break;
        case 'variants':
          productService.selectedPictureForDetails = imageToAdd;
          productService.selectedPicturesForDetails.isEmpty
              ? productService.selectedPicturesForDetails = [imageToAdd]
              : productService.selectedPicturesForDetails.add(imageToAdd);
          debugPrint(
              'Imagen guardada Detalles: ${productService.selectedPicturesForDetails.last.path}');
          setState(() {});
          break;
        default:
          break;
      }
    }
  }

  // * ----------------------------- WIDGET SELECTED PICTURES FOR MAIN * ----------------------------- //
  Widget buildWidgetSelectPicture() {
    return Stack(
      alignment: AlignmentDirectional.topStart,
      children: [
        productService.selectedPictures.isEmpty
            ? ClipRRect(
                borderRadius: const BorderRadius.all(
                    Radius.circular(borderRadiusImagesProduct)),
                child: getImage(null),
              )
            : SizedBox(
                width: SizeConfig.screenWidth,
                height: SizeConfig.screenHeight / 3,
                child: Center(
                  child: Swiper(
                    itemCount: productService.selectedPictures.length,
                    viewportFraction: 0.8,
                    scale: 0.9,
                    itemWidth: SizeConfig.screenWidth * 0.8, //0.6
                    itemHeight: SizeConfig.screenHeight * 0.4, //0.4
                    itemBuilder: (_, index) {
                      String productImage;
                      if (productService.selectedPictures[index] is! File &&
                          productService.selectedPictures[index] is String) {
                        productImage = productService.selectedPictures[index];
                      } else {
                        productImage =
                            productService.selectedPictures[index].path;
                      }

                      return Center(
                        child: Stack(
                          alignment: AlignmentDirectional.topStart,
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: getImage(productImage)),
                            if (productService.selectedPictures.isNotEmpty)
                              Positioned(
                                  bottom: 20,
                                  left: 20,
                                  child: IconButton(
                                    tooltip: 'Eliminar',
                                    iconSize: sizeGeneralIcon / 2,
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return Wrap(
                                            children: [
                                              ListTile(
                                                  leading:
                                                      const Icon(Icons.delete),
                                                  title: const Text(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      'Eliminar'),
                                                  onTap: () {
                                                    setState(() {
                                                      productService
                                                          .selectedPictures
                                                          .removeAt(index);
                                                    });
                                                    Navigator.of(context).pop();
                                                  }),
                                              ListTile(
                                                  leading:
                                                      const Icon(Icons.cancel),
                                                  title: const Text(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      'Conservar imagen'),
                                                  onTap: () =>
                                                      Navigator.of(context)
                                                          .pop())
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.delete_forever_rounded,
                                      color: primaryColorStrong,
                                      size: sizeGeneralIcon,
                                    ),
                                  )),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
        builButtonToSelectCamera(whereStore: 'principal')
      ],
    );
  }

  // * ----------------------------- WIDGET TO OPTIONS PICK FILE * ----------------------------- //
  Widget builButtonToSelectCamera({required String whereStore}) {
    return Positioned(
        top: 20,
        right: 20,
        child: IconButton(
          tooltip: 'Presioname',
          iconSize: sizeGeneralIcon / 2,
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return Wrap(
                  children: [
                    ListTile(
                        leading: const Icon(Icons.camera_alt_outlined),
                        title: const Text(
                            overflow: TextOverflow.ellipsis, 'Abrir cámara'),
                        onTap: () {
                          onTapSelectPicture(
                              howUpload: ImageSource.camera,
                              whereToSave: whereStore);
                        }),
                    ListTile(
                        leading: const Icon(Icons.browse_gallery),
                        title: const Text(
                            overflow: TextOverflow.ellipsis,
                            'Seleccionar de galería'),
                        onTap: () {
                          onTapSelectPicture(
                              howUpload: ImageSource.gallery,
                              whereToSave: whereStore);
                        })
                  ],
                );
              },
            );
          },
          icon: const Icon(
            Icons.camera_alt_rounded,
            color: primaryColorStrong,
            size: sizeGeneralIcon,
          ),
        ));
  }

  //NOTE -  //!build functions
  Widget buildFlexTextValue({required String label, required String value}) {
    return Flex(
      direction: Axis.horizontal,
      children: [
        Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.only(left: paddingHorizontal / 2),
              child: Text(
                overflow: TextOverflow.ellipsis,
                label,
                style: txtStyleBodyBlackStrong,
              ),
            )),
        Expanded(
            flex: 6,
            child: Text(
              overflow: TextOverflow.ellipsis,
              value,
              style: txtStyleBodyBlackStrong,
            )),
      ],
    );
  }

  List<Widget> inputsVariantProducts() => [
        //* ----------------------------  VARIANTES DE PRODUCTO ---------------------------- *//
        SwitchListTile.adaptive(
            activeColor: primaryColorStrong,
            title: const Text(
              overflow: TextOverflow.clip,
              '¿Vendes más variables del mismo producto (Colores / Marcas) ?',
              style: txtStyleBodyBlackStrong,
            ),
            value: variantsForProduct,
            onChanged: (bool newValue) {
              setState(() {
                variantsForProduct = newValue;
              });
            }),
        if (variantsForProduct)
          ...List.generate(buildWidgetVariants().length,
              (index) => buildWidgetVariants()[index]),
        if (productService.product.productOptions != null &&
            productService.product.productOptions!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: paddingVertical),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: paddingVertical, horizontal: paddingHorizontal),
                child: ListView.separated(
                  itemCount: productService.product.productOptions!.length,
                  shrinkWrap: true,
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(
                    color: primaryColor,
                    height: paddingVertical * 2,
                    thickness: 2.0,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return ItemVariantProduct(
                      file:
                          productService.product.productOptions![index].imagen!,
                      nameVariant: productService
                          .product.productOptions![index].optionName!,
                    );
                  },
                ),
              ),
            ),
          )
        else
          const SizedBox(height: paddingVertical * 6),
      ];

  //NOTE // * ----------------------------- ALL INPUTS FOR BUILD WIDGET * ----------------------------- //
  List<Widget> inputsProductForm() => [
        const SizedBox(height: paddingVertical * 6),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: paddingVertical),
          child: Center(
            child: buildWidgetMarginHrzAllScreen(buildWidgetSelectPicture()),
          ),
        ),
        //* ----------------------------  INFORMACION BASICA ---------------------------- *//
        const Text(
          overflow: TextOverflow.ellipsis,
          'Información de producto',
          style: txtStyleSubTitleBlack,
        ),
        TextFormField(
          obscureText: false,
          initialValue: productService.product.name,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            labelText: 'Nombre del producto',
            hintText: "Ingresa un nombre",
            prefixIconColor: primaryColor,
            prefixIcon: Icon(
              Icons.title,
            ),
          ),
          onChanged: (value) => productService.product.name = value,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingresa el nombre de tu articulo';
            } else {
              return null;
            }
          },
        ),
        //! PRODUCT DESCRIPTION
        TextFormField(
          minLines: 1,
          maxLines: 2, // allow user to enter 5 line in textfield
          keyboardType: TextInputType.multiline, obscureText: false,
          initialValue: productService.product.description,
          decoration: const InputDecoration(
            labelText: 'Descripción del producto',
            hintText: "Ingresa una descripción",
            prefixIconColor: primaryColor,
            prefixIcon: Icon(
              Icons.description,
            ),
          ),
          onChanged: (value) => setState(() {
            productService.product.description = value;
          }),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingresa descripción valida';
            } else {
              return null;
            }
          },
        ),

        if (productService.product.description!.isNotEmpty)
          SizedBox(
            width: SizeConfig.screenWidth,
            child: Card(
              elevation: 4.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: paddingVertical / 2,
                          horizontal: paddingHorizontal),
                      child: Text(
                        'Descripción del producto',
                        style: txtStyleSubTitlePurpleStrong,
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: paddingVertical,
                        horizontal: paddingHorizontal),
                    child: Text(
                      productService.product.description!,
                      overflow: TextOverflow.ellipsis,
                      style: txtStyleBodyBlack,
                    ),
                  ),
                ],
              ),
            ),
          ),

        const Text(
          overflow: TextOverflow.ellipsis,
          '¿A que categoría pertenece?',
          style: txtStyleBodyBlackStrong,
        ),
        Wrap(
          spacing: paddingHorizontal,
          runSpacing: paddingVertical,
          children: categoryService!.categories.map((category) {
            bool isSelected = false;
            if (productService.product.categories!
                .any((element) => element.id == category.id)) {
              isSelected = true;
            }

            //* PUT PILL
            return PillItemSelector(category: category, isSelected: isSelected);
          }).toList(),
        ),

        if (sectionService != null && sectionService!.sections.isNotEmpty)
          const Text(
            overflow: TextOverflow.ellipsis,
            '¿A que sección pertenece?',
            style: txtStyleBodyBlackStrong,
          ),
        if (sectionService != null && sectionService!.sections.isNotEmpty)
          Wrap(
            spacing: paddingHorizontal,
            runSpacing: paddingVertical,
            children: sectionService!.sections.map((section) {
              bool isSelected = false;
              if (productService.product.sections != null &&
                  productService.product.sections!
                      .any((element) => element.id == section.id)) {
                isSelected = true;
              }

              //* PUT PILL
              return PillItemSelectorSection(
                  section: section, isSelected: isSelected);
            }).toList(),
          ),

        // *PRODUCTO POPULAR

        SwitchListTile.adaptive(
            activeColor: primaryColorStrong,
            title: const Text(
              overflow: TextOverflow.clip,
              '¿El producto es popular entre tus clientes?',
              style: txtStyleBodyBlackStrong,
            ),
            value: productService.product.isPopular ?? false,
            onChanged: (bool newValue) {
              setState(() {
                productService.product.isPopular = newValue;
              });
            }),

        //* ----------------------------  INFORMACION VENTA ---------------------------- *//
        const Text(
          overflow: TextOverflow.ellipsis,
          'Información de venta',
          style: txtStyleSubTitleBlack,
        ),
        //! PRODUCT NAME
        TextFormField(
          obscureText: false,
          keyboardType: TextInputType.number,
          initialValue: productService.product.price.toString(),
          decoration: const InputDecoration(
            labelText: 'Precio',
            hintText: "Precio",
            prefixIconColor: primaryColor,
            prefixIcon: Icon(
              Icons.monetization_on_sharp,
              color: primaryColor,
            ),
          ),
          onChanged: (value) => value.isNotEmpty
              ? productService.product.price = double.parse(value)
              : productService.product.price = 0.0,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingresa una cantidad valida';
            } else {
              return null;
            }
          },
        ),

        Row(
          children: [
            Expanded(
                child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: IconButton(
                      color: productService.product.descountType == 'percent'
                          ? primaryColorStrong
                          : secondaryColor,
                      isSelected:
                          productService.product.descountType == 'percent',
                      onPressed: () {
                        setState(() {
                          productService.product.descountType = 'percent';
                        });
                      },
                      icon: const Icon(
                        Icons.percent_outlined,
                      )),
                ),
                Expanded(
                  flex: 8,
                  child: Text(
                    'Porcentaje',
                    style: productService.product.descountType == 'percent'
                        ? txtStyleSubTitlePurpleStrong
                        : txtStyleSubTitleDisable,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            )),
            Expanded(
                child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: IconButton(
                      color: productService.product.descountType == 'cash'
                          ? primaryColorStrong
                          : secondaryColor,
                      isSelected: productService.product.descountType == 'cash',
                      onPressed: () {
                        setState(() {
                          productService.product.descountType = 'cash';
                        });

                        debugPrint(productService.product.descountType);
                      },
                      icon: const Icon(
                        Icons.monetization_on,
                      )),
                ),
                Expanded(
                  flex: 8,
                  child: Text(
                    'Pesos',
                    style: productService.product.descountType == 'cash'
                        ? txtStyleSubTitlePurpleStrong
                        : txtStyleSubTitleDisable,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ))
          ],
        ),
        //! PRODUCT DESCRIPTION
        TextFormField(
          obscureText: false,
          keyboardType: TextInputType.number,
          initialValue: productService.product.descount.toString(),
          decoration: InputDecoration(
            labelText: productService.product.descountType == 'percent'
                ? 'Porcentaje'
                : 'Pesos',
            hintText: productService.product.descountType == 'percent'
                ? 'Porcentaje'
                : 'Pesos',
            prefixIconColor: primaryColor,
            prefixIcon: Icon(
              productService.product.descountType == 'percent'
                  ? Icons.percent
                  : Icons.monetization_on,
              color: primaryColor,
            ),
          ),
          onChanged: (value) {
            if (productService.product.descountType != null) {
              if (productService.product.descountType == 'cash') {
                value.isNotEmpty
                    ? productService.product.descount = double.parse(value)
                    : 0;
              } else {
                value.isNotEmpty
                    ? productService.product.descount = int.parse(value)
                    : 0;
              }
            }
          },
          validator: (value) {
            if (productService.product.descountType == null) {
              return 'Selecciona un tipo de descuento';
            }
            if (value == null || value.isEmpty) {
              return 'Ingresa una cantidad valida';
            }

            if (productService.product.descountType == 'percent') {
              if (productService.product.descount! > 99 ||
                  productService.product.descount! < 0) {
                return 'Ingresa un porcentaje valido';
              }
            } else {
              if (productService.product.descount! >=
                      productService.product.price! ||
                  productService.product.descount! < 0) {
                return 'Ingresa un descuento en pesos valido';
              }
            }

            return null;
          },
        ),
        TextFormField(
          obscureText: false,
          keyboardType: TextInputType.number,
          initialValue: productService.product.stock.toString(),
          decoration: const InputDecoration(
            labelText: 'Stock disponible',
            hintText: "Porcentaje",
            prefixIconColor: primaryColor,
            prefixIcon: Icon(
              Icons.numbers,
              color: primaryColor,
            ),
          ),
          onChanged: (value) => value.isNotEmpty
              ? productService.product.stock = int.parse(value)
              : productService.product.stock = 0,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingresa una cantidad valida';
            } else {
              return null;
            }
          },
        ),
        SwitchListTile.adaptive(
            activeColor: primaryColorStrong,
            title: const Text(
              overflow: TextOverflow.clip,
              '¿Está disponible actualmente?',
              style: txtStyleBodyBlackStrong,
            ),
            value: productService.product.stock != null &&
                    productService.product.stock! > 0
                ? productService.product.available!
                : false,
            onChanged: (bool newValue) {
              if (productService.product.stock != null &&
                  productService.product.stock! > 0) {
                setState(() {
                  productService.product.available = newValue;
                });
              } else {
                showMessageModal(
                    contentTxt:
                        'Ingresa primero una cantidad de Stock valida para poder habilitar tu producto',
                    context: context,
                    titleIcon: const Icon(
                      Icons.info_outline,
                      color: primaryColorStrong,
                    ),
                    titleTxt: 'Stock insufuciente');
              }
            }),
        buildFlexTextValue(
            label: 'Precio de lista',
            value: '\$ ${productService.product.price}'),
        buildFlexTextValue(label: 'Descuento', value: getValueOfDescount()),
        buildFlexTextValue(label: 'Total', value: getTotalValueOfProduct()),

        //* ----------------------------  INFORMACION DETALLES ---------------------------- *//
      ];

  // * ----------------------------- CALCULATE TOTAL FOR WIDGETS * ----------------------------- //
  String getValueOfDescount() {
    return productService.product.descountType != null
        ? productService.product.descountType == 'percent'
            ? '\$ ${productService.product.price! * (productService.product.descount! / 100)}'
            : '\$ ${productService.product.descount!}'
        : '\$ 0.0 ';
  }

  String getTotalValueOfProduct() {
    return productService.product.descountType != null
        ? productService.product.descountType == 'percent'
            ? '\$ ${productService.product.price! * ((100 - productService.product.descount!) / 100)}'
            : '\$ ${productService.product.price! - productService.product.descount!}'
        : '\$ ${productService.product.price!}';
  }

  // * ----------------------------- WIDGET TO CARD FOR VARIANT [TITLE ,SELECTED IMAGE , NAME] * ----------------------------- //
  List<Widget> buildWidgetVariants() {
    return [
      TextFormField(
        initialValue: productService.product.titleOptions,
        obscureText: false,
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
            labelText: 'Titulo tipos de variantes',
            hintText: "Variante",
            prefixIcon: Icon(
              Icons.title,
              color: primaryColor,
            )),
        onChanged: (value) => productService.product.titleOptions = value,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Debes introducir un titulo';
          } else {
            return null;
          }
        },
      ),
      Card(
        elevation: 20,
        shadowColor: Colors.black38,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: paddingHorizontal, vertical: paddingVertical),
          child: Column(
            children: [
              buildWidgetSelectPictureForVariants(),
              Padding(
                padding: const EdgeInsets.only(top: paddingVertical),
                child: TextFormField(
                  obscureText: false,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                      labelText: 'Nombre de variante #',
                      hintText: "Variante",
                      prefixIcon: Icon(
                        Icons.title,
                        color: primaryColor,
                      )),
                  controller: controllerVariant,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Introduce algun nombre';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              const Divider(
                height: paddingVertical * 4,
                thickness: 1.0,
                color: primaryColor,
              ),
              DefaultButton(text: 'Agregar', press: () async => addVariant())
            ],
          ),
        ),
      )
    ];
  }

  // * ----------------------------- WIDGET SELECT PICTURE TO VARIANT * ----------------------------- //
  buildWidgetSelectPictureForVariants() {
    return SizedBox(
      width: SizeConfig.screenWidth,
      height: SizeConfig.screenHeight / 3,
      child: Center(
        child: Stack(
          alignment: AlignmentDirectional.topStart,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: getImage(productService.selectedPictureForDetails != null
                    ? productService.selectedPictureForDetails!.path
                    : null)),
            builButtonToSelectCamera(whereStore: 'variants')
          ],
        ),
      ),
    );
  }

  // * ----------------------------- ADD VARIANT / UPDATE STATES * ----------------------------- //
  addVariant() async {
    String title = 'Error al agregar variante';
    Icon icon = const Icon(
      Icons.error_outline,
      color: primaryColorStrong,
    );

    if (controllerVariant.text.isEmpty ||
        productService.selectedPictureForDetails == null) {
      if (controllerVariant.text.isEmpty) {
        productService.errorMessage =
            'Ingresa el nombre de la variante a agregar para continuar';
      }

      if (productService.selectedPictureForDetails == null) {
        productService.errorMessage = 'Ingresa una imagen para continuar';
      }
    } else {
      title = 'Éxito al agregar variante';
      icon = const Icon(
        Icons.done_all,
        color: primaryColorStrong,
      );
      // final String? urlVariant = await productService.uploadImage(
      //     newPictureFile: productService.selectedPictureForDetails);
      final variantToAdd = ProductOptions(
          imagen: productService.selectedPictureForDetails!.path,
          optionName: controllerVariant.text);

      productService.product.productOptions == null
          ? productService.product.productOptions = [variantToAdd]
          : productService.product.productOptions!.add(variantToAdd);

      productService.selectedPictureForDetails = null;
      controllerVariant.text = '';

      setState(() {});
    }

    showMessageModal(
        contentTxt: productService.errorMessage ?? '',
        context: context,
        titleIcon: icon,
        titleTxt: title);
  }

  TextEditingController controllerVariant = TextEditingController();

  // * ----------------------------- WIDGET TO BUILD * ----------------------------- //
  @override
  Widget build(BuildContext context) {
    categoryService = Provider.of<CategoriesService>(context);
    sectionService = Provider.of<SectionService>(context);

    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(paddingVertical),
          vertical: getProportionateScreenHeight(paddingVertical / 2)),
      width: SizeConfig.screenWidth,
      decoration: buildBoxDecorationCard(),
      child: Column(
        // direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Form(
              key: productService.formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  ...List.generate(
                      inputsProductForm().length,
                      (index) => Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: paddingHorizontal,
                                vertical: paddingVertical / 2),
                            child: inputsProductForm()[index],
                          )),
                ],
              )),
          Form(
              key: productService.formKeyOptions,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  ...List.generate(
                      inputsVariantProducts().length,
                      (index) => Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: paddingHorizontal,
                                vertical: paddingVertical / 2),
                            child: inputsVariantProducts()[index],
                          ))
                ],
              )),
        ],
      ),
    );
  }
}
