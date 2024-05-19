import 'package:dowajo/components/models/medicine.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dowajo/database/medicine_database.dart';
import 'package:provider/provider.dart';
import 'package:dowajo/components/models/injectModel.dart';
import 'package:dowajo/database/inject_database.dart';

class TodayBanner extends StatefulWidget {
  final DateTime selectedDay;

  const TodayBanner({
    required this.selectedDay,
    Key? key,
  }) : super(key: key);

  @override
  _TodayBannerState createState() => _TodayBannerState();
}

class _TodayBannerState extends State<TodayBanner> {
  @override
  void initState() {
    super.initState();
    Provider.of<MedicineModel>(context, listen: false)
        .updateMedicineData(widget.selectedDay.weekday);
  }

  @override
  void didUpdateWidget(TodayBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDay != oldWidget.selectedDay) {
      Provider.of<MedicineModel>(context, listen: false)
          .updateMedicineData(widget.selectedDay.weekday);
    }
  }

  @override
  Widget build(BuildContext context) {
    const textStyle =
        TextStyle(fontWeight: FontWeight.w600, color: Colors.white);

    var medicineModel = Provider.of<MedicineModel>(context);
    String dayOfWeek = DateFormat('E', 'ko_KR').format(widget.selectedDay);

    final medicineCount = medicineModel.allMedicines
        .where((medicine) => medicine.medicineDay.contains(dayOfWeek))
        .length;

    int remainingMedicineCount = medicineModel.allMedicines
        .where((medicine) =>
            medicine.medicineDay.contains(dayOfWeek) &&
            (!(medicine.takenDates[
                    DateFormat('yyyy-MM-dd').format(widget.selectedDay)] ??
                false)))
        .length;

    return Container(
      height: 40,
      color: const Color(0xFFA6CBA5),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${widget.selectedDay.year}년 ${widget.selectedDay.month}월 '
            '${widget.selectedDay.day}일',
            style: textStyle,
          ),
          Text(
            '남은 복용 일정  |  $remainingMedicineCount / $medicineCount 건',
            style: textStyle,
          ),
        ],
      ),
    );
  }
}

class MedicineModel extends ChangeNotifier {
  List<Medicine> allMedicines = [];
  int dayOfWeek = DateTime.now().weekday;
  int remainingMedicineCount = 0;

  String convertDayOfWeek(int dayOfWeek) {
    List<String> weekdays = ['일', '월', '화', '수', '목', '금', '토'];
    return weekdays[dayOfWeek - 1];
  }

  Future<void> updateMedicineData(int selectedDayOfWeek) async {
    String dayOfWeekStr = convertDayOfWeek(selectedDayOfWeek);

    // 리스트 업데이트를 동기적으로 실행
    allMedicines = await DatabaseHelper.instance.getAllMedicines();

    // remainingMedicineCount 업데이트 로직 추가
    remainingMedicineCount = allMedicines
        .where((medicine) => medicine.medicineDay.contains(dayOfWeekStr))
        .length;

    allMedicines = await DatabaseHelper.instance.getAllMedicines();

    notifyListeners();
  }
}

//주사모델프로바이더 수정중
// class InjectModelProvider extends ChangeNotifier {
//   List<InjectModel> allInjects = [];
//   int remainingInjectCount = 0;

//   Future<void> updateInjectData() async {
//     // 리스트 업데이트를 동기적으로 실행
//     allInjects = await DatabaseHelper.instance.getAllInjects();

//     // remainingInjectCount 업데이트 로직 추가
//     remainingInjectCount = allInjects.length;

//     notifyListeners();
//   }
// }

//4.30 임시로 추가, 수정 필요
class InjectModelProvider extends ChangeNotifier {
  List<InjectModel> _injects = [];

  List<InjectModel> get injects => _injects;

//주가 추가 ->공백 반환
  void addInject(InjectModel inject) {
    _injects.add(inject);
    notifyListeners();
  }

// 주사 제거
  void removeInject(InjectModel inject) {
    _injects.remove(inject);
    notifyListeners();
  }
}
