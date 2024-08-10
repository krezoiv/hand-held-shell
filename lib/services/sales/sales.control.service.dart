import 'dart:convert';
import 'package:get/get.dart';
import 'package:hand_held_shell/models/enteties.exports.files.dart';

import 'package:http/http.dart' as http;

class SalesControlService extends GetxService {
  static const String baseUrl =
      'http://192.168.0.100:3000/api'; // Ajusta esta URL según tu configuración

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
}
//el tiempo llegara , ahorita no es el tiempo, mientras tanto estare enfocado crear los recursos