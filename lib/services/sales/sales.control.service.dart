import 'dart:convert';
import 'package:get/get.dart';
import 'package:hand_held_shell/config/database/apis/sales/sales.control.api.dart';
import 'package:hand_held_shell/models/enteties.exports.files.dart';
import 'package:hand_held_shell/models/mappers/sales/last.sale.control.response.dart';
import 'package:hand_held_shell/models/mappers/sales/update.last.sales.control.response.dart';

import 'package:http/http.dart' as http;

class SalesControlService extends GetxService {
  Future<NewSalesControlResponse> createSalesControl(
      Map<String, dynamic> requestBody, String token) async {
    final uri = Uri.parse(SalesControlApi.createSalesControl());

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
    final uri = Uri.parse(SalesControlApi.updateLastSalesControl());

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
    final uri = Uri.parse(SalesControlApi.getLastSalesControl());

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
