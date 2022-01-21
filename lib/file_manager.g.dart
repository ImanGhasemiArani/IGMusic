part of 'file_manager.dart';

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData()
  ..audiosMetadata = (json['audiosMetadata'] as List<dynamic>)
      .map((e) => _$AudioMetadataFromJson(e as Map<String, dynamic>))
      .toList()
  ..songSortType = $enumDecode(_$SongSortTypeEnumMap, json['songSortType'])
  ..currentAudioFileID = json['currentAudioFileID'] as int;

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'audiosMetadata': _$AudiosMetadataToJson(instance.audiosMetadata),
      'songSortType': _$SongSortTypeEnumMap[instance.songSortType],
      'currentAudioFileID': instance.currentAudioFileID,
    };

List<dynamic> _$AudiosMetadataToJson(List<AudioMetadata> instance) {
  List<dynamic> tmp = [];
  for (var e in instance) {
    tmp.add(_$AudioMetadataToJson(e));
  }
  return tmp;
}

const _$SongSortTypeEnumMap = {
  SongSortType.TITLE: 'TITLE',
  SongSortType.ARTIST: 'ARTIST',
  SongSortType.ALBUM: 'ALBUM',
  SongSortType.DURATION: 'DURATION',
  SongSortType.DATE_ADDED: 'DATE_ADDED',
  SongSortType.SIZE: 'SIZE',
  SongSortType.DISPLAY_NAME: 'DISPLAY_NAME',
};

AudioMetadata _$AudioMetadataFromJson(Map<String, dynamic> json) =>
    AudioMetadata(
      id: json['id'] as int,
      data: json['data'] as String,
      title: json['title'] as String,
      artist: json['artist'] as String?,
      album: json['album'] as String?,
      artwork: AudioMetadata._stringToArtwork(json['artwork'] as String?),
    );

Map<String, dynamic> _$AudioMetadataToJson(AudioMetadata instance) =>
    <String, dynamic>{
      'id': instance.id,
      'data': instance.data,
      'title': instance.title,
      'artist': instance.artist,
      'album': instance.album,
      'artwork': AudioMetadata._artworkToString(instance.artwork),
    };
