import 'dart:developer';

void logging(String message, {bool? isShowTime}) {
  isShowTime = isShowTime ?? false;
  if (isShowTime) {
    var time = DateTime.now();
    log("$message -> time: ${time.minute}: ${time.second}: ${time.millisecond} ", time: time);
  } else {
    log(message);
  }
}
