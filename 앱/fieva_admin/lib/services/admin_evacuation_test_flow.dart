enum AdminEvacuationTestDecision {
  missingMap,
  adminModeRequired,
  startAndWaitForBleLocation,
  start,
}

class AdminEvacuationTestFlow {
  const AdminEvacuationTestFlow._();

  static AdminEvacuationTestDecision decide({
    required bool hasMap,
    required bool adminModeEnabled,
    required bool hasUserLocation,
  }) {
    if (!hasMap) return AdminEvacuationTestDecision.missingMap;
    if (!adminModeEnabled) return AdminEvacuationTestDecision.adminModeRequired;
    if (!hasUserLocation) {
      return AdminEvacuationTestDecision.startAndWaitForBleLocation;
    }
    return AdminEvacuationTestDecision.start;
  }
}
