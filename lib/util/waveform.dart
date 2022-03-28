import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:just_waveform/just_waveform.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:rxdart/rxdart.dart';

import '../models/user_data.dart';

class WaveformBuilder extends StatefulWidget {
  const WaveformBuilder({Key? key, required this.width, required this.height})
      : super(key: key);

  final double width;
  final double height;

  @override
  State<WaveformBuilder> createState() => _WaveformBuilderState();
}

class _WaveformBuilderState extends State<WaveformBuilder> {
  final progressStream = BehaviorSubject<WaveformProgress>();
  Waveform? waveform;
  bool isExists = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    var tmp = UserData().audiosMetadata[3];
    final audioFile = File(tmp.data);
    final String outName = "waveform${tmp.id}.wave";
    try {
      final waveFile =
          File(p.join((await getExternalStorageDirectory())!.path, outName));
      if (waveFile.existsSync()) {
        waveform = await JustWaveform.parse(waveFile);
        if (waveform != null) {
          setState(() {
            isExists = true;
          });
        }
      } else {
        JustWaveform.extract(
                audioInFile: audioFile,
                waveOutFile: waveFile,
                zoom: const WaveformZoom.pixelsPerSecond(50))
            .listen(progressStream.add, onError: progressStream.addError);
      }
    } catch (e) {
      progressStream.addError(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      color: Colors.transparent,
      width: widget.width,
      child: StreamBuilder<WaveformProgress>(
          stream: progressStream,
          builder: (context, snapshot) {
            if (isExists) {
              return AudioWaveformWidget(
                waveform: waveform!,
                start: Duration.zero,
                waveColor: Colors.blue.shade900,
                duration: waveform!.duration,
              );
            } else {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                );
              }
              final progress = snapshot.data?.progress ?? 0.0;
              waveform = snapshot.data?.waveform;
              if (waveform == null) {
                return Center(
                  child: Text(
                    '${(100 * progress).toInt()}%',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                );
              }
              return AudioWaveformWidget(
                waveform: waveform!,
                start: Duration.zero,
                waveColor: Colors.amber,
                duration: waveform!.duration,
              );
            }
          }),
    );
  }
}

class AudioWaveformWidget extends StatefulWidget {
  final Color waveColor;
  final double scale;
  final double strokeWidth;
  final double pixelsPerStep;
  final Waveform waveform;
  final Duration start;
  final Duration duration;

  const AudioWaveformWidget({
    Key? key,
    required this.waveform,
    required this.start,
    required this.duration,
    this.waveColor = Colors.grey,
    this.scale = 0.5,
    this.strokeWidth = 2,
    this.pixelsPerStep = 4,
  }) : super(key: key);

  @override
  _AudioWaveformState createState() => _AudioWaveformState();
}

class _AudioWaveformState extends State<AudioWaveformWidget> {
  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: CustomPaint(
        painter: AudioWaveformPainter(
          waveColor: widget.waveColor,
          waveform: widget.waveform,
          start: widget.start,
          duration: widget.duration,
          scale: widget.scale,
          strokeWidth: widget.strokeWidth,
          pixelsPerStep: widget.pixelsPerStep,
        ),
      ),
    );
  }
}

class AudioWaveformPainter extends CustomPainter {
  final double scale;
  final double strokeWidth;
  final double pixelsPerStep;
  final Paint wavePaint;
  final Waveform waveform;
  final Duration start;
  final Duration duration;

  AudioWaveformPainter({
    required this.waveform,
    required this.start,
    required this.duration,
    Color waveColor = Colors.blue,
    this.scale = 1.0,
    this.strokeWidth = 5.0,
    this.pixelsPerStep = 8.0,
  }) : wavePaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round
          ..color = waveColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (duration == Duration.zero) return;

    double width = size.width;
    double height = size.height;

    final waveformPixelsPerWindow = waveform.positionToPixel(duration).toInt();
    final waveformPixelsPerDevicePixel = waveformPixelsPerWindow / width;
    final waveformPixelsPerStep = waveformPixelsPerDevicePixel * pixelsPerStep;
    final sampleOffset = waveform.positionToPixel(start);
    final sampleStart = -sampleOffset % waveformPixelsPerStep;
    for (var i = sampleStart.toDouble();
        i <= waveformPixelsPerWindow + 1.0;
        i += waveformPixelsPerStep) {
      final sampleIdx = (sampleOffset + i).toInt();
      final x = i / waveformPixelsPerDevicePixel;
      final minY = normalise(waveform.getPixelMin(sampleIdx), height);
      final maxY = normalise(waveform.getPixelMax(sampleIdx), height);
      canvas.drawLine(
        Offset(x + strokeWidth / 2, max(strokeWidth * 0.75, minY)),
        Offset(x + strokeWidth / 2, min(height - strokeWidth * 0.75, maxY)),
        wavePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant AudioWaveformPainter oldDelegate) {
    return false;
  }

  double normalise(int s, double height) {
    if (waveform.flags == 0) {
      final y = 32768 + (scale * s).clamp(-32768.0, 32767.0).toDouble();
      return height - 1 - y * height / 65536;
    } else {
      final y = 128 + (scale * s).clamp(-128.0, 127.0).toDouble();
      return height - 1 - y * height / 256;
    }
  }
}
