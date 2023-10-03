import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:domas_ecommerce/components/components.dart';
import 'package:domas_ecommerce/constants.dart';
import 'package:domas_ecommerce/controllers/general.dart';
import 'package:domas_ecommerce/models/models.dart';
import 'package:domas_ecommerce/screens/admin/products/add/add_product_form.dart';
import 'package:domas_ecommerce/size_config.dart';
import 'package:domas_ecommerce/ui/ui.dart';

import 'package:domas_ecommerce/services/products_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

class ProductScreen extends StatefulWidget {
  static String routeName = "/product";
  const ProductScreen({super.key});
  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  ProductsService get productService => GetIt.instance<ProductsService>();
  @override
  Widget build(BuildContext context) {
    return const _ProductScreenBody();
  }
}

//* PRODUCT SCREEN
class _ProductScreenBody extends StatefulWidget {
  const _ProductScreenBody({
    Key? key,
  }) : super(key: key);

  @override
  State<_ProductScreenBody> createState() => _ProductScreenBodyState();
}

class _ProductScreenBodyState extends State<_ProductScreenBody> {
  List<File> _imagesToAdd = [];

  List<File> get imagesToAdd => _imagesToAdd;

  set imagesToAdd(List<File> value) {
    _imagesToAdd = value;
  }

  ProductsService get productService => GetIt.instance<ProductsService>();

  CarouselController buttonCarouselController = CarouselController();

  onTapSelectPicture({required ImageSource howUpload}) async {
    final picker = ImagePicker();
    Navigator.of(context).pop();
    final XFile? pickedFile =
        await picker.pickImage(source: howUpload, imageQuality: 100);

    if (pickedFile != null) {
      setState(() {
        _imagesToAdd.add(pickedFile as File);
      });
    }
  }

  int _currentImageSelected = 0;

  int get currentImageSelected => _currentImageSelected;

  set currentImageSelected(int value) {
    _currentImageSelected = value;
  }

