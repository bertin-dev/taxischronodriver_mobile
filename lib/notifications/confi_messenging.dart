import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:taxischronodriver/varibles/variables.dart';

AndroidNotificationChannel channel = const AndroidNotificationChannel(
    "id", "notification de taxis",
    playSound: true,
    description: 'une nouvelle commande disponible',
    importance: Importance.high);

FlutterLocalNotificationsPlugin notificationPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> firebaseMessanginbackgroundHandler(RemoteMessage message) async {
  print('Message de notification reçu en arrière-plan : ${message.notification?.title}');
  print('song de notification reçu en arrière-plan : ${message.notification?.android?.sound}');
  Firebase.initializeApp();
}

eventListner() {
  FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
    RemoteNotification? notification = remoteMessage.notification;
    AndroidNotification? androidNofication =
        remoteMessage.notification!.android;

    if (androidNofication != null) {
      notificationPlugin.show(
        notification!.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            importance: Importance.high,
            color: dredColor,
            playSound: true,
            icon: "@mipmap/ic_launcher",
          ),
        ),
      );
    }
  });
}

// testerLaNotification() {
//   notificationPlugin.show(
//     0,
//     "Teste de la notification",
//     "Corps de la notification",
//     NotificationDetails(
//       android: AndroidNotificationDetails(channel.id, channel.name,
//           channelDescription: channel.description,
//           importance: Importance.high,
//           color: dredColor,
//           playSound: true,
//           icon: "@mipmap/ic_launcher"),
//     ),
//   );
// }

Future<void> requestPermissionMessenging() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('Autorisations de notification accordées');
    // Configurer la méthode de gestion des notifications en arrière-plan
    FirebaseMessaging.onBackgroundMessage(firebaseMessanginbackgroundHandler);
  } else {
    print('Autorisations de notification refusées');
  }
}
