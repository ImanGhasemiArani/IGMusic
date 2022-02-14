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
  bool _isSemiExpanded = false;
  bool _isFullExpanded = false;
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
    _medHeight = widget.size.width * 0.97;
    _minHeight = (widget.size.height * 0.09).clamp(65, 75);
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
      onVerticalDragUpdate: _isSemiExpanded
          ? (details) {
              setState(() {
                final newHeight = _currentHeight - details.delta.dy;
                _controller.value = _currentHeight / _medHeight;
                _currentHeight = newHeight.clamp(_minHeight, _maxHeight);
              });
            }
          : null,
      onVerticalDragEnd: _isSemiExpanded
          ? (details) {
              if (_currentHeight < _medHeight / 1.5) {
                _controller.reverse();
                _isSemiExpanded = false;
                _isFullExpanded = false;
              } else if (_currentHeight < _maxHeight * 0.5) {
                _isSemiExpanded = true;
                _isFullExpanded = false;
                _controller.forward(from: _currentHeight / _medHeight);
                _currentHeight = _medHeight;
              } else if (_currentHeight > _maxHeight * 0.5) {
                _isSemiExpanded = false;
                _isFullExpanded = true;
                _controller.forward(from: _currentHeight / _maxHeight);
                _currentHeight = _maxHeight;
              } else {
                _isSemiExpanded = true;
                _isFullExpanded = false;
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
                  width: _currentHeight <= _medHeight
                      ? lerpDouble(_minWidth, _medWidth, value)
                      : _isFullExpanded
                          ? lerpDouble(_minWidth, _maxWidth, value)
                          : lerpDouble(_medWidth, _maxWidth, value),
                  height: lerpDouble(_minHeight, _currentHeight, value),
                  left: _currentHeight <= _medHeight
                      ? lerpDouble(size.width / 2 - _minWidth / 2,
                          size.width / 2 - _medWidth / 2, value)
                      : _isFullExpanded
                          ? lerpDouble(size.width / 2 - _minWidth / 2, 0, value)
                          : lerpDouble(
                              size.width / 2 - _medWidth / 2, 0, value),
                  bottom: _currentHeight <= _medHeight
                      ? lerpDouble(40, size.width / 2 - _medWidth / 2, value)
                      : _isFullExpanded
                          ? lerpDouble(40, 0, value)
                          : lerpDouble(
                              size.width / 2 - _medWidth / 2, 0, value),
                  child: GlassContainer(
                    blur: 30,
                    opacity: 0.2,
                    border: Border.fromBorderSide(_isSemiExpanded
                        ? BorderSide.none
                        : const BorderSide(color: Colors.grey)),
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(
                          _currentHeight <= _medHeight
                              ? lerpDouble(20, 30, value)!
                              : lerpDouble(30, 0, value)!,
                        ),
                        bottom: Radius.circular(
                          _currentHeight <= _medHeight
                              ? lerpDouble(20, 30, value)!
                              : lerpDouble(30, 0, value)!,
                        )),
                    child: _isSemiExpanded
                        ? Opacity(
                            opacity: _controller.value,
                            child: MiniPlayer(
                              maxWidth: _medWidth,
                              draggableLineWidget: Container(
                                  height: 3,
                                  width: _medWidth * 0.1,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(100),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.7),
                                          blurRadius: 10,
                                        ),
                                      ])),
                            ))
                        : _isFullExpanded
                            ? _buildFullPlayer()
                            : _buildMenuContent(),
                  ),
                ),
              ],
            );
          }),
    );
  }

  Widget _buildFullPlayer() {
    return ValueListenableBuilder<Uint8List?>(
      valueListenable: AudioManager().currentSongArtworkNotifier,
      builder: (_, value, __) {
        return Stack(children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: getArtwork(value).image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          GlassContainer(
            width: _maxWidth,
            height: _maxHeight,
            blur: 20,
            border: const Border.fromBorderSide(BorderSide.none),
            opacity: 0.05,
            borderRadius: BorderRadius.circular(20),
          ),
          Center(
            child: GestureDetector(
                onTap: () {
                  setState(() {
                    _controller.reverse(from: _maxHeight).then((value) {
                      _isSemiExpanded = false;
                      _isFullExpanded = false;
                      _currentHeight = _minHeight;
                    });
                  });
                },
                child: const Icon(
                  Icons.close,
                  color: Colors.red,
                  size: 50,
                )),
          ),
        ]);
      },
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
              _isSemiExpanded = true;
              _isFullExpanded = false;
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
