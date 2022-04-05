import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

import '../controllers/file_manager.dart';
import '../controllers/value_notifier.dart';
import '../models/enums.dart';
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
    await setPlaylist(playlist: playlistNotifier.value, isPlay: false);
    loadLoopModeFromDevice();
    _listenToChangesInPlaylist();
    _initPlayerStateStream();
  }

  Future<void> setPlaylist(
      {List<SongMetadata>? playlist, int? index, bool isPlay = true}) async {
    playlist = playlist ?? UserData().audiosMetadata;
    updateCurrentPlaylistToDevice(playlist);
    try {
      index = index ??
          playlist.indexOf(
              UserData().audiosMetadataMapToID[recentlySongsNotifier.value]
                  as SongMetadata);
    } catch (e) {
      logging("Error in setting playlist");
      return;
    }

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
    (_audioHandler as MyAudioHandler).setPlayListToAudioSources(mediaItems,
        initIndex: index, isPlay: isPlay);
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

  void seekToPreviousAudio() =>
      (_audioHandler as MyAudioHandler).skipToPrevious();

  void seekToNextAudio() => (_audioHandler as MyAudioHandler).skipToNext();

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
      } else {
        final sequence = (_audioHandler as MyAudioHandler).audioPlayer.sequence;
        if (sequence == null) return;
        final newPlaylist = sequence.map((e) {
          return e.tag as MediaItem;
        }).toList();
        final newList = newPlaylist
            .map((item) => UserData().audiosMetadataMapToID[int.parse(item.id)]
                as SongMetadata)
            .toList();
        if (playlistNotifier.value.length != newList.length ||
            !playlistNotifier.value.any((item) => newList.contains(item))) {
          playlistNotifier.value = newList;
        }
      }
      isLastSongNotifier.value =
          !(_audioHandler as MyAudioHandler).audioPlayer.hasNext;
      isFirstSongNotifier.value =
          !(_audioHandler as MyAudioHandler).audioPlayer.hasPrevious;
    });
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
        seek(Duration.zero);
        pauseAudio();
      }
    });
  }
}
