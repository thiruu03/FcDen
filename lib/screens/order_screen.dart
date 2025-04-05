import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool isOrderVisible = false;
  bool isFullScreen = false;
  List<Map<String, dynamic>> selectedOrder = [
    {
      'id': '#0001',
      'type': 'Dine',
      'items': [
        {
          'image':
              'https://www.kannammacooks.com/wp-content/uploads/street-style-chicken-rice-recipe-1-3.jpg',
          'name': 'Chicken fried rice',
          'quantity': 1,
        },
      ],
    },
    {
      'id': '#0002',
      'type': 'Dine',
      'items': [
        {
          'image':
              'https://www.kannammacooks.com/wp-content/uploads/street-style-chicken-rice-recipe-1-3.jpg',
          'name': 'Finger fries',
          'quantity': 1,
        },
      ],
    }
  ]; // sample order map

  // Store status for each row
  List<String> statusList = ["Processing", "Processing"]; // Default values

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/pattern.png',
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Hero(
                tag: 'redd',
                child: Material(
                  type: MaterialType.transparency,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 600),
                    padding: EdgeInsets.all(16),
                    width: MediaQuery.of(context).size.width * 0.95,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: DataTable(
                        border: TableBorder.all(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        headingRowColor: WidgetStateColor.resolveWith(
                            (states) => Theme.of(context).colorScheme.primary),
                        headingRowHeight: 100,
                        dataRowHeight: 90,
                        dataTextStyle: TextStyle(fontWeight: FontWeight.bold),
                        columns: [
                          DataColumn(
                            headingRowAlignment: MainAxisAlignment.center,
                            label: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor: Colors.white,
                                  child: Image.asset(
                                    'assets/images/logo-modified.png',
                                    height: 60,
                                  ),
                                ),
                                SizedBox(width: 30),
                                Text(
                                  "Token number",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          DataColumn(
                            headingRowAlignment: MainAxisAlignment.center,
                            label: Text(
                              "Date",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            headingRowAlignment: MainAxisAlignment.center,
                            label: Text(
                              "Type",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            headingRowAlignment: MainAxisAlignment.center,
                            label: Text(
                              "Status",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            headingRowAlignment: MainAxisAlignment.center,
                            label: Text(
                              "View",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            headingRowAlignment: MainAxisAlignment.center,
                            label: Text(
                              "Action",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                        rows: [
                          buildRow("#0001", "18 Mar, 2025 05:35 PM", "Dine", 0),
                          buildRow("#0002", "18 Mar, 2025 05:40 PM", "T/A", 1),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (isOrderVisible)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {}, // block interaction behind
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(
                    child: AnimatedContainer(
                      curve: Curves.easeInOut,
                      duration: Duration(milliseconds: 1),
                      width: isFullScreen
                          ? MediaQuery.of(context).size.width * 0.97
                          : 800,
                      height: isFullScreen
                          ? MediaQuery.of(context).size.height * 0.92
                          : 400,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Header
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(24)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Order ${selectedOrder[0]['id']}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontStyle: FontStyle.italic,
                                    fontSize: isFullScreen ? 22 : 25,
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.open_in_full,
                                          color: Colors.white),
                                      onPressed: () {
                                        setState(() {
                                          isFullScreen = !isFullScreen;
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.close,
                                          color: Colors.white),
                                      onPressed: () {
                                        setState(() {
                                          isOrderVisible = false;
                                        });
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),

                          // Order Type
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 35, vertical: 10),
                            child: Text(
                              "Order type : ${selectedOrder[0]['type']}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: isFullScreen ? 21 : 22,
                              ),
                            ),
                          ),

                          // Table
                          Expanded(
                            child: SingleChildScrollView(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 35),
                                child: DataTable(
                                  border: TableBorder(
                                    bottom: BorderSide(color: Colors.black),
                                    top: BorderSide(color: Colors.black),
                                    verticalInside:
                                        BorderSide(color: Colors.black),
                                    horizontalInside:
                                        BorderSide(color: Colors.black),
                                  ),
                                  columnSpacing: isFullScreen ? 40 : 20,
                                  headingRowHeight: isFullScreen ? 50 : 36,
                                  dataRowHeight: isFullScreen ? 130 : 120,
                                  columns: [
                                    DataColumn(
                                      headingRowAlignment:
                                          MainAxisAlignment.center,
                                      label: Text("Image",
                                          style: TextStyle(
                                              fontSize: isFullScreen ? 21 : 22,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    DataColumn(
                                      headingRowAlignment:
                                          MainAxisAlignment.center,
                                      label: Text("Name",
                                          style: TextStyle(
                                              fontSize: isFullScreen ? 21 : 22,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    DataColumn(
                                      headingRowAlignment:
                                          MainAxisAlignment.center,
                                      label: Text("quantity",
                                          style: TextStyle(
                                              fontSize: isFullScreen ? 21 : 22,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                  rows: selectedOrder[0]['items']
                                      .map<DataRow>((item) {
                                    return DataRow(cells: [
                                      DataCell(
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 3),
                                          child: Center(
                                            child: Image.network(
                                              item['image'],
                                              width: isFullScreen ? 130 : 80,
                                              height: isFullScreen ? 130 : 80,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Center(
                                          child: Text(item['name'],
                                              style: TextStyle(
                                                  fontSize:
                                                      isFullScreen ? 21 : 22)),
                                        ),
                                      ),
                                      DataCell(
                                        Center(
                                          child: Text(
                                              item['quantity'].toString(),
                                              style: TextStyle(
                                                  fontSize:
                                                      isFullScreen ? 21 : 22)),
                                        ),
                                      ),
                                    ]);
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  DataRow buildRow(String token, String date, String type, int index) {
    return DataRow(
      cells: [
        DataCell(Center(child: Text(token, style: TextStyle(fontSize: 20)))),
        DataCell(Center(child: Text(date, style: TextStyle(fontSize: 20)))),
        DataCell(Center(child: Text(type, style: TextStyle(fontSize: 20)))),
        DataCell(Center(
            child: Text(statusList[index], style: TextStyle(fontSize: 20)))),
        DataCell(Center(
          child: IconButton(
            icon: Icon(Icons.remove_red_eye),
            onPressed: () {
              setState(() {
                isOrderVisible = true;
                isFullScreen = false;
              });
            },
          ),
        )),
        DataCell(
          DropdownButton<String>(
            value: statusList[index], // Set the selected value
            items: ["Processing", "Completed"].map((String status) {
              return DropdownMenuItem<String>(
                value: status,
                child: Container(
                    padding: EdgeInsets.all(7),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black),
                        color: status == "Processing"
                            ? Colors.amber
                            : Colors.green),
                    child: Text(status, style: TextStyle(fontSize: 17))),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                statusList[index] = newValue!;
              });
            },
          ),
        ),
      ],
    );
  }
}
