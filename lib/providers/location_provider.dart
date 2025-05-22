import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LocationProvider extends ChangeNotifier {
  String? selectedLocation;
  String? locationId;
  List<String> locations = [];
  List<Map<String, dynamic>> locationAndId = [];

  Future<List<Map<String, dynamic>>> getlocation() async {
    final res = await http.get(Uri.parse(
        'https://www.fcdens.ndapp.in/fcdenapi/api/Master/getlocationmasterdata'));

    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      locations = List<String>.from(data.map((item) => item['text']));
      locationAndId = List<Map<String, dynamic>>.from(data.map((item) => {
            'text': item['text'],
            'value': item['id'],
          }));

      notifyListeners();
      print(locationAndId);
    } else {
      print("Error fetching data");
    }

    return locationAndId;
  }

  void setLocationId(String locationText) {
    final match = locationAndId.firstWhere(
      (element) => element['text'] == locationText,
      orElse: () => {},
    );
    locationId = match['value'];
    selectedLocation = locationText;
    saveSelectedLocation(locationText, locationId);
    notifyListeners();
    print(locationId);
  }

  Future<void> saveSelectedLocation(
      String locationText, String? locationId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_location_text', locationText);
    if (locationId != null) {
      await prefs.setString('selected_location_id', locationId);
    }
  }

  Future<bool> loadSavedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    selectedLocation = prefs.getString('selected_location_text');
    locationId = prefs.getString('selected_location_id');
    notifyListeners();
    return selectedLocation != null && locationId != null;
  }

  Future<void> clearSavedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('selected_location_text');
    await prefs.remove('selected_location_id');
    selectedLocation = null;
    locationId = null;
    notifyListeners();
  }
}
