import 'dart:convert';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/notification_service.dart';
import '../models/playlist.dart';
import '../models/song_metadata.dart';
import '../models/user_data.dart';
import '../util/log.dart';
import 'value_notifier.dart';

late SharedPreferences sharedPreferences;
final _audioQuery = OnAudioQuery();

Future<bool> permissionsRequest() async {
  var state = await _audioQuery.permissionsStatus();
  if (!state) {
    await _audioQuery.permissionsRequest();
  }
  return _audioQuery.permissionsStatus();
}

Future<void> fastLoadUserData() async {
  Logger("Loading SongsMetadata",
          voidAction: _loadSongsMetadataFromDevice, isShowTime: true)
      .start();
  Logger("Loading Playlists",
          voidAction: _loadPlaylistFromDevice, isShowTime: true)
      .start();
  Logger("Loading RecentlyPlayedSongs",
          voidAction: _loadRecentlyPlayedSongsFromDevice, isShowTime: true)
      .start();
  Logger("Loading CurrentPlaylist",
          voidAction: _loadCurrentPlaylistFromDevice, isShowTime: true)
      .start();
}

Future<void> checkStorage() async {
  NotificationService().showNotifications();
  await Logger("Checking Storage",
          asyncAction: _slowLoadAllSongs, isShowTime: true)
      .start();
  NotificationService().cancelNotifications(id: 0);
}

// ignore//
// ignore//
// ignore//
// ignore//
// ignore//

void updateCurrentPlaylistToDevice(List<SongMetadata> currentPlaylist) {
  final songsID = currentPlaylist.map((e) => e.id.toString()).toList();
  sharedPreferences.setStringList("currentPlaylist", songsID);
}

void updatePlaylistsToDevice({Playlist? playlist, List<Playlist>? playlists}) {
  if (playlist != null) {
    sharedPreferences.setString(
        playlist.id.toString(), jsonEncode(playlist.toJSON()));
  }
  if (playlists != null) {
    playlists
        // ignore: avoid_function_literals_in_foreach_calls
        .forEach((playlist) => updatePlaylistsToDevice(playlist: playlist));
  }
}

void increasePlaylistsNumToDevice(int addNum) {
  int num = sharedPreferences.getInt("playlistsNum") ?? 0;
  sharedPreferences.setInt("playlistsNum", num + addNum);
}

void removePlaylistFromDevice(Playlist playlist) {
  sharedPreferences.remove(playlist.id.toString());
}

void updateSongsMetadataToDevice() {
  var songs = UserData().audiosMetadata;
  var tmp = songs.map((e) => jsonEncode(e.toJSON())).toList();
  sharedPreferences.setStringList("songsMeta", tmp);
}

void updateRecentlyPlayedSongsToDevice() {
  var songs = UserData().recentlyPlayedSongs;
  var tmp = songs.map((e) => e.toString()).toList();
  sharedPreferences.setStringList("recentlyPlayed", tmp);
}

void _loadCurrentPlaylistFromDevice() {
  final songsID = sharedPreferences.getStringList("currentPlaylist") ?? [];
  if (songsID.isEmpty) {
    playlistNotifier.value = UserData().audiosMetadata;
  } else {
    final songsMapToID = UserData().audiosMetadataMapToID;
    final currentPlaylist =
        songsID.map((e) => songsMapToID[int.parse(e)] as SongMetadata).toList();
    playlistNotifier.value = currentPlaylist;
  }
}

void _loadPlaylistFromDevice() {
  int tmpDataNum = sharedPreferences.getInt("playlistsNum") ?? 0;
  List<Playlist> tmpPlaylists = <Playlist>[];
  for (int i = 0; i < tmpDataNum; i++) {
    Map<String, dynamic> tmpPlaylistsStrings =
        jsonDecode(sharedPreferences.getString(i.toString())!);
    tmpPlaylists.add(Playlist.fromJSON(tmpPlaylistsStrings));
  }
  UserData().playlists = tmpPlaylists;
}

void _loadSongsMetadataFromDevice() {
  var tmp = sharedPreferences.getStringList("songsMeta");
  List<String> tmpList = tmp ?? <String>[];
  List<SongMetadata> songs =
      tmpList.map((e) => SongMetadata.fromJSON(jsonDecode(e))).toList();
  UserData().audiosMetadata = songs;
}

void _loadRecentlyPlayedSongsFromDevice() {
  var tmp = sharedPreferences.getStringList("recentlyPlayed");
  UserData().recentlyPlayedSongs =
      tmp == null ? <int>[] : tmp.map((e) => int.parse(e)).toList();
  try {
    recentlySongsNotifier.value = UserData().recentlyPlayedSongs.first;
    // ignore: empty_catches
  } catch (e) {}
}

Future<void> _slowLoadAllSongs() async {
  List<SongModel> tmpSongs = (await _audioQuery.querySongs(
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
    var art = await _audioQuery.queryArtwork(songModel.id, ArtworkType.AUDIO);
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
