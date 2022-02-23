import 'dart:convert';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/audio_manager.dart';
import '../models/playlist.dart';
import '../models/song_metadata.dart';
import '../models/user_data.dart';
import '../util/log.dart';
import 'value_notifier.dart';

Future<bool> permissionsRequest() async {
  var state = await AudioManager().audioQuery.permissionsStatus();
  if (!state) {
    await AudioManager().audioQuery.permissionsRequest();
  }
  return AudioManager().audioQuery.permissionsStatus();
}

Future<void> fastLoadUserData() async {
  UserData().sharedPreferences = await SharedPreferences.getInstance();
//   UserData().sharedPreferences.clear();
  Logger("Loading SongsMetadata",
          voidAction: _loadSongsMetadataFromDevice, isShowTime: true)
      .start();
  Logger("Loading Playlists",
          voidAction: _loadPlaylistFromDevice, isShowTime: true)
      .start();
  Logger("Loading RecentlyPlayedSongs",
          voidAction: _loadRecentlyPlayedSongsFromDevice, isShowTime: true)
      .start();
}

Future<void> checkStorage() async {
  Logger("Checking Storage", asyncAction: _slowLoadAllSongs, isShowTime: true)
      .start();
}

// ignore//
// ignore//
// ignore//
// ignore//
// ignore//

void updatePlaylistToDevice({Playlist? playlist, List<Playlist>? playlists}) {
  if (playlist != null) {
    UserData()
        .sharedPreferences
        .setString(playlist.id.toString(), jsonEncode(playlist.toJSON()));
  }
  if (playlists != null) {
    // ignore: avoid_function_literals_in_foreach_calls
    playlists.forEach((playlist) => updatePlaylistToDevice(playlist: playlist));
  }
}

void increasePlaylistNumToDevice() {
  int num = UserData().sharedPreferences.getInt("playlistsNum") ?? 0;
  UserData().sharedPreferences.setInt("playlistsNum", ++num);
}

void decreasePlaylistNumToDevice() {
  int num = UserData().sharedPreferences.getInt("playlistsNum") ?? 0;
  UserData().sharedPreferences.setInt("playlistsNum", --num);
}

void removePlaylistFromDevice(Playlist playlist) {
  UserData().sharedPreferences.remove(playlist.id.toString());
}

void updateSongsMetadataToDevice() {
  var songs = UserData().audiosMetadata;
  var tmp = songs.map((e) => jsonEncode(e.toJSON())).toList();
  UserData().sharedPreferences.setStringList("songsMeta", tmp);
}

void updateRecentlyPlayedSongsToDevice() {
  UserData().sharedPreferences.setStringList("recentlyPlayed",
      UserData().recentlyPlayedSongs.map((e) => e.toString()).toList());
}

void _loadSongsMetadataFromDevice() {
  var tmp = UserData().sharedPreferences.getStringList("songsMeta");
  List<String> tmpList = tmp ?? <String>[];
  List<SongMetadata> songs =
      tmpList.map((e) => SongMetadata.fromJSON(jsonDecode(e))).toList();
  UserData().audiosMetadata = songs;
}

void _loadPlaylistFromDevice() {
  var sharedPreferences = UserData().sharedPreferences;
  int tmpDataNum = sharedPreferences.getInt("playlistsNum") ?? 0;
  List<Playlist> tmpPlaylists = <Playlist>[];
  for (int i = 0; i < tmpDataNum; i++) {
    Map<String, dynamic> tmpPlaylistsStrings =
        jsonDecode(sharedPreferences.getString(i.toString())!);
    tmpPlaylists.add(Playlist.fromJSON(tmpPlaylistsStrings));
  }
  UserData().playlists = tmpPlaylists;
}

void _loadRecentlyPlayedSongsFromDevice() {
  var tmp = UserData().sharedPreferences.getStringList("recentlyPlayed");
  UserData().recentlyPlayedSongs =
      tmp == null ? <int>[] : tmp.map((e) => int.parse(e)).toList();
  try {
    recentlySongsNotifier.value = UserData().recentlyPlayedSongs.first;
    // ignore: empty_catches
  } catch (e) {}
}

Future<void> _slowLoadAllSongs() async {
  List<SongModel> tmpSongs = (await AudioManager().audioQuery.querySongs(
          sortType: UserData().songSortType,
          orderType: OrderType.DESC_OR_GREATER))
      .where((element) {
    if (element.duration == null ||
        !element.isMusic! ||
        element.duration! <= 60000) {
      return false;
    }
    return true;
  }).toList();

  List<SongMetadata> audiosMetadata = <SongMetadata>[];

  for (SongModel songModel in tmpSongs) {
    var art = await AudioManager()
        .audioQuery
        .queryArtwork(songModel.id, ArtworkType.AUDIO);
    var tmpMeta = SongMetadata(
        id: songModel.id,
        data: songModel.data,
        title: songModel.title,
        artist: songModel.artist,
        album: songModel.album,
        artwork: art);

    audiosMetadata.add(tmpMeta);
  }
  UserData().rebuildSongWidgets(songsList: audiosMetadata);
  Logger("Updating SongsMetadata To Device",
          voidAction: updateSongsMetadataToDevice, isShowTime: true)
      .start();
}
