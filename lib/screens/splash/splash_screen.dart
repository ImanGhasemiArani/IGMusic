import 'package:flutter/material.dart';

import '../../assets/imgs.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(Imgs.img_splash_screen_loading_img);
  }
}
