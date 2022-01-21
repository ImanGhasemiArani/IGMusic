import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'file_manager.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();

  factory AudioManager() {
    return _instance;
  }

  AudioManager._internal() {
    initAudioPlayer();
  }

  //-----------------------------------------attributes-----------------------------------------//
  final OnAudioQuery audioQuery = OnAudioQuery();
  final audioPlayer = AudioPlayer();

  final audioStatusNotifier = ValueNotifier<AudioStatus>(AudioStatus.paused);
  final progressNotifier = ValueNotifier<ProgressBarStatus>(
    ProgressBarStatus(
      current: Duration.zero,
      buffered: Duration.zero,
      total: Duration.zero,
    ),
  );
  final currentSongMetaDataNotifier = ValueNotifier<AudioMetadata?>(null);
  final currentSongIDNotifier = ValueNotifier<int>(0);
  final currentSongTitleNotifier = ValueNotifier<String>("Unknown");
  final currentSongArtistNotifier = ValueNotifier<String>("Unknown");
  final currentSongArtworkNotifier = ValueNotifier<Uint8List?>(null);

  final playlistNotifier = ValueNotifier<List<String>>([]);
  final isFirstSongNotifier = ValueNotifier<bool>(true);
  final isLastSongNotifier = ValueNotifier<bool>(true);
  final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);
  final loopModeNotifier = ValueNotifier<LoopModeState>(LoopModeState.loopAll);

  ConcatenatingAudioSource _playList = ConcatenatingAudioSource(
      children: UserData()
          .audiosMetadata
          .map((e) => AudioSource.uri(Uri.file(e.data), tag: e))
          .toList());

  //--------------------------------------attributes==>end--------------------------------------//

  void initAudioPlayer() {
    audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        // buttonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        audioStatusNotifier.value = AudioStatus.paused;
      } else if (processingState != ProcessingState.completed) {
        audioStatusNotifier.value = AudioStatus.playing;
      } else {
        audioPlayer.seek(Duration.zero);
        pauseAudio();
      }
    });

    audioPlayer.positionStream.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarStatus(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });

    audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarStatus(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });

    audioPlayer.durationStream.listen((totalDuration) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarStatus(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );
    });

    audioPlayer.sequenceStateStream.listen((sequenceState) {
      if (sequenceState == null) return;
      final currentItem = sequenceState.currentSource;
      final tag = currentItem?.tag as AudioMetadata?;
      if (tag != null) {
        currentSongMetaDataNotifier.value = tag;
        currentSongIDNotifier.value = tag.id;
        currentSongTitleNotifier.value = tag.title;
        currentSongArtistNotifier.value = tag.artist;
        currentSongArtworkNotifier.value = tag.artwork;
      }
      isShuffleModeEnabledNotifier.value = sequenceState.shuffleModeEnabled;
      final playlist = sequenceState.effectiveSequence;
      if (playlist.isEmpty || currentItem == null) {
        isFirstSongNotifier.value = true;
        isLastSongNotifier.value = true;
      } else {
        isFirstSongNotifier.value = playlist.first == currentItem;
        isLastSongNotifier.value = playlist.last == currentItem;
      }
    });
  }

  void setPlayList({int? index, bool? forceInit}) {
    if (_playList.children.isEmpty || (forceInit ?? false)) {
      _playList = ConcatenatingAudioSource(
          children: UserData()
              .audiosMetadata
              .map((e) => AudioSource.uri(Uri.file(e.data), tag: e))
              .toList());
    }
    setPlayListToAudioPlayer(index: index);
  }

  Future<void> setPlayListToAudioPlayer({int? index}) async {
    await audioPlayer.setAudioSource(_playList, initialIndex: index ?? 0);
    setLoopModeToLoopAll();
  }

  Future<void> setAudioFile(AudioMetadata audioMetadata) async {
    await audioPlayer.setFilePath(audioMetadata.data);
    UserData().currentAudioFileID = audioMetadata.id;
  }

  void seek(Duration duration) async {
    await audioPlayer.seek(duration);
  }

  void pauseAudio() {
    try {
      audioPlayer.pause();
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void playAudio() {
    try {
      audioPlayer.play();
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void seekToAudio(int index) async {
    await audioPlayer.seek(Duration.zero, index: index);
  }

  void seekToPreviousAudio() {
    audioPlayer.seekToPrevious();
  }

  void seekToNextAudio() {
    audioPlayer.seekToNext();
  }

  void setLoopModeToLoopAll() {
    loopModeNotifier.value = LoopModeState.loopAll;
    audioPlayer.setShuffleModeEnabled(true);
    audioPlayer.setShuffleModeEnabled(false);
  }

  void setLoopModeToLoopOne() {
    loopModeNotifier.value = LoopModeState.loopOne;
    audioPlayer.setLoopMode(LoopMode.one);
  }

  void setLoopModeToShuffle() {
    loopModeNotifier.value = LoopModeState.shuffle;
    audioPlayer.setShuffleModeEnabled(true);
    audioPlayer.setLoopMode(LoopMode.all);
  }
}

class ProgressBarStatus {
  final Duration current;
  final Duration buffered;
  final Duration total;

  ProgressBarStatus(
      {required this.current, required this.buffered, required this.total});
}

enum AudioStatus {
  playing,
  paused,
}

enum LoopModeState {
  loopOne,
  loopAll,
  shuffle,
}
