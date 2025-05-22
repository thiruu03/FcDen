import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AlertProvider extends ChangeNotifier {
  Future<void> orderAlert(String orderId, BuildContext context) async {
    bool resutlt;

    try {
      final res = await http.get(Uri.parse(
          "https://www.fcdens.ndapp.in/fcdenapi/api/Order/calltokennumber/$orderId"));

      if (res.statusCode == 200 || res.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Token number has been called Successfulyy !"),
          ),
        );
        print(res.body);
        resutlt = jsonDecode(res.body);
        print(resutlt);
      }
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Unable to call this token number !"),
        ),
      );
    }
  }
}
