import 'dart:convert';

class InjectModel {
  final int? id;
  final String injectType;
  final String injectName;
  final String injectPicture; // 사진 파일의 경로를 저장
  final String injectDay; // 요일
  final String injectStartTime;
  final String injectEndTime;
  final String injectAmount;
  final int injectChange;

  InjectModel({
    required this.id,
    required this.injectType,
    required this.injectName,
    required this.injectPicture, // 사진 파일의 경로를 저장
    required this.injectDay, //요일
    required this.injectStartTime,
    required this.injectEndTime,
    required this.injectAmount,
    required this.injectChange,
  });

  // Convert a InjectModels object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'injectType': injectType,
      'injectName': injectName,
      'injectPicture': injectPicture,
      'injectDay': injectDay,
      'injectStartTime': injectStartTime,
      'injectEndTime': injectEndTime,
      'injectAmount': injectAmount,
      'injectChange': injectChange,
    };
  }

  // Convert a Map object into a InjectModels object
  static InjectModel fromMap(Map<String, dynamic> map) {
    return InjectModel(
      id: map['id'],
      injectType: map['injectType'],
      injectName: map['injectName'],
      injectPicture: map['injectPicture'],
      injectDay: map['injectDay'],
      injectStartTime: map['injectStartTime'],
      injectEndTime: map['injectEndTime'],
      injectAmount: map['injectAmount'],
      injectChange: map['injectChange'],
    );
  }
}
