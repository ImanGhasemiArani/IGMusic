import 'dart:async';
import 'dart:core';
import 'dart:math';

import 'package:flutter/material.dart';

class VisualizerMusic extends StatelessWidget {
  const VisualizerMusic(
      {Key? key,
      required this.maxHeight,
      required this.maxWidth,
      required this.widthItem,
      required this.alignment})
      : super(key: key);

  final double maxHeight;
  final double maxWidth;
  final double widthItem;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    var counter = maxHeight.toInt() ~/ (widthItem + 2);
    return Container(
      height: maxHeight,
      width: maxWidth,
      decoration: BoxDecoration(
          color: Colors.transparent, borderRadius: BorderRadius.circular(15)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
              counter,
              (index) => _VisualizerMusicItem(
                    maxWidth: maxWidth,
                    height: widthItem,
                    alignment: alignment,
                  )),
        ),
      ),
    );
  }
}

class _VisualizerMusicItem extends StatefulWidget {
  const _VisualizerMusicItem(
      {Key? key, required this.maxWidth, required this.height, required this.alignment})
      : super(key: key);
  final double maxWidth;
  final double height;
  final AlignmentGeometry alignment;

  @override
  _VisualizerMusicItemState createState() => _VisualizerMusicItemState();
}

class _VisualizerMusicItemState extends State<_VisualizerMusicItem> {
  bool _goDown = false;
  double _width = 0;
  final Color _color = Colors.teal.withOpacity(0.8);
  final BorderRadiusGeometry _borderRadius =
      const BorderRadius.vertical(top: Radius.circular(2));
  final random = Random();
  late Duration _duration;
  late Timer _timer;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _duration = Duration(milliseconds: random.nextInt(50) + 150);
    _timer = Timer.periodic(_duration, (timer) {
      setState(() {
        if (_goDown) {
          _width -= random.nextInt(_width.toInt()).toDouble() + 1;
          _goDown = false;
        } else {
          _width +=
              random.nextInt((widget.maxWidth - _width).toInt()).toDouble() + 1;
          _goDown = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Align(
        alignment: widget.alignment,
        child: AnimatedContainer(
          width: _width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: _borderRadius,
            color: _color,
          ),
          duration: _duration,
          curve: Curves.bounceOut,
        ),
      ),
    );
  }
}
