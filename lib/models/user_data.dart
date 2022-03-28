import 'dart:collection';

import 'package:on_audio_query/on_audio_query.dart';

import '../controllers/file_manager.dart';
import '../controllers/value_notifier.dart';
import '../screens/offline/home_screen.dart';
import 'playlist.dart';
import 'song_metadata.dart';

class UserData {
  static final UserData _instance = UserData._internal();

  UserData._internal();

  factory UserData() {
    return _instance;
  }

  //the attributes of the UserData Class
  HashMap<int, SongMetadata> _audiosMetadataMapToID =
      HashMap<int, SongMetadata>();
  List<SongMetadata> _audiosMetadata = <SongMetadata>[];
  List<Playlist> playlists = <Playlist>[];
  List<int> recentlyPlayedSongs = <int>[];
  List<int> likedSongs = <int>[];
  SongSortType songSortType = SongSortType.DATE_ADDED;
  int currentAudioFileID = 0;

  HashMap<int, SongMetadata> get audiosMetadataMapToID =>
      _audiosMetadataMapToID;
  List<SongMetadata> get audiosMetadata => _audiosMetadata;

  set audiosMetadata(List<SongMetadata> audiosMetadata) {
    _audiosMetadata = audiosMetadata;
    _audiosMetadataMapToID =
        HashMap.fromIterable(audiosMetadata, key: (e) => e.id, value: (e) => e);
    likedSongs.addAll(
        _audiosMetadata.where((element) => element.isLiked).map((e) => e.id));
  }

  void likeSong({required SongMetadata songMetadata, bool setIsLike = false}) {
    songMetadata.isLiked = setIsLike;
    setIsLike
        ? likedSongs.contains(songMetadata.id)
            ? null
            : likedSongs.add(songMetadata.id)
        : likedSongs.remove(songMetadata.id);
    updateSongsMetadataToDevice();
  }

  void addToRecently(SongMetadata metadata) {
    int index = recentlyPlayedSongs.indexOf(metadata.id);
    if (index == -1) {
      recentlyPlayedSongs.insert(0, metadata.id);
    } else {
      recentlyPlayedSongs.removeAt(index);
      recentlyPlayedSongs.insert(0, metadata.id);
    }
    recentlySongsNotifier.value = recentlyPlayedSongs.first;
    updateRecentlyPlayedSongsToDevice();
  }

  SongMetadata? getSongBy({int? id}) {
    if (id != null) {
      return audiosMetadataMapToID[id];
    }
    return null;
  }

  void createPlaylist({String? tmpName}) {
    tmpName = tmpName ?? "Playlist";
    String name = tmpName;
    bool isUnique = _checkIsPlaylistNameUnique(name);
    int counter = 2;
    while (!isUnique) {
      name = tmpName + " (${counter++})";
      isUnique = _checkIsPlaylistNameUnique(name);
    }
    Playlist newPlaylist = Playlist(id: playlists.length, name: name);
    playlists.add(newPlaylist);
    playlistSongsNotifier.value = playlists.last;
    increasePlaylistsNumToDevice(1);
    updatePlaylistsToDevice(playlist: newPlaylist);
  }

  void removePlaylist(Playlist playlist) {
    int num = playlists.length - 1;
    playlists.remove(playlist);
    for (int i = 0; i < num; i++) {
      playlists[i].id = i;
    }
    playlistSongsNotifier.value = playlists.last;
    increasePlaylistsNumToDevice(-1);
    updatePlaylistsToDevice(playlists: playlists);
  }

  bool _checkIsPlaylistNameUnique(String name) {
    return !playlists.any((playlist) => playlist.name == name);
  }

  void _updateRecentlyPlayed() {
    bool isChanged = false;
    // ignore: avoid_function_literals_in_foreach_calls
    List.from(recentlyPlayedSongs).forEach((id) {
      if (audiosMetadataMapToID[id] == null) {
        isChanged = true;
        recentlyPlayedSongs.remove(id);
      }
    });
    if (isChanged) {
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      recentlySongsNotifier.notifyListeners();
      updateRecentlyPlayedSongsToDevice();
    }
  }

  void rebuildSongWidgets({List<SongMetadata>? songsList}) {
    if (songsList != null && songsList.length == audiosMetadata.length) {
      var isRebuild = songsList.any((element) =>
          element.id != audiosMetadata[songsList.indexOf(element)].id);
      if (isRebuild) {
        UserData().audiosMetadata = songsList;
        _updateRecentlyPlayed();
        createWidgets();
        songsMetadataNotifier.value = !songsMetadataNotifier.value;
      }
    } else {
      songsList != null ? UserData().audiosMetadata = songsList : null;
      songsList != null ? _updateRecentlyPlayed() : null;

      createWidgets();
      songsMetadataNotifier.value = !songsMetadataNotifier.value;
    }
  }
}
