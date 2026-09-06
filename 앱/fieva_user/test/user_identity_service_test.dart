import 'package:flutter_test/flutter_test.dart';

import 'package:fieva_user/services/user_identity_service.dart';

void main() {
  test('normalizes user id for Firestore document ids', () {
    expect(UserIdentityService.normalizeUserId(' user01 '), 'user01');
    expect(UserIdentityService.normalizeUserId('USER 02'), 'user02');
    expect(UserIdentityService.normalizeUserId('User-03_ok'), 'user-03_ok');
  });

  test('normalization rejects ids without safe characters', () {
    expect(UserIdentityService.normalizeUserId('   '), '');
    expect(UserIdentityService.normalizeUserId('사용자'), '');
  });
}
