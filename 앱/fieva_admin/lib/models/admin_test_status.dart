class AdminTestStatus {
  final bool isTest;
  final String selectedBeaconId;
  final bool testActive;

  const AdminTestStatus({
    this.isTest = false,
    this.selectedBeaconId = '',
    this.testActive = false,
  });

  factory AdminTestStatus.fromMap(Map<String, dynamic> data) {
    return AdminTestStatus(
      isTest: _boolField(data, const ['isTest']),
      selectedBeaconId: _stringField(data, const [
        'selectedBeaconId',
        'selected_beacon_id',
        'fireBeaconId',
      ]),
      testActive: _boolField(data, const ['testActive', 'test_active']),
    );
  }

  bool get canStartTest => isTest && selectedBeaconId.isNotEmpty;

  static bool _boolField(Map<String, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final value = data[key];
      if (value is bool) return value;
    }
    return false;
  }

  static String _stringField(Map<String, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final value = data[key];
      if (value is String && value.trim().isNotEmpty) return value.trim();
    }
    return '';
  }
}
