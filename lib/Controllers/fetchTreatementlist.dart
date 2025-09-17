import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Models/model_treatmentList.dart';

class TreatmentProvider with ChangeNotifier {
  List<Treatment> _treatments = [];
  bool _loading = false;

  List<Treatment> get treatments => _treatments;
  bool get loading => _loading;

  /// Fetch treatments from API with Bearer token
  Future<void> fetchTreatments(String token) async {
    if (_loading) return;

    _loading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://flutter-amr.noviindus.in/api/TreatmentList'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print("Treatment API status: ${response.statusCode}");
      print("Treatment API body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        // Adjust this based on your API JSON structure
        if (jsonData['treatments'] != null) {
          _treatments = (jsonData['treatments'] as List)
              .map((e) => Treatment.fromJson(e))
              .toList();
        } else if (jsonData['data'] != null) {
          // If API returns data key
          _treatments = (jsonData['data'] as List)
              .map((e) => Treatment.fromJson(e))
              .toList();
        } else {
          _treatments = [];
        }
      } else {
        _treatments = [];
        print('Failed to load treatments. Status: ${response.statusCode}');
      }
    } catch (e) {
      _treatments = [];
      print("Error fetching treatments: $e");
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void clearTreatments() {
    _treatments = [];
    notifyListeners();
  }
}
