import 'package:audio_service/audio_service.dart';
import 'package:ig_music/models/user_data.dart';
import 'package:ig_music/util/log.dart';
import 'package:just_audio/just_audio.dart';

import '../controllers/value_notifier.dart';
import '../models/progress_bar_status.dart';
import '../widgets/list/current_playlist_horizontal_list.dart';

Future<AudioHandler> initAudioService() async {
  return await AudioService.init(
    builder: () => MyAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'Music',
      androidNotificationChannelName: 'Music Player',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );
}

class MyAudioHandler extends BaseAudioHandler {
  final _audioPlayer = AudioPlayer();
  final _playlist = ConcatenatingAudioSource(children: []);

  MyAudioHandler() {
    _loadEmptyPlaylist();
    _notifyAudioHandlerAboutPlaybackEvents();
    _listenForDurationChanges();
    _listenForCurrentSongIndexChanges();
    _listenForSequenceStateChanges();
  }

  AudioPlayer get audioPlayer => _audioPlayer;

  Future<void> _loadEmptyPlaylist() async {
    try {
      await _audioPlayer.setAudioSource(_playlist);
    } catch (e) {
      logging("Error: $e");
    }
  }

  Future<void> setPlayListToAudioSources(List<MediaItem> mediaItems,
      {int? initIndex = 0}) async {
    try {
      initIndex = mediaItems.isEmpty ? null : initIndex;
      final audioSource = mediaItems.map(_createAudioSource);
      await _playlist.clear().then((value) => _playlist
          .addAll(audioSource.toList())
          .then((value) => _audioPlayer
                  .setAudioSource(_playlist, initialIndex: initIndex)
                  .then((value) {
                queue.add(queue.value..addAll(mediaItems));
                //   play();
                //   pause();
              })));
    } catch (e) {
      logging("Error 1");
      return;
    }
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    final audioSource = mediaItems.map(_createAudioSource);
    _playlist.addAll(audioSource.toList());
    final newQueue = queue.value..addAll(mediaItems);
    queue.add(newQueue);
  }

  UriAudioSource _createAudioSource(MediaItem mediaItem) {
    return AudioSource.uri(
      Uri.file(mediaItem.extras!['data']),
      tag: mediaItem,
    );
  }

  @override
  Future<void> setSpeed(double speed) async {
    logging("Set Speed to $speed", isRed: true);

    _audioPlayer.setSpeed(speed);
  }

  @override
  Future<void> play() {
    logging("Play", isRed: true);

    return _audioPlayer.play();
  }

  @override
  Future<void> pause() {
    logging("Pause", isRed: true);

    return _audioPlayer.pause();
  }

  @override
  Future<void> seek(Duration position) {
    logging("Seek to $position", isRed: true);

    return _audioPlayer.seek(position);
  }

  @override
  Future<void> skipToNext() {
    logging("Skip Next", isRed: true);

    isUpdateProgressNotifier = false;
    return _audioPlayer.seekToNext().then((value) {
      Future.delayed(const Duration(milliseconds: 5000), () {
        isUpdateProgressNotifier = true;
        play();
        _updateCurrentAudioDuration();
      });
    });
  }

  Future<void> next() {
    logging("Skip Next", isRed: true);

    isUpdateProgressNotifier = false;
    return _audioPlayer.seekToNext().then((value) {
      isUpdateProgressNotifier = true;
      play();
      _updateCurrentAudioDuration();
    });
  }

  @override
  Future<void> skipToPrevious() {
    logging("Skip Pervious", isRed: true);

    isUpdateProgressNotifier = false;
    return _audioPlayer.seekToPrevious().then((value) {
      Future.delayed(const Duration(milliseconds: 5000), () {
        isUpdateProgressNotifier = true;
        play();
        _updateCurrentAudioDuration();
      });
    });
  }

  Future<void> previous() {
    logging("Skip Pervious", isRed: true);

    isUpdateProgressNotifier = false;
    return _audioPlayer.seekToPrevious().then((value) {
      isUpdateProgressNotifier = true;
      play();
      _updateCurrentAudioDuration();
    });
  }

