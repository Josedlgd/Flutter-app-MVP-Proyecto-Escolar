import 'package:domas_ecommerce/models/models.dart';
import 'package:domas_ecommerce/screens/section/components/body_section.dart';
import 'package:domas_ecommerce/widgets/widgets.dart';
import 'package:flutter/material.dart';

class SectionScreenIndex extends StatelessWidget {
  const SectionScreenIndex({super.key, required this.section});
  final Section section;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBarList(),
      body: SafeArea(
          child: BodySection(
        sectionData: section,
      )),
    );
  }
}
