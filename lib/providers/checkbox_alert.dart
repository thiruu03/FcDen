import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CheckboxAlert extends ChangeNotifier {
  Future<void> checkboxAlert(
      String orderID, BuildContext context, bool val) async {
    final uri = Uri.parse(
        "https://www.fcdens.ndapp.in/fcdenapi/api/Order/updateservedstatus");
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({
      "OrderDetailId": orderID,
      "IsServed": val,
    });

    try {
      final res = await http.post(uri, headers: headers, body: body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Item checked successfully!")),
        );
        print("✅ Response: ${res.body}");
      } else {
        print("❌ Failed with status: ${res.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to check the item!")),
        );
      }
    } catch (e) {
      print("❌ Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Unable to check the item!")),
      );
    }
  }
}
