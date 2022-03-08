import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../controllers/value_notifier.dart';
import '../widgets/list/current_playlist_horizontal_list.dart';
import 'enums.dart';
import 'progress_bar_status.dart';
import 'song_metadata.dart';
import 'user_data.dart';

typedef AudioChangeStatus = void Function(bool);

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();

  final OnAudioQuery audioQuery = OnAudioQuery();
  final audioPlayer = AudioPlayer();

  //Notifiers
  late AudioChangeStatus audioChangeStatus;

  ConcatenatingAudioSource _playList = ConcatenatingAudioSource(
      children: UserData()
          .audiosMetadata
          .map((e) => AudioSource.uri(Uri.file(e.data), tag: e))
          .toList());

  factory AudioManager() {
    return _instance;
  }

  AudioManager._internal() {
    audioChangeStatus = (bool tmp) {};
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
    isUpdateProgressNotifier = false;
    audioPlayer.seekToPrevious().then((value) {
      isUpdateProgressNotifier = true;
      playAudio();
      updateCurrentAudioDuration();
    });
  }

  void seekToNextAudio() {
    isUpdateProgressNotifier = false;
    audioPlayer.seekToNext().then((value) {
      isUpdateProgressNotifier = true;
      playAudio();
      updateCurrentAudioDuration();
    });
  }

  void updateCurrentAudioDuration() {
    final oldState = progressNotifier.value;
    progressNotifier.value = ProgressBarStatus(
      current: oldState.current,
      buffered: oldState.buffered,
      total: audioPlayer.duration ?? Duration.zero,
    );
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
    isUpdateProgressNotifier = false;
    await audioPlayer.setAudioSource(_playList, initialIndex: index ?? 0);
    isUpdateProgressNotifier = true;
    updateCurrentAudioDuration();
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
        audioStatusNotifier.value = AudioStatus.loading;
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
      if (isUpdateProgressNotifier) {
        final oldState = progressNotifier.value;
        progressNotifier.value = ProgressBarStatus(
          current: position,
          buffered: oldState.buffered,
          total: oldState.total,
        );
      }
    });
  }

  void _initBufferPositionStream() {
    audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      if (isUpdateProgressNotifier) {
        final oldState = progressNotifier.value;
        progressNotifier.value = ProgressBarStatus(
          current: oldState.current,
          buffered: bufferedPosition,
          total: oldState.total,
        );
      }
    });
  }

  void _initDurationStream() {
    audioPlayer.durationStream.listen((totalDuration) {
      if (isUpdateProgressNotifier) {
        final oldState = progressNotifier.value;
        progressNotifier.value = ProgressBarStatus(
          current: oldState.current,
          buffered: oldState.buffered,
          total: totalDuration ?? Duration.zero,
        );
      }
    });
  }

  void _initSequenceStateStream() {
    audioPlayer.sequenceStateStream.listen((sequenceState) {
      if (sequenceState == null) return;
      final currentItem = sequenceState.currentSource;
      final tag = currentItem?.tag as SongMetadata?;
      if (tag != null) {
        UserData().addToRecently(tag);
        currentSongMetaDataNotifier.value = tag;
        currentSongIDNotifier.value = tag.id;
        currentSongTitleNotifier.value = tag.title;
        currentSongArtistNotifier.value = tag.artist;
        currentSongArtworkNotifier.value = tag.artwork;
        if (updateHorizontalCurrentPlaylist) {
          HorizontalCardPagerState.updateIndex(sequenceState.currentIndex);
        }
      }
      isShuffleModeEnabledNotifier.value = sequenceState.shuffleModeEnabled;
      final playlist = sequenceState.effectiveSequence;
      final currentQueue =
          playlist.map((item) => item.tag as SongMetadata).toList();
      if (!playlistNotifier.value.any((item) => currentQueue.contains(item))) {
        playlistNotifier.value = currentQueue;
      }
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
