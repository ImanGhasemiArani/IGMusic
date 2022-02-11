import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../controllers/audio_manager.dart';

class CircularVisualizer extends StatefulWidget {
  const CircularVisualizer(
      {Key? key, required this.child, required this.onPressed})
      : super(key: key);

  final Widget child;
  final VoidCallback onPressed;

  @override
  State<CircularVisualizer> createState() => _CircularVisualizerState();
}

class _CircularVisualizerState extends State<CircularVisualizer>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _scaleController;

  double _rotation = 0;
  double _scale = 0.85;

  bool get _showWaves => !_scaleController.isDismissed;

  @override
  void initState() {
    _rotationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 5))
          ..addListener(() => setState(() {
                _rotation = _rotationController.value * 2 * pi;
              }))
          ..repeat();
    _scaleController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300))
      ..addListener(() => setState(() {
            _scale = (_scaleController.value * 0.2) + 0.85;
          }));
    AudioManager().audioChangeStatus = _updateIsPlaying;
    if (AudioManager().audioStatusNotifier.value == AudioStatus.playing) {
      _updateIsPlaying(true);
    } else {
      _updateIsPlaying(false);
    }
    super.initState();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 50,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
        child: Stack(
          children: [
            if (_showWaves) ...[
              Blob(
                  color: const Color(0xff0092ff),
                  scale: _scale,
                  rotation: _rotation),
              Blob(
                  color: const Color(0xff4ac7b7),
                  scale: _scale,
                  rotation: _rotation * 2 - 30),
              Blob(
                  color: const Color(0xffa4a6f6),
                  scale: _scale,
                  rotation: _rotation * 3 - 45),
            ],
            Container(
                constraints: const BoxConstraints.expand(),
                decoration: const BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: SizedBox.expand(
                    key: ValueKey<AudioStatus>(
                        AudioManager().audioStatusNotifier.value),
                    child: widget.child,
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void _updateIsPlaying(bool isP) {
    if (!isP) {
      if (_scaleController.isCompleted) {
        _scaleController.reverse();
      }
    } else {
      _scaleController.forward();
    }

    widget.onPressed();
  }
}

class Blob extends StatelessWidget {
  const Blob({
    Key? key,
    this.rotation = 0,
    this.scale = 1,
    required this.color,
  }) : super(key: key);

  final double rotation;
  final double scale;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Transform.rotate(
        angle: rotation,
        child: Container(
          decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(150),
                  topRight: Radius.circular(240),
                  bottomLeft: Radius.circular(220),
                  bottomRight: Radius.circular(180))),
        ),
      ),
    );
  }
}
