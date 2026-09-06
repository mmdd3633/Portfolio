enum UserGuidanceMode {
  general('일반', true, true, true);

  const UserGuidanceMode(
    this.label,
    this.usesTts,
    this.usesVibration,
    this.usesVisual,
  );

  final String label;
  final bool usesTts;
  final bool usesVibration;
  final bool usesVisual;

  static UserGuidanceMode fromKey(String? value) {
    return UserGuidanceMode.general;
  }
}
