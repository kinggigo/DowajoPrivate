int parseHour(String time) {
  int hour = int.parse(time.split(':')[0]);
  String amPm = time.split(' ')[1];

  if (amPm == 'PM' && hour != 12) {
    hour += 12;
  } else if (amPm == 'AM' && hour == 12) {
    hour = 0;
  }

  return hour;
}

int parseMinute(String time) {
  int minute = int.parse(time.split(':')[1].split(' ')[0]);
  return minute;
}

int dayToNum(String day) {
  switch (day) {
    case '월':
      return 1;
    case '화':
      return 2;
    case '수':
      return 3;
    case '목':
      return 4;
    case '금':
      return 5;
    case '토':
      return 6;
    case '일':
      return 7;
    default:
      return 0;
  }
}
