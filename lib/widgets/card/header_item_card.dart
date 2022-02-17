import 'package:flutter/material.dart';

import '../button/btn_header_item.dart';

class HeaderItemCard extends StatelessWidget {
  const HeaderItemCard({
    Key? key,
    double? height,
    double? width,
    required this.onTap,
    required this.child,
  })  : height = height ?? double.infinity,
        width = width ?? double.infinity,
        super(key: key);

  final double height;
  final double width;
  final PressedFunction onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: BtnHeaderItem(
        onTap: onTap,
        child: Container(
          height: height,
          width: width,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: child,
        ),
      ),
    );
  }
}
