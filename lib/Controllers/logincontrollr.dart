import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginController with ChangeNotifier {
  String _token = '';
  bool _isLoading = false;
  String get token => _token;
  bool get isLoading => _isLoading;

  Future<bool> login(String username, String password) async {
    const String url = "https://flutter-amr.noviindus.in/api/Login";
    _isLoading = true;
    notifyListeners();

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields['username'] = username;
      request.fields['password'] = password;
      print('Sending request to: $url');
      print('Form fields: ${request.fields}');
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == true && data.containsKey('token')) {
          _token = data['token'];
          _isLoading = false;
          notifyListeners();
          return true;
        } else {
          print('Login failed: ${data['message'] ?? 'Invalid credentials'}');
          _isLoading = false;
          notifyListeners();
          return false;
        }
      } else {
        print('Login failed with status: ${response.statusCode}');
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      print('Login error: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _token = '';
    notifyListeners();
  }

  bool get isLoggedIn => _token.isNotEmpty;
}