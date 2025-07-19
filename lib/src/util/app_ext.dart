extension StringExt on double {
  String get asMoney {
    return toStringAsFixed(2);
  }
}
