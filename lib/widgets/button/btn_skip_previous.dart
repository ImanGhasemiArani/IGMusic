import 'package:flutter/material.dart';
import 'package:ig_music/controllers/btn_controllers.dart';
import 'package:ig_music/widgets/button/tap_effect.dart';

import '../../assets/icos.dart';
import '../../controllers/audio_manager.dart';

class BtnSkipPrevious extends StatelessWidget {
  const BtnSkipPrevious({Key? key, this.color = Colors.white, this.size = 17})
      : super(key: key);
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AudioManager().isFirstSongNotifier,
      builder: (_, value, __) {
        return TapEffect(
          onTap: value ? null : btnPreviousTaped,
          child: Icon(
            Icos.skip_previous,
            size: size,
            color: value ? color.withOpacity(0.3) : color.withOpacity(0.8),
          ),
        );
      },
    );
  }
}
