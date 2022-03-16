import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../assets/imgs.dart';

Image getArtwork({Uint8List? artworkData, double? height, double? width}) {
  width = width ?? 50;
  height = height ?? 50;
  return artworkData == null || artworkData.isEmpty
      ? Image.asset(
          Imgs.imgDefaultMusicCover,
          width: width,
          height: height,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
        )
      : Image.memory(
          artworkData,
          width: width,
          height: height,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
        );
}
