import 'dart:convert';
import 'package:get/get.dart';
import 'package:hand_held_shell/models/enteties.exports.files.dart';
import 'package:hand_held_shell/models/mappers/sales/last.sale.control.response.dart';
import 'package:hand_held_shell/models/mappers/sales/update.last.sales.control.response.dart';

import 'package:http/http.dart' as http;

class SalesControlService extends GetxService {
  static const String baseUrl = 'http://192.168.0.103:3000/api';
  Future<NewSalesControlResponse> createSalesControl(
      Map<String, dynamic> requestBody, String token) async {
    final uri = Uri.parse('$baseUrl/sales/newSalesControl');

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 201) {
      return NewSalesControlResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error creating SalesControl: ${response.body}');
    }
  }

  Future<UpdateLastSalesControlResponse> updateLastSalesControl(
      Map<String, dynamic> requestBody, String token) async {
    final uri = Uri.parse('$baseUrl/sales/updateSalesControl');

    final response = await http.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      return UpdateLastSalesControlResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error updating SalesControl: ${response.body}');
    }
  }

  Future<GetLastSaleControlResponse> getLastSalesControl(String token) async {
    final uri = Uri.parse('$baseUrl/sales/lastSalesControl');

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      },
    );

    if (response.statusCode == 200) {
      return GetLastSaleControlResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error fetching last SalesControl: ${response.body}');
    }
  }
}
