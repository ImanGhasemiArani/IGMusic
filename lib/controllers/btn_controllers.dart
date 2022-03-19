import 'dart:async';

import '../models/song_metadata.dart';
import '../screens/offline/offline_screen.dart';
import '../services/audio_manager.dart';
import '../util/log.dart';
import '../models/enums.dart';
import 'value_notifier.dart';

void btnLikeTaped(bool isLiked) {
  logging("song ${isLiked ? 'liked' : 'disLiked'}");
}

void btnSetSpeedTaped(double speed) {
  AudioManager().setSpeed(speed);
}

Future<void> btnSetTimerTaped(Duration time) async {
  var allSeconds = time.inSeconds;
  if (allSeconds != 0 && time != Duration.zero) {
    playbackTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      allSeconds--;
      playbackTimerNotifier.value = Duration(seconds: allSeconds);
      if (allSeconds == 0) {
        timer.cancel();
        btnPauseTaped();
      }
    });
  }
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

void btnShufflePlaybackTaped() {
  AudioManager().repeat(setRepeatModeTo: LoopModeState.shuffle);
  AudioManager().setPlaylist().then((value) => AudioManager()
      .audioPlayer
      .shuffle()
      .then((value) => AudioManager().playAudio()));
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
