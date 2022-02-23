import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../models/enums.dart';
import '../models/playlist.dart';
import '../models/progress_bar_status.dart';
import '../models/song_metadata.dart';

final audioStatusNotifier = ValueNotifier<AudioStatus>(AudioStatus.paused);
bool isDraggingProgressBar = false;
final progressNotifier =
    ValueNotifier<ProgressBarStatus>(ProgressBarStatus.zero());

final currentSongMetaDataNotifier =
    ValueNotifier<SongMetadata>(SongMetadata.defaultValue());
final currentSongIDNotifier = ValueNotifier<int>(0);
final currentSongTitleNotifier = ValueNotifier<String>("Unknown");
final currentSongArtistNotifier = ValueNotifier<String>("Unknown");
final currentSongArtworkNotifier = ValueNotifier<Uint8List?>(null);

final songsMetadataNotifier = ValueNotifier<bool>(false);
final recentlySongsNotifier = ValueNotifier<int>(0);
final playlistSongsNotifier = ValueNotifier<Playlist?>(null);

final playlistNotifier = ValueNotifier<List<String>>([]);
final isFirstSongNotifier = ValueNotifier<bool>(true);
final isLastSongNotifier = ValueNotifier<bool>(true);
final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);
final loopModeNotifier = ValueNotifier<LoopModeState>(LoopModeState.loopAll);
