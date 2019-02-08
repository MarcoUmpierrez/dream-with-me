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
  DateTime now;
  int year, month, day, weekday, monthDays;

  Calendar() {
    this.now = DateTime.now();
    this.year = this.now.year;
    this.month = this.now.month;
    this.day = this.now.day;
    this._updateDateInfo();
  }

  String getMonthString() {
    assert(this.month >= 1 && this.month <= 12);

    return months[this.month];
  }

  String getDayLetter() {
    assert(this.weekday >= 1 && this.weekday <= 7);

    return days[this.weekday];
  }

  void increaseYear() {    
    assert(this.year >= 1);

    this.year++;
    this._updateDateInfo();
  }

  void decreaseYear() {
    assert(this.year >= 1);

    this.year--;
    this._updateDateInfo();
  }

  void increaseMonth() {
    assert(this.month >= 1 && this.month <= 12);

    this.month++;
    if (this.month == 13) {
      this.month = 1;
    }

    this._updateDateInfo();
  }

  void decreaseMonth() {
    assert(this.month >= 1 && this.month <= 12);
    this.month--;
    if (this.month == 0) {
      this.month = 12;
    }
    
    this._updateDateInfo();
  }

  void _updateDateInfo() {    
    this.monthDays = this._daysOfTheMonth();
    this.weekday = this._firstDayOfTheMonth();
  }

  int _daysOfTheMonth() {  
    assert(this.year >= 1);  
    assert(this.month >= 1 && this.month <= 12);

    int year = this.year;
    int month = this.month + 1;
    if (month == 13) {
      year++;
      month = 1;
    }

    // get the month last day number. For example
    // 20190200 returns 31 days (31 in January)
    return DateTime.parse(formatDate(year, month, 0, '')).day;
  }

  int _firstDayOfTheMonth() {
    assert(this.year >= 1);  
    assert(this.month >= 1 && this.month <= 12);

    return DateTime.parse(formatDate(this.year, this.month, 1, '')).weekday;
  }
}
  

String formatDate(int year, int month, int day, String separator) {
    assert(year >= 1);
    assert(month >= 1 && month <= 12);
    assert(day >= 0 && day <= 31);

  String formattedDate = year.toString();
  
  formattedDate += separator;

  if (month < 10) {
    formattedDate += '0$month';
  } else {
    formattedDate += '$month';
  }
  
  formattedDate += separator;

  if (day < 10) {
    formattedDate +='0$day';
  } else {
    formattedDate +='$day';
  }
  
  return formattedDate;
}