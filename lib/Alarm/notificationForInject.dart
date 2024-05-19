import 'package:dowajo/Alarm/utils.dart';
import 'package:dowajo/database/inject_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:dowajo/components/models/injectModel.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void sendNotificationForInject(
    int id, String name, String time, int change) async {
  InjectDatabaseHelper db = InjectDatabaseHelper.instance;
  List<InjectModel> injects = await db.getAllInjects();
  print('Retrieved ${injects.length} injects'); // 주입 정보 로드 로그

  for (InjectModel inject in injects) {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    int notificationId =
        int.parse('${inject.id}${parseHour(inject.injectEndTime)}');

    String title = '주사 알림: ${inject.injectName}';
    String body = '종료시간입니다';
    String payload = change == 1 ? '추가 교체가 필요합니다.' : '';

    flutterLocalNotificationsPlugin.show(
        notificationId, // 주입의 ID를 알림 ID로 사용
        title, // 주입의 이름을 알림 제목에 포함
        body, // 종료 시간을 알림 본문에 포함
        platformChannelSpecifics,
        payload: payload);
    print(
        'Notification prepared for inject ID ${inject.id}: ${inject.injectName} at ${inject.injectEndTime}');
  }
}
