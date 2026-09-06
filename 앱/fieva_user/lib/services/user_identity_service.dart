import 'dart:io';

import 'package:path_provider/path_provider.dart';

class UserIdentityService {
  static const defaultUserId = 'user01';
  static const _fileName = 'fieva_user_id.txt';

  static String normalizeUserId(String value) {
    final compact = value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '');
    final safe = RegExp(r'[a-z0-9_-]+').stringMatch(compact) ?? '';
    return safe == compact ? safe : '';
  }

  Future<String?> loadUserId() async {
    final file = await _identityFile();
    if (!await file.exists()) return null;
    final normalized = normalizeUserId(await file.readAsString());
    return normalized.isEmpty ? null : normalized;
  }

  Future<void> saveUserId(String userId) async {
    final normalized = normalizeUserId(userId);
    if (normalized.isEmpty) {
      throw ArgumentError.value(userId, 'userId', 'Invalid user id');
    }
    final file = await _identityFile();
    await file.writeAsString(normalized);
  }

  Future<File> _identityFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }
}
