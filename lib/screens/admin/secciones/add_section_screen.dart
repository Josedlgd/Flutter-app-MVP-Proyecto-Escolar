import 'package:domas_ecommerce/screens/admin/secciones/components/form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class FormSectionScreen extends StatelessWidget {
  const FormSectionScreen({super.key});
  static String routeName = "/section";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Editar sección'),
      ),
      body: const SafeArea(child: BodyForm()),
    );
  }
}
