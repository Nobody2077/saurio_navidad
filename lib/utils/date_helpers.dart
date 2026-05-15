DateTime nextChristmasEve(DateTime now) {
  final thisYear = DateTime(now.year, 12, 24);
  if (now.month == 12 && now.day > 24) {
    return DateTime(now.year + 1, 12, 24);
  }
  return thisYear;
}

String shortDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}
