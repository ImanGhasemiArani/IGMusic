import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../assets/icos.dart';
import '../../controllers/audio_manager.dart';

class PlayPauseButtonWithProgressBar extends StatefulWidget {
  const PlayPauseButtonWithProgressBar({Key? key}) : super(key: key);

  @override
  _PlayPauseButtonWithProgressBarState createState() =>
      _PlayPauseButtonWithProgressBarState();
}

class _PlayPauseButtonWithProgressBarState
    extends State<PlayPauseButtonWithProgressBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
      ),
      child: Stack(children: [
        ValueListenableBuilder<ProgressBarStatus>(
          valueListenable: AudioManager().progressNotifier,
          builder: (_, value, __) {
            double progress = (value.current.inSeconds / value.total.inSeconds);
            if (progress.isNaN || progress.isInfinite) {
              progress = 0;
            }
            return CircularPercentIndicator(
              radius: 20,
              lineWidth: 3,
              circularStrokeCap: CircularStrokeCap.round,
              backgroundColor: Colors.black26,
              progressColor: Colors.black45,
              percent: progress,
            );
          },
        ),
        Container(
          height: 40,
          width: 40,
          color: Colors.transparent,
          child: ValueListenableBuilder<AudioStatus>(
            valueListenable: AudioManager().audioStatusNotifier,
            builder: (_, value, __) {
              switch (value) {
                case AudioStatus.playing:
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        AudioManager().pauseAudio();
                      });
                    },
                    child: Icon(
                      Icos.pause_svgrepo_com,
                      size: 20,
                      color: Colors.black.withOpacity(0.7),
                    ),
                  );
                case AudioStatus.paused:
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        AudioManager().playAudio();
                      });
                    },
                    child: Icon(
                      Icos.play_fill_svgrepo_com,
                      size: 20,
                      color: Colors.black.withOpacity(0.7),
                    ),
                  );
              }
            },
          ),
        ),
      ]),
    );
  }
}

class LoopButton extends StatefulWidget {
  const LoopButton({Key? key}) : super(key: key);

  @override
  _LoopButtonState createState() => _LoopButtonState();
}

class _LoopButtonState extends State<LoopButton> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<LoopModeState>(
      valueListenable: AudioManager().loopModeNotifier,
      builder: (_, value, __) {
        switch (value) {
          case LoopModeState.loopAll:
            return InkWell(
              borderRadius: BorderRadius.circular(50),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              enableFeedback: false,
              onTap: () {
                setState(() {
                  AudioManager().setLoopModeToLoopOne();
                });
              },
              child: Icon(
                Icos.repeat,
                size: 25,
                color: Colors.white.withOpacity(0.7),
              ),
            );
          case LoopModeState.loopOne:
            return InkWell(
              borderRadius: BorderRadius.circular(50),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              enableFeedback: false,
              onTap: () {
                setState(() {
                  AudioManager().setLoopModeToShuffle();
                });
              },
              child: Icon(
                Icos.repeat_once,
                size: 25,
                color: Colors.white.withOpacity(0.7),
              ),
            );
          case LoopModeState.shuffle:
            return InkWell(
              borderRadius: BorderRadius.circular(50),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              enableFeedback: false,
              onTap: () {
                setState(() {
                  AudioManager().setLoopModeToLoopAll();
                });
              },
              child: Icon(
                Icos.shuffle,
                size: 25,
                color: Colors.white.withOpacity(0.7),
              ),
            );
        }
      },
    );
  }
}
