final Map<int, String> months = {
  1: 'JAN',
  2: 'FEB',
  3: 'MAR',
  4: 'APR',
  5: 'MAY',
  6: 'JUN',
  7: 'JUL',
  8: 'AUG',
  9: 'SEP',
  10: 'OCT',
  11: 'NOV',
  12: 'DIC'
};

final Map<int, String> days = {
  1: 'M',
  2: 'T',
  3: 'W',
  4: 'T',
  5: 'F',
  6: 'S',
  7: 'S'
};

class Calendar {
  DateTime date;

  Calendar({DateTime date}) {
    if (date != null) {
      this.date = DateTime(date.year, date.month, 1); 
    } else {
      var now = DateTime.now();
      this.date = DateTime(now.year, now.month, 1);
    }

    this.date = date;
  }

  String getMonthString() {
    return months[this.date.month];
  }

  String getDayLetter() {
    return days[this.weekday()];
  }

  void increaseYear() {
    this.date = DateTime(this.date.year+1, this.date.month, 1);
  }

  void decreaseYear() {
    this.date = DateTime(this.date.year-1, this.date.month, 1);
  }

  void increaseMonth() {
    this.date = DateTime(this.date.year, (this.date.month + 1) == 13? 1: this.date.month + 1, 1);
  }

  void decreaseMonth() {
    this.date = DateTime(this.date.year, (this.date.month - 1) == 0? 12: this.date.month - 1, 1);
  }

  int monthDays() {
    // get the month last day number. For example
    // 20190200 returns 31 days (31 in January)
    return DateTime.parse(formatDate(this.date.year, (this.date.month + 1) == 13? 1 : this.date.month + 1, 0, '')).day;
  }

  DateTime getCurrentDate() {
    return DateTime.parse(formatDate(this.date.year, this.date.month, 1, ''));
  }

  int weekday() {
    return DateTime.parse(formatDate(this.date.year, this.date.month, 1, '')).weekday;
  }
}
  

String formatDate(int year, int month, int day, String separator) {
  String formattedDate = year.toString();  
  formattedDate += separator;
  formattedDate += month < 10? '0$month' : '$month';  
  formattedDate += separator;
  formattedDate += day < 10? '0$day' : '$day';  
  return formattedDate;
}