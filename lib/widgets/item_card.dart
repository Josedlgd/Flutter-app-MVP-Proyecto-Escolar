import 'package:domas_ecommerce/constant/app_color.dart';
import 'package:domas_ecommerce/models/models.dart';
import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  final Section section;
  final VoidCallback? action;

  const ItemCard({super.key, required this.section, this.action});
  //  width: MediaQuery.of(context).size.width / 1.5,
  //           height: MediaQuery.of(context).size.width / 3,
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // item image
          Container(
            width: MediaQuery.of(context).size.width / 1.5,
            height: MediaQuery.of(context).size.width / 3,
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColor.secondary,
              image: DecorationImage(
                  image: NetworkImage(section.icon!), fit: BoxFit.fitHeight),
            ),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Color.fromARGB(157, 0, 0, 0)),
              child: Text(
                section.name,
                style: const TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
