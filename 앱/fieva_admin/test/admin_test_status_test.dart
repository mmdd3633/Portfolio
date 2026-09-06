import 'package:flutter_test/flutter_test.dart';

import 'package:fieva_admin/models/admin_test_status.dart';

void main() {
  test('parses admin test status from the Firebase admin test document', () {
    final status = AdminTestStatus.fromMap({
      'isTest': true,
      'selectedBeaconId': ' B03 ',
      'testActive': true,
    });

    expect(status.isTest, isTrue);
    expect(status.selectedBeaconId, 'B03');
    expect(status.testActive, isTrue);
  });

  test(
    'keeps empty defaults and supports the existing lowercase istest field',
    () {
      final status = AdminTestStatus.fromMap({'istest': true});

      expect(status.isTest, isTrue);
      expect(status.selectedBeaconId, isEmpty);
      expect(status.testActive, isFalse);
    },
  );
}
