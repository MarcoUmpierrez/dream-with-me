class Entry {
  String journalName;
  int logTime;
  int itemId;
  String posterName;
  String security;
  String posterType;
  String eventRaw;
  String subjectRaw;
  String journalType;

  String getContent() {
    String content;
    if (this.eventRaw.isNotEmpty) {
      content = '<p>${this.eventRaw.replaceAll("<br />", "</p><p>")}';
    }

    return content;
  }

  DateTime getDate() {
    // multiply by 1000 to get the milliseconds
    return DateTime.fromMillisecondsSinceEpoch(this.logTime*1000);
  }
} 