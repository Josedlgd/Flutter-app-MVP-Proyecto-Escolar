import 'package:domas_ecommerce/constants.dart';
import 'package:domas_ecommerce/models/models.dart';
import 'package:domas_ecommerce/screens/admin/secciones/add_section_screen.dart';
import 'package:domas_ecommerce/screens/admin/secciones/components/body.dart';
import 'package:domas_ecommerce/services/sections_service.dart';
import 'package:domas_ecommerce/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SectionsScreen extends StatelessWidget {
  static String routeName = "/sections";
  const SectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sectionService = Provider.of<SectionService>(context);
    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Secciones'),
      ),
      body: const SafeArea(child: BodySection()),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColorStrong,
        onPressed: () {
          sectionService.selectedSection = Section(name: '', enable: false);
          Navigator.pushNamed(context, FormSectionScreen.routeName);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
