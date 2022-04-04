import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../assets/fonts.dart';
import '../assets/icos.dart';
import '../controllers/btn_controllers.dart';
import '../lang/strs.dart';
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
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(10),
      ),
    ),
    leading: TapEffect(
      onTap: scaffoldKey.currentState!.openDrawer,
      child: Icon(
        Icos.sliders,
        color: iconColor,
        size: 25,
      ),
    ),
    centerTitle: true,
    title: SizedBox(
      height: size.height * 0.68,
      child: TextField(
        onTap: btnSearchTaped,
        readOnly: true,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: Strs.searchStr.tr,
          hintMaxLines: 1,
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 0,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 0,
            ),
          ),
          contentPadding: const EdgeInsets.all(0),
          fillColor: Theme.of(context).cardColor,
          filled: true,
          suffixIcon: Icon(
            Icos.search,
            color: Theme.of(context).colorScheme.primary,
            size: 25,
          ),
        ),
        style: Fonts.regular_16_2,
      ),
    ),
  );
}
