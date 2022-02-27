import 'package:flutter/material.dart';

import 'tap_effect.dart';

class BtnSongItem extends StatelessWidget {
  const BtnSongItem({Key? key, required this.child, required this.onTap})
      : super(key: key);

  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TapEffect(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: child,
    );
  }
}
