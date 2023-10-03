import 'package:domas_ecommerce/models/models.dart';
import 'package:domas_ecommerce/ui/general.dart';
import 'package:domas_ecommerce/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class DirectionDetails extends StatefulWidget {
  DirectionDetails({super.key, required this.address});
  Address address;
  @override
  State<DirectionDetails> createState() => _DirectionDetailsState();
}

class _DirectionDetailsState extends State<DirectionDetails> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${widget.address.street ?? ''} #${widget.address.numberExt}',
          style: txtStyleBodyBlackStrong,
        ),
        Text(
          '${widget.address.street ?? ''} Ext: ${widget.address.numberExt ?? ''} ${widget.address.numberExt != null ? 'Ext: ${widget.address.numberExt}' : ''}',
          style: txtStyleBodyBlack,
        ),
        Text(
          'Colonia: ${widget.address.neighborhood ?? ''}',
          style: txtStyleBodyBlack,
        ),
        Text(
          'Descripcion: ${widget.address.description ?? ''}',
          style: txtStyleBodyBlack,
        )
      ],
    );
  }
}
