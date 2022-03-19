import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../models/enums.dart';
import '../models/playlist.dart';
import '../models/progress_bar_status.dart';
import '../models/song_metadata.dart';
import '../util/log.dart';
import 'file_manager.dart';

final audioStatusNotifier = ValueNotifier<AudioStatus>(AudioStatus.paused);
bool isUpdateProgressNotifier = true;
final progressNotifier =
    ValueNotifier<ProgressBarStatus>(ProgressBarStatus.def());

final currentSongMetaDataNotifier =
    ValueNotifier<SongMetadata>(SongMetadata.defaultValue());
final currentSongIDNotifier = ValueNotifier<int>(0);
final currentSongTitleNotifier = ValueNotifier<String>("Unknown");
final currentSongArtistNotifier = ValueNotifier<String>("Unknown");
final currentSongArtworkNotifier = ValueNotifier<Uint8List?>(null);

final songsMetadataNotifier = ValueNotifier<bool>(false);
final recentlySongsNotifier = ValueNotifier<int>(0);
final playlistSongsNotifier = ValueNotifier<Playlist?>(null);

final playlistNotifier = ValueNotifier<List<SongMetadata>>([]);
final isFirstSongNotifier = ValueNotifier<bool>(true);
final isLastSongNotifier = ValueNotifier<bool>(true);
final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);
final loopModeNotifier = ValueNotifier<LoopModeState>(LoopModeState.loopAll);

Timer? playbackTimer;
final playbackTimerNotifier = ValueNotifier<Duration>(Duration.zero);

LoopModeState loopModeNextValue({LoopModeState? setRepeatModeTo}) {
  logging("LoopMode next value", isRed: true);
  if (setRepeatModeTo == null) {
    final nowMode = loopModeNotifier.value;
    switch (nowMode) {
      case LoopModeState.loopAll:
        loopModeNotifier.value = LoopModeState.loopOne;
        break;
      case LoopModeState.loopOne:
        loopModeNotifier.value = LoopModeState.shuffle;
        break;
      case LoopModeState.shuffle:
        loopModeNotifier.value = LoopModeState.loopAll;
        break;
    }
  } else {
    loopModeNotifier.value = setRepeatModeTo;
  }
  updateLoopModeToDevice();
  return loopModeNotifier.value;
}
