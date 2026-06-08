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

/// Días que faltan para que inicie diciembre (el mes de navidad).
int daysUntilDecember(DateTime now) {
  final today = DateTime(now.year, now.month, now.day);
  final dec1 = DateTime(today.month == 12 ? today.year + 1 : today.year, 12, 1);
  return dec1.difference(today).inDays;
}
