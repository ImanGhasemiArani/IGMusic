import 'package:flutter/material.dart';

import '../../controllers/pressed_buttons.dart';

class RecentlyButton extends StatelessWidget {
  const RecentlyButton({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      enableFeedback: false,
      borderRadius: BorderRadius.circular(20),
      onTap: () => recentlyButtonPressed(),
      child: child,
    );
  }
}
