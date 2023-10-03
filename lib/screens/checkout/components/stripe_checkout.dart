import 'package:domas_ecommerce/constant/app_color.dart';
import 'package:domas_ecommerce/constants.dart';
import 'package:domas_ecommerce/ui/general.dart';
import 'package:domas_ecommerce/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CheckoutStripe extends StatefulWidget {
  final String sessionId;
  final String paymethod;

  const CheckoutStripe(
      {super.key, required this.sessionId, required this.paymethod});

  @override
  _CheckoutStripeState createState() => _CheckoutStripeState();
}

class _CheckoutStripeState extends State<CheckoutStripe> {
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Expanded(
                  flex: 1,
                  child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: paddingHorizontal / 2),
                      child: Icon(
                        Icons.warning,
                        color: primaryColorStrong,
                      )),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    '¿Estás seguro de salir?',
                    overflow: TextOverflow.clip,
                  ),
                ),
              ],
            ),
            content: const Text(
              'Estás a punto de cancelar la operación y regresar al paso previo, podrás acceder nuevamente al seleccionar el método de pago Tarjeta de crédito',
              style: txtStyleSubTitlePurpleStrong,
              overflow: TextOverflow.clip,
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: paddingVertical / 2,
                    horizontal: paddingHorizontal / 2),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: primaryColorStrong,
                    padding: const EdgeInsets.symmetric(
                        horizontal: paddingHorizontal / 2,
                        vertical: paddingVertical / 2),
                    backgroundColor: AppColor.border,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    shadowColor: Colors.transparent,
                  ),
                  child: const Text(
                    'Regresar',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: AppColor.secondary),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: paddingVertical / 2,
                    horizontal: paddingHorizontal / 2),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: primaryColorStrong,
                    padding: const EdgeInsets.symmetric(
                        horizontal: paddingHorizontal / 2,
                        vertical: paddingVertical / 2),
                    backgroundColor: AppColor.border,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    shadowColor: Colors.transparent,
                  ),
                  child: const Text(
                    'Continuar',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: AppColor.secondary),
                  ),
                ),
              ),
            ],
          ),
        )) ??
        false;
  }

  late WebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final res = await _onWillPop();
        if (res) {
          Navigator.pop(context, false);
        }

        return res;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Regresar',
            style: txtStyleSubTitlePurpleStrong,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: primaryColorStrong),
            onPressed: () async {
              final res = await _onWillPop();
              if (res) {
                Navigator.pop(context, false);
              }
            },
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: WebView(
            initialUrl: initialUrl,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (webViewController) => setState(() {
              _webViewController = webViewController;
            }),
            onPageFinished: (String url) async {
              if (url == initialUrl) {
                await _redirectToStripe(widget.sessionId);
              }
            },
            navigationDelegate: (NavigationRequest request) async {
              if (request.url.startsWith('http://localhost:8080/#/success')) {
                Navigator.pop(context, true);
                // final data = await rechargeprovider.step5RechargeCitizen();

                // if (validateUpdateDocument(
                //     rechargeprovider.resRechargeCitizenStep5,
                //     rechargeprovider.setErrorMessage)) {
                //   Navigator.pop(
                //       context,
                //       CheckoutResult(
                //           message: 'Payment success', success: true));
                // } else {

                // }
              } else if (request.url
                  .startsWith('http://localhost:8080/#/cancel')) {
                Navigator.pop(context, false);
              }
              return NavigationDecision.navigate;
            },
          ),
        ),
      ),
    );
  }

  String get initialUrl => 'https://marcinusx.github.io/test1/index.html';

  Future<void> _redirectToStripe(
    String sessionId,
  ) async {
    final apiKey =
        'pk_test_51MfMfCK1ApnvfbhnQFhHZw88hKtqe59IRlUauIClCy67IYt1KSBK1jHBUOQLSaLF9VO95hZdorQNJojXdZFROLZs00Ihu3B7wO';

    final redirectToCheckoutJs = '''
var stripe = Stripe('$apiKey');
stripe.redirectToCheckout({
  sessionId: '$sessionId'
}).then(function (result) {
  result.error.message = 'Error'
});
''';
    try {
      print(_webViewController);
      final String res = await _webViewController
          .runJavascriptReturningResult(redirectToCheckoutJs);
      print(res);
    } on PlatformException catch (e) {
      if (!e.details.contains(
          'JavaScript execution returned a result of an unsupported type')) {
        rethrow;
      }
    }
  }
}
