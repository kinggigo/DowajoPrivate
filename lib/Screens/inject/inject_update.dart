import 'dart:io';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:dowajo/components/models/injectModel.dart';
import 'package:dowajo/Screens/inject/inject_list_provider.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:dowajo/Alarm/alarm_schedule.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dowajo/database/inject_database.dart';

class injectUpdate extends StatefulWidget {
  final InjectModel inject;

  const injectUpdate({Key? key, required this.inject}) : super(key: key);

  @override
  State<injectUpdate> createState() => _inject_UpdateState();
}

enum type { normal, IV, nose }

class _inject_UpdateState extends State<injectUpdate> {
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
    // ignore: unused_local_variable
    final imageSize = MediaQuery.of(context).size.width / 4;

    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            "투여 수액 사진(확인용)",
            style: TextStyle(
              fontSize: 17.0, // 글자크기
              fontWeight: FontWeight.bold, // 볼드체
              color: Colors.black, // 색, // 자간
            ),
          ),
        ),
        SizedBox(height: 10),
        if (_pickedFile == null)
          Container(
            constraints: BoxConstraints(
              minHeight: imageSize,
              minWidth: imageSize,
            ),
            child: GestureDetector(
              onTap: () {
                _showBottomSheet();
              },
              child: Center(
                child: Image.asset(
                  'repo/icons/photo.png',
                  width: 75.0,
                  height: 75.0,
                ),
                // Icon(
                //   Icons.photo_camera,
                //   size: imageSize,
                // ),
              ),
            ),
          )
        else
          Center(
            child: GestureDetector(
              onTap: requestPermission,
              child: _pickedFile == null
                  ? Container(
                      constraints: BoxConstraints(
                        minHeight: imageSize,
                        minWidth: imageSize,
                      ),
                      child: Center(
                        child: Image.asset(
                          'repo/icons/photo.png',
                          width: 75.0,
                          height: 75.0,
                        ),
                      ),
                    )
                  : Center(
                      child: Container(
                        width: imageSize,
                        height: imageSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              width: 3,
                              color: Color.fromARGB(255, 217, 217, 217)),
                          image: DecorationImage(
                              image: FileImage(File(_pickedFile!.path)),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
            ),
          ),
      ],
    );
  }

  Widget injectName() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "약의 이름을 입력하세요",
                  style: TextStyle(
                    fontSize: 15.0, // 글자크기
                    color: Colors.black, // 색상
                    // letterSpacing: 2.0, // 자간
                  ),
                )),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 330, // TextField 가로 길이
              height: 45,
              child: TextField(
                controller: _injectNameController,
                decoration: InputDecoration(
                  hintText: '예) 혈압약',
                  hintStyle: TextStyle(
                    fontSize: 13.0,
                    color: Color.fromARGB(255, 171, 171, 171),
                  ),
                  contentPadding: EdgeInsets.fromLTRB(15.0, 10.0, 10.0, 10.0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 221, 221, 221),
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Color(0xFFA6CBA5),
                      width: 2.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "시간당 투여량",
          style: TextStyle(
            fontSize: 15.0, // 글자크기
            color: Colors.black, // 색상
            // letterSpacing: 2.0, // 자간
          ),
        ),
        SizedBox(height: 10),
        SizedBox(
          width: 80, // TextField 가로 길이
          height: 45,
          child: TextField(
            controller: _injectAmountController,
            decoration: InputDecoration(),
          ),
        ),
      ],
    );
  }

  Widget addAlram() {
    return SizedBox(
      width: 350,
      height: 55,
      child: GestureDetector(
        onTap: () {
          if (_injectNameController.text.isNotEmpty && _pickedFile != null) {
            // 모든 정보가 입력되었다면 InjectModel 객체를 생성하고 데이터베이스에 저장
            String Typename;
            if (_type == type.normal)
              Typename = "기본 주사";
            else if (_type == type.IV)
              Typename = "수액";
            else if (_type == type.nose) Typename = "비위관(콧줄)";
            InjectModel updatedInject = InjectModel(
              id: null,
              injectChange: Change,
              injectEndTime: endTime.format(context),
              injectStartTime: startTime.format(context),
              injectDay:
                  '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}',
              injectName: _injectNameController.text,
              injectAmount: _injectAmountController.text,
              injectPicture: _pickedFile?.path ?? '',
              injectType: _type.name,
            );
            var dbHelper = InjectDatabaseHelper.instance;
            dbHelper.update(updatedInject);
            Navigator.of(context).pop(updatedInject);
            updateInject(updatedInject);
          } else {
            // 정보가 입력되지 않았다면 경고창 띄우기
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Color.fromARGB(200, 255, 255, 255),
                  content: Padding(
                    // Padding 위젯 사용
                    padding: EdgeInsets.only(top: 20.0),
                    child: Text(
                      '정보를 모두 입력하세요',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  //contentPadding: EdgeInsets.symmetric(vertical: 100.0),
                  actions: <Widget>[
                    TextButton(
                      child: Text(
                        '확인',
                        style: TextStyle(
                            //color: Color(0xFFA6CBA5),
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
        },
        child: ElevatedButton(
          onPressed: null, // onPressed를 null로 설정하여 버튼을 비활성화
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Color(0xFFA6CBA5)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            elevation: MaterialStateProperty.all<double>(0),
          ),
          child: Text(
            "알람 수정하기",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15.5,
            ),
          ),
        ),
      ),
    );
  }

  void updateInject(InjectModel inject) async {
    InjectDatabaseHelper db = InjectDatabaseHelper.instance;

    // 주사 정보를 업데이트하는 코드
    await db.update(inject);

    // 기존 알람을 취소합니다.
    if (inject.id != null) {
      await AndroidAlarmManager.cancel(inject.id!);
    }

    // 새로운 알람을 스케줄링합니다.
    scheduleAlarm();
  }
}
