import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dowajo/components/models/injectModel.dart';
import 'package:dowajo/database/inject_database.dart';
import 'package:dowajo/Screens/inject/inject_list_provider.dart';
import 'package:provider/provider.dart';
import 'package:dowajo/Screens/home_screen.dart';
import 'package:dowajo/Screens/inject_screen.dart';
import 'package:dowajo/components/calendar/calendar.dart';
import 'package:dowajo/components/calendar/schedule.dart';
import 'package:dowajo/components/calendar/today_banner.dart';

class InjectRecord extends StatefulWidget {
  const InjectRecord({Key? key}) : super(key: key);

  @override
  State<InjectRecord> createState() => _InjectRecordState();
}

class _InjectRecordState extends State<InjectRecord> {
  int _currentIndex = 1;

  DateTime selectedDay = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime focusedDay = DateTime.now();

  onDaySelected(DateTime focusedDay, DateTime selectedDay) {
    setState(() {
      this.focusedDay = selectedDay;
      this.selectedDay = selectedDay;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text('주입약', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // 메인 화면으로 돌아가기
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Calendar(
              selectedDay: selectedDay,
              focusedDay: focusedDay,
              onDaySelected: onDaySelected),
          const SizedBox(height: 15.0),
          TodayBanner(
            selectedDay: selectedDay,
          ),
          const SizedBox(height: 18.0),
          // Expanded(
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
          //     child: InjectList(selectedDay: selectedDay),
          //   ),
          // )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm, size: 25),
            label: '알람',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: '기록',
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFFA6CBA5),
        onTap: (int index) {
          _onItemTapped(index);
          if (_currentIndex == 1 && index == 1) {
            return; // 이미 알람 화면이므로 아무것도 하지 않음
          } else {
            switch (index) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InjectScreen()),
                );
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InjectRecord()),
                );
                break;
            }
          }
        },
      ),
    );
  }
}
//ScheduleCardListViewer 기능 삭제