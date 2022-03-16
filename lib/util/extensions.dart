extension StringExt on String {
  bool? parseBool() {
    if (toLowerCase() == 'null') {
      return null;
    }
    return toLowerCase() == 'true';
  }

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalize())
      .join(' ');

  String toCapitalize() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
}
