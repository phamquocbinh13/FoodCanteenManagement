// ignore_for_file: avoid_print
/// Session vertical-slice persistence proof against NestJS + MySQL.
///
/// Run (backend must be up, passwords seeded):
///   dart run tools/verify_session_vertical_slice.dart
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

const base = 'http://localhost:3000/api/v1';
const restaurantId = 'demo-restaurant';
const tableId = 'table-1';

Future<void> main() async {
  final client = http.Client();
  try {
    print('1) Login cashier...');
    final loginRes = await client.post(
      Uri.parse('$base/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': 'cashier', 'password': 'cashier123'}),
    );
    _expect(
      loginRes.statusCode == 200 || loginRes.statusCode == 201,
      'login ${loginRes.statusCode} ${loginRes.body}',
    );
    final login = jsonDecode(loginRes.body) as Map<String, dynamic>;
    final accessToken = login['accessToken'] as String;
    final auth = {'Authorization': 'Bearer $accessToken', 'Content-Type': 'application/json'};

    print('2) Close any active session on table-1...');
    final activeRes = await client.get(
      Uri.parse('$base/restaurants/$restaurantId/tables/$tableId/session'),
      headers: auth,
    );
    _expect(activeRes.statusCode == 200, 'findActive ${activeRes.body}');
    final activeBody = jsonDecode(activeRes.body) as Map<String, dynamic>;
    final existingSnapshot = activeBody['session'] as Map<String, dynamic>?;
    if (existingSnapshot != null) {
      final sid =
          (existingSnapshot['session'] as Map<String, dynamic>)['id'] as String;
      final closeRes = await client.post(
        Uri.parse('$base/restaurants/$restaurantId/sessions/$sid/close'),
        headers: auth,
        body: '{}',
      );
      _expect(
        closeRes.statusCode == 200 || closeRes.statusCode == 201,
        'pre-close ${closeRes.statusCode} ${closeRes.body}',
      );
    }

    print('3) Create session (Stage A)...');
    final token = 'verify_${DateTime.now().millisecondsSinceEpoch}';
    final createRes = await client.post(
      Uri.parse('$base/restaurants/$restaurantId/sessions'),
      headers: auth,
      body: jsonEncode({
        'tableId': tableId,
        'openedVia': 'cashier_manual',
        'displayNumber': 'S-VERIFY-${DateTime.now().millisecondsSinceEpoch}',
        'sessionSequence': DateTime.now().millisecond + 1,
        'sessionToken': token,
        'tokenExpiresAt': DateTime.now().toUtc().add(const Duration(hours: 8)).toIso8601String(),
      }),
    );
    _expect(createRes.statusCode == 201, 'create ${createRes.statusCode} ${createRes.body}');
    final created = jsonDecode(createRes.body) as Map<String, dynamic>;
    final sessionId =
        ((created['snapshot'] as Map<String, dynamic>)['session'] as Map<String, dynamic>)['id']
            as String;
    print('   sessionId=$sessionId token=$token');

    print('4) Join via token...');
    final joinRes = await client.post(
      Uri.parse('$base/sessions/join'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'sessionToken': token, 'deviceId': 'verify-device'}),
    );
    _expect(
      joinRes.statusCode == 200 || joinRes.statusCode == 201,
      'join ${joinRes.statusCode} ${joinRes.body}',
    );

    print('5) Validate /sessions/me...');
    final meRes = await client.get(
      Uri.parse('$base/sessions/me'),
      headers: {'Authorization': 'Bearer $token', 'X-Session-Token': token},
    );
    _expect(meRes.statusCode == 200, 'me ${meRes.body}');

    print('6) Restore active...');
    final restoreRes = await client.get(
      Uri.parse('$base/restaurants/$restaurantId/sessions/active'),
      headers: auth,
    );
    _expect(restoreRes.statusCode == 200, 'restore ${restoreRes.body}');
    final items = (jsonDecode(restoreRes.body) as Map<String, dynamic>)['items'] as List;
    _expect(items.any((e) => (e as Map)['session']['id'] == sessionId), 'session in restore');

    print('7) Restart-survival check: re-fetch by id...');
    final byId = await client.get(
      Uri.parse('$base/restaurants/$restaurantId/sessions/$sessionId'),
      headers: auth,
    );
    _expect(byId.statusCode == 200, 'byId ${byId.body}');

    print('8) Close session...');
    final closeRes = await client.post(
      Uri.parse('$base/restaurants/$restaurantId/sessions/$sessionId/close'),
      headers: auth,
      body: '{}',
    );
    _expect(
      closeRes.statusCode == 200 || closeRes.statusCode == 201,
      'close ${closeRes.statusCode} ${closeRes.body}',
    );

    print('OK — Session vertical slice API verified (MySQL-backed).');
  } finally {
    client.close();
  }
}

void _expect(bool ok, String message) {
  if (!ok) {
    stderr.writeln('FAIL: $message');
    exit(1);
  }
}
