//?DATA NOR RECEIVED [NULL DATA]
import 'package:domas_ecommerce/components/components.dart';
import 'package:domas_ecommerce/constants.dart';
import 'package:domas_ecommerce/size_config.dart';
import 'package:domas_ecommerce/ui/ui.dart';
import 'package:domas_ecommerce/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

getNoDataReceivedText() => SizedBox(
    height: heightBody,
    width: SizeConfig.screenWidth,
    child: const Center(child: Text("No Data Received")));

//?
buildWidgetWaiting() {
  return SizedBox(
      height: heightBody,
      width: SizeConfig.screenWidth,
      child: const Center(child: CircularProgressIndicator()));
}

Future<bool> onWillPop(
    {required BuildContext context,
    required Widget icon,
    required String titleAlert,
    required String txtContentAlert,
    Widget? widgetToShow,
    required List<Widget> actions}) async {
  return (await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: paddingHorizontal / 2),
                    child: icon),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  titleAlert,
                  overflow: TextOverflow.clip,
                ),
              ),
            ],
          ),
          content: widgetToShow ??
              Text(
                txtContentAlert,
                style: txtStyleBodyBlack,
                overflow: TextOverflow.clip,
              ),
          actions: <Widget>[
            ...List.generate(
                actions.length,
                (index) => Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: paddingVertical / 2,
                        horizontal: paddingHorizontal / 2),
                    child: actions[index]))
          ],
        ),
      )) ??
      false;
}

buildSnackBarToState({required BuildContext context, required String txtBody}) {
  showModalBottomSheet(
      backgroundColor: primaryColor,
      useSafeArea: true,
      elevation: 10.0,
      builder: (BuildContext context) {
        return SizedBox(
          width: SizeConfig.screenWidth,
          height: SizeConfig.defaultSize,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: paddingVertical, horizontal: paddingHorizontal),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 6,
                  child: Text(
                    txtBody,
                    style: txtStyleSubTitleWhite,
                  ),
                ),
                Expanded(
                    flex: 3,
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: paddingVertical,
                              horizontal: paddingHorizontal / 2),
                          child: Text(
                            'Entendido',
                            style: txtStyleSubTitlePurpleStrong,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ))
              ],
            ),
          ),
        );
      },
      context: context);
}

showMessageModal(
    {required BuildContext context,
    required Widget titleIcon,
    required String titleTxt,
    Widget? contentWidget,
    List<Widget>? actions,
    required String contentTxt}) async {
  await showModalBottomSheet(
      context: context,
      constraints:
          BoxConstraints.tight(Size.fromHeight(SizeConfig.screenHeight / 2)),
      builder: ((context) => Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: paddingVertical, horizontal: paddingHorizontal),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    children: <Widget>[
                      Expanded(flex: 2, child: Center(child: titleIcon)),
                      Expanded(
                        flex: 10,
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          titleTxt,
                          style: txtStyleTitlePurpleStrong,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: paddingVertical / 2,
                    ),
                    child: Center(
                      child: contentWidget ??
                          Text(
                            overflow: TextOverflow.clip,
                            contentTxt,
                            style: txtStyleTitlePurpleStrong,
                          ),
                    ),
                  ),
                  actions != null
                      ? Column(
                          children: [
                            ...List.generate(
                                actions.length,
                                (index) => Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: paddingVertical / 2),
                                      child: actions[index],
                                    ))
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.only(
                              bottom: paddingVertical / 2),
                          child: DefaultButton(
                            text: 'Entendido',
                            press: () => Navigator.of(context).pop(),
                          ),
                        )
                ],
              ),
            ),
          )));
}
