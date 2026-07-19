import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:food_canteen_management/domain/entities/analytics_metrics.dart';

void main() async {
  // Try to parse the JSON manually
  final jsonString = '''{
    "averageOrderValueMinor": 8593939,
    "totalSessions": 33,
    "totalRevenueMinor": 283600000,
    "paymentMethods": [
      { "method": "bank_transfer", "totalMinor": 187800000 },
      { "method": "other", "totalMinor": 40600000 },
      { "method": "cash", "totalMinor": 22200000 },
      { "method": "card", "totalMinor": 21500000 }
    ]
  }''';

  try {
    final Map<String, dynamic> data = jsonDecode(jsonString);
    final kpis = KpiMetrics.fromJson(data);
    print('SUCCESS: $kpis');
  } catch (e, stack) {
    print('ERROR PARSING: $e\n$stack');
  }
}
