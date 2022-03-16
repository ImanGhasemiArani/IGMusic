import 'package:audio_service/audio_service.dart';
import 'package:ig_music/controllers/file_manager.dart';
import 'package:just_audio/just_audio.dart';

import '../controllers/value_notifier.dart';
import '../models/enums.dart';
import '../models/progress_bar_status.dart';
import '../models/song_metadata.dart';
import '../models/user_data.dart';
import '../util/log.dart';
import 'audio_handler.dart';
import 'service_locator.dart';

typedef AudioChangeStatus = void Function(bool);

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();

  final _audioHandler = getIt<AudioHandler>();
  late AudioChangeStatus audioChangeStatus;

  factory AudioManager() {
    return _instance;
  }

  AudioManager._internal() {
    audioChangeStatus = (bool tmp) {};
    _initAudioPlayer();
  }

  AudioPlayer get audioPlayer => (_audioHandler as MyAudioHandler).audioPlayer;

  Future<void> _initAudioPlayer() async {
    // await loadPlaylist();
    await setPlaylist(playlist: playlistNotifier.value);
    loadLoopModeFromDevice();
    _listenToChangesInPlaylist();
    _listenToPlaybackState();
    _listenToCurrentPosition();
    _listenToBufferedPosition();
    _listenToTotalDuration();
    _listenToChangesInSong();
  }

  Future<void> setPlaylist({List<SongMetadata>? playlist, int? index}) async {
    playlist = playlist ?? UserData().audiosMetadata;
    index = index ??
        playlist.indexOf(
            UserData().audiosMetadataMapToID[recentlySongsNotifier.value]
                as SongMetadata);
    final mediaItems = playlist
        .map((audioMetadata) => MediaItem(
              id: audioMetadata.id.toString(),
              title: audioMetadata.title,
              artist: audioMetadata.artist,
              album: audioMetadata.album,
              extras: {
                'data': audioMetadata.data,
              },
            ))
        .toList();
    (_audioHandler as MyAudioHandler)
        .setPlayListToAudioSources(mediaItems, initIndex: index);
  }

  Future<void> loadPlaylist({List<SongMetadata>? playlist}) async {
    playlist = playlist ?? UserData().audiosMetadata;
    updateCurrentPlaylistToDevice(playlist);
    final mediaItems = playlist
        .map((audioMetadata) => MediaItem(
              id: audioMetadata.id.toString(),
              title: audioMetadata.title,
              artist: audioMetadata.artist,
              album: audioMetadata.album,
              extras: {
                'data': audioMetadata.data,
              },
            ))
        .toList();
    _audioHandler.addQueueItems(mediaItems);
    _audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
  }

  void setSpeed(double speed) => _audioHandler.setSpeed(speed);

  void playAudio() => _audioHandler.play();

  void pauseAudio() => _audioHandler.pause();

  void seek(Duration position) => _audioHandler.seek(position);

  void seekToPreviousAudio() => (_audioHandler as MyAudioHandler).previous();

  void seekToNextAudio() => (_audioHandler as MyAudioHandler).next();

  void seekToAudioItem(int index) => _audioHandler.skipToQueueItem(index);

  void repeat({LoopModeState? setRepeatModeTo}) {
    final newMode = loopModeNextValue(setRepeatModeTo: setRepeatModeTo);
    logging("Changing LoopMode to $newMode", isRed: true);
    switch (newMode) {
      case LoopModeState.loopAll:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
        _audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
        break;
      case LoopModeState.loopOne:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
        _audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
        break;
      case LoopModeState.shuffle:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
        _audioHandler.setShuffleMode(AudioServiceShuffleMode.all);
        break;
    }
  }

  void shuffle() {
    final enable = !isShuffleModeEnabledNotifier.value;
    isShuffleModeEnabledNotifier.value = enable;
    if (enable) {
      _audioHandler.setShuffleMode(AudioServiceShuffleMode.all);
    } else {
      _audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
    }
  }

  void _listenToChangesInPlaylist() {
    _audioHandler.queue.listen((playlist) {
      if (playlist.isEmpty) {
        playlistNotifier.value = [];
        currentSongTitleNotifier.value = '';
      } else {
        final newList = playlist
            .map((item) => UserData().audiosMetadataMapToID[int.parse(item.id)]
                as SongMetadata)
            .toList();
        if (!playlistNotifier.value.any((item) => newList.contains(item))) {
          playlistNotifier.value = newList;
        }
      }
      _updateSkipButtons();
    });
  }

  void _listenToPlaybackState() {
    _audioHandler.playbackState.listen((playbackState) {
      final isPlaying = playbackState.playing;
      final processingState = playbackState.processingState;
      if (processingState == AudioProcessingState.loading ||
          processingState == AudioProcessingState.buffering) {
        audioStatusNotifier.value = AudioStatus.loading;
      } else if (!isPlaying) {
        audioStatusNotifier.value = AudioStatus.paused;
        audioChangeStatus(false);
      } else if (processingState != AudioProcessingState.completed) {
        audioStatusNotifier.value = AudioStatus.playing;
        audioChangeStatus(true);
      } else {
        _audioHandler.seek(Duration.zero);
        _audioHandler.pause();
      }
    });
  }

  void _listenToCurrentPosition() {
    AudioService.position.listen((position) {
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

  void _listenToBufferedPosition() {
    _audioHandler.playbackState.listen((playbackState) {
      if (isUpdateProgressNotifier) {
        final oldState = progressNotifier.value;
        progressNotifier.value = ProgressBarStatus(
          current: oldState.current,
          buffered: playbackState.bufferedPosition,
          total: oldState.total,
        );
      }
    });
  }

  void _listenToTotalDuration() {
    _audioHandler.mediaItem.listen((mediaItem) {
      if (isUpdateProgressNotifier) {
        final oldState = progressNotifier.value;
        progressNotifier.value = ProgressBarStatus(
          current: oldState.current,
          buffered: oldState.buffered,
          total: mediaItem?.duration ?? Duration.zero,
        );
      }
    });
  }

  void _listenToChangesInSong() {
    _audioHandler.mediaItem.listen((mediaItem) {
      if (mediaItem == null) return;
      var tmpTag = mediaItem;
      final tag = UserData().audiosMetadataMapToID[int.parse(tmpTag.id)];
      if (tag != null) {
        UserData().addToRecently(tag);
        currentSongMetaDataNotifier.value = tag;
        currentSongIDNotifier.value = tag.id;
        currentSongTitleNotifier.value = tag.title;
        currentSongArtistNotifier.value = tag.artist;
        currentSongArtworkNotifier.value = tag.artwork;
      }
      _updateSkipButtons();
    });
  }

  void _updateSkipButtons() {
    final mediaItem = _audioHandler.mediaItem.value;
    final playlist = _audioHandler.queue.value;
    if (playlist.length < 2 || mediaItem == null) {
      isFirstSongNotifier.value = true;
      isLastSongNotifier.value = true;
    }
    // else {
    //   isFirstSongNotifier.value = playlist.first == mediaItem;
    //   isLastSongNotifier.value = playlist.last == mediaItem;
    // }
    isFirstSongNotifier.value = false;
    isLastSongNotifier.value = false;
  }
}
