import 'package:fcden/main.dart';
import 'package:fcden/providers/orders_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fcden/providers/location_provider.dart';

class CustomDropdown extends StatefulWidget {
  const CustomDropdown({super.key});

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  @override
  void initState() {
    super.initState();
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    locationProvider.getlocation();
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 60),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red, width: 2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: locationProvider.selectedLocation,
          hint: Row(
            children: const [
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
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.red,
            size: 30,
          ),
          items: locationProvider.locationAndId.map((loc) {
            return DropdownMenuItem<String>(
              value: loc['text'],
              child: Text(
                loc['text'],
                style: const TextStyle(color: Colors.black, fontSize: 19),
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                locationProvider.selectedLocation = value;
                locationProvider.setLocationId(value);
              });
              // Sets ID here
              // Debug print
              print("Selected location: $value");
              print("Location ID set: ${locationProvider.locationId}");

              Future.delayed(Duration(milliseconds: 100), () {
                // Then call the API

                Provider.of<OrderProvider>(context, listen: false)
                    .ordersHistory(context);
              });
            }
          },
        ),
      ),
    );
  }
}
