import 'package:flutter_test/flutter_test.dart';

import 'package:fieva_admin/models/cad_map.dart';
import 'package:fieva_admin/services/user_location_display_selection.dart';

void main() {
  test('shows all registered users by default regardless of id pattern', () {
    final users = [
      UserLiveLocation(userId: 'user01', x: 0, y: 0),
      UserLiveLocation(userId: 'wheelchair_a', x: 10, y: 0),
      UserLiveLocation(userId: 'room708-helper', x: 20, y: 0),
      UserLiveLocation(userId: 'kim04', x: 30, y: 0),
    ];

    final visible = UserLocationDisplaySelection.visibleLocations(
      users,
      hiddenUserIds: const {},
    );

    expect(visible.map((user) => user.userId), [
      'user01',
      'wheelchair_a',
      'room708-helper',
      'kim04',
    ]);
  });

  test('hides only unchecked users and keeps the rest visible', () {
    final users = [
      UserLiveLocation(userId: 'user01', x: 0, y: 0),
      UserLiveLocation(userId: 'wheelchair_a', x: 10, y: 0),
      UserLiveLocation(userId: 'room708-helper', x: 20, y: 0),
      UserLiveLocation(userId: 'kim04', x: 30, y: 0),
    ];

    final visible = UserLocationDisplaySelection.visibleLocations(
      users,
      hiddenUserIds: const {'wheelchair_a'},
    );

    expect(visible.map((user) => user.userId), [
      'user01',
      'room708-helper',
      'kim04',
    ]);
  });

  test('uses a stable fallback key when user id is absent', () {
    final user = UserLiveLocation(userId: null, x: 0, y: 0);

    expect(UserLocationDisplaySelection.userKey(user, 2), 'user_3');
  });
}
