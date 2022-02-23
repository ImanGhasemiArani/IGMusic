import 'dart:developer';

import 'package:flutter/foundation.dart';

void logging(String message, {bool? isShowTime}) {
  isShowTime = isShowTime ?? false;
  if (isShowTime) {
    var time = DateTime.now();
    log("$message -> time: ${time.minute}: ${time.second}: ${time.millisecond} ",
        time: time);
  } else {
    log(message);
  }
}

class Logger {
  final AsyncCallback? asyncAction;
  final VoidCallback? voidAction;
  final String message;
  final bool isShowTime;

  Logger(this.message,
      {this.asyncAction, this.voidAction, this.isShowTime = false});

  Future<void> start() async {
    var beforeTime = DateTime.now().millisecondsSinceEpoch;
    voidAction != null ? voidAction!() : await asyncAction!();
    var afterTime = DateTime.now().millisecondsSinceEpoch;
    var time = DateTime.fromMillisecondsSinceEpoch(afterTime - beforeTime)
        .toString()
        .trim();
    if (isShowTime) {
      log("✔  $message -> period: ${time.substring(15)}");
    } else {
      log("✔  $message");
    }
  }
}
