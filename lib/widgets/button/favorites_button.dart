import 'package:flutter/material.dart';

import '../../controllers/pressed_buttons.dart';

class FavoritesButton extends StatelessWidget {
  const FavoritesButton({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      enableFeedback: false,
      borderRadius: BorderRadius.circular(20),
      onTap: () => favoritesButtonPressed(),
      child: child,
    );
  }
}
