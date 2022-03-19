import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';

import '../../assets/icos.dart';
import '../../controllers/btn_controllers.dart';
import '../../controllers/value_notifier.dart';
import 'tap_effect.dart';

class BtnSetTimer extends StatelessWidget {
  const BtnSetTimer({Key? key, this.size = 25}) : super(key: key);

  final double size;
  @override
  Widget build(BuildContext context) {
    return TapEffect(
      onTap: () {
        bottomSheet(context);
      },
      child: Icon(
        Icos.timer,
        size: size,
        color: Colors.white.withOpacity(0.7),
      ),
    );
  }

  Object bottomSheet(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var duration = Duration.zero;
    return showModalBottomSheet(
      context: context,
      enableDrag: false,
      builder: (BuildContext buildContext) {
        return playbackTimer == null || !playbackTimer!.isActive
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StatefulBuilder(
                    builder: (context, setSate) {
                      return DurationPicker(
                        duration: duration,
                        onChange: (dur) {
                          setSate(() {
                            duration = dur;
                          });
                        },
                      );
                    },
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          alignment: Alignment.center,
                          enableFeedback: false,
                          primary: Colors.white70,
                          onPrimary: Colors.black,
                          minimumSize: Size(size.width / 3, 36),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(1000),
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.cancel_outlined,
                        ),
                        label: const Text("Cancel"),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          alignment: Alignment.center,
                          enableFeedback: false,
                          minimumSize: Size(size.width / 3, 36),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(1000),
                            ),
                          ),
                        ),
                        onPressed: () {
                          btnSetTimerTaped(duration);
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.check_circle_outline_rounded,
                        ),
                        label: const Text("Start"),
                      ),
                    ],
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: FittedBox(
                      alignment: Alignment.center,
                      fit: BoxFit.fitWidth,
                      child: ValueListenableBuilder<Duration>(
                          valueListenable: playbackTimerNotifier,
                          builder: (_, value, __) {
                            var time = value.toString().substring(0, 7);
                            if (time[1] == ':') {
                              time = "0" + time;
                            }
                            return Text(
                              time,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            );
                          }),
                    ),
                    decoration: const BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    width: size.width / 2.5,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          alignment: Alignment.center,
                          enableFeedback: false,
                          primary: Colors.white70,
                          onPrimary: Colors.black,
                          minimumSize: Size(size.width / 3, 36),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(1000),
                            ),
                          ),
                        ),
                        onPressed: () {
                          playbackTimer!.cancel();
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.cancel_outlined,
                        ),
                        label: const Text("Cancel"),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          alignment: Alignment.center,
                          enableFeedback: false,
                          primary: Colors.blue,
                          minimumSize: Size(size.width / 3, 36),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(1000),
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.check_circle_outline_rounded,
                        ),
                        label: const Text("OK"),
                      ),
                    ],
                  ),
                ],
              );
      },
    );
  }
}
