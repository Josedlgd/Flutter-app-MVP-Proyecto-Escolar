import 'package:domas_ecommerce/components/components.dart';
import 'package:domas_ecommerce/components/direction_details.dart';
import 'package:domas_ecommerce/components/item_product_list_details.dart';
import 'package:domas_ecommerce/components/payment_details.dart';
import 'package:domas_ecommerce/constant/app_color.dart';
import 'package:domas_ecommerce/constants.dart';
import 'package:domas_ecommerce/controllers/general.dart';
import 'package:domas_ecommerce/models/direction.dart';
import 'package:domas_ecommerce/models/models.dart';
import 'package:domas_ecommerce/services/services.dart';
import 'package:domas_ecommerce/ui/text_styles.dart';
import 'package:domas_ecommerce/ui/ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class SaleDetails extends StatefulWidget {
  SaleDetails({super.key, required this.title, required this.orderToShow});
  static String routeName = "/saleDetails";
  PaymentIntent orderToShow;
  String title;

  @override
  State<SaleDetails> createState() => _SaleDetailsState();
}

class _SaleDetailsState extends State<SaleDetails> {
  final Map<String, dynamic> payment = {
    "status": "Pendiente de envío",
    "type": "Tarjeta"
  };

  Map<String, dynamic> keyDeliver = {
    'warehous': 'Tarjeta crédito o débito',
    'deliver_home': 'Efectivo',
  };

