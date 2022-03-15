import '../models/song_metadata.dart';
import '../screens/offline/offline_screen.dart';
import '../services/audio_manager.dart';
import '../util/log.dart';
import '../models/enums.dart';
import 'value_notifier.dart';

void btnLikeTaped(bool isLiked) {
  logging("song ${isLiked ? 'liked' : 'disLiked'}");
}

void btnPlayTaped() {
  AudioManager().playAudio();
}

void btnPlayAllTaped() {
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

void btnLoopModeTaped() {
  AudioManager().repeat();
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

void songItemTaped(
    {SongMetadata? audioMetadata,
    required int index,
    List<SongMetadata>? playlist}) {
  AudioManager().setPlaylist(playlist: playlist, index: index);
  if (audioMetadata != null) {
    var temp = audioStatusNotifier.value == AudioStatus.playing &&
        currentSongIDNotifier.value == audioMetadata.id;
    if (temp) {
      AudioManager().pauseAudio();
    } else {
      if (audioStatusNotifier.value == AudioStatus.playing) {
        AudioManager().pauseAudio();
        AudioManager().seekToAudioItem(index);
        AudioManager().playAudio();
      } else if (currentSongIDNotifier.value == audioMetadata.id) {
        AudioManager().playAudio();
      } else {
        AudioManager().seekToAudioItem(index);
        AudioManager().playAudio();
      }
    }
  } else {
    AudioManager().pauseAudio();
    AudioManager().seekToAudioItem(index);
    AudioManager().playAudio();
  }
}
