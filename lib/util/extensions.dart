extension BoolParsing on String {
  bool? parseBool() {
    if (toLowerCase() == 'null') {
      return null;
    }
    return toLowerCase() == 'true';
  }
}
