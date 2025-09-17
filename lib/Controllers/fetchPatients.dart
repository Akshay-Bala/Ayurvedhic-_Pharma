import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Models/model_patientlist.dart';

class PatientProvider with ChangeNotifier {
  List<Patient> patient = [];
  bool _loading = false;

  List<Patient> get patients => patient;
  bool get loading => _loading;

  Future<void> fetchPatients(String token) async {
    if (_loading) return;

    _loading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://flutter-amr.noviindus.in/api/PatientList'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final model = ModelPatientsList.fromJson(jsonData);
        print(
          "-------------------------------------------------------------------------------------------------------------------------",
        );
        print(model.toJson());
        print(token);
        print(
          "-------------------------------------------------------------------------------------------------------------------------",
        );
        patient = model.patient;
      } else {
        print('Failed to load patients. Status code: ${response.statusCode}');
        patient = [];
      }
    } catch (e) {
      patient = [];
      print("Error fetching patients: $e");
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void clearPatients() {
    patient = [];
    notifyListeners();
  }
}
