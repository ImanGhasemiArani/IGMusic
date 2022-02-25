import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();
  factory NotificationService() {
    return _notificationService;
  }
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final AndroidNotificationDetails _androidNotificationDetails =
      const AndroidNotificationDetails(
    'Music',
    'Music Player',
    channelDescription: 'Advanced Music Player',
    playSound: false,
    enableVibration: false,
    priority: Priority.low,
    importance: Importance.low,
    onlyAlertOnce: true,
    visibility: NotificationVisibility.public,
    
  );
  late NotificationDetails platformChannelSpecifics;

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('myicon');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (payload) {});

    platformChannelSpecifics =
        NotificationDetails(android: _androidNotificationDetails);
  }

  Future<void> showNotifications() async {
    await flutterLocalNotificationsPlugin.show(
      0,
      'Checking Storage...',
      null,
      platformChannelSpecifics,
    );
  }

  Future<void> cancelNotifications({int? id}) async {
    if (id != null) {
      await flutterLocalNotificationsPlugin.cancel(id);
    } else {
      await flutterLocalNotificationsPlugin.cancelAll();
    }
  }
}



// Future selectNotification(String payload) async {
//   await Navigator.push(
//     context,
//     MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
//   );
// }
