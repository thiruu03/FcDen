import 'package:fcden/providers/checkbox_alert.dart';
import 'package:fcden/providers/location_provider.dart';
import 'package:fcden/providers/orders_provider.dart';
import 'package:fcden/screens/splash_screen.dart';
import 'package:fcden/themes/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Notification initialization
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@drawable/notification');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  final androidPlugin =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
  bool? granted = await androidPlugin?.areNotificationsEnabled();
  if (granted == false) {
    await androidPlugin?.requestNotificationsPermission();
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => OrderProvider(
            flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => LocationProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CheckboxAlert(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightmode,
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
