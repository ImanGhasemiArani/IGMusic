class ProgressBarStatus {
  late final Duration current;
  late final Duration buffered;
  late final Duration total;

  ProgressBarStatus(
      {required this.current, required this.buffered, required this.total});

  ProgressBarStatus.def() {
    current = const Duration(seconds: 0);
    buffered = const Duration(seconds: 300);
    total = const Duration(seconds: 300);
  }
}
