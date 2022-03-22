import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:github/github.dart';
import 'package:path_provider/path_provider.dart';

Future<void> sendFeedback(
    String title, String message, String screenshotFilePath) async {
  sendIssueToGitHub("Feedback", message, screenshotFilePath);
  sendEmailFeedback("Feedback", message, screenshotFilePath);
}

Future<void> sendEmailFeedback(
    String title, String message, String screenshotFilePath) async {
  String body = message;

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

Future<void> sendIssueToGitHub(
    String title, String message, String screenshotFilePath) async {
  var github = GitHub(
      auth:
          Authentication.withToken('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'));

  String body = message;
  await github.issues.create(RepositorySlug('ImanGhasemiArani', 'IGMusic'),
      IssueRequest(title: title, body: body));
  github.dispose();
}

Future<String> writeImageToStorage(Uint8List feedbackScreenshot) async {
  final Directory output = await getTemporaryDirectory();
  final String screenshotFilePath = '${output.path}/feedback.png';
  final File screenshotFile = File(screenshotFilePath);
  await screenshotFile.writeAsBytes(feedbackScreenshot);
  return screenshotFilePath;
}
