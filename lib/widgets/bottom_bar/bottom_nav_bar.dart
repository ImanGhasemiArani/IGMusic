import 'dart:ui';

import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isExpanded = false;
  final double _maxHeight = 350;
  final double _minHeight = 70;
  late double _currentHeight;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _currentHeight = _minHeight;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onVerticalDragUpdate: _isExpanded
          ? (details) {
              setState(() {
                final newHeight = _currentHeight - details.delta.dy;
                _controller.value = _currentHeight / _maxHeight;
                _currentHeight = newHeight.clamp(_minHeight, _maxHeight);
              });
            }
          : null,
      onVerticalDragEnd: _isExpanded
          ? (details) {
              if (_currentHeight < _maxHeight / 1.5) {
                _controller.reverse();
                _isExpanded = false;
              } else {
                _isExpanded = true;
                _controller.forward(from: _currentHeight / _maxHeight);
                _currentHeight = _maxHeight;
              }
            }
          : null,
      child: AnimatedBuilder(
          animation: _controller,
          builder: (context, snapshot) {
            final value = const ElasticInOutCurve(0.7).transform(_controller.value);
            return Stack(
              children: [
                Positioned(
                  height: lerpDouble(_minHeight, _currentHeight, value),
                  left: lerpDouble(size.width / 2 - size.width * 0.4 / 2, 0, value),
                  width: lerpDouble(size.width * 0.4, size.width, value),
                  bottom: lerpDouble(40, 0, value),
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                            top: const Radius.circular(20),
                            bottom: Radius.circular(lerpDouble(20, 0, value)!)),
                        color: Colors.deepPurpleAccent,
                      ),
                      child: _isExpanded
                          ? Opacity(opacity: _controller.value, child: _buildExpandedContent())
                          : _buildMenuContent()),
                ),
                // Positioned(child: child),
              ],
            );
          }),
    );
  }

  Widget _buildExpandedContent() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          children: [
            Container(
              color: Colors.black,
              height: 80,
              width: 80,
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              "Iman",
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              "Ghasemi Arani",
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Icon(Icons.shuffle),
                Icon(Icons.pause),
                Icon(Icons.playlist_add),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMenuContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Icon(Icons.accessibility_new_rounded),
        GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = true;
                _currentHeight = _maxHeight;
                _controller.forward(from: 0);
              });
            },
            child: const Icon(Icons.multitrack_audio_rounded)),
        const Icon(Icons.access_alarms_rounded),
      ],
    );
  }
}
