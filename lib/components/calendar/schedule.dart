import 'package:dowajo/database/medicine_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleCard extends StatefulWidget {
  final TimeOfDay scheduleTime;
  final String medicineName;
  final int id; // 추가된 id 필드
  final DateTime date;
  final VoidCallback onTakenUpdated; // 복용 완료 상태가 업데이트될 때 호출될 콜백 함수 추가

  const ScheduleCard({
    required this.scheduleTime,
    required this.medicineName,
    required this.id,
    required this.date,
    required this.onTakenUpdated,
    Key? key,
  }) : super(key: key);

  @override
  _ScheduleCardState createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<ScheduleCard> {
  bool _isChecked = false;
  final dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();

    _loadIsTaken();
  }

  @override
  void didUpdateWidget(covariant ScheduleCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // ScheduleCard 위젯의 상태가 변경되었을 때 복용 완료 상태 불러오기
    if (oldWidget.id != widget.id || oldWidget.date != widget.date) {
      _loadIsTaken();
    }
  }

  Future<void> _loadIsTaken() async {
    try {
      String dateStr = DateFormat('yyyy-MM-dd').format(widget.date);
      bool isTaken = await dbHelper.getIsTaken(widget.id, dateStr);
      setState(() {
        _isChecked = isTaken;
      });
    } catch (e) {
      print('Error loading taken status: $e');
    }
  }

  void _toggleCheckbox(bool? value) {
    setState(() {
      _isChecked = value ?? false;
    });

    String dateStr = DateFormat('yyyy-MM-dd').format(widget.date);
    dbHelper.updateIsTaken(widget.id, dateStr, _isChecked);
    widget.onTakenUpdated();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: dbHelper.getIsTaken(
          widget.id, DateFormat('yyyy-MM-dd').format(widget.date)),
      // 데이터베이스에서 복용 완료 상태 불러오기
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // 데이터를 불러오는 동안 로딩 인디케이터 표시
        } else if (snapshot.error != null) {
          return const Text('An error occurred!'); // 에러가 발생한 경우 에러 메시지 표시
        } else {
          _isChecked = snapshot.data!; // 데이터를 불러온 후 _isChecked 변수에 저장
          return Container(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 7),
            child: Row(
              children: [
                Container(
                  height: 50.0,
                  width: 8.0,
                  decoration: BoxDecoration(
                    color: _isChecked
                        ? const Color(0xFFA6CBA5) //const Color(0xFFA6CBA5)
                        : const Color(0xFFEFB8B2), // 체크 여부에 따른 컬러 변경
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
                _Time(scheduleTime: widget.scheduleTime),
                const SizedBox(width: 8.0),
                _IsTakeMedicine(
                  medicineName: widget.medicineName,
                  onChecked: _toggleCheckbox,
                  id: widget.id,
                  date: widget.date,
                  onTakenUpdated: widget.onTakenUpdated,
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

class _Time extends StatelessWidget {
  final TimeOfDay scheduleTime;
  const _Time({
    required this.scheduleTime,
    Key? key,
  }) : super(key: key);

  final textStyle = const TextStyle(
      fontWeight: FontWeight.w700, color: Colors.black, fontSize: 23.0);

  @override
  Widget build(BuildContext context) {
    String period = scheduleTime.period == DayPeriod.am ? '오전' : '오후';
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(period, style: textStyle.copyWith(fontSize: 14.0)),
          Text(
              '${scheduleTime.hourOfPeriod.toString().padLeft(2, '0')}:${scheduleTime.minute.toString().padLeft(2, '0')}',
              style: textStyle),
        ],
      ),
    );
  }
}

class _IsTakeMedicine extends StatefulWidget {
  final String medicineName;
  final ValueChanged<bool?> onChecked;
  final int id;
  final DateTime date;
  final VoidCallback onTakenUpdated;

  const _IsTakeMedicine({
    required this.medicineName,
    required this.onChecked,
    required this.id,
    required this.date,
    required this.onTakenUpdated,
    Key? key,
  }) : super(key: key);

  @override
  State<_IsTakeMedicine> createState() => _IsTakeMedicineState();
}

class _IsTakeMedicineState extends State<_IsTakeMedicine> {
  bool _isChecked = false;
  String _isTaked = '복용 완료';

  final dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();

    // 데이터베이스에서 복용 완료 상태 불러오기
    _loadIsTaken();
  }

  @override
  void didUpdateWidget(covariant _IsTakeMedicine oldWidget) {
    super.didUpdateWidget(oldWidget);

    // _IsTakeMedicine 위젯의 상태가 변경되었을 때 복용 완료 상태 불러오기
    if (oldWidget.id != widget.id || oldWidget.date != widget.date) {
      _loadIsTaken();
    }
  }

  Future<void> _loadIsTaken() async {
    String dateStr = DateFormat('yyyy-MM-dd').format(widget.date);

    bool isTaken = await dbHelper.getIsTaken(widget.id, dateStr);
    setState(() {
      _isChecked = isTaken;
      _isTaked = _isChecked ? '복용 완료' : '복용 완료';
    });
  }

  void _toggleCheckbox(bool? value) {
    setState(() {
      _isChecked = value!;
      // _isTaked = _isChecked ? '복용 완료' : '복용 완료';
    });
    //widget.onChecked(value);

    String dateStr = DateFormat('yyyy-MM-dd').format(widget.date);
    // 복용 완료 상태 업데이트
    dbHelper.updateIsTaken(widget.id, dateStr, _isChecked);

    // // 복용 완료 버튼을 눌렀을 때 MedicineModel의 updateMedicineData 메서드 호출
    // Provider.of<MedicineModel>(context, listen: false).updateMedicineData();
    // 복용 완료 버튼을 눌렀을 때 콜백 함수 호출
    widget.onTakenUpdated();
  }

  void _updateIsTaken() async {
    String dateStr = DateFormat('yyyy-MM-dd').format(widget.date);
    Map<String, bool> takenDates = await dbHelper.getTakenDates(widget.id);
    takenDates[dateStr] = _isChecked;

    // dbHelper를 사용하여 updateIsTaken 메서드를 호출합니다.
    await dbHelper.updateIsTaken(widget.id, dateStr, _isChecked);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.medicineName),
          Container(
            padding: const EdgeInsets.only(left: 15.0, right: 4.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(
                width: 2.0,
                color: _isChecked
                    ? const Color(0xFFA6CBA5)
                    : const Color(0xFFEFB8B2),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(_isTaked),
                Transform.scale(
                    scale: 1.1,
                    child: Checkbox(
                      value: _isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          _isChecked = value ?? false;
                        });
                        // 데이터베이스 업데이트
                        String dateStr =
                            DateFormat('yyyy-MM-dd').format(widget.date);
                        dbHelper.updateIsTaken(widget.id, dateStr, _isChecked);
                        widget.onTakenUpdated();
                      },
                      // _toggleCheckbox,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      activeColor: const Color(0xFFA6CBA5),
                      side: MaterialStateBorderSide.resolveWith(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.selected)) {
                            return const BorderSide(
                                color: Color(0xFFA6CBA5),
                                width: 2); // 체크박스가 선택된 상태일 때의 테두리 색상
                          }
                          return const BorderSide(
                              color: Color(
                                  0xFFEFB8B2), //Color.fromARGB(255, 203, 202, 202),
                              width: 2); // 체크박스가 선택되지 않은 상태일 때의 테두리 색상
                        },
                      ),
                    ))
              ],
            ),
          )
        ],
      ),
    ));
  }
}