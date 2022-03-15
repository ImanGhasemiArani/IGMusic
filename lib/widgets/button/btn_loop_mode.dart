import 'package:flutter/material.dart';

import '../../assets/icos.dart';
import '../../controllers/btn_controllers.dart';
import '../../controllers/value_notifier.dart';
import '../../models/enums.dart';
import 'tap_effect.dart';

class LoopButton extends StatelessWidget {
  const LoopButton({Key? key, this.color = Colors.white, this.size = 25})
      : super(key: key);
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isLastSongNotifier,
      builder: (_, value, __) {
        return TapEffect(
          onTap: value ? null : btnLoopModeTaped,
          child: ValueListenableBuilder<LoopModeState>(
              valueListenable: loopModeNotifier,
              builder: (_, value, __) {
                return Icon(
                  value == LoopModeState.loopAll
                      ? Icos.repeat
                      : value == LoopModeState.loopOne
                          ? Icos.repeat_once
                          : Icos.shuffle,
                  size: size,
                  color: color.withOpacity(0.7),
                );
              }),
        );
      },
    );
  }
}