  Widget buildWidgetSelectPicture({required String? url}) {
    return Column(
      children: [
        Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  productService.product.images!.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () =>
                      buttonCarouselController.animateToPage(entry.key),
                  child: Container(
                    width: 12.0,
                    height: 12.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black)
                            .withOpacity(
                                currentImageSelected == entry.key ? 0.9 : 0.4)),
                  ),
                );
              }).toList(),
            ),
            Positioned(
                top: 20,
                right: 20,
                child: IconButton(
                  iconSize: sizeGeneralIcon,
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Wrap(
                          children: [
                            ListTile(
                                leading: const Icon(Icons.camera_alt_outlined),
                                title: const Text('Abrir cámara'),
                                onTap: () {
                                  onTapSelectPicture(
                                      howUpload: ImageSource.camera);
                                }),
                            ListTile(
                                leading: const Icon(Icons.browse_gallery),
                                title: const Text('Seleccionar de galería'),
                                onTap: () {
                                  onTapSelectPicture(
                                      howUpload: ImageSource.gallery);
                                }),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.black87,
                  ),
                ))
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: paddingVertical / 2),
          child: CarouselSlider(
            options: CarouselOptions(
                // autoPlay: true,
                // enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentImageSelected = index;
                  });
                }),
            carouselController: buttonCarouselController,
            items: productService.product.images!
                .map((e) => Container(child: getImage(e)))
                .toList(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // ignore: unnecessary_null_comparison
        title: Text(productService.product.name != ''
            ? 'Editar producto'
            : 'Nuevo producto'),
        centerTitle: true,
      ),
      body: LayoutBuilder(builder: (context, constraint) {
        return SingleChildScrollView(
          child: isLoading
              ? SizedBox(
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.screenHeight,
                  child: LoadingOverlay())
              : ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
                  child: const AddProductForm(),
                ),
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: SpeedDial(
          iconTheme: const IconThemeData(color: Colors.white),
          label: const Text('Siguiente', style: txtStyleBodyWhite),
          // animatedIcon: AnimatedIcons.menu_close,
          icon: Icons.next_plan,
          backgroundColor: primaryColor,
          children: [
            SpeedDialChild(
              onTap: () async => await storeProduct(),
              child: const Icon(Icons.save_alt, color: primaryColor),
              label: 'Guardar',
            ),
            SpeedDialChild(
              onTap: () => debugPrint('Se presiono cancelar'),
              child: const Icon(Icons.cancel, color: primaryColor),
              label: 'Cancelar',
            ),
          ]),
    );
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
  }

  storeProduct() async {
    setState(() {
      isLoading = true;
    });

    String contentTxt =
        'Hubo un problema al guardar imagenes, intenta nuevamente';
    Icon titleIcon = const Icon(Icons.error_outline);
    String titleTxt = 'Error en subida';

    setState(() {
      productService.isSaving = true;
    });
    if (productService.isValidForm()) {
      productService.searchCaseForProduct();
      if (productService.selectedPictures.isNotEmpty ||
          (productService.product.images != null &&
              productService.product.images!.isNotEmpty)) {
        bool resImages = await storeImageForProduct();
        if (resImages) {
          bool resProduct = await productService.saveOrCreateProduct();

          if (resProduct) {
            titleIcon = const Icon(Icons.done_all, color: primaryColorStrong);
            contentTxt = 'El producto ha sido agregado correctamente';
            titleTxt = '¡Éxito!';
          } else {
            contentTxt =
                'Hubo un problema al guardar el producto, verifica e intenta nuevamente';
            titleTxt = 'Error al agregar producto';
          }
        } else {
          contentTxt =
              'Hubo un problema al guardar imagenes, intenta nuevamente';
          titleTxt = 'Error agregando imagenes';
        }
      } else {
        contentTxt = 'Hubo un problema al guardar imagenes, intenta nuevamente';
        titleTxt = 'Error agregando imagenes';
      }
    } else {
      contentTxt =
          'Alguno de los campos del formulario no han sido completados, revisa nuevamente';
      titleTxt = 'Error en formulario';
    }

    setState(() {
      isLoading = false;
    });

    // ignore: use_build_context_synchronously
    await onWillPop(
        actions: [
          DefaultButton(
            text: 'Ir a productos',
            press: () => Navigator.of(context)
                .popUntil(ModalRoute.withName('/products')),
          ),
          DefaultButton(
            text: 'Continuar editando',
            press: () => Navigator.of(context).pop(),
          ),
        ],
        context: context,
        icon: titleIcon,
        titleAlert: titleTxt,
        txtContentAlert: contentTxt);
  }

  //NOTE //* --------------------------------- HERE STORE IMAGES FOR MAIN AND VARIANTS --------------------------------- */
  Future<bool> storeImageForProduct() async {
    //* -------------- STORE MAIN IMAGES -------------- */
    for (var i = 0; i < productService.selectedPictures.length; i++) {
      if (productService.selectedPictures[i] is File &&
          productService.selectedPictures[i] is! String) {
        //NOTE //! RETRIEVE IMAGE FROM SAME COLLECTION
        final String? imageURL = await productService.uploadImage(
            newPictureFile: productService.selectedPictures[i]);

        //NOTE //! IF IS NOT NULL IS VALID IMAGE
        if (imageURL != null) {
          if (productService.product.images == null) {
            productService.product.images = [imageURL];
          } else {
            productService.product.images!.isEmpty
                ? productService.product.images = [imageURL]
                : productService.product.images!.add(imageURL);
          }
          debugPrint('url Guardada${productService.product.images!.last}');
        }
      }

      //* -------------- STORE VARIANT IMAGES -------------- */
    }

    if (productService.product.productOptions != null &&
        productService.product.productOptions!.isNotEmpty) {
      for (var i = 0; i < productService.product.productOptions!.length; i++) {
        if (productService.product.productOptions![i].imagen is String &&
            productService.product.productOptions![i].imagen != null &&
            !productService.product.productOptions![i].imagen!
                .startsWith('http')) {
          //NOTE //! RETRIEVE IMAGE FROM SAME COLLECTION
          final String? imageURL = await productService.uploadImage(
              newPictureFile:
                  File(productService.product.productOptions![i].imagen!));

          //NOTE //! IF IS NOT NULL IS VALID IMAGE
          if (imageURL != null) {
            //! SUSTITE THE ORIGINAL FOR THE MAIN
            productService.product.productOptions![i].imagen = imageURL;
          }
        }
      }
    }

    return true;
  }
}
