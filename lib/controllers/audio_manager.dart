import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../models/models.dart';

typedef AudioChangeStatus = void Function(bool);

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();

  final OnAudioQuery audioQuery = OnAudioQuery();
  final audioPlayer = AudioPlayer();

  //Notifiers
  late AudioChangeStatus audioChangeStatus;
  final audioStatusNotifier = ValueNotifier<AudioStatus>(AudioStatus.paused);
  final progressNotifier =
      ValueNotifier<ProgressBarStatus>(ProgressBarStatus.zero());

  final currentSongMetaDataNotifier =
      ValueNotifier<SongMetadata>(SongMetadata.defaultValue());
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

  factory AudioManager() {
    return _instance;
  }

  AudioManager._internal() {
    _initAudioPlayer();
  }

  void _initAudioPlayer() {
    _initPlayerStateStream();
    _initPositionStream();
    _initBufferPositionStream();
    _initDurationStream();
    _initSequenceStateStream();
  }

  Future<void> seek(Duration duration) async {
    await audioPlayer.seek(duration);
  }

  void pauseAudio() {
    try {
      audioPlayer.pause();
      // ignore: empty_catches
    } on Exception {}
  }

  void playAudio() {
    try {
      audioPlayer.play();
      // ignore: empty_catches
    } on Exception {}
  }

  void seekToPreviousAudio() {
    audioPlayer.seekToPrevious();
  }

  void seekToNextAudio() {
    audioPlayer.seekToNext();
  }

  void setLoopModeToLoopAll() {
    loopModeNotifier.value = LoopModeState.loopAll;
    audioPlayer.setShuffleModeEnabled(false);
    audioPlayer.setLoopMode(LoopMode.all);
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
  }

  Future<void> setAudioFile(SongMetadata audioMetadata) async {
    await audioPlayer.setFilePath(audioMetadata.data);
    UserData().currentAudioFileID = audioMetadata.id;
  }

  void _initPlayerStateStream() {
    audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        // buttonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        audioStatusNotifier.value = AudioStatus.paused;
        audioChangeStatus(false);
      } else if (processingState != ProcessingState.completed) {
        audioStatusNotifier.value = AudioStatus.playing;
        audioChangeStatus(true);
      } else {
        audioPlayer.seek(Duration.zero);
        pauseAudio();
      }
    });
  }

  void _initPositionStream() {
    audioPlayer.positionStream.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarStatus(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });
  }

  void _initBufferPositionStream() {
    audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarStatus(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });
  }

  void _initDurationStream() {
    audioPlayer.durationStream.listen((totalDuration) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarStatus(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );
    });
  }

  void _initSequenceStateStream() {
    audioPlayer.sequenceStateStream.listen((sequenceState) {
      if (sequenceState == null) return;
      final currentItem = sequenceState.currentSource;
      final tag = currentItem?.tag as SongMetadata?;
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
}

class ProgressBarStatus {
  late final Duration current;
  late final Duration buffered;
  late final Duration total;

  ProgressBarStatus(
      {required this.current, required this.buffered, required this.total});

  ProgressBarStatus.zero() {
    current = Duration.zero;
    buffered = Duration.zero;
    total = Duration.zero;
  }
}

enum AudioStatus {
  playing,
  paused,
  // loading
}

enum LoopModeState {
  loopOne,
  loopAll,
  shuffle,
}
