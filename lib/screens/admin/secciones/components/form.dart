import 'package:domas_ecommerce/providers/providers.dart';
import 'package:domas_ecommerce/services/sections_service.dart';
import 'package:domas_ecommerce/ui/input_decorations.dart';
import 'package:domas_ecommerce/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class BodyForm extends StatelessWidget {
  const BodyForm({super.key});

  @override
  Widget build(BuildContext context) {
    final sectionService = Provider.of<SectionService>(context);

    return ChangeNotifierProvider(
      create: (_) => SectionFormProvider(sectionService.selectedSection),
      child: _SectionScreenBody(sectionService: sectionService),
    );
  }
}

class _SectionScreenBody extends StatelessWidget {
  const _SectionScreenBody({
    Key? key,
    required this.sectionService,
  }) : super(key: key);

  final SectionService sectionService;

  @override
  Widget build(BuildContext context) {
    final categoryForm = Provider.of<SectionFormProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                CategoryImage(
                  url: sectionService.selectedSection.icon,
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
                                      sectionService
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
                                      sectionService
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
            const _SectionForm(),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: sectionService.isSaving
            ? null
            : () async {
                if (!categoryForm.isValidForm()) {
                  return;
                } else {
                  final String? imageURL = await sectionService.uploadImage();
                  if (imageURL != null) {
                    categoryForm.section.icon = imageURL;
                  }
                  await sectionService
                      .saveOrCreateSection(categoryForm.section);
                }
              },
        child: sectionService.isSaving
            ? const CircularProgressIndicator(
                color: Colors.black87,
              )
            : const Icon(Icons.save_rounded),
      ),
    );
  }
}

class _SectionForm extends StatelessWidget {
  const _SectionForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categoryForm = Provider.of<SectionFormProvider>(context);
    final section = categoryForm.section;

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
                  initialValue: section.name,
                  onChanged: (value) => section.name = value,
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
                  value: section.enable,
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
