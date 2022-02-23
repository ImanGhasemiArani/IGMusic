import 'dart:collection';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  late final SharedPreferences sharedPreferences;
  HashMap<int, SongMetadata> _audiosMetadataMapToID =
      HashMap<int, SongMetadata>();
  List<SongMetadata> _audiosMetadata = <SongMetadata>[];
  List<Playlist> playlists = <Playlist>[];
  List<int> _recentlyPlayedSongs = <int>[];
  List<int> likedSongs = <int>[];
  SongSortType songSortType = SongSortType.DATE_ADDED;
  int currentAudioFileID = 0;

  HashMap<int, SongMetadata> get audiosMetadataMapToID =>
      _audiosMetadataMapToID;
  List<SongMetadata> get audiosMetadata => _audiosMetadata;
  List<int> get recentlyPlayedSongs => _recentlyPlayedSongs;

  set recentlyPlayedSongs(List<int> recentlyPlayedSongs) {
    _recentlyPlayedSongs = recentlyPlayedSongs;
  }

  set audiosMetadata(List<SongMetadata> audiosMetadata) {
    _audiosMetadata = audiosMetadata;
    _audiosMetadataMapToID =
        HashMap.fromIterable(audiosMetadata, key: (e) => e.id, value: (e) => e);
  }

  void likeSong({required SongMetadata songMetadata, bool setIsLike = false}) {
    songMetadata.isLiked = setIsLike;
    setIsLike
        ? likedSongs.contains(songMetadata.id)
            ? null
            : likedSongs.add(songMetadata.id)
        : likedSongs.remove(songMetadata.id);
  }

  void addToRecently(SongMetadata metadata) {
    int index = _recentlyPlayedSongs.indexOf(metadata.id);
    if (index == -1) {
      _recentlyPlayedSongs.insert(0, metadata.id);
    } else {
      _recentlyPlayedSongs.removeAt(index);
      _recentlyPlayedSongs.insert(0, metadata.id);
    }
    recentlySongsNotifier.value = _recentlyPlayedSongs.first;
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
    increasePlaylistNumToDevice();
    updatePlaylistToDevice(playlist: newPlaylist);
  }

  void removePlaylist(Playlist playlist) {
    int num = playlists.length - 1;
    playlists.remove(playlist);
    for (int i = 0; i < num; i++) {
      playlists[i].id = i;
    }
    playlistSongsNotifier.value = playlists.last;
    decreasePlaylistNumToDevice();
    updatePlaylistToDevice(playlists: playlists);
  }

  bool _checkIsPlaylistNameUnique(String name) {
    return !playlists.any((playlist) => playlist.name == name);
  }

  void _updateRecentlyPlayed() {
    bool isChanged = false;
    List.from(recentlyPlayedSongs).forEach((id) {
      if (audiosMetadataMapToID[id] == null) {
        isChanged = true;
        recentlyPlayedSongs.remove(id);
      }
    });
    if (isChanged) {
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
