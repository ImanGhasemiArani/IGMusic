import 'package:flutter/material.dart';

class TapEffect extends StatefulWidget {
  const TapEffect(
      {Key? key,
      required this.child,
      this.onTap,
      this.padding = const EdgeInsets.all(10)})
      : super(key: key);
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  @override
  State<TapEffect> createState() => _TapEffectState();
}

class _TapEffectState extends State<TapEffect>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> easeInAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 150,
        ),
        value: 1.0);
    easeInAnimation = Tween(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeIn,
      ),
    );
    controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onTap == null) {
          return;
        }
        controller.forward().then((val) {
          widget.onTap!();
          controller.reverse();
        });
      },
      child: Container(
        color: Colors.transparent,
        padding: widget.padding,
        child: ScaleTransition(
          scale: easeInAnimation,
          child: widget.child,
        ),
      ),
    );
  }
}
