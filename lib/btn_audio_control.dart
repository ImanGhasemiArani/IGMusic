import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'controllers/audio_manager.dart';
import 'my_graphics/MyIcons.dart';

class PlayPauseButton extends StatefulWidget {
  const PlayPauseButton({Key? key}) : super(key: key);

  @override
  _PlayPauseButtonState createState() => _PlayPauseButtonState();
}

class _PlayPauseButtonState extends State<PlayPauseButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.white.withOpacity(0.2),
      ),
      child: ValueListenableBuilder<AudioStatus>(
        valueListenable: AudioManager().audioStatusNotifier,
        builder: (_, value, __) {
          switch (value) {
            case AudioStatus.playing:
              return InkWell(
                borderRadius: BorderRadius.circular(50),
                enableFeedback: false,
                onTap: () {
                  setState(() {
                    AudioManager().pauseAudio();
                  });
                },
                child: const Icon(
                  MyIcons.pause_svgrepo_com,
                  size: 30,
                  color: Colors.white,
                ),
              );
            case AudioStatus.paused:
              return InkWell(
                borderRadius: BorderRadius.circular(50),
                enableFeedback: false,
                onTap: () {
                  setState(() {
                    AudioManager().playAudio();
                  });
                },
                child: const Icon(
                  MyIcons.play_fill_svgrepo_com,
                  size: 30,
                  color: Colors.white,
                ),
              );
          }
        },
      ),
    );
  }
}

class PlayPauseAllLocalSongsButton extends StatefulWidget {
  const PlayPauseAllLocalSongsButton({Key? key}) : super(key: key);

  @override
  _PlayPauseAllLocalSongsButtonState createState() =>
      _PlayPauseAllLocalSongsButtonState();
}

class _PlayPauseAllLocalSongsButtonState
    extends State<PlayPauseAllLocalSongsButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.white.withOpacity(0.2),
      ),
      child: ValueListenableBuilder<AudioStatus>(
        valueListenable: AudioManager().audioStatusNotifier,
        builder: (_, value, __) {
          switch (value) {
            case AudioStatus.playing:
              return InkWell(
                borderRadius: BorderRadius.circular(50),
                enableFeedback: false,
                onTap: () {
                  setState(() {
                    AudioManager().pauseAudio();
                  });
                },
                child: const Icon(
                  MyIcons.pause_svgrepo_com,
                  size: 30,
                  color: Colors.white,
                ),
              );
            case AudioStatus.paused:
              return InkWell(
                borderRadius: BorderRadius.circular(50),
                enableFeedback: false,
                onTap: () {
                  setState(() {
                    AudioManager().setPlayList();
                    AudioManager().playAudio();
                  });
                },
                child: const Icon(
                  MyIcons.play_fill_svgrepo_com,
                  size: 30,
                  color: Colors.white,
                ),
              );
          }
        },
      ),
    );
  }
}

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
                      MyIcons.pause_svgrepo_com,
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
                      MyIcons.play_fill_svgrepo_com,
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
                MyIcons.repeat,
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
                MyIcons.repeat_once,
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
                MyIcons.shuffle,
                size: 25,
                color: Colors.white.withOpacity(0.7),
              ),
            );
        }
      },
    );
  }
}

class NextButton extends StatefulWidget {
  const NextButton({Key? key, this.color}) : super(key: key);
  final Color? color;

  @override
  _NextButtonState createState() => _NextButtonState();
}

class _NextButtonState extends State<NextButton> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AudioManager().isLastSongNotifier,
      builder: (_, value, __) {
        if (!value) {
          return InkWell(
            borderRadius: BorderRadius.circular(50),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            enableFeedback: false,
            onTap: () {
              setState(() {
                AudioManager().seekToNextAudio();
              });
            },
            child: Icon(
              MyIcons.skip_next,
              size: 17,
              color: widget.color ?? Colors.white,
            ),
          );
        } else {
          return Icon(
            MyIcons.skip_next,
            size: 17,
            color: widget.color == null
                ? Colors.white.withOpacity(0.3)
                : widget.color!.withOpacity(0.3),
          );
        }
      },
    );
  }
}

class PreviousButton extends StatefulWidget {
  const PreviousButton({Key? key, this.color}) : super(key: key);
  final Color? color;

  @override
  _PreviousButtonState createState() => _PreviousButtonState();
}

class _PreviousButtonState extends State<PreviousButton> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AudioManager().isFirstSongNotifier,
      builder: (_, value, __) {
        if (!value) {
          return InkWell(
            borderRadius: BorderRadius.circular(50),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            enableFeedback: false,
            onTap: () {
              setState(() {
                AudioManager().seekToPreviousAudio();
              });
            },
            child: Icon(
              MyIcons.skip_previous,
              size: 17,
              color: widget.color ?? Colors.white,
            ),
          );
        } else {
          return Icon(
            MyIcons.skip_previous,
            size: 17,
            color: widget.color == null
                ? Colors.white.withOpacity(0.3)
                : widget.color!.withOpacity(0.3),
          );
        }
      },
    );
  }
}
