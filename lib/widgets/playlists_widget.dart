import 'package:flutter/material.dart';

import '../controllers/value_notifier.dart';
import '../models/playlist.dart';
import '../models/user_data.dart';
import 'button/btn_create_playlist.dart';
import 'card/card_favorites_playlist.dart';
import 'card/card_playlist_item.dart';

class PlaylistsWidget extends StatelessWidget {
  const PlaylistsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.width / 4 + 8,
      width: size.width,
      child: ValueListenableBuilder<Playlist?>(
          valueListenable: playlistSongsNotifier,
          builder: (_, value, __) {
            return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                addAutomaticKeepAlives: true,
                physics: const BouncingScrollPhysics(),
                itemCount: UserData().playlists.length + 2,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const CardFavoritesPlaylist();
                  }
                  index--;
                  try {
                    return CardPlaylistItem(
                        index: index, playlist: UserData().playlists[index]);
                  } catch (e) {
                    return const BtnCreatePlaylist();
                  }
                });
          }),
    );
  }
}
