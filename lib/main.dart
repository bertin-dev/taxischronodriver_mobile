import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:taxischronodriver/controllers/controllerbuilding.dart';
import 'package:taxischronodriver/firebase_options.dart';
import 'package:taxischronodriver/modeles/applicationuser/appliactionuser.dart';
import 'package:taxischronodriver/notifications/confi_messenging.dart';
import 'package:taxischronodriver/screens/auth/login_page.dart';
import 'package:taxischronodriver/services/transitionchauffeur.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  requestPermissionMessenging();
  FirebaseMessaging.onBackgroundMessage(firebaseMessanginbackgroundHandler);
  await notificationPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()!
      .createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
  eventListner();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApplicationUser?>(
        stream: ApplicationUser.currentUser(),
        builder: (context, snapshot) {
          return GetMaterialApp(
            initialBinding: ControllerBinding(),
            title: 'TaxisChrono',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: snapshot.data == null
                ? const LoginPage()
                : //HomePage()
                TransitionChauffeurVehicule(applicationUser: snapshot.data!),
          );
        });
  }
}
