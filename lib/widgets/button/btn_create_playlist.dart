import 'package:flutter/material.dart';

import '../../assets/icos.dart';
import '../../models/user_data.dart';

class BtnCreatePlaylist extends StatelessWidget {
  const BtnCreatePlaylist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width / 4,
      child: Center(
        child: InkWell(
          enableFeedback: false,
          borderRadius: BorderRadius.circular(50),
          onTap: () {
            UserData().createPlaylist();
            // UserData().playlists.clear();
          },
          child: const Icon(Icos.createPlaylist, size: 30),
        ),
      ),
    );
  }
}
