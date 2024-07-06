import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hand_held_shell/global/environment.dart';
import 'package:hand_held_shell/views/entities/enteties.exports.files.dart';
import 'package:hand_held_shell/views/entities/mappers/login.response.dart';

import 'package:http/http.dart' as http;

class AuthService with ChangeNotifier {
  UserModel? userModel;
  bool _authenticating = false;
  final _storage = FlutterSecureStorage();

  bool get authenticating => _authenticating;

  set authenticating(bool value) {
    _authenticating = value;
    notifyListeners();
  }

//Getters del token de forma static

  static Future<String?> getToken() async {
    final _storage = FlutterSecureStorage();
    // const storage = FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    // final _storage = FlutterSecureStorage();
    const _storage = FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    authenticating = true;

    final data = {
      'email': email,
      'password': password,
    };

    final resp = await http.post(
      Uri.parse('${Environment.apiUrl}/login'), // Convertir la URL a tipo Uri
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    authenticating = false;

    // Manejar la respuesta según sea necesario
    if (resp.statusCode == 200) {
      // La solicitud fue exitosa
      final loginResponse = loginResponseFromJson(resp.body);
      userModel = loginResponse.user!;
      await _saveToken(loginResponse.token!);
      print('Login successful: ${resp.body}');
      return true;
    } else {
      print('Login failed: ${resp.body}');
      return false;
    }
  }

  Future isUserLoggedIn() async {
    final token = await _storage.read(key: 'token');

    print(token);
  }

  Future _saveToken(String token) async {
    return await _storage.write(key: 'toke', value: token);
  }

  Future logout() async {
    await _storage.delete(key: 'token');
  }
}
