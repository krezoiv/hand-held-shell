import 'dart:convert';
import 'package:hand_held_shell/config/database/database.exports.files.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:hand_held_shell/views/entities/mappers/login.response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:hand_held_shell/views/entities/enteties.exports.files.dart';
import 'package:hand_held_shell/views/entities/models/user.model.dart';
// Asegúrate de importar la clase AuthApi

class AuthService extends GetxController {
  final Rxn<UserModel> _usuario = Rxn<UserModel>();
  final _autenticando = false.obs;
  final _storage = FlutterSecureStorage();

  UserModel? get usuario => _usuario.value;
  bool get autenticando => _autenticando.value;

  set autenticando(bool valor) {
    _autenticando.value = valor;
  }

  // Getters del token de forma estática
  static Future<String?> getToken() async {
    final storage = FlutterSecureStorage();
    return await storage.read(key: 'token');
  }

  static Future<void> deleteToken() async {
    final storage = FlutterSecureStorage();
    await storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    autenticando = true;

    final data = {'email': email, 'password': password};

    final uri = Uri.parse(AuthApi.login());
    final resp = await http.post(uri,
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    autenticando = false;

    if (resp.statusCode == 200) {
      final loginResponse = LoginResponse.fromJsonString(resp.body);
      _usuario.value = loginResponse.user;

      if (loginResponse.token.isNotEmpty) {
        await _guardarToken(loginResponse.token);
      }

      return true;
    } else {
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token') ?? '';

    final uri = Uri.parse(AuthApi.renewToken());
    final resp = await http.get(uri,
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      final loginResponse = LoginResponse.fromJsonString(resp.body);
      _usuario.value = loginResponse.user;
      if (loginResponse.token.isNotEmpty) {
        await _guardarToken(loginResponse.token);
      }
      return true;
    } else {
      logout();
      return false;
    }
  }

  Future _guardarToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    await _storage.delete(key: 'token');
    _usuario.value = null;
  }
}
