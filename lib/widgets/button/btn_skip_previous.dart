import 'package:flutter/material.dart';

import '../../assets/icos.dart';
import '../../controllers/btn_controllers.dart';
import '../../controllers/value_notifier.dart';
import 'tap_effect.dart';

class BtnSkipPrevious extends StatelessWidget {
  const BtnSkipPrevious({Key? key, this.color = Colors.white, this.size = 17})
      : super(key: key);
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isFirstSongNotifier,
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
