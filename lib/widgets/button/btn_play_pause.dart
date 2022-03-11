import 'package:flutter/material.dart';

import '../../assets/icos.dart';
import '../../controllers/value_notifier.dart';
import '../../models/enums.dart';
import '../../controllers/btn_controllers.dart';
import 'tap_effect.dart';

class BtnPlayPause extends StatelessWidget {
  const BtnPlayPause({Key? key, this.onPlayTap, this.size = 60})
      : super(key: key);

  final double size;
  final VoidCallback? onPlayTap;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AudioStatus>(
      valueListenable: audioStatusNotifier,
      builder: (_, value, __) {
        return TapEffect(
            padding: EdgeInsets.zero,
            onTap: value == AudioStatus.paused
                ? onPlayTap ?? btnPlayTaped
                : btnPauseTaped,
            child: Container(
                height: size,
                width: size,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(100),
                ),
                // alignment: Alignment.,
                child: Icon(
                  value == AudioStatus.paused
                      ? Icos.play_fill_svgrepo_com
                      : Icos.pause_svgrepo_com,
                  size: size / 1.8,
                  color: Colors.white.withOpacity(0.8),
                )));
      },
    );
  }
}
