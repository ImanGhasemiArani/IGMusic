import 'dart:io';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:get/get.dart';
import 'package:github/github.dart';
import 'package:path_provider/path_provider.dart';

import '../lang/strs.dart';

Future<void> sendFeedback(String title, String message, String rating,
    String screenshotFilePath) async {
  var result = await Connectivity().checkConnectivity();
  if (result != ConnectivityResult.mobile ||
      result != ConnectivityResult.wifi) {
    Get.showSnackbar(
      GetSnackBar(
        forwardAnimationCurve: Curves.decelerate,
        reverseAnimationCurve: Curves.decelerate,
        isDismissible: false,
        duration: const Duration(seconds: 4),
        messageText: FittedBox(
          alignment: Alignment.center,
          fit: BoxFit.scaleDown,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1000),
              color: const Color(0xFF303030),
            ),
            alignment: Alignment.center,
            child: Text(
              Strs.noInternetConnection.tr,
              style: const TextStyle(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
    );
    return;
  }
  sendIssueToGitHub(title, message, rating, screenshotFilePath);
  sendEmailFeedback(title, message, rating, screenshotFilePath);
}

Future<void> sendEmailFeedback(String title, String message, String rating,
    String screenshotFilePath) async {
  String body = "rate: $rating \n\n $message";

  final Email email = Email(
    body: body,
    subject: title,
    recipients: ['igmusic_feedback@yahoo.com'],
    cc: [],
    bcc: [],
    attachmentPaths: [screenshotFilePath],
    isHTML: false,
  );

  await FlutterEmailSender.send(email);
}

Future<void> sendIssueToGitHub(String title, String message, String rating,
    String screenshotFilePath) async {
  var github = GitHub(
      auth:
          Authentication.withToken('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'));

  String body = "rate: $rating \n\n $message";
  await github.issues.create(RepositorySlug('ImanGhasemiArani', 'IGMusic'),
      IssueRequest(title: title, body: body));
//   github.dispose();
}

Future<String> writeImageToStorage(Uint8List feedbackScreenshot) async {
  final Directory output = await getTemporaryDirectory();
  final String screenshotFilePath = '${output.path}/feedback.png';
  final File screenshotFile = File(screenshotFilePath);
  await screenshotFile.writeAsBytes(feedbackScreenshot);
  return screenshotFilePath;
}
