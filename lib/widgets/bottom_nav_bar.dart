import 'dart:ui';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:flutter/material.dart';
import '../controllers/btn_controllers.dart';
import '../models/user_data.dart';
import '../util/log.dart';
import 'button_nav_bar_content_menu.dart';
import 'mini_player.dart';

class BottomNavBar extends HookWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logging("rebuild");
    final size = MediaQuery.of(context).size;
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 500),
    );
    final isSemiExpanded = useState(false);
    final double medHeight = size.width * 0.7;
    final double minHeight = (size.height * 0.07).clamp(60, 70);
    final double medWidth = size.width * 0.7;
    final double minWidth = size.width * 0.6;
    var currentHeight = useState(minHeight);

    return GestureDetector(
      onVerticalDragUpdate: isSemiExpanded.value
          ? (details) {
              final newHeight = currentHeight.value - details.delta.dy;
              controller.value = currentHeight.value / medHeight;
              currentHeight.value = newHeight.clamp(minHeight, medHeight);
            }
          : null,
      onVerticalDragEnd: isSemiExpanded.value
          ? (details) {
              if (currentHeight.value < medHeight / 1.5) {
                controller.reverse();
                isSemiExpanded.value = false;
              } else if (currentHeight.value >= medHeight / 1.5) {
                currentHeight.value = medHeight;
                controller.forward(from: currentHeight.value / medHeight);
                isSemiExpanded.value = true;
              }
            }
          : null,
      child: AnimatedBuilder(
          animation: controller,
          builder: (context, snapshot) {
            var value =
                const ElasticInOutCurve(0.7).transform(controller.value);
            return Stack(
              children: [
                Positioned(
                  width: lerpDouble(minWidth, medWidth, value),
                  height: lerpDouble(minHeight, currentHeight.value, value),
                  left: lerpDouble(size.width / 2 - minWidth / 2,
                      size.width / 2 - medWidth / 2, value),
                  bottom: lerpDouble(20, size.width / 2 - medWidth / 2, value),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(lerpDouble(20, 40, value)!),
                      ),
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: isSemiExpanded.value
                          ? Opacity(
                              opacity: controller.value,
                              child: MiniPlayer(maxWidth: medWidth),
                            )
                          : ButtonNavBarContentMenu(
                              avatarOnTap: () {
                                if (UserData().recentlyPlayedSongs.isNotEmpty) {
                                  isSemiExpanded.value = true;
                                  currentHeight.value = medHeight;
                                  controller.forward(from: 0);
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