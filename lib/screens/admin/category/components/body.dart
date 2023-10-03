import 'package:domas_ecommerce/providers/providers.dart';
import 'package:domas_ecommerce/services/services.dart';
import 'package:domas_ecommerce/ui/input_decorations.dart';
import 'package:domas_ecommerce/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryService = Provider.of<CategoriesService>(context);

    return ChangeNotifierProvider(
      create: (_) => CategoryFormProvider(categoryService.selectedCategory),
      child: _CategoryScreenBody(categoryService: categoryService),
    );
  }
}

class _CategoryScreenBody extends StatelessWidget {
  const _CategoryScreenBody({
    Key? key,
    required this.categoryService,
  }) : super(key: key);

  final CategoriesService categoryService;

  @override
  Widget build(BuildContext context) {
    final categoryForm = Provider.of<CategoryFormProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                CategoryImage(
                  url: categoryService.selectedCategory.icon,
                ),
                Positioned(
                    top: 20,
                    right: 20,
                    child: IconButton(
                      iconSize: 35,
                      onPressed: () {
                        final picker = ImagePicker();
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Wrap(
                              children: [
                                ListTile(
                                  leading:
                                      const Icon(Icons.camera_alt_outlined),
                                  title: const Text('Open camera'),
                                  onTap: () async {
                                    Navigator.of(context).pop();
                                    final XFile? pickedFile =
                                        await picker.pickImage(
                                            source: ImageSource.camera,
                                            imageQuality: 100);
                                    if (pickedFile == null) {
                                      return;
                                    } else {
                                      categoryService
                                          .updateSelectedCategoryImage(
                                              pickedFile.path);
                                    }
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.browse_gallery),
                                  title: const Text('Select from gallery'),
                                  onTap: () async {
                                    Navigator.pop(context);
                                    final XFile? pickedFile =
                                        await picker.pickImage(
                                            source: ImageSource.gallery,
                                            imageQuality: 100);
                                    if (pickedFile == null) {
                                      return;
                                    } else {
                                      categoryService
                                          .updateSelectedCategoryImage(
                                              pickedFile.path);
                                    }
                                  },
                                ),
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
            const _CategoryForm(),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: categoryService.isSaving
            ? null
            : () async {
                if (!categoryForm.isValidForm()) {
                  return;
                } else {
                  final String? imageURL = await categoryService.uploadImage();
                  if (imageURL != null) {
                    categoryForm.category.icon = imageURL;
                  }
                  await categoryService
                      .saveOrCreateCategory(categoryForm.category);
                }
              },
        child: categoryService.isSaving
            ? const CircularProgressIndicator(
                color: Colors.black87,
              )
            : const Icon(Icons.save_rounded),
      ),
    );
  }
}

class _CategoryForm extends StatelessWidget {
  const _CategoryForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categoryForm = Provider.of<CategoryFormProvider>(context);
    final category = categoryForm.category;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
            key: categoryForm.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  initialValue: category.name,
                  onChanged: (value) => category.name = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Debes ingresar un nombre';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecorations.authInputDecoration(
                    hintText: 'Nombre',
                    labelText: 'Nombre de la categoría',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SwitchListTile.adaptive(
                  title: const Text('Habilitada'),
                  activeColor: Colors.black87,
                  value: category.enable,
                  onChanged: categoryForm.updateAvailability,
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            )),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 0),
              blurRadius: 5,
            )
          ]);
}
