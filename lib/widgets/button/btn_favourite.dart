import 'package:flutter/material.dart';
import 'package:ig_music/controllers/btn_controllers.dart';
import 'package:ig_music/widgets/button/tap_effect.dart';

import '../../assets/icos.dart';

class BtnFavourite extends StatelessWidget {
  BtnFavourite({Key? key, bool isLiked = false, this.size = 20})
      : isLiked = ValueNotifier<bool>(isLiked),
        super(key: key);

  final ValueNotifier<bool> isLiked;
  final double size;

  @override
  Widget build(BuildContext context) {
    return TapEffect(
        onTap: () {
          isLiked.value = !isLiked.value;
          btnLikeTaped(isLiked.value);
        },
        child: ValueListenableBuilder<bool>(
            valueListenable: isLiked,
            builder: (_, value, __) {
              return value
                  ? Icon(
                      Icos.heart,
                      color: Colors.red,
                      size: size,
                    )
                  : Icon(
                      Icos.heart_outlined,
                      color: Colors.white.withOpacity(0.7),
                      size: size,
                    );
            }));
  }
}
