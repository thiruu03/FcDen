import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: Image.asset(
              'assets/images/pattern.png',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: DataTable(
              border: TableBorder.all(
                borderRadius: BorderRadius.circular(40),
              ),
              headingRowColor: WidgetStateColor.resolveWith(
                  (states) => Theme.of(context).colorScheme.primary),
              headingRowHeight: 100,
              dataRowHeight: 70,
              columns: [
                DataColumn(
                  label: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white,
                        child: Image.asset(
                          'assets/images/logo-modified.png',
                          height: 140,
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Text(
                        "Token number",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Date",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Type",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Status",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "View",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Action",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              rows: [
                buildRow("#0001", "18 Mar, 2025 05:35 PM", "Dine", "Accept"),
                buildRow("#0002", "18 Mar, 2025 05:40 PM", "T/A", "Accept"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

DataRow buildRow(String token, String date, String type, String status) {
  return DataRow(cells: [
    DataCell(Text(token, style: TextStyle(fontSize: 23))),
    DataCell(Text(date, style: TextStyle(fontSize: 23))),
    DataCell(Text(type, style: TextStyle(fontSize: 23))),
    DataCell(Text(status, style: TextStyle(fontSize: 23))),
    DataCell(Icon(Icons.remove_red_eye, color: Colors.red, size: 28)),
    DataCell(Icon(Icons.keyboard_arrow_down, size: 28)),
  ]);
}