  buildTitle({required String title}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: paddingVertical),
      child: Text(
        title,
        style: txtStyleTitleBlack,
      ),
    );
  }

  Widget buildConfirmOrder() {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text('Modal BottomSheet'),
            ElevatedButton(
              child: const Text('Close BottomSheet'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildReScheduleOrder() {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text('Modal BottomSheet'),
            ElevatedButton(
              child: const Text('Close BottomSheet'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  @override
  initState() {
    dateinput.text = widget.orderToShow.schedule!.day
        .toString()
        .toString(); //set the initial value of text field
    timeinput.text =
        '${widget.orderToShow.schedule!.hour} : ${widget.orderToShow.schedule!.minute}';

    //NOTE //!DATE AND TIME
    date =
        "${widget.orderToShow.schedule!.day!.day} / ${widget.orderToShow.schedule!.day!.month} / ${widget.orderToShow.schedule!.day!.year}";
    time =
        "${widget.orderToShow.schedule!.hour!} : ${widget.orderToShow.schedule!.minute!}";

    super.initState();
  }

  Widget buildCancelOrder() {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text('Modal BottomSheet'),
            ElevatedButton(
              child: const Text('Close BottomSheet'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  TextEditingController dateinput = TextEditingController();
  TextEditingController timeinput = TextEditingController();

  //text editing controller for text field

  PaymentIntentsService get ordersService =>
      GetIt.instance<PaymentIntentsService>();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: primaryColorStrong)),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: primaryLightColor),
          backgroundColor: primaryColorStrong,
          title: Text(
            widget.title,
            style: txtStyleTitleWhite,
          ),
        ),
        floatingActionButton: widget.orderToShow.status != 'complete' &&
                widget.orderToShow.status != 'cancel'
            ? SpeedDial(
                iconTheme: const IconThemeData(color: Colors.white),
                label: const Text('Completar', style: txtStyleBodyWhite),
                // animatedIcon: AnimatedIcons.menu_close,
                // icon: Icons.menu,
                backgroundColor: primaryColor,
                children: [
                    SpeedDialChild(
                      onTap: () async {
                        await onWillPop(
                            actions: [
                              DefaultButton(
                                  text: 'Si, completar',
                                  press: () async {
                                    if (await ordersService.changeStatusOrder(
                                        id: widget.orderToShow.id!,
                                        newStatus: 'complete')) {
                                      Navigator.of(context).pop(false);
                                      buildSnackBarToState(
                                          txtBody:
                                              '¡Éxito! Al COMPLETAR pedido',
                                          context: context);
                                    }
                                  }),
                              DefaultButton(
                                text: 'No, conservar',
                                press: () => Navigator.of(context).pop(false),
                              ),
                            ],
                            context: context,
                            icon: const Icon(Icons.warning,
                                color: primaryColorStrong),
                            titleAlert: 'Completar pedido',
                            txtContentAlert:
                                '¿Estás seguro de marcar como COMPLETADO el pedido? Le comunicaremos al usuario');
                      },
                      child: const Icon(Icons.done, color: primaryColor),
                      label: 'Finalizar',
                    ),
                    SpeedDialChild(
                      onTap: () async {
                        await onWillPop(
                            actions: [
                              DefaultButton(
                                  text: 'Si, cancelar',
                                  press: () async {
                                    if (await ordersService.changeStatusOrder(
                                        id: widget.orderToShow.id!,
                                        newStatus: 'cancel')) {
                                      Navigator.of(context).pop(false);
                                      showModalBottomSheet(
                                          builder: (BuildContext context) {
                                            return Text(
                                                '¡Éxito! pedido CANCELADO');
                                          },
                                          context: context);
                                    }
                                  }),
                              DefaultButton(
                                text: 'No, conservar',
                                press: () => Navigator.of(context).pop(false),
                              ),
                            ],
                            context: context,
                            icon: const Icon(Icons.warning,
                                color: primaryColorStrong),
                            titleAlert: 'Cancelar pedido',
                            txtContentAlert:
                                '¿Estás seguro de marcar como CANCELADO el pedido? Le comunicaremos al usuario de su cancelación');
                      },
                      child: const Icon(Icons.cancel, color: primaryColor),
                      label: 'Cancelar',
                    ),
                    SpeedDialChild(
                      onTap: () async {
                        await onWillPop(
                            context: context,
                            icon: const Icon(Icons.calendar_month,
                                color: primaryColorStrong),
                            titleAlert: 'Cambiar fecha de entrega',
                            txtContentAlert: 'Cambio de fecha',
                            actions: [
                              DefaultButton(
                                  text: 'Cambiar datos',
                                  press: () async {
                                    String txtModal =
                                        'Error al intentar cambiar los datos de entrega';
                                    if (await ordersService.updateDateOrder(
                                        newSchedule: {
                                          "day": dateinput.text,
                                          "from_hour": timeinput.text
                                        },
                                        id: widget.orderToShow.id ?? '')) {
                                      txtModal =
                                          '¡Éxito! La fecha y hora fueron modificadas';
                                    }

                                    buildSnackBarToState(
                                        txtBody: txtModal, context: context);

                                    setState(() {
                                      widget.orderToShow.schedule =
                                          Schedule.fromJson({
                                        "day": dateinput.text,
                                        "from_hour": timeinput.text
                                      });
                                    });

                                    Navigator.of(context).pop(false);

                                    debugPrint('Se cambio fecha');
                                  }),
                              DefaultButton(
                                text: 'Cancelar',
                                press: () => Navigator.of(context).pop(false),
                              )
                            ],
                            widgetToShow: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: paddingVertical / 2),
                                  child: ElevatedButton(
                                    onPressed: () => _selectDate(context),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 36, vertical: 18),
                                      backgroundColor: AppColor.primary,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      elevation: 0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          paddingHorizontal /
                                                              2),
                                                  child: Icon(
                                                    Icons.date_range,
                                                    size: 18.0,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(date,
                                                    style:
                                                        txtStyleSubTitleWhite,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ],
                                            )
                                          ],
                                        ),
                                        const Text("  Elegir Fecha",
                                            style: txtStyleSubTitleWhite,
                                            overflow: TextOverflow.ellipsis),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: paddingVertical / 2),
                                  child: ElevatedButton(
                                    onPressed: () =>
                                        _showDialogTimePicker(context),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 36, vertical: 18),
                                      backgroundColor: AppColor.primary,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      elevation: 0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          paddingHorizontal /
                                                              2),
                                                  child: Icon(
                                                    Icons.access_time,
                                                    size: 18.0,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  time,
                                                  style: txtStyleSubTitleWhite,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        const Text("  Elegir Hora",
                                            style: txtStyleSubTitleWhite,
                                            overflow: TextOverflow.ellipsis),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ));
                      },
                      child: const Icon(Icons.watch_later, color: primaryColor),
                      label: 'Posponer entrega',
                    ),
                  ])
            : null,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: paddingHorizontal),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: paddingVertical * 2,
                ),
                buildTitle(title: 'Productos'),
                ListView.separated(
                  itemCount: widget.orderToShow.products!.length,
                  shrinkWrap: true,
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(
                    color: primaryColor,
                    height: paddingVertical * 2,
                    thickness: 2.0,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return ItemProductListDetails(
                        product: widget.orderToShow.products![index]);
                  },
                ),

                buildTitle(title: 'Método de pago'),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: paddingVertical,
                        horizontal: paddingHorizontal / 2),
                    child: PaymentDetails(
                      order_resume: widget.orderToShow.orderResume!,
                      payment: {
                        'status': widget.orderToShow.status,
                        'type': widget.orderToShow.paymentType
                      },
                    ),
                  ),
                ),

                buildTitle(title: 'Tipo de entrega'),

                Text(
                  keyDeliver[widget.orderToShow.shippingType.toString()],
                  style: txtStyleBodyBlack,
                ),

                buildTitle(title: 'Dirección de entrega'),

                DirectionDetails(
                    address: Address.fromJson(
                        widget.orderToShow.direction!.toJson())),

                buildTitle(title: 'Fecha y hora'),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        '${widget.orderToShow.schedule!.day!.day} / ${widget.orderToShow.schedule!.day!.month} / ${widget.orderToShow.schedule!.day!.year}',
                        style: txtStyleBodyBlack),
                    Text(
                        'A partir de: ${'${widget.orderToShow.schedule!.hour} : ${widget.orderToShow.schedule!.minute}'}',
                        style: txtStyleBodyBlack),
                  ],
                ),

                const SizedBox(
                  height: paddingVertical * 4,
                )

                // ...List.generate(2, (index) => ItemProductListDetails(product: product_cart_example))
              ],
            ),
          ),
        ),
      ),
    );
  }

  late Future<DateTime?> selectedDate;
  String date = "-";

  late Future<TimeOfDay?> selectedTime;
  String time = "-";

  void _showDialogTimePicker(BuildContext context) {
    // Show the time picker dialog and return the selected time as a Future.
    selectedTime = showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        // Customize the look and feel of the dialog using a custom theme.
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              // primary: MyColors.primary,
              primary: AppColor.primary,
              onPrimary: primaryLightColor,
              surface: primaryLightColor,
              onSurface: primaryColorStrong,
            ),
            //.dialogBackgroundColor:Colors.blue[900],
          ),
          child: child!,
        );
      },
    );
    // When the user selects a time, update the state of the widget with the new time value.
    selectedTime.then((value) {
      setState(() {
        if (value == null) return;
        time = "${value.hour} : ${value.minute}";
        widget.orderToShow.schedule!.hour = value.hour;
        widget.orderToShow.schedule!.minute = value.minute;
      });
    }, onError: (error) {
      // Handle any errors that occur when selecting a time (e.g. user cancels).
      if (kDebugMode) {
        debugPrint(error);
      }
    });
  }

  DateTime? selected;

  _selectDate(BuildContext context) {
    selectedDate = showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: new DateTime.now().add(new Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColor.primary, // <-- SEE HERE
              onPrimary: primaryColor, // <-- SEE HERE
              onSurface: primaryColorStrong, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: AppColor.primary, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    selectedDate.then((value) {
      setState(() {
        if (value == null) return;
        date = "${value.day} / ${value.month} / ${value.year}";
        widget.orderToShow.schedule!.day = value;
      });
    }, onError: (error) {
      // Handle any errors that occur when selecting a time (e.g. user cancels).
      if (kDebugMode) {
        debugPrint(error);
      }
    });
  }
}
