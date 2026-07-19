import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:food_canteen_management/domain/entities/staff_user.dart';

void main() async {
  try {
    final response = await http.get(
      Uri.parse('http://localhost:3000/api/v1/staff'),
      headers: {'x-restaurant-id': 'demo-restaurant'},
    );
    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');
    
    final List<dynamic> data = jsonDecode(response.body);
    final users = data.map((e) => StaffUser.fromJson(e)).toList();
    print('Parsed ${users.length} users!');
  } catch (e, st) {
    print('Error: $e');
    print(st);
  }
}
