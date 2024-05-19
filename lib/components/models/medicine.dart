import 'dart:convert';

class Medicine {
  // final List<dynamic> notificationIDs; // 알림 ID
  final int? id; // id 필드 추가
  final String medicineName;
  final String medicinePicture; // 사진 파일의 경로를 저장
  final String medicineDay; // 요일
  final int medicineRepeat; // 반복 횟수
  final String medicineTime;
  final Map<String, bool> takenDates; // 복용완료체크박스 상태를 저장하는 필드

  Medicine({
    // required this.notificationIDs,
    this.id, // 생성자에 id 추가
    required this.medicineName,
    required this.medicinePicture,
    required this.medicineDay,
    required this.medicineRepeat,
    required this.medicineTime,
    required this.takenDates,
  });

  // List<dynamic> get getIDs => notificationIDs;
  int? get getId => id; // id getter 추가
  String get getName => medicineName;
  String get getPicture => medicinePicture;
  String get getDay => medicineDay;
  int get getRepeat => medicineRepeat;

  //String get getTime => medicineTime;

  Map<String, dynamic> toMap() {
    return {
      'id': id, // toMap 메서드에 id 추가
      'medicineName': medicineName,
      'medicinePicture': medicinePicture,
      'medicineDay': medicineDay,
      'medicineRepeat': medicineRepeat,
      'medicineTime': medicineTime,
      'takenDates': jsonEncode(takenDates), // takenDates 필드를 JSON 문자열로 변환합니다.
    };
  }

  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      id: map['id'],
      medicineName: map['medicineName'],
      medicinePicture: map['medicinePicture'],
      medicineDay: map['medicineDay'],
      medicineRepeat: map['medicineRepeat'],
      medicineTime: map['medicineTime'],
      takenDates: Map<String, bool>.from(jsonDecode(
          map['takenDates'])), // JSON 문자열을 Map<String, bool>으로 변환합니다.
    );
  }
}
