import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";

class WeekdayButtons extends StatefulWidget {
  // const WeekdayButtons({super.key});
  final Function(List<String>) onSelectedDaysChanged;
  final List<String> initialSelectedDays;

  // const WeekdayButtons({Key? key, required this.onSelectedDaysChanged})
  //     : super(key: key);

  const WeekdayButtons(
      {Key? key,
      required this.onSelectedDaysChanged,
      required this.initialSelectedDays})
      : super(key: key);

  @override
  _WeekdayButtonsState createState() => _WeekdayButtonsState();
}

class _WeekdayButtonsState extends State<WeekdayButtons> {
  List<bool> selectedButtons = List<bool>.filled(
      7, false); // 각 버튼의 선택 상태를 추적하는 리스트, 모든 버튼의 초기 상태는 '선택되지 않음(false)'
  bool isAllDaysSelected = false; // '매일' 스위치의 상태를 추적하는 변수
  List<String> selectedDays = []; // 선택된 요일을 저장하는 리스트

  @override
  void initState() {
    super.initState();
    selectedDays = widget.initialSelectedDays;
    selectedButtons = ['일', '월', '화', '수', '목', '금', '토'].map((day) {
      return selectedDays.contains(day);
    }).toList();
    isAllDaysSelected = selectedButtons.every((isSelected) => isSelected);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text(
              "매일",
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 3.0),
              child: CupertinoSwitch(
                activeColor: const Color(0xFFA6CBA5),
                value: isAllDaysSelected,
                onChanged: (value) {
                  setState(() {
                    isAllDaysSelected = value;
                    if (value) {
                      // '매일' 스위치가 켜져있으면 모든 버튼을 선택 상태로 변경
                      selectedButtons = List<bool>.filled(7, true);
                      selectedDays = ['일', '월', '화', '수', '목', '금', '토'];
                    } else {
                      // '매일' 스위치가 꺼져있으면 모든 버튼을 선택되지 않은 상태로 변경
                      selectedButtons = List<bool>.filled(7, false);
                      selectedDays = [];
                    }
                  });
                  widget.onSelectedDaysChanged(selectedDays); //매일 스위치로 일~월 받기
                },
              ),
            ),
          ],
        ),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final buttonSize = constraints.maxWidth / 8.5; // 버튼의 크기를 조절
            final buttonGap = buttonSize / 7; // 버튼 간의 여백을 설정
            final totalButtonsWidth =
                buttonSize * 7 + buttonGap * 6; // 모든 버튼들의 총 너비
            final leftPadding =
                (constraints.maxWidth - totalButtonsWidth) / 2; // 왼쪽에 줄 여백

            return SizedBox(
              width: constraints.maxWidth,
              height: 85,
              child: Stack(
                children: ['일', '월', '화', '수', '목', '금', '토']
                    .asMap()
                    .entries
                    .map((e) {
                  double left = leftPadding + (buttonSize + buttonGap) * e.key;

                  return Positioned(
                    left: left, // 버튼 간의 여백과 왼쪽, 오른쪽 여백을 추가
                    top: 15,
                    child: SizedBox(
                      width: buttonSize,
                      height: buttonSize,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedButtons[e.key] = !selectedButtons[e.key];
                            isAllDaysSelected = selectedButtons
                                .every((isSelected) => isSelected);

                            selectedDays = [];
                            for (int i = 0; i < selectedButtons.length; i++) {
                              if (selectedButtons[i]) {
                                selectedDays.add(
                                    ['일', '월', '화', '수', '목', '금', '토'][i]);
                              }
                            }
                          });

                          widget.onSelectedDaysChanged(selectedDays);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            selectedButtons[e.key]
                                ? const Color(0xFFA6CBA5)
                                : Colors
                                    .white, // 선택된 버튼의 배경색을 Color(0xFFA6CBA5)로, 그 외의 버튼은 흰색으로 설정
                          ),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5)),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: const BorderSide(
                                  color: Color(0xFFA6CBA5),
                                  width: 2.0), // 버튼 선 색을 Color(0xFFA6CBA5)로 변경
                            ),
                          ),
                          elevation: MaterialStateProperty.all(0), // 버튼 그림자 제거
                        ),
                        child: Text(
                          e.value,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: selectedButtons[e.key]
                                ? Colors.white
                                : const Color(
                                    0xFFA6CBA5), // 선택된 버튼의 글씨색을 흰색으로, 그 외의 버튼은 Color(0xFFA6CBA5)로 설정
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),
      ],
    );
  }
}
