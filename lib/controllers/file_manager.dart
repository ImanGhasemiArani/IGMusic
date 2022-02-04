import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'audio_manager.dart';
import '../models/models.dart';

Future<void> permissionsRequest() async {
  var state = await AudioManager().audioQuery.permissionsStatus();
  if (!state) {
    await AudioManager().audioQuery.permissionsRequest().whenComplete(() => loadUserData());
  } else {
    await loadUserData();
  }
}

Future<void> loadUserData() async {
  printDebugTime("Checking Storage");

  List<SongModel> tmpSongs = (await AudioManager()
          .audioQuery
          .querySongs(sortType: UserData().songSortType, orderType: OrderType.DESC_OR_GREATER))
      .where((element) {
    if (element.duration == null || !element.isMusic! || element.duration! <= 60000) {
      return false;
    }
    return true;
  }).toList();

  List<SongMetadata> audiosMetadata = <SongMetadata>[];
  HashMap<int, SongMetadata> audiosMetadataMapToID = HashMap<int, SongMetadata>();

  for (SongModel songModel in tmpSongs) {
    var art = await AudioManager().audioQuery.queryArtwork(songModel.id, ArtworkType.AUDIO);
    var tmpMeta = SongMetadata(
        id: songModel.id,
        data: songModel.data,
        title: songModel.title,
        artist: songModel.artist,
        album: songModel.album,
        artwork: art);

    audiosMetadata.add(tmpMeta);
    audiosMetadataMapToID[tmpMeta.id] = tmpMeta;
  }

  UserData().sharedPreferences = await SharedPreferences.getInstance();
  var sharedPreferences = UserData().sharedPreferences;
  int tmpDataNum = sharedPreferences.getInt("playlistsNum") ?? 0;
  List<Playlist> tmpPlaylists = <Playlist>[];
  for (int i = 0; i < tmpDataNum; i++) {
    Map<String, dynamic> tmpPlaylistsStrings =
        jsonDecode(sharedPreferences.getString(i.toString())!);
    tmpPlaylists.add(playlistFromJSON(tmpPlaylistsStrings));
  }

  printDebugTime("Checking Storage Completed");
  printDebugTime("Updating UserData");

  UserData().audiosMetadata = audiosMetadata;
  UserData().audiosMetadataMapToID = audiosMetadataMapToID;
  UserData().playlists = tmpPlaylists;

  printDebugTime("Updating UserData Completed");
}

Playlist playlistFromJSON(Map<String, dynamic> map) {
  var tmp = (map["metasID"] as List<dynamic>);
  List<int> ids = <int>[];
  for (int id in tmp) {
    ids.add(id);
  }
  return Playlist(id: map["id"] as int, name: map["name"] as String, audiosMetadataID: ids);
}

Map<String, dynamic> playlistToJSON(Playlist playlist) {
  return {"id": playlist.id, "name": playlist.name, "metasID": playlist.audiosMetadataID};
}

void updatePlaylistToDevice({Playlist? playlist, List<Playlist>? playlists}) {
  if (playlist != null) {
    UserData()
        .sharedPreferences
        .setString(playlist.id.toString(), jsonEncode(playlistToJSON(playlist)));
  } else if (playlists != null) {
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

void printDebugTime(String message) {
  if (kDebugMode) {
    var time = DateTime.now();
    print("Log: $message => time: ${time.minute}: ${time.second}: ${time.millisecond}");
  }
}
