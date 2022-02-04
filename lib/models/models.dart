import 'dart:collection';
import 'dart:typed_data';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/file_manager.dart';

class UserData {
  static final UserData _instance = UserData._internal();

  UserData._internal();

  factory UserData() {
    return _instance;
  }

  //the attributes of the UserData Class
  late final SharedPreferences sharedPreferences;
  HashMap<int, SongMetadata> audiosMetadataMapToID = HashMap<int, SongMetadata>();
  List<SongMetadata> audiosMetadata = <SongMetadata>[];
  List<Playlist> playlists = <Playlist>[];
  SongSortType songSortType = SongSortType.DATE_ADDED;
  int currentAudioFileID = 0;

  void createPlaylist(String tmpName) {
    String name = tmpName;
    bool isUnique = _checkIsPlaylistNameUnique(name);
    int counter = 2;
    while (!isUnique) {
      name = tmpName + " (${counter++})";
      isUnique = _checkIsPlaylistNameUnique(name);
    }
    Playlist newPlaylist = Playlist(id: playlists.length, name: name);
    playlists.add(newPlaylist);
    increasePlaylistNumToDevice();
    updatePlaylistToDevice(playlist: newPlaylist);
  }

  void removePlaylist(Playlist playlist) {
    int num = playlists.length - 1;
    playlists.remove(playlist);
    for (int i = 0; i < num; i++) {
      playlists[i].id = i;
    }
    decreasePlaylistNumToDevice();
    updatePlaylistToDevice(playlists: playlists);
  }

  bool _checkIsPlaylistNameUnique(String name) {
    for (Playlist playlist in playlists) {
      if (playlist.name == name) {
        return false;
      }
    }
    return true;
  }
}

class SongMetadata {
  late final int id;
  late final String data;
  late final String title;
  late final String artist;
  late final String album;
  late final Uint8List? artwork;

  SongMetadata({
    required this.id,
    required this.data,
    required this.title,
    required String? artist,
    required String? album,
    required Uint8List? artwork,
  })  : artist = artist ?? "Unknown",
        album = album ?? "Unknown",
        artwork = ((artwork != null && artwork.isNotEmpty) ? artwork : null);

  SongMetadata.defaultValue() {
    id = 0;
    data = "";
    title = "Unknown";
    artist = "Unknown";
    album = "Unknown";
    artwork = null;
  }
}

class Playlist {
  int id;
  String name;
  final List<int> audiosMetadataID;

  Playlist({required this.id, required this.name, List<int>? audiosMetadataID})
      : audiosMetadataID = audiosMetadataID ?? <int>[];

  void addAudioMetadataID(int id) {
    audiosMetadataID.add(id);
    updatePlaylistToDevice(playlist: this);
  }

  void removeAudioMetadataID(int id) {
    audiosMetadataID.remove(id);
    updatePlaylistToDevice(playlist: this);
  }

  void changePlaylistName(String newName) {
    name = newName;
    updatePlaylistToDevice(playlist: this);
  }
}
