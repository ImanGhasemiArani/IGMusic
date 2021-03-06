import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../../assets/fonts.dart';
import '../../assets/icos.dart';
import '../../controllers/btn_controllers.dart';
import '../../lang/strs.dart';
import '../../services/audio_manager.dart';
import 'tap_effect.dart';

class BtnSetSpeed extends StatelessWidget {
  const BtnSetSpeed({Key? key, this.size = 25}) : super(key: key);

  final double size;
  @override
  Widget build(BuildContext context) {
    return TapEffect(
      onTap: () {
        bottomSheet(context);
      },
      child: Icon(
        Icos.speed,
        size: size,
        color: Colors.white.withOpacity(0.7),
      ),
    );
  }

  Object bottomSheet(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return showModalBottomSheet(
      context: context,
      enableDrag: false,
      builder: (BuildContext buildContext) {
        return FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(bottom: size.height / 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                speedProgressBar(context),
                SizedBox(
                  width: size.width,
                  child: Row(
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
                        label: Text(Strs.cancelStr.tr),
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
                          btnSetSpeedTaped(1.0);
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.refresh_rounded,
                        ),
                        label: Text(Strs.resetStr.tr),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget speedProgressBar(BuildContext context) {
    return SleekCircularSlider(
      appearance: CircularSliderAppearance(
        animationEnabled: false,
        infoProperties: InfoProperties(
          mainLabelStyle: Fonts.s30_ffffffff,
          modifier: (value) {
            return value.toStringAsFixed(1);
          },
        ),
      ),
      max: 2,
      min: 0.5,
      initialValue: AudioManager().audioPlayer.speed,
      onChange: (d) {},
      onChangeEnd: (speed) {
        btnSetSpeedTaped(double.parse(speed.toStringAsFixed(1)));
        Navigator.pop(context);
      },
    );
  }
}
