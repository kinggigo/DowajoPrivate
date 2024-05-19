import 'dart:io';
import 'package:dowajo/Alarm/alarm_schedule.dart';
import 'package:dowajo/components/models/injectModel.dart';
import 'package:dowajo/components/calendar/today_banner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../database/inject_database.dart';
import 'package:dowajo/screens/inject_screen.dart';

class inject_add extends StatefulWidget {
  const inject_add({Key? key}) : super(key: key);

  @override
  _inject_addState createState() => _inject_addState();
}

enum type { normal, IV, nose }

class _inject_addState extends State<inject_add> {
  int selectedRepeat = 1;
  XFile? _pickedFile;
  String Type = "일반 주사";
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();
  final TextEditingController _injectNameController = TextEditingController();
  final TextEditingController _injectAmountController = TextEditingController();
  List<String> selectedDays = []; // 선택된 요일을 저장하는 리스트
  bool Change = false; //추가 교체 여부
  type _type = type.normal;

  void _showTimePicker(TimeOfDay time, bool start) async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: time,
    );

    if (newTime != null) {
      setState(() {
        if (start)
          startTime = newTime;
        else
          endTime = newTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final injectProvider = Provider.of<InjectModel>(context, listen: false);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: <Widget>[
                AppBar(
                  backgroundColor: Colors.white,
                  iconTheme: IconThemeData(color: Colors.black),
                ),
                SizedBox(height: 5),
                Container(
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      injectType(), // 상단 안내문
                      addPhoto(), // 사진등록
                    ])),
                SizedBox(height: 10),
                injectName(), // 약 이름 입력창
                SizedBox(height: 20),
                // 경계선 추가
                Divider(
                  color: Color.fromARGB(255, 236, 236, 236),
                  thickness: 4.0,
                ),
                SizedBox(height: 15),
                numOfTitle(), // 복용횟수- 타이틀
                //numOfTakeinject(), // 복용횟수 - 횟수 설정
                SizedBox(height: 15),
                //복용시간 추가
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(children: [
                        addTime("투여 시작 시간", startTime, true),
                        SizedBox(height: 15),
                        addTime("투여 종료 시간", endTime, false),
                      ]),
                      injectAmount(),
                    ]),
                // 경계선 추가
                Divider(
                  color: Color.fromARGB(255, 236, 236, 236),
                  thickness: 4.0,
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Checkbox(
                        value: Change,
                        onChanged: (value) {
                          setState(() {
                            Change = value!;
                          });
                        }),
                    Text("추가 교체 여부"),
                  ],
                ),
                SizedBox(height: 20),
                addAlram(), //알람 추가 버튼
                //SizedBox(height: 30),
              ],
            ),
          ),
        ));
  }

  //카메라 설정
  _showBottomSheet() {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () => _getCameraImage(),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.transparent,
                minimumSize: Size(MediaQuery.of(context).size.width, 60),
              ),
              child: const Text('사진 찍기'),
            ),
            const SizedBox(height: 5),
            const Divider(thickness: 4),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _getPhotoLibraryImage(),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.transparent,
                minimumSize: Size(MediaQuery.of(context).size.width, 60),
              ),
              child: const Text('라이브러리에서 불러오기'),
            ),
            const SizedBox(height: 10),
            const Divider(thickness: 4),
            const SizedBox(height: 5),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.transparent,
                minimumSize: Size(MediaQuery.of(context).size.width, 60),
              ),
              child: const Text('닫기'),
            ),
            const SizedBox(height: 18),
          ],
        );
      },
    );
  }

  _getCameraImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });
      Navigator.pop(context);
    } else {
      if (kDebugMode) {
        print('이미지 선택안함');
      }
    }
  }

  _getPhotoLibraryImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });
      Navigator.pop(context);
    } else {
      if (kDebugMode) {
        print('이미지 선택안함');
      }
    }
  }

  Widget injectType() {
    return Expanded(
        child: Column(children: [
      Row(children: [
        Padding(
          padding: EdgeInsets.only(left: 0, right: 10.0),
          child: Image.asset(
            'repo/icons/pill.png',
            width: 25.0,
            height: 25.0,
          ),
        ),
        Text(
          "투여 약 종류",
          style: TextStyle(
            fontSize: 17.0, // 글자크기
            fontWeight: FontWeight.bold, // 볼드체
            color: Colors.black, // 색상
            //  letterSpacing: 2.0, // 자간
          ),
        ),
      ]),
      Container(
          height: 200,
          child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  RadioListTile(
                    title: Text("일반 주사"),
                    value: type.normal,
                    groupValue: _type,
                    onChanged: (value) {
                      setState(() {
                        _type = value!;
                      });
                    },
                  ),
                  RadioListTile(
                    title: Text("수액"),
                    value: type.IV,
                    groupValue: _type,
                    onChanged: (value) {
                      setState(() {
                        _type = value!;
                      });
                    },
                  ),
                  RadioListTile(
                    title: Text("비위관(콧줄)"),
                    value: type.nose,
                    groupValue: _type,
                    onChanged: (value) {
                      setState(() {
                        _type = value!;
                      });
                    },
                  ),
                ],
              )))
    ]));
  }

  void requestPermission() async {
    PermissionStatus status = await Permission.camera.status;

    if (!status.isGranted) {
      status = await Permission.camera.request();
    }

    if (status.isGranted) {
      _showBottomSheet(); // 카메라나 갤러리를 열어 이미지를 선택하는 함수
    } else {
      // 권한이 거부된 경우 로직 (ex: 사용자에게 알림 표시)
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('권한 거부'),
            content: Text('카메라와 갤러리 접근 권한이 필요합니다.'),
            actions: <Widget>[
              TextButton(
                child: Text('확인'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Widget addPhoto() {
    return GestureDetector(
      onTap: () {
        requestPermission();
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(15),
        ),
        child: _pickedFile != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.file(
                  File(_pickedFile!.path),
                  fit: BoxFit.cover,
                ),
              )
            : Icon(
                Icons.camera_alt,
                color: Colors.grey[800],
              ),
      ),
    );
  }

  Widget injectName() {
    return TextField(
      controller: _injectNameController,
      decoration: InputDecoration(
        labelText: '주사 이름',
        labelStyle: TextStyle(fontSize: 18),
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget numOfTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 15.0, right: 10.0),
          child: Image.asset(
            'repo/icons/alarm.png',
            width: 26.0,
            height: 26.0,
          ),
        ),
        Text(
          "투여 시간 설정",
          style: TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget addTime(String name, TimeOfDay time, bool start) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          name,
          style: TextStyle(fontSize: 15),
        ),
        TextButton(
          onPressed: () {
            _showTimePicker(time, start); // 버튼을 누를 때 텍스트 업데이트
          },
          child: Text(time.format(context)),
        ),
      ],
    );
  }

  Widget injectAmount() {
    return TextField(
      controller: _injectAmountController,
      decoration: InputDecoration(
        labelText: '주사량',
        labelStyle: TextStyle(fontSize: 18),
        border: OutlineInputBorder(),
      ),
    );
  }

  //addAlarm 함수 타임포맷 임시로 수정
  String formatTimeOfDay(TimeOfDay timeOfDay) {
    final hours = timeOfDay.hour.toString().padLeft(2, '0');
    final minutes = timeOfDay.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  Widget addAlram() {
    return SizedBox(
      width: 350,
      height: 55,
      child: GestureDetector(
        onTap: () async {
          final inject = InjectModel(
            id: null,
            injectType: Type,
            injectName: _injectNameController.text,
            injectPicture: _pickedFile?.path ?? '',
            //injectDay: selectedDays.join(','),
            injectStartTime: formatTimeOfDay(startTime),
            injectEndTime: formatTimeOfDay(endTime),
            injectAmount: _injectAmountController.text,
            injectChange: Change,
          );

          // DatabaseHelper 인스턴스 생성
          var dbHelper = InjectDatabaseHelper.instance;

          // InjectModel 인스턴스를 데이터베이스에 저장
          await dbHelper.insert(inject);
          Provider.of<InjectModelProvider>(context, listen: false);

          scheduleAlarm();

          Navigator.pop(context);
        },
        child: Text('알람 추가'),
      ),
    );
  }
}
