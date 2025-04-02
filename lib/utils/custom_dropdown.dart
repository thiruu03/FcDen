import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  
  const CustomDropdown({super.key});

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? selectedLocation;
  final List<String> locations = ['Vizianagaram', 'Hyderabad', 'Bangalore'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 60),
      decoration: BoxDecoration(
        color: Colors.amber, // Background color
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red, width: 2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedLocation,
          hint: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.location_on, color: Colors.red),
              SizedBox(width: 9),
              Text(
                'Select location',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ],
          ),
          icon: Icon(
            Icons.arrow_drop_down,
            color: Colors.red,
            size: 30,
          ),
          items: locations.map((String location) {
            return DropdownMenuItem<String>(
              value: location,
              child: Text(
                location,
                style: TextStyle(color: Colors.black, fontSize: 19),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedLocation = value;
            });
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: Scaffold(body: Center(child: CustomDropdown()))));
}
