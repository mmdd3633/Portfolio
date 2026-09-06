import '../models/cad_map.dart';

class UserLocationDisplaySelection {
  const UserLocationDisplaySelection._();

  static String userKey(UserLiveLocation user, int index) {
    final id = user.userId?.trim();
    if (id != null && id.isNotEmpty) return id;
    return 'user_${index + 1}';
  }

  static List<UserLiveLocation> visibleLocations(
    List<UserLiveLocation> users, {
    required Set<String> hiddenUserIds,
  }) {
    return users
        .asMap()
        .entries
        .where((entry) {
          final key = userKey(entry.value, entry.key);
          return !hiddenUserIds.contains(key);
        })
        .map((entry) => entry.value)
        .toList();
  }
}
