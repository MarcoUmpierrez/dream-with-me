class Entry {
  String journalName;
  int itemId;
  String posterName;
  String security;
  String posterType;
  String eventRaw;
  String subjectRaw;
  String journalType;
  String tags;
  DateTime date;

  Entry(String journalName, String posterName, String subject, String body) {
    this.journalName = journalName ?? 'Journal';
    this.posterName = posterName ?? 'Poster';
    this.subjectRaw = subject ?? 'No Subject';
    this.eventRaw = body ?? 'No content';
    this.tags = '';
  }

  String getContent() {
    assert(this.eventRaw != null);
    
    String content;
    if (this.eventRaw.isNotEmpty) {
      content = '<p>${this.eventRaw.replaceAll("<br />", "</p><p>")}';
    }

    return content;
  }

  void setDateFromLogTime(dynamic logTime) {
    if (logTime is String) {
      this._setDateFromLogTimeString(logTime);
    } else if (logTime is int) {
      this._setDateFromLogTimeInt(logTime);
    }
  }

  void _setDateFromLogTimeInt(int logTime) {
    // multiply by 1000 to get the milliseconds
    this.date = DateTime.fromMillisecondsSinceEpoch(logTime*1000);
  }

  void _setDateFromLogTimeString(String logTime) {
    // convert date to milliseconds and adjust it
    this._setDateFromLogTimeInt(DateTime.parse(logTime).millisecondsSinceEpoch ~/ 1000);
  }
} 