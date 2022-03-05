import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../assets/icos.dart';
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
      bottomRight: Radius.circular(5),
    )),
    centerTitle: true,
    title: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: TapEffect(
            onTap: () {
              scaffoldKey.currentState!.openDrawer();
            },
            child: Icon(
              Icos.sliders,
              color: iconColor,
              size: 25,
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            height: size.height,
            child: Stack(
              children: [
                Container(
                  height: double.infinity,
                  margin: const EdgeInsets.fromLTRB(10, 5, 10, 15),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                TextField(
                  //   readOnly: true,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    suffixIcon: Icon(
                      Icos.search,
                      color: Theme.of(context).colorScheme.primary,
                      size: 25,
                    ),
                  ),
                  maxLines: 1,
                  minLines: 1,
                  style: GoogleFonts.itim(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
