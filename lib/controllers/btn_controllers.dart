import 'dart:async';
import 'dart:math';

import '../models/song_metadata.dart';
import '../models/user_data.dart';
import '../screens/offline/offline_screen.dart';
import '../services/audio_manager.dart';
import '../models/enums.dart';
import 'file_manager.dart';
import 'value_notifier.dart';

void btnLikeTaped({required SongMetadata songMetadata, bool isLiked = false}) {
  UserData().likeSong(songMetadata: songMetadata, setIsLike: isLiked);
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

void btnFavoritesPlaylistTaped() {
  var maps = UserData().audiosMetadataMapToID;
  var list = UserData().likedSongs.map((e) => maps[e] as SongMetadata).toList();
  if (list.isNotEmpty) {
    AudioManager().setPlaylist(playlist: list, index: 0);
  }
}

void btnShufflePlaybackTaped() {
  AudioManager().repeat(setRepeatModeTo: LoopModeState.shuffle);
  AudioManager()
      .setPlaylist(
          playlist: UserData().audiosMetadata,
          index: Random().nextInt(UserData().audiosMetadata.length))
      .then((value) => AudioManager()
          .audioPlayer
          .shuffle()
          .then((value) => AudioManager().playAudio()));
}

void songItemTaped(
    {SongMetadata? audioMetadata,
    required int index,
    List<SongMetadata>? playlist}) {
  if (audioMetadata != null) {
    var temp = audioStatusNotifier.value == AudioStatus.playing &&
        currentSongIDNotifier.value == audioMetadata.id;
    if (temp) {
      AudioManager().pauseAudio();
    } else {
      if (currentSongIDNotifier.value == audioMetadata.id) {
        AudioManager().playAudio();
      } else {
        AudioManager().setPlaylist(playlist: playlist, index: index);
      }
    }
  } else {
    AudioManager().setPlaylist(playlist: playlist, index: index);
  }
}

void btnRefreshTaped() {
  if (!isCheckingStorage) {
    checkStorage().then((value) => isCheckingStorage = false);
  }
}
