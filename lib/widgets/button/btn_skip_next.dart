import 'package:flutter/material.dart';


import '../../assets/icos.dart';
import '../../controllers/btn_controllers.dart';
import '../../controllers/value_notifier.dart';
import 'tap_effect.dart';

class BtnSkipNext extends StatelessWidget {
  const BtnSkipNext({Key? key, this.color = Colors.white, this.size = 17})
      : super(key: key);
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isLastSongNotifier,
      builder: (_, value, __) {
        return TapEffect(
          onTap: value ? null : btnNextTaped,
          child: Icon(
            Icos.skip_next,
            size: size,
            color: value ? color.withOpacity(0.3) : color.withOpacity(0.8),
          ),
        );
      },
    );
  }
}
