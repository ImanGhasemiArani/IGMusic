import 'package:flutter/material.dart';

import '../models/models.dart';
import '../screens/offline/offline_screen.dart';
import 'audio_manager.dart';

void playlistBtnTaped() {
  OfflineScreen.currentBodyNotifier.value = 1;
}

void favoritesBtnTaped() {
  OfflineScreen.currentBodyNotifier.value = 2;
}

void recentlyBtnTaped() {
  OfflineScreen.currentBodyNotifier.value = 3;
}

void songItemTaped(SongMetadata audioMetadata, int index) {
  var temp = AudioManager().audioStatusNotifier.value == AudioStatus.playing &&
      AudioManager().currentSongIDNotifier.value == audioMetadata.id;
  if (temp) {
    AudioManager().pauseAudio();
  } else {
    if (AudioManager().audioStatusNotifier.value == AudioStatus.playing) {
      AudioManager().pauseAudio();
      AudioManager().setPlayList(index: index);
      AudioManager().playAudio();
    } else if (AudioManager().currentSongIDNotifier.value == audioMetadata.id) {
      AudioManager().playAudio();
    } else {
      AudioManager().setPlayList(index: index);
      AudioManager().playAudio();
    }
  }


  //   showModalBottomSheet(
  //       transitionAnimationController: _controller,
  //       context: context,
  //       backgroundColor: Colors.transparent,
  //       isScrollControlled: true,
  //       builder: (builder) {
  //         return const MusicItemPage();
  //       });
}
