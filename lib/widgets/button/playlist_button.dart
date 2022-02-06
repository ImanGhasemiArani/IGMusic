import 'package:flutter/material.dart';

import '../../controllers/pressed_buttons.dart';

class PlaylistButton extends StatelessWidget {
  const PlaylistButton({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      enableFeedback: false,
      borderRadius: BorderRadius.circular(20),
      onTap: () => playlistButtonPressed(),
      child: child,
    );
  }
}
