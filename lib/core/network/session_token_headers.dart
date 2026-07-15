import '../../data/datasources/customer/customer_session_local_datasource.dart';

Future<Map<String, String>> customerSessionHeaders(
  CustomerSessionLocalDataSource local,
) async {
  final token = (await local.readSessionToken()).valueOrNull;
  if (token == null) return {};
  return {
    'Authorization': 'Bearer $token',
    'X-Session-Token': token,
  };
}
