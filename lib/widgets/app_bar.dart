import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../assets/clrs.dart';
import '../assets/icos.dart';
import '../screens/offline/offline_screen.dart';

AppBar searchAppBar() => AppBar(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(30),
      )),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ValueListenableBuilder<int>(
              valueListenable: OfflineScreen.currentBodyNotifier,
              builder: (_, value, __) {
                if (value == 0) {
                  return GestureDetector(
                    child: const Icon(
                      Icos.sliders,
                      color: Clrs.tmp,
                      size: 25,
                    ),
                    onTap: () {},
                  );
                } else {
                  return GestureDetector(
                    child: const Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.grey,
                      size: 25,
                    ),
                    onTap: () {
                      OfflineScreen.currentBodyNotifier.value = 0;
                    },
                  );
                }
              }),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                onTap: () {},
                autofocus: false,
                maxLines: 1,
                textAlignVertical: TextAlignVertical.center,
                readOnly: true,
                textDirection: TextDirection.rtl,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    suffixIcon: Icon(
                      Icos.search,
                      color: Clrs.tmp,
                      size: 25,
                    )),
                textAlign: TextAlign.right,
                style: GoogleFonts.ubuntuMono(color: Colors.black, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
