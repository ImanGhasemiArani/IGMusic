import 'dart:developer';

import 'package:flutter/foundation.dart';

void logging(String message,
    {bool isShowTime = false, bool isRed = false, String color = "\x1B[35m"}) {
  isRed ? color = "\x1B[31m" : null;
  if (isShowTime) {
    var time = DateTime.now();
    log("$color$message -> time: ${time.minute}: ${time.second}: ${time.millisecond} \x1B[0m",
        time: time);
  } else {
    log("$color$message\x1B[0m");
  }
}

class Logger {
  final AsyncCallback? asyncAction;
  final VoidCallback? voidAction;
  final String message;
  final bool isShowTime;
  final String color;

  Logger(this.message,
      {this.asyncAction,
      this.voidAction,
      this.isShowTime = false,
      this.color = "\x1B[32m"});

  Future<void> start() async {
    var beforeTime = DateTime.now().millisecondsSinceEpoch;
    voidAction != null ? voidAction!() : await asyncAction!();
    var afterTime = DateTime.now().millisecondsSinceEpoch;
    var time = DateTime.fromMillisecondsSinceEpoch(afterTime - beforeTime)
        .toString()
        .trim();
    if (isShowTime) {
      log("$color✔  $message -> period: ${time.substring(15)}\x1B[0m");
    } else {
      log("$color✔  $message\x1B[0m");
    }
  }
}
