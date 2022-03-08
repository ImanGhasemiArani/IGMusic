import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';

import 'button_nav_bar_content_menu.dart';
import 'full_player.dart';
import 'mini_player.dart';

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
  bool _isFullExpanding = false;
  bool _isSemiExpanding = false;
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
    _medHeight = widget.size.width * 0.7;
    _minHeight = (widget.size.height * 0.09).clamp(65, 75);
    _maxWidth = widget.size.width;
    _medWidth = widget.size.width * 0.7;
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
                if (_currentHeight >= _medHeight) {
                  _isFullExpanding = true;
                  _isSemiExpanding = false;
                  _controller.value = _currentHeight / _maxHeight;
                  _currentHeight = newHeight.clamp(_minHeight, _maxHeight);
                } else {
                  _isFullExpanding = false;
                  _isSemiExpanding = true;
                  _controller.value = _currentHeight / _medHeight;
                  _currentHeight = newHeight.clamp(_minHeight, _medHeight);
                }
              });
            }
          : null,
      onVerticalDragEnd: _isSemiExpanded
          ? (details) {
              if (_currentHeight < _medHeight / 1.5) {
                _isSemiExpanding = true;
                _controller.reverse().then((value) => _isSemiExpanding = false);
                _isSemiExpanded = false;
                _isFullExpanded = false;
                _isFullExpanding = false;
              } else if (_currentHeight > _maxHeight * 0.5 ||
                  (!_isSemiExpanding && details.primaryVelocity! != 0)) {
                _currentHeight = _maxHeight;
                _isFullExpanding = true;
                _isSemiExpanding = false;
                _controller
                    .forward(from: _currentHeight / _maxHeight)
                    .then((value) => _isFullExpanding = false);
                _isSemiExpanded = false;
                _isFullExpanded = true;
              } else if (_currentHeight >= _medHeight / 1.5) {
                _currentHeight = _medHeight;
                _isSemiExpanding = true;

                _controller
                    .forward(from: _currentHeight / _medHeight)
                    .then((value) => _isSemiExpanding = false);
                _isSemiExpanded = true;
                _isFullExpanded = false;
                _isFullExpanding = false;
              }
            }
          : _isFullExpanded
              ? (details) {
                  if (details.primaryVelocity != 0) {
                    _isFullExpanding = false;
                    setState(() {
                      _isSemiExpanded = false;
                      _controller.reverse().then((value) {
                        _isFullExpanded = false;
                        _currentHeight = _minHeight;
                      });
                    });
                  }
                }
              : null,
      child: AnimatedBuilder(
          animation: _controller,
          builder: (context, snapshot) {
            final value =
                ElasticInOutCurve(_currentHeight <= _medHeight ? 0.7 : 4)
                    .transform(_controller.value);
            return Stack(
              children: [
                Positioned(
                  width: _isFullExpanding
                      ? lerpDouble(_medWidth, _maxWidth, value)
                      : _isSemiExpanding || _isSemiExpanded
                          ? lerpDouble(_minWidth, _medWidth, value)
                          : lerpDouble(_minWidth, _maxWidth, value),
                  height: _isFullExpanding
                      ? lerpDouble(_medHeight, _currentHeight, value)
                      : lerpDouble(_minHeight, _currentHeight, value),
                  left: _isFullExpanding
                      ? lerpDouble(size.width / 2 - _medWidth / 2, 0, value)
                      : _isSemiExpanding || _isSemiExpanded
                          ? lerpDouble(size.width / 2 - _minWidth / 2,
                              size.width / 2 - _medWidth / 2, value)
                          : lerpDouble(
                              size.width / 2 - _minWidth / 2, 0, value),
                  bottom: _isFullExpanding
                      ? lerpDouble(size.width / 2 - _medWidth / 2, 0, value)
                      : _isSemiExpanding || _isSemiExpanded
                          ? lerpDouble(
                              20, size.width / 2 - _medWidth / 2, value)
                          : lerpDouble(20, 0, value),
                  child: GlassContainer(
                    blur: 30,
                    opacity: 0.2,
                    border: const Border.fromBorderSide(BorderSide.none),
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        _isFullExpanding
                            ? lerpDouble(40, 10, value)!
                            : _isSemiExpanding || _isSemiExpanded
                                ? lerpDouble(20, 40, value)!
                                : lerpDouble(20, 0, value)!,
                      ),
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: _isSemiExpanded
                          ? Opacity(
                              opacity: _isFullExpanding ? 1 : _controller.value,
                              child: MiniPlayer(maxWidth: _medWidth),
                            )
                          : _isFullExpanded
                              ? Opacity(
                                  opacity: _controller.value,
                                  child: FullPlayer(
                                    closeButtonOnTap: () {
                                      setState(() {
                                        _isSemiExpanded = false;
                                        _controller.reverse().then((value) {
                                          _isFullExpanded = false;
                                          _currentHeight = _minHeight;
                                        });
                                      });
                                    },
                                  ),
                                )
                              : ButtonNavBarContentMenu(
                                  avatarOnTap: () {
                                    setState(() {
                                      _isSemiExpanded = true;
                                      _isFullExpanded = false;
                                      _currentHeight = _medHeight;
                                      _controller.forward(from: 0);
                                    });
                                  },
                                ),
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
