import 'package:flutter/material.dart';

import 'home_screen.dart';

class OnlineScreen extends StatelessWidget {
  const OnlineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const HomeScreen(),
    );
  }
}
