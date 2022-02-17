import 'package:flutter/material.dart';
import 'package:ig_music/controllers/btn_controllers.dart';
import 'package:ig_music/widgets/button/tap_effect.dart';

import '../../assets/icos.dart';

// ignore: must_be_immutable
class BtnFavourite extends StatelessWidget {
  BtnFavourite({Key? key, this.isLiked = false, this.size = 20})
      : super(key: key);

  bool isLiked;
  final double size;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return TapEffect(
          onTap: () {
            setState(() {
              isLiked = !isLiked;
              btnLikeTaped(isLiked);
            });
          },
          child: isLiked
              ? Icon(
                  Icos.heart,
                  color: Colors.red,
                  size: size,
                )
              : Icon(
                  Icos.heart_outlined,
                  color: Colors.white.withOpacity(0.7),
                  size: size,
                ));
    });
  }
}