  @override
  Future<void> skipToQueueItem(int index) async {
    logging("Skip to index $index", isRed: true);

    if (index < 0 || index >= queue.value.length) return;
    if (_audioPlayer.shuffleModeEnabled) {
      index = _audioPlayer.shuffleIndices!.indexOf(index);
    }
    isUpdateProgressNotifier = false;
    _audioPlayer.seek(Duration.zero, index: index).then((value) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        isUpdateProgressNotifier = true;
        _updateCurrentAudioDuration();
      });
    });
  }

  void _updateCurrentAudioDuration() {
    final oldState = progressNotifier.value;
    progressNotifier.value = ProgressBarStatus(
      current: oldState.current,
      buffered: oldState.buffered,
      total: mediaItem.value?.duration ?? Duration.zero,
    );
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    switch (repeatMode) {
      case AudioServiceRepeatMode.one:
        _audioPlayer.setLoopMode(LoopMode.one);
        break;
      case AudioServiceRepeatMode.none:
      case AudioServiceRepeatMode.group:
      case AudioServiceRepeatMode.all:
        _audioPlayer.setLoopMode(LoopMode.all);
        break;
    }
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    if (shuffleMode == AudioServiceShuffleMode.none) {
      logging("shuffleMode Off", isRed: true);
      _audioPlayer.setShuffleModeEnabled(false);
    } else {
      logging("shuffleMode On", isRed: true);
      _audioPlayer.setShuffleModeEnabled(true);
    }
  }

  void _notifyAudioHandlerAboutPlaybackEvents() {
    _audioPlayer.playbackEventStream.listen((PlaybackEvent event) {
      final playing = _audioPlayer.playing;
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
        },
        androidCompactActionIndices: const [0, 1, 2],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_audioPlayer.processingState]!,
        playing: playing,
        updatePosition: _audioPlayer.position,
        bufferedPosition: _audioPlayer.bufferedPosition,
        speed: _audioPlayer.speed,
        queueIndex: event.currentIndex,
      ));
    });
  }

  void _listenForDurationChanges() {
    _audioPlayer.durationStream.listen((duration) {
      var index = _audioPlayer.currentIndex;
      final newQueue = queue.value;
      if (index == null || newQueue.isEmpty) return;
      if (_audioPlayer.shuffleModeEnabled) {
        index = _audioPlayer.shuffleIndices!.indexOf(index);
      }
      try {
        final oldMediaItem = newQueue[index];
        final newMediaItem = oldMediaItem.copyWith(duration: duration);
        newQueue[index] = newMediaItem;
        queue.add(newQueue);
        mediaItem.add(newMediaItem);
        // ignore: empty_catches
      } catch (e) {}
    });
  }

  void _listenForCurrentSongIndexChanges() {
    _audioPlayer.currentIndexStream.listen((index) {
      final playlist = queue.value;
      if (index == null || playlist.isEmpty) return;
      final saveIndex = index;
      if (_audioPlayer.shuffleModeEnabled) {
        index = _audioPlayer.shuffleIndices!.indexOf(index);
      }
      MediaItem? tmpTag;
      try {
        tmpTag = playlist[index];
        // ignore: empty_catches
      } catch (e) {}
      if (tmpTag == null) return;
      final tag = UserData().audiosMetadataMapToID[int.parse(tmpTag.id)];
      if (tag != null) {
        UserData().addToRecently(tag);
        currentSongMetaDataNotifier.value = tag;
        currentSongIDNotifier.value = tag.id;
        currentSongTitleNotifier.value = tag.title;
        currentSongArtistNotifier.value = tag.artist;
        currentSongArtworkNotifier.value = tag.artwork;
        if (updateHorizontalCurrentPlaylist) {
          HorizontalCardPagerState.updateIndex(saveIndex);
        }
      }
      mediaItem.add(tmpTag);
    });
  }

  void _listenForSequenceStateChanges() {
    _audioPlayer.sequenceStateStream.listen((SequenceState? sequenceState) {
      try {
        final sequence = sequenceState!.effectiveSequence;
        if (sequence == null || sequence.isEmpty) return;
        final items = sequence.map((source) => source.tag as MediaItem);
        queue.add(items.toList());
      } catch (e) {
        logging("Error 2");
        return;
      }
    });
  }
}
