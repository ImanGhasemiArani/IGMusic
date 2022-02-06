import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';

class MyGlassContainer extends StatelessWidget {
  const MyGlassContainer({Key? key, this.blur, required this.child})
      : super(key: key);
  final Widget child;
  final double? blur;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: BorderRadius.circular(15),
      height: double.infinity,
      width: double.infinity,
      gradient: LinearGradient(
        colors: [
          Colors.white.withOpacity(0.40),
          Colors.white.withOpacity(0.10)
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderGradient: LinearGradient(
        colors: [
          Colors.white.withOpacity(0.60),
          Colors.white.withOpacity(0.10),
          Colors.lightBlueAccent.withOpacity(0.05),
          Colors.lightBlueAccent.withOpacity(0.6)
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: const [0.0, 0.39, 0.40, 1.0],
      ),
      blur: blur ?? 5,
      borderWidth: 0,
      elevation: 3.0,
      shadowColor: Colors.black.withOpacity(0.20),
      alignment: Alignment.center,
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Align(alignment: Alignment.topLeft, child: child),
    );
  }
}
