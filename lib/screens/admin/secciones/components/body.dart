import 'dart:ui';

import 'package:domas_ecommerce/models/models.dart';
import 'package:domas_ecommerce/screens/admin/loading_screen.dart';
import 'package:domas_ecommerce/screens/admin/secciones/add_section_screen.dart';
import 'package:domas_ecommerce/services/sections_service.dart';
import 'package:domas_ecommerce/ui/general.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BodySection extends StatelessWidget {
  const BodySection({super.key});

  @override
  Widget build(BuildContext context) {
    final sectionsService = Provider.of<SectionService>(context);
    if (sectionsService.isLoading) {
      return const LoadingScreen();
    } else {
      return RefreshIndicator(
        child: ListView.builder(
          itemCount: sectionsService.sections.length,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              sectionsService.selectedSection =
                  sectionsService.sections[index].copy();
              Navigator.pushNamed(context, FormSectionScreen.routeName);
            },
            child: Table(
              children: [
                TableRow(children: [
                  _SigleCard(category: sectionsService.sections[index]),
                ]),
              ],
            ),
          ),
        ),
        onRefresh: () async {
          await sectionsService.loadSections();
        },
      );
    }
  }
}

class _SigleCard extends StatelessWidget {
  final Section category;

  const _SigleCard({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _CardBackground(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 50,
            child: getImage(category.icon),
          ),
          const SizedBox(height: 10),
          Text(
            category.name,
            style: const TextStyle(fontSize: 18),
          )
        ],
      ),
    );
  }
}

class _CardBackground extends StatelessWidget {
  final Widget child;

  const _CardBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            height: 150,
            decoration: BoxDecoration(
                color: const Color.fromARGB(176, 229, 230, 233),
                borderRadius: BorderRadius.circular(20)),
            child: child,
          ),
        ),
      ),
    );
  }
}
