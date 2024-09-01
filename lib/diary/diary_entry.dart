class DiaryEntry {
  final DateTime date;
  final String content;
  final String danchu;
  final String summary;

  DiaryEntry(
      {required this.content,
      required this.date,
      required this.danchu,
      required this.summary});
}
