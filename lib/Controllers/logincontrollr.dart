import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginController with ChangeNotifier {
  String _token = '';
  bool _isLoading = false;

  String get token => _token;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    const String url = "https://flutter-amr.noviindus.in/api/Login";

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields['username'] = username;
      request.fields['password'] = password;

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == true && data.containsKey('token')) {
          _token = data['token'];
          return true;
        } else {
          print('Login failed: ${data['message'] ?? 'Invalid credentials'}');
          return false;
        }
      } else {
        print('Login failed with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  void logout() {
    _token = '';
    notifyListeners();
  }

  bool get isLoggedIn => _token.isNotEmpty;
}
