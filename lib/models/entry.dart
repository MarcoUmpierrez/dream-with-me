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

  Entry(String journalName, String posterName, String subject, String body) {
    this.journalName = journalName ?? 'Journal';
    this.posterName = posterName ?? 'Poster';
    this.subjectRaw = subject ?? 'No Subject';
    this.eventRaw = body ?? 'No content';
  }

  String getContent() {
    assert(this.eventRaw != null);
    
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