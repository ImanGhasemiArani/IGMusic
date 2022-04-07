import 'dart:ui';

import 'package:flutter/material.dart';
import '../controllers/btn_controllers.dart';
import '../models/user_data.dart';
import 'button_nav_bar_content_menu.dart';
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
  late final double _medHeight;
  late final double _minHeight;
  late final double _medWidth;
  late final double _minWidth;
  late double _currentHeight;

  @override
  void initState() {
    _medHeight = widget.size.width * 0.7;
    _minHeight = (widget.size.height * 0.07).clamp(60, 70);
    _medWidth = widget.size.width * 0.7;
    _minWidth = widget.size.width * 0.6;
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
                _currentHeight = newHeight.clamp(_minHeight, _medHeight);
              });
            }
          : null,
      onVerticalDragEnd: _isSemiExpanded
          ? (details) {
              if (_currentHeight < _medHeight / 1.5) {
                _controller.reverse();
                _isSemiExpanded = false;
              } else if (_currentHeight >= _medHeight / 1.5) {
                _currentHeight = _medHeight;
                _controller.forward(from: _currentHeight / _medHeight);
                _isSemiExpanded = true;
              }
            }
          : null,
      child: AnimatedBuilder(
          animation: _controller,
          builder: (context, snapshot) {
            var value =
                const ElasticInOutCurve(0.7).transform(_controller.value);
            return Stack(
              children: [
                Positioned(
                  width: lerpDouble(_minWidth, _medWidth, value),
                  height: lerpDouble(_minHeight, _currentHeight, value),
                  left: lerpDouble(size.width / 2 - _minWidth / 2,
                      size.width / 2 - _medWidth / 2, value),
                  bottom: lerpDouble(20, size.width / 2 - _medWidth / 2, value),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(lerpDouble(20, 40, value)!),
                      ),
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: _isSemiExpanded
                          ? Opacity(
                              opacity: _controller.value,
                              child: MiniPlayer(maxWidth: _medWidth),
                            )
                          : ButtonNavBarContentMenu(
                              avatarOnTap: () {
                                if (UserData().recentlyPlayedSongs.isNotEmpty) {
                                  setState(() {
                                    _isSemiExpanded = true;
                                    _currentHeight = _medHeight;
                                    _controller.forward(from: 0);
                                  });
                                } else {
                                  btnShufflePlaybackTaped();
                                }
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
