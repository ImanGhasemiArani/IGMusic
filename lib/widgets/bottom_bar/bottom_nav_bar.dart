import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';

import '../../assets/clrs.dart';
import '../../assets/icos.dart';
import '../../assets/imgs.dart';
import '../../controllers/audio_manager.dart';
import '../mini_player.dart';
import '../visualizer/circular_visualizer.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key, required this.size}) : super(key: key);

  final Size size;

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isExpanded = false;
  late final double _maxHeight;
  late final double _medHeight;
  late final double _minHeight;
  late final double _maxWidth;
  late final double _medWidth;
  late final double _minWidth;
  late double _currentHeight;

  @override
  void initState() {
    _maxHeight = widget.size.height;
    _medHeight = widget.size.width * 0.9;
    _minHeight = widget.size.height * 0.09;
    _maxWidth = widget.size.width;
    _medWidth = widget.size.width * 0.9;
    _minWidth = widget.size.width * 0.4;
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _currentHeight = _minHeight;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = widget.size;

    return GestureDetector(
      onVerticalDragUpdate: _isExpanded
          ? (details) {
              setState(() {
                final newHeight = _currentHeight - details.delta.dy;
                _controller.value = _currentHeight / _medHeight;
                _currentHeight = newHeight.clamp(_minHeight, _medHeight);
              });
            }
          : null,
      onVerticalDragEnd: _isExpanded
          ? (details) {
              if (_currentHeight < _medHeight / 1.5) {
                _controller.reverse();
                _isExpanded = false;
              } else {
                _isExpanded = true;
                _controller.forward(from: _currentHeight / _medHeight);
                _currentHeight = _medHeight;
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
                  left: lerpDouble(size.width / 2 - _minWidth / 2,
                      size.width / 2 - _medWidth / 2, value),
                  width: lerpDouble(_minWidth, _medWidth, value),
                  bottom: lerpDouble(40, size.width / 2 - _medWidth / 2, value),
                  child: GlassContainer(
                    blur: 30,
                    opacity: 0.2,
                    border: Border.fromBorderSide(_isExpanded
                        ? BorderSide.none
                        : const BorderSide(color: Colors.grey)),
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(lerpDouble(20, 30, value)!),
                        bottom: Radius.circular(lerpDouble(20, 30, value)!)),
                    child: _isExpanded
                        ? Opacity(
                            opacity: _controller.value,
                            child: MiniPlayer(maxWidth: _medWidth))
                        : _buildMenuContent(),
                  ),
                ),
              ],
            );
          }),
    );
  }

  Widget _buildMenuContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Icon(Icos.offllineTab, color: Clrs.bottonNavIconColor, size: 30),
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = true;
              _currentHeight = _medHeight;
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
