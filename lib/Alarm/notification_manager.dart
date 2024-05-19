import 'package:dowajo/Alarm/utils.dart';
import 'package:dowajo/database/medicine_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:dowajo/components/models/medicine.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void sendNotification() async {
  print('sendNotification called'); // 함수 호출 로그

  DatabaseHelper db = DatabaseHelper.instance;
  List<Medicine> medicines = await db.getAllMedicines();
  print('Retrieved ${medicines.length} medicines'); // 약 정보 로드 로그

  for (Medicine medicine in medicines) {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    int notificationId = int.parse(
        '${medicine.id}${dayToNum(medicine.medicineDay)}${parseHour(medicine.medicineTime)}');
    flutterLocalNotificationsPlugin.show(
      notificationId, // 약의 ID를 알림 ID로 사용
      '약 복용 알림: ${medicine.medicineName}', // 약의 이름을 알림 제목에 포함
      '약 복용할 시간입니다.', // 복용 시간을 알림 본문에 포함
      platformChannelSpecifics,
    );
    print(
        'Notification prepared for medicine ID ${medicine.id}: ${medicine.medicineName} at ${medicine.medicineTime}');
  }
}
