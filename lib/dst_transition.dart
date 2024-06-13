class DstTransition {
  /// exact date and time (hour precision) of next DST transition
  DateTime transitionDate;

  /// how many hours the offset changes because of DST
  /// The TimeZone offset doesn't affect this value
  int offsetChange;

  /// true if DST is active immediately after the transition, false otherwise
  bool isDSTActive;

  DstTransition(this.transitionDate, this.offsetChange, this.isDSTActive);
}
