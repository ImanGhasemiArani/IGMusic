import 'dart:collection';
import 'dart:typed_data';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../file_manager.dart';

class UserData {
  static final UserData _instance = UserData._internal();

  UserData._internal();

  factory UserData() {
    return _instance;
  }

  //the attributes of the UserData Class
  late final SharedPreferences sharedPreferences;
  HashMap<int, AudioMetadata> audiosMetadataMapToID = HashMap<int, AudioMetadata>();
  List<AudioMetadata> audiosMetadata = <AudioMetadata>[];
  List<Playlist> playlists = <Playlist>[];
  SongSortType songSortType = SongSortType.DATE_ADDED;
  int currentAudioFileID = 0;

  void createPlaylist(String name) {
    Playlist newPlaylist = Playlist(id: playlists.length, name: name);
    playlists.add(newPlaylist);
    increasePlaylistNumToDevice();
    savePlaylistToDevice(newPlaylist);
  }
}

class AudioMetadata {
  late final int id;
  late final String data;
  late final String title;
  late final String artist;
  late final String album;
  late final Uint8List? artwork;

  AudioMetadata({
    required this.id,
    required this.data,
    required this.title,
    required String? artist,
    required String? album,
    required Uint8List? artwork,
  })  : artist = artist ?? "Unknown",
        album = album ?? "Unknown",
        artwork = ((artwork != null && artwork.isNotEmpty) ? artwork : null);

  AudioMetadata.defaultValue() {
    id = 0;
    data = "";
    title = "Unknown";
    artist = "Unknown";
    album = "Unknown";
    artwork = null;
  }
}

class Playlist {
  final int id;
  String name;
  final List<int> audiosMetadataID;

  Playlist({required this.id, required this.name, List<int>? audiosMetadataID})
      : audiosMetadataID = audiosMetadataID ?? <int>[];

  void addAudioMetadataID(int id) {
    audiosMetadataID.add(id);
    savePlaylistToDevice(this);
  }

  void removeAudioMetadataID(int id) => audiosMetadataID.remove(id);

  void changePlaylistName(String newName) => name = newName;
}
