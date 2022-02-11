import 'package:flutter/material.dart';

typedef TapedFunction = void Function();

class SongItemBtn extends StatelessWidget {
  const SongItemBtn({Key? key, required this.child, required this.onTap})
      : super(key: key);

  final Widget child;
  final TapedFunction onTap;

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
