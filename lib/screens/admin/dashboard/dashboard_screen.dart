import 'package:domas_ecommerce/constants.dart';
import 'package:domas_ecommerce/controllers/tabs.dart';
import 'package:domas_ecommerce/models/models.dart';
import 'package:domas_ecommerce/screens/admin/dashboard/shipping_list.dart';
import 'package:domas_ecommerce/services/services.dart';
import 'package:domas_ecommerce/ui/ui.dart';
import 'package:domas_ecommerce/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  static String routeName = "/dashboard";
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  PaymentIntentsService get ordersService =>
      GetIt.instance<PaymentIntentsService>();

  Map<String, List<PaymentIntent>> _list_orders_complete = {};

  Map<String, List<PaymentIntent>> get list_orders_complete =>
      _list_orders_complete;

  set list_orders_complete(Map<String, List<PaymentIntent>> value) {
    _list_orders_complete = value;
  }

  Map<String, List<PaymentIntent>> list_orders_pending = {};

  Map<String, List<PaymentIntent>> get orderAlreadyDone => list_orders_pending;

  set orderAlreadyDone(Map<String, List<PaymentIntent>> value) {
    list_orders_pending = value;
  }

  @override
  void initState() {
    super.initState();
    list_orders_pending = {
      'Monday': [order_example]
    };

    list_orders_complete = {
      'Monday': [order_example]
    };
  }

  buildWidgetResponse() {
    return TabBarView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        // Lista de pedidos a enviar
        RefreshIndicator(
          onRefresh: () async {
            Map<String, Map<String, List<PaymentIntent>>> result =
                await ordersService.loadPaymentIntents();
            list_orders_complete = result.containsKey('list_orders_complete')
                ? result['list_orders_complete'] ?? {}
                : {};
            list_orders_pending = result.containsKey('list_orders_pending')
                ? result['list_orders_pending'] ?? {}
                : {};
            setState(() {});
          },
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var element in list_orders_pending.entries) ...[
                  dateAndShippingWidget(
                      order_list: element.value, day: element.key)
                ]
              ],
            ),
          ),
        ),

        // Lista de pedidos entregados recientemente
        RefreshIndicator(
          onRefresh: () async {
            Map<String, Map<String, List<PaymentIntent>>> result =
                await ordersService.loadPaymentIntents();
            list_orders_complete = result.containsKey('list_orders_complete')
                ? result['list_orders_complete'] ?? {}
                : {};
            list_orders_pending = result.containsKey('list_orders_pending')
                ? result['list_orders_pending'] ?? {}
                : {};
            setState(() {});
          },
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var element in list_orders_complete.entries) ...[
                  dateAndShippingWidget(
                      order_list: element.value, day: element.key)
                ]
              ],
            ),
          ),
        ),
      ],
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // * SE PODRAN VISUALIZAR LOS PEDIDOS COMPLETADOS Y PENDIENTES DE LA SEMANA EN CURSO O EN SU DEFECTO A 7 DIAS DESPUES DEL ACTUAL
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: dashboardTabs().length,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: const SideMenu(),
        appBar: AppBar(
          title: const Text(
            'Dashboard',
            style: txtStyleSubTitlePurpleStrong,
          ),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: primaryColorStrong,
            labelColor: primaryColorStrong,
            unselectedLabelColor: primaryColor,
            labelStyle: txtStyleSubTitlePurpleStrong,
            tabs: [
              ...List.generate(
                  dashboardTabs().length, (index) => dashboardTabs()[index])
            ],
          ),
        ),
        body: FutureBuilder(
            future: ordersService.loadPaymentIntents(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // Future resolved check if it has error
                if (snapshot.hasError) {
                  // showErrorAlert(
                  //     context, 'Error al acceder a mis, Intenta mas tarde');
                  return const Center(
                    child: Text("Error en extracción de información"),
                  );
                } else if (snapshot.hasData) {
                  //NOTE: isEmpty can only be used on Maps and Strings
                  if (snapshot.data != null) {
                    list_orders_complete =
                        snapshot.data!.containsKey('list_orders_complete')
                            ? snapshot.data!['list_orders_complete'] ?? {}
                            : {};
                    list_orders_pending =
                        snapshot.data!.containsKey('list_orders_pending')
                            ? snapshot.data!['list_orders_pending'] ?? {}
                            : {};
                    return buildWidgetResponse();
                  }
                  return const Center(
                    child: Text("Data Received, but is empty"),
                  );
                } else {
                  return getNoDataReceivedText();
                }
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                // Future in progress
                return buildWidgetWaiting();
              } else {
                return Text("State: ${snapshot.connectionState}");
              }
            }),
      ),
    );
  }

  Widget dateAndShippingWidget(
      {required List<PaymentIntent> order_list, required String day}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: paddingVertical, horizontal: paddingHorizontal),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: paddingVertical),
            child: Text(
              DateFormat.yMMMd().format(DateTime.parse(order_list.isNotEmpty
                  ? order_list[0].schedule!.day.toString()
                  : '2023-05-04 14:36:54.507086')),
              style: txtStyleSubTitleBlack,
            ),
          ),
          ShippingList(salesToShip: order_list),
        ],
      ),
    );
  }
}
