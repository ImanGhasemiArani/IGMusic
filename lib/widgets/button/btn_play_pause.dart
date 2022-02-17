import 'package:flutter/material.dart';

import '../../assets/icos.dart';
import '../../controllers/audio_manager.dart';
import '../../controllers/btn_controllers.dart';
import 'tap_effect.dart';

class BtnPlayPause extends StatelessWidget {
  const BtnPlayPause({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AudioStatus>(
      valueListenable: AudioManager().audioStatusNotifier,
      builder: (_, value, __) {
        return TapEffect(
            onTap: value == AudioStatus.paused ? btnPauseTaped : btnPlayTaped,
            child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(
                  value == AudioStatus.paused
                      ? Icos.play_fill_svgrepo_com
                      : Icos.pause_svgrepo_com,
                  size: 30,
                  color: Colors.white.withOpacity(0.8),
                )));
      },
    );
  }
}
