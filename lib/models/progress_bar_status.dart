class ProgressBarStatus {
  late final Duration current;
  late final Duration buffered;
  late final Duration total;

  ProgressBarStatus(
      {required this.current, required this.buffered, required this.total});

  ProgressBarStatus.zero() {
    current = Duration.zero;
    buffered = Duration.zero;
    total = Duration.zero;
  }
}