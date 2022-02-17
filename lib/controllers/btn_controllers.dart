import 'package:ig_music/util/log.dart';

import '../models/models.dart';
import '../screens/offline/offline_screen.dart';
import 'audio_manager.dart';

void btnLikeTaped(bool isLiked) {
  logging("song ${isLiked ? 'liked' : 'disLiked'}");
}

void btnPlayTaped() {
  AudioManager().playAudio();
}

void btnPlayAllTaped() {
  AudioManager().setPlayList();
  AudioManager().playAudio();
}

void btnPauseTaped() {
  AudioManager().pauseAudio();
}

void btnNextTaped() {
  AudioManager().seekToNextAudio();
}

void btnPreviousTaped() {
  AudioManager().seekToPreviousAudio();
}

void btnPlaylistTaped() {
  OfflineScreen.currentBodyNotifier.value = 1;
}

void btnFavoritesTaped() {
  OfflineScreen.currentBodyNotifier.value = 2;
}

void btnRecentlyTaped() {
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
}
