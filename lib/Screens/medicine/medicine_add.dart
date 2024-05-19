// ignore_for_file: camel_case_types, prefer_const_constructors

import 'dart:io';

import 'package:dowajo/Alarm/alarm_schedule.dart';
import 'package:dowajo/components/calendar/today_banner.dart';
import 'package:dowajo/components/weekday_buttons.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../components/models/medicine.dart';
import 'package:dowajo/database/medicine_database.dart';
import 'package:permission_handler/permission_handler.dart';

class medicine_add extends StatefulWidget {
  const medicine_add({Key? key}) : super(key: key);

  @override
  State<medicine_add> createState() => _medicine_addState();
}

class _medicine_addState extends State<medicine_add> {
  final valueList = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];
  int selectedRepeat = 1;
  XFile? _pickedFile;
  //DateTime dateTime = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  final TextEditingController _medicineNameController = TextEditingController();
  List<String> selectedDays = []; // 선택된 요일을 저장하는 리스트
  //List<TimeOfDay> selectedTimes = [];

  /*@override
  void initState() {
    super.initState();
    for (int i = 0; i < selectedRepeat; i++) {
      selectedTimes.add(TimeOfDay.now());
    }
  }*/

  void _showTimePicker() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (newTime != null) {
      setState(() {
        selectedTime = newTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            AppBar(
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.black),
            ),
            SizedBox(height: 5),
            topMessage(), // 상단 안내문
            addPhoto(), // 사진등록
            SizedBox(height: 10),
            medicineName(), // 약 이름 입력창

            SizedBox(height: 20),
            // 경계선 추가
            Divider(
              color: Color.fromARGB(255, 236, 236, 236),
              thickness: 4.0,
            ),
            SizedBox(height: 15),

            textWeekday(), // 요일설정
            WeekdayButtons(
              onSelectedDaysChanged: (days) {
                // 선택된 요일을 medicineDay에 저장
                setState(() {
                  selectedDays = days;
                });
              },
              initialSelectedDays: const [],
            ), // 요일설정 - 스위치, 월 ~ 일 선택버튼

            // 경계선 추가
            Divider(
              color: Color.fromARGB(255, 236, 236, 236),
              thickness: 4.0,
            ),
            SizedBox(height: 15),

            numOfTitle(), // 복용횟수- 타이틀
            //numOfTakeMedicine(), // 복용횟수 - 횟수 설정
            SizedBox(height: 15),
            //복용시간 추가
            for (int i = 1; i < selectedRepeat + 1; i++) addTime(i),

            SizedBox(height: 20),
            addAlram(), //알람 추가 버튼
            //SizedBox(height: 30),
          ],
        ),
      ),
    );
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

  Widget topMessage() {
    return Row(
      children: [
        // Icon(
        //   Icons.medication,
        //   color: Colors.red,
        //   size: 35.0,
        // ),
        Padding(
          padding: EdgeInsets.only(left: 15.0, right: 10.0),
          child: Image.asset(
            'repo/icons/pill.png',
            width: 25.0,
            height: 25.0,
          ),
        ),
        Text(
          "어떤 약을 드시나요?",
          style: TextStyle(
            fontSize: 17.0, // 글자크기
            fontWeight: FontWeight.bold, // 볼드체
            color: Colors.black, // 색상
            //  letterSpacing: 2.0, // 자간
          ),
        ),
      ],
    );
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
        SizedBox(height: 15),
        Align(
          alignment: Alignment.center,
          child: Text(
            "복용하는 약의 사진을 등록하세요",
            style: TextStyle(
              fontSize: 15.0, // 글자크기
              color: Colors.black, // 색상
              //letterSpacing: 2.0, // 자간
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

  Widget medicineName() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            "약의 이름을 입력하세요",
            style: TextStyle(
              fontSize: 15.0, // 글자크기
              color: Colors.black, // 색상
              // letterSpacing: 2.0, // 자간
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          width: 330, // TextField 가로 길이
          height: 45,
          child: Flexible(
            child: TextField(
              controller: _medicineNameController,
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
        ),
      ],
    );
  }

  Widget textWeekday() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 15.0, right: 10.0),
          child: Image.asset(
            'repo/icons/calendar.png',
            width: 25.0,
            height: 25.0,
          ),
        ),
        Text(
          "요일을 선택하세요",
          style: TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
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
          "몇 시에 드시는 약인가요?",
          style: TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget addTime(int i) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '복용시간',
          style: TextStyle(fontSize: 15),
        ),
        TextButton(
          onPressed: () {
            _showTimePicker(); // 버튼을 누를 때 텍스트 업데이트
          },
          child: Text(selectedTime.format(context)),
        ),
      ],
    );
  }

  Widget addAlram() {
    return SizedBox(
      width: 350,
      height: 55,
      child: GestureDetector(
        onTap: () async {
          if (_medicineNameController.text.isNotEmpty &&
              selectedDays.isNotEmpty &&
              _pickedFile != null) {
            // 모든 정보가 입력되었다면 Medicine 객체를 생성하고 데이터베이스에 저장
            Medicine newMedicine = Medicine(
              medicineName: _medicineNameController.text,
              medicinePicture: _pickedFile?.path ?? '',
              medicineDay: selectedDays.join(','),
              medicineRepeat: selectedRepeat,
              medicineTime: selectedTime.format(context),
              takenDates: {},
            );
            var dbHelper = DatabaseHelper.instance;
            await dbHelper.insert(newMedicine);

            // 복용약 추가 후에 상태 업데이트
            Provider.of<MedicineModel>(context, listen: false);
            //     .updateMedicineData();
            // for (String day in selectedDays) {
            //   Provider.of<MedicineModel>(context, listen: false)
            //       .updateMedicineData(day);
            // }
            scheduleAlarm();

            Navigator.of(context).pop(newMedicine);
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
            "알람 추가하기 +",
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
}
