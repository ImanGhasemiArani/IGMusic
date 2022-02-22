import 'dart:collection';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/file_manager.dart';
import '../controllers/value_notifier.dart';
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
  HashMap<int, SongMetadata> audiosMetadataMapToID =
      HashMap<int, SongMetadata>();
  List<SongMetadata> audiosMetadata = <SongMetadata>[];
  List<Playlist> playlists = <Playlist>[];
  List<int> recentlyPlayedSongs = <int>[];
  List<int> likedSongs = <int>[];
  SongSortType songSortType = SongSortType.DATE_ADDED;
  int currentAudioFileID = 0;

  void likeSong({required SongMetadata songMetadata, bool setIsLike = false}) {
    songMetadata.isLiked = setIsLike;
    setIsLike
        ? likedSongs.contains(songMetadata.id)
            ? null
            : likedSongs.add(songMetadata.id)
        : likedSongs.remove(songMetadata.id);
  }

  void addToRecently(SongMetadata metadata) {
    int index = recentlyPlayedSongs.indexOf(metadata.id);
    if (index == -1) {
      recentlyPlayedSongs.insert(0, metadata.id);
    } else {
      recentlyPlayedSongs.removeAt(index);
      recentlyPlayedSongs.insert(0, metadata.id);
    }
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
}
