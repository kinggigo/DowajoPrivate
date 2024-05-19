//import 'dart:isolate';

import 'package:dowajo/Alarm/alarm_schedule.dart';
import 'package:dowajo/Alarm/notification_manager.dart';
import 'package:dowajo/Alarm/work_manager.dart';
import 'package:dowajo/Screens/home_screen.dart';
import 'package:dowajo/components/calendar/today_banner.dart';
import 'package:dowajo/components/models/injectModel.dart';
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
// import 'notification_manager.dart'; // notification_manager.dart를 import합니다.
// import 'work_manager_setup.dart'; // work_manager_setup.dart를 import합니다.
// import 'utils.dart'; // utils.dart를 import합니다.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting();
  await AndroidAlarmManager.initialize();
  setupWorkManager(); // work_manager_setup.dart에서 정의한 함수를 호출합니다.

  const String channelId = 'your channel id';
  const String channelName = 'your channel name';
  const String channelDescription = 'your channel description'; // Optional

  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    channelId,
    channelName,
    description: channelDescription,
    importance: Importance.max,
  );

  var initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');

  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  flutterLocalNotificationsPlugin.initialize(initializationSettings);
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  scheduleAlarm(); // 알람 스케줄링 추가

  runApp(
    //멀티프로바이더 추가
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MedicineModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => InjectModelProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
        unselectedWidgetColor: const Color.fromARGB(255, 203, 202, 202),
      ),
      home: const HomeScreen(),
    );
  }
}
