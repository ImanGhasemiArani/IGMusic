import 'package:flutter/material.dart';

typedef PressedFunction = void Function();

class BtnHeaderItem extends StatelessWidget {
  const BtnHeaderItem({Key? key, required this.child, required this.onTap}) : super(key: key);

  final Widget child;
  final PressedFunction onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      enableFeedback: false,
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: child,
    );
  }
}
