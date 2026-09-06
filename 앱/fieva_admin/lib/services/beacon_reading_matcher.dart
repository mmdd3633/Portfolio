import '../models/beacon_data.dart';
import '../models/cad_map.dart';

class BeaconReadingMatcher {
  const BeaconReadingMatcher._();

  static String? matchKeyForCadBeacon(
    CadMapBeacon beacon,
    Iterable<BeaconData> metadata,
  ) {
    final meta = metadataForCadBeacon(beacon, metadata);
    final matchKey = meta?.matchKey.trim().toLowerCase();
    return matchKey == null || matchKey.isEmpty ? null : matchKey;
  }

  static BeaconData? metadataForCadBeacon(
    CadMapBeacon beacon,
    Iterable<BeaconData> metadata,
  ) {
    final cadKeys = _identityKeys(beacon.id, beacon.name);
    if (cadKeys.isEmpty) return null;

    for (final meta in metadata) {
      if (_hasSharedKey(cadKeys, _identityKeys(meta.id, meta.name))) {
        return meta;
      }
    }
    return null;
  }

  static CadMapBeacon? cadBeaconForMatchKey(
    String matchKey,
    Iterable<BeaconData> metadata,
    Iterable<CadMapBeacon> beacons,
  ) {
    final normalizedMatchKey = _normalize(matchKey);
    if (normalizedMatchKey.isEmpty) return null;

    for (final meta in metadata) {
      if (_normalize(meta.matchKey) == normalizedMatchKey) {
        return cadBeaconForMetadata(meta, beacons);
      }
    }
    return null;
  }

  static CadMapBeacon? cadBeaconForMetadata(
    BeaconData meta,
    Iterable<CadMapBeacon> beacons,
  ) {
    final metaKeys = _identityKeys(meta.id, meta.name);
    if (metaKeys.isEmpty) return null;

    for (final beacon in beacons) {
      if (_hasSharedKey(_identityKeys(beacon.id, beacon.name), metaKeys)) {
        return beacon;
      }
    }
    return null;
  }

  static Set<String> _identityKeys(String id, String name) {
    return {
      id,
      name,
    }.map(_normalize).where((value) => value.isNotEmpty).toSet();
  }

  static String _normalize(String value) => value.trim().toLowerCase();

  static bool _hasSharedKey(Set<String> a, Set<String> b) {
    for (final key in a) {
      if (b.contains(key)) return true;
    }
    return false;
  }
}
