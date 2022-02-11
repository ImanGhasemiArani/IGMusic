import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ig_music/assets/icos.dart';
import 'package:ig_music/widgets/visualizer/circular_visualizer.dart';

import '../../assets/clrs.dart';
import '../../assets/imgs.dart';
import '../../controllers/audio_manager.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isExpanded = false;
  late final double _maxHeight;
  late final double _minHeight;
  late double _currentHeight;

  @override
  void initState() {
    _maxHeight = 350;
    _minHeight = 70;
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _currentHeight = _minHeight;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final maxWidth = size.width * 0.9;
    final minWidth = size.width * 0.4;
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
            final value =
                const ElasticInOutCurve(0.7).transform(_controller.value);
            return Stack(
              children: [
                Positioned(
                  height: lerpDouble(_minHeight, _currentHeight, value),
                  left: lerpDouble(size.width / 2 - minWidth / 2,
                      size.width / 2 - maxWidth / 2, value),
                  width: lerpDouble(minWidth, maxWidth, value),
                  bottom: lerpDouble(40, size.width / 2 - maxWidth / 2, value),
                  child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                            bottom: Radius.circular(20)),
                        color: Colors.deepPurpleAccent,
                      ),
                      child: _isExpanded
                          ? Opacity(
                              opacity: _controller.value,
                              child: _buildExpandedContent())
                          : _buildMenuContent()),
                ),
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
        const Icon(Icos.offllineTab, color: Clrs.bottonNavIconColor, size: 30),
        GestureDetector(
          onLongPress: () {
            setState(() {
              _isExpanded = true;
              _currentHeight = _maxHeight;
              _controller.forward(from: 0);
            });
          },
          child: CircularVisualizer(
            onPressed: () {},
            child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: ValueListenableBuilder<Uint8List?>(
                  valueListenable: AudioManager().currentSongArtworkNotifier,
                  builder: (_, value, __) {
                    return getArtwork(value);
                  },
                )),
          ),
        ),
        const Icon(Icos.onlineTab, color: Clrs.bottonNavIconColor, size: 30),
      ],
    );
  }

  Image getArtwork(Uint8List? tmp) {
    var width = 50.0;
    var height = 50.0;
    return tmp == null || tmp.isEmpty
        ? Image.asset(
            Imgs.img_default_music_cover,
            width: width,
            height: height,
            fit: BoxFit.cover,
          )
        : Image.memory(
            tmp,
            width: width,
            height: height,
            fit: BoxFit.cover,
          );
  }
}
