import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../assets/icos.dart';
import '../controllers/btn_controllers.dart';
import '../screens/screen_holder.dart';
import 'button/tap_effect.dart';

AppBar searchAppBar(BuildContext context, Size size) {
  var iconColor = Theme.of(context).brightness != Brightness.dark
      ? Theme.of(context).colorScheme.surface
      : Theme.of(context).colorScheme.primary;
  return AppBar(
    automaticallyImplyLeading: false,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(40),
      bottomRight: Radius.circular(10),
    )),
    centerTitle: true,
    title: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TapEffect(
          onTap: () {
            scaffoldKey.currentState!.openDrawer();
          },
          child: Icon(
            Icos.sliders,
            color: iconColor,
            size: 25,
          ),
        ),
        Expanded(
          child: Center(
            child: GestureDetector(
              onTap: btnSearchTaped,
              child: Container(
                height: size.height * 0.65,
                padding: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.centerRight,
                child: Icon(
                  Icos.search,
                  color: Theme.of(context).colorScheme.primary,
                  size: 25,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
