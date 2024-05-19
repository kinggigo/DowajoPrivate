import 'package:workmanager/workmanager.dart';
import 'notification_manager.dart'; // 이전에 분리했던 notification_manager.dart를 import합니다.
import 'package:dowajo/Alarm/notificationForInject.dart';

// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     sendNotificationForInject(1, "name", "time", 1);
//     return Future.value(true);
//   });
// }

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case 'simplePeriodicTask':
        sendNotification();
        break;
      case 'injectPeriodicTask':
        // inputData에서 필요한 데이터를 가져옵니다.
        int id = inputData?['id'];
        String name = inputData?['name'];
        String time = inputData?['time'];
        int change = inputData?['change'];

        // null 검사를 추가합니다.
        if (id != null && name != null && time != null && change != null) {
          // sendNotificationForInject 함수를 호출합니다.
          sendNotificationForInject(id, name, time, change);
        }
        break;
      default:
        print("Unknown task: $task");
        break;
    }
    return Future.value(true);
  });
}

void setupWorkManager() {
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );

  Workmanager().registerPeriodicTask(
    "1",
    "simplePeriodicTask",
    frequency: const Duration(minutes: 1),
  );
}
