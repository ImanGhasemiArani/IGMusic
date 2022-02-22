import 'dart:collection';
import 'dart:convert';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/audio_manager.dart';
import '../models/playlist.dart';
import '../models/song_metadata.dart';
import '../models/user_data.dart';
import '../util/log.dart';

Future<void> permissionsRequest() async {
  var state = await AudioManager().audioQuery.permissionsStatus();
  if (!state) {
    await AudioManager()
        .audioQuery
        .permissionsRequest()
        .whenComplete(() => loadUserData());
  } else {
    await loadUserData();
  }
}

Future<void> loadUserData() async {
  logging("🔶 Checking Storage", isShowTime: true);

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
  HashMap<int, SongMetadata> audiosMetadataMapToID =
      HashMap<int, SongMetadata>();

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
    audiosMetadataMapToID[tmpMeta.id] = tmpMeta;
  }

  UserData().sharedPreferences = await SharedPreferences.getInstance();
  var sharedPreferences = UserData().sharedPreferences;
//   sharedPreferences.clear();
  int tmpDataNum = sharedPreferences.getInt("playlistsNum") ?? 0;
  List<Playlist> tmpPlaylists = <Playlist>[];
  for (int i = 0; i < tmpDataNum; i++) {
    Map<String, dynamic> tmpPlaylistsStrings =
        jsonDecode(sharedPreferences.getString(i.toString())!);
    tmpPlaylists.add(Playlist.fromJSON(tmpPlaylistsStrings));
  }

  logging("🆗 Checking Storage", isShowTime: true);
  logging("🔶 Updating UserData", isShowTime: true);

  UserData().audiosMetadata = audiosMetadata;
  UserData().audiosMetadataMapToID = audiosMetadataMapToID;
  UserData().playlists = tmpPlaylists;

  logging("🆗 Updating UserData", isShowTime: true);

  updateSongsMetadataToDevice();
  loadSongsMetadataFromDevice();
}

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
  logging("🔶 Updating Songs To Device", isShowTime: true);
  var songs = UserData().audiosMetadata;
  var tmp = songs.map((e) => jsonEncode(e.toJSON())).toList();
  UserData().sharedPreferences.setStringList("songsMeta", tmp);
  logging("🆗 Updating Songs To Device", isShowTime: true);
}

void loadSongsMetadataFromDevice() {
  logging("🔶 Loading SongsMetadata", isShowTime: true);
  var tmp = UserData().sharedPreferences.getStringList("songsMeta");
  List<String> tmpList = tmp ?? <String>[];
  List<SongMetadata> songs =
      tmpList.map((e) => SongMetadata.fromJSON(jsonDecode(e))).toList();
  logging(songs.length.toString());
  UserData().audiosMetadata = songs;
  logging("🆗 Loading SongsMetadata", isShowTime: true);
}
